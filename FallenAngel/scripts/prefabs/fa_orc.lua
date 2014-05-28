
local assets=
{
    Asset("ANIM", "anim/fa_orc.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}
local YELL_TIMEOUT=30
local ORC_HEALTH=500
local ORC_DAMAGE=40
local ORC_ATTACK_PERIOD=2
local ORC_RUN_SPEED=5
local ORC_WALK_SPEED=3

local MAX_TARGET_SHARES = 6
local TARGET_DISTANCE = 30
local SHARE_TARGET_DIST = 40

local function RetargetFn(inst)

    local defenseTarget = inst
    local invader=nil
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
       invader = FindEntity(home, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") and not guy:HasTag("orc")
    end)
    end
    if not invader then
        invader = FindEntity(inst, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") and not guy:HasTag("orc")
        end)
    end
    if(invader and not inst.components.combat.target)then--invader~=inst.components.combat.target)then
        if not(inst.fa_yelltime and (GetTime()-inst.fa_yelltime)<YELL_TIMEOUT)then
            inst.fa_yelltime=GetTime()
            inst.SoundEmitter:PlaySound("fa/orc/drums")
        end
    end
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
	shadow:SetSize( 3, 2 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(0.6,0.6, 0.6)
	
	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("orc")
    inst:AddTag("hostile")
	
    MakeCharacterPhysics(inst, 10, 0.5)
     
    anim:SetBank("fa_orc")
    anim:SetBuild("fa_orc") 

    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = ORC_RUN_SPEED
    inst:SetStateGraph("SGorc")


    local brain = require "brains/orcbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(ORC_HEALTH)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    inst:AddComponent("sleeper")
    inst.components.sleeper.sleeptestfn = function() return false end
    inst.components.sleeper.waketestfn = function() return true end
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(ORC_DAMAGE)
    inst.components.combat:SetAttackPeriod(ORC_ATTACK_PERIOD)
    inst.components.combat:SetRange(3)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("knownlocations")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "monstermeat"})
    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)


     MakeMediumFreezableCharacter(inst, "orc")
     MakeMediumBurnableCharacter(inst, "orc")

    return inst
end

return Prefab( "common/fa_orc", fn, assets)
