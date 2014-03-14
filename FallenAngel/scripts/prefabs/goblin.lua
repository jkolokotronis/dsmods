
local assets=
{
	Asset("ANIM", "anim/orc.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}

local GOBLIN_HEALTH=300
local GOBLIN_DAMAGE=20
local GOBLIN_ATTACK_PERIOD=1

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 40

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("goblin")
    end)
    return invader
end
local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)     
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and inst.components.combat:CanTarget(attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
                return dude.components.homeseeker
                       and dude.components.homeseeker.home
                       and dude.components.homeseeker.home == home
            end, targetshares)
        end
    end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2, 1 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1,1, 1)
	
	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("goblin")
    inst:AddTag("hostile")
	
    MakeCharacterPhysics(inst, 10, 0.5)
     
    anim:SetBank("orc")
    anim:SetBuild("orc") 

    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 2
    inst:SetStateGraph("SGorc")


    local brain = require "brains/orcbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(GOBLIN_HEALTH)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(GOBLIN_DAMAGE)
    inst.components.combat:SetAttackPeriod(GOBLIN_ATTACK_PERIOD)
    inst.components.combat:SetRange(3)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "monstermeat"})
--    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)

     MakeMediumFreezableCharacter(inst, "orc")
     MakeMediumBurnableCharacter(inst, "orc")

    return inst
end

return Prefab( "common/goblin", fn, assets)
