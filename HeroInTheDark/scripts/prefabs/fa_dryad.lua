
local assets=
{
    Asset("ANIM", "anim/fa_dryad.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}
local YELL_TIMEOUT=30

local HEALTH = 500
local DAMAGE = 50
local ATTACK_PERIOD = 2
local RUN_SPEED=2

local TREEGUARD_COUNTER=8
local LIGHTNING_COUNTER=5
local PLANT_COUNTER=50
local HEAL_COUNTER=5
local GUST_COUNTER=50
local SWARM_COUNTER=5
local KICK_COUNTER=5

local function RetargetFn(inst)
    local invader = FindEntity( inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") 
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

local onloadfn = function(inst, data)
     if(data)then
        inst.fa_summontreeguard_counter=data.fa_summontreeguard_counter
        inst.fa_calllightning_counter=data.fa_calllightning_counter
        inst.fa_plantgrowth_counter=data.fa_plantgrowth_counter
        inst.fa_heal_counter=data.fa_heal_counter
        inst.fa_gustofwind_counter=data.fa_gustofwind_counter
        inst.fa_summonswarm_counter=data.fa_summonswarm_counter
        inst.fa_kick_counter=data.fa_kick_counter
    end
end

local onsavefn = function(inst, data)
        data.fa_summontreeguard_counter=inst.fa_summontreeguard_counter
        data.fa_calllightning_counter=inst.fa_calllightning_counter
        data.fa_plantgrowth_counter=inst.fa_plantgrowth_counter
        data.fa_heal_counter=inst.fa_heal_counter
        data.fa_gustofwind_counter=inst.fa_gustofwind_counter
        data.fa_summonswarm_counter=inst.fa_summonswarm_counter
        data.fa_kick_counter=inst.fa_kick_counter
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
--    inst.Transform:SetScale(0.85,0.85, 0.85)
	
    inst:AddTag("hostile")
    inst:AddTag("fa_good")
    inst:AddTag("fa_humanoid")
	
    MakeCharacterPhysics(inst, 5, 0.5)
     
    anim:SetBuild("fa_dryad") 
    anim:SetBank("fa_dryad") 

        inst.fa_summontreeguard_counter=TREEGUARD_COUNTER
        inst.fa_calllightning_counter=LIGHTNING_COUNTER
        inst.fa_plantgrowth_counter=PLANT_COUNTER
        inst.fa_heal_counter=HEAL_COUNTER
        inst.fa_gustofwind_counter=GUST_COUNTER
        inst.fa_summonswarm_counter=SWARM_COUNTER
        inst.fa_kick_counter=KICK_COUNTER

    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = RUN_SPEED
    inst:SetStateGraph("SGdryad")
    inst:AddComponent("leader")
    inst:AddComponent("follower")


    local brain = require "brains/dryadbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.1
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(DAMAGE)
    inst.components.combat:SetAttackPeriod(ATTACK_PERIOD)
--    inst.components.combat:SetRange(OGRE_ATTACK_RANGE)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"fa_dryadheart","livinglog","livinglog","livinglog","livinglog","livinglog"})
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys2,FALLENLOOTTABLE.TABLE_KEYS2_WEIGHT,0.1)
--    inst:AddComponent("inspectable")
    
    inst:ListenForEvent("attacked", OnAttacked)

--    inst:AddComponent("sleeper")

    MakeLargeBurnableCharacter(inst)
    MakeLargeFreezableCharacter(inst)

    inst.OnSave=onsavefn
    inst.OnLoad=onloadfn

    return inst
end

return Prefab( "common/fa_dryad", fn, assets)
