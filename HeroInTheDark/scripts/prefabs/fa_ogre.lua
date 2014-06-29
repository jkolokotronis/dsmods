
local assets=
{
	Asset("ANIM", "anim/PlaceholderBeast.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}

local OGRE_HEALTH=3000
local OGRE_DAMAGE=60
local OGRE_ATTACK_PERIOD=1.2


local function RetargetFn(inst)
    local invader = FindEntity( inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("ogre")
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
    inst.Transform:SetScale(2,2, 2)
	
	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("ogre")
    inst:AddTag("hostile")
    inst:AddTag("fa_evil")
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_giant")
	
    MakeCharacterPhysics(inst, 100, 0.5)
     
    inst:AddTag("largecreature")
    anim:SetBank("PlaceholderBeast")
    anim:SetBuild("PlaceholderBeast") 

    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 2
    inst:SetStateGraph("SGtroll")


    local brain = require "brains/orcbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(OGRE_HEALTH)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(OGRE_DAMAGE)
    inst.components.combat:SetAttackPeriod(OGRE_ATTACK_PERIOD)
    inst.components.combat:SetRange(5)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"monstermeat",  "monstermeat"})
--    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("sleeper")

    MakeLargeBurnableCharacter(inst, "ogre")
    MakeLargeFreezableCharacter(inst, "ogre")

    return inst
end

return Prefab( "common/fa_ogre", fn, assets)
