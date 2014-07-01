--theyre all defaults, shouldnt need this
local fa_summonmonster1_assets=
{
}
local fa_summonmonster2_assets=
{
}
local fa_summonmonster3_assets=
{
}
local fa_summonmonster4_assets=
{
}
local fa_animated_assets=
{
    Asset("ANIM", "anim/drybones.zip"),
}
    

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30
local PET_HEALTH=300

local function ShouldWakeUp(inst)
    return DefaultWakeTest(inst) or (inst.components.follower and inst.components.follower.leader and not inst.components.follower:IsNearLeader(WAKE_TO_FOLLOW_DISTANCE))
end

local function ShouldSleep(inst)
    return not GetClock():IsDay() and not GetClock():IsDusk()
    and not (inst.components.combat and inst.components.combat.target)
    and not (inst.components.burnable and inst.components.burnable:IsBurning() )
end

local function ShouldSleepSpider(inst)
    return GetClock():IsDay()
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.follower and inst.components.follower.leader)
end

local function OnNewTarget(inst, data)
    if inst.components.sleeper:IsAsleep() then
        inst.components.sleeper:WakeUp()
    end
end

local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)
    return newtarget
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    if attacker and not attacker:HasTag("player") then
        inst.components.combat:SetTarget(attacker)
    end
end

local function auratest(inst, target)

    if target == GetPlayer() then return false end

    local leader = inst.components.follower.leader
    if target.components.combat.target and ( target.components.combat.target == inst or target.components.combat.target == leader) then return true end
    if inst.components.combat.target == target then return true end

    if leader then
        if leader == target then return false end
        if target.components.follower and target.components.follower.leader == leader then return false end
    end

    return target:HasTag("monster") --or target:HasTag("prey")
end


local loadpostpass=function(inst,data)
    if(inst.components.follower and inst.components.follower.leader)then
   inst:ListenForEvent("stopfollowing",function(f)
            inst.components.health:Kill()
        end)
    end
end

local function common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

    inst.LoadPostPass=loadpostpass
    
    inst.Transform:SetFourFaced()
    inst.entity:AddPhysics()

    inst:AddTag("companion")
    inst:AddTag("pet")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")

    inst.AnimState:SetRayTestOnBB(true);

    inst:AddComponent("lootdropper")
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph   
    inst:AddComponent("inspectable")        
    inst:AddComponent("follower")

    return inst
end

local function fa_summonmonster1()
    
    local inst=common()

    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst:AddTag("spider")
    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_build")
    inst.AnimState:PlayAnimation("idle")

    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = TUNING.SPIDER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.SPIDER_RUN_SPEED

    inst:SetStateGraph("SGspider")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleepSpider)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(TUNING.SPIDER_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    inst.components.combat:SetHurtSound("dontstarve/creatures/spider/hit_response")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.SPIDER_HEALTH)
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/spiderbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_summonmonster2()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 50, .5)
    shadow:SetSize( 1.5, .75 )

    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("merm_build")
    inst.AnimState:PlayAnimation("idle_loop")

    inst.components.locomotor.runspeed = TUNING.MERM_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.MERM_WALK_SPEED

    inst:SetStateGraph("SGmerm")
    inst.AnimState:Hide("hat")
    
    inst:AddTag("notraptrigger")
    inst:AddTag("merm")
    inst:AddTag("wet")

    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleepSpider)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)

    inst:AddComponent("inventory")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/mermbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_summonmonster3()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 50, .5)
    shadow:SetSize( 1.5, .75 )

    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst:AddTag("pig")
    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("pig_build")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")

    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    inst:SetStateGraph("SGpig")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "pig_torso")
    MakeMediumFreezableCharacter(inst, "pig_torso")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleepSpider)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetDefaultDamage(TUNING.PIG_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.PIG_ATTACK_PERIOD)

    inst:AddComponent("inventory")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/pigbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_summonmonster4()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    shadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("hound_ice")
    inst.AnimState:PlayAnimation("idle")

    inst.components.locomotor.runspeed = TUNING.ICEHOUND_SPEED

    inst:SetStateGraph("SGhound")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "hound_body")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ICEHOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.ICEHOUND_ATTACK_PERIOD)
    inst.components.combat:SetHurtSound("dontstarve/creatures/hound/hurt")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ICEHOUND_HEALTH)
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/houndbrain"
    inst:SetBrain(brain)


    inst:ListenForEvent("death", function(inst)
        inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/icehound_explo", "explosion")
    end)

    return inst
end


local function fa_animatedead()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    shadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("drybones")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")
    inst:AddTag("skeleton")
    inst:AddTag("undead")

    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*2

    inst:SetStateGraph("SGskeletonspawn")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "hound_body")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_horrorpet()
    
    local inst=common()

    local sounds = 
    {
        attack = "dontstarve/sanity/creature1/attack",
        attack_grunt = "dontstarve/sanity/creature1/attack_grunt",
        death = "dontstarve/sanity/creature1/die",
        idle = "dontstarve/sanity/creature1/idle",
        taunt = "dontstarve/sanity/creature1/taunt",
        appear = "dontstarve/sanity/creature1/appear",
        disappear = "dontstarve/sanity/creature1/dissappear",
    }
    
    MakeCharacterPhysics(inst, 10, .5)
    shadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
        inst.AnimState:SetBank("shadowcreature1")
        inst.AnimState:SetBuild("shadow_insanity1_basic")
        inst.AnimState:PlayAnimation("idle_loop")
        inst.AnimState:SetMultColour(1, 1, 1, 0.5)
    inst:AddTag("shadow")
    inst:AddTag("undead")

    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*2

        inst:SetStateGraph("SGshadowcreature")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "hound_body")

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.CRAWLINGHORROR_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.CRAWLINGHORROR_ATTACK_PERIOD)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CRAWLINGHORROR_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health:StartRegen(5,5)

        local brain = require "brains/shadowcreaturebrain"
        inst:SetBrain(brain)

    return inst
end

return Prefab( "common/fa_summonmonster1", fa_summonmonster1, fa_summonmonster1_assets),
    Prefab("common/fa_summonmonster2",fa_summonmonster2,fa_summonmonster2_assets),
    Prefab("common/fa_summonmonster3",fa_summonmonster3,fa_summonmonster3_assets),
    Prefab("common/fa_summonmonster4",fa_summonmonster4,fa_summonmonster4_assets),
    Prefab("common/fa_animatedead",fa_animatedead,fa_animated_assets),
    Prefab("common/fa_horrorpet",fa_horrorpet,fa_summonmonster1_assets)