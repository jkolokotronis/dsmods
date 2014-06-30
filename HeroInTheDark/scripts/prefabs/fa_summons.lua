--theyre all defaults, shouldnt need this
local fa_cummonmonster1_assets=
{
}
local fa_cummonmonster2_assets=
{
}
local fa_cummonmonster3_assets=
{
}
local fa_cummonmonster4_assets=
{
}
    

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30

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

local function common()
    local inst = CreateEntity()
    inst.entity:AddTransform()
    anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    
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

local function fa_cummonmonster1()
    
    local inst=common()

    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
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

local function fa_cummonmonster2()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 50, .5)
    shadow:SetSize( 1.5, .75 )

    inst:AddTag("spider")
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

local function fa_cummonmonster3()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 50, .5)
    shadow:SetSize( 1.5, .75 )

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

local function fa_cummonmonster4()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    shadow:SetSize( 2.5, 1.5 )
    
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

return Prefab( "common/fa_cummonmonster1", fa_cummonmonster1, fa_cummonmonster1_assets),
    Prefab("common/fa_cummonmonster2",fa_cummonmonster2,fa_cummonmonster2_assets),
    Prefab("common/fa_cummonmonster3",fa_cummonmonster3,fa_cummonmonster3_assets),
    Prefab("common/fa_cummonmonster4",fa_cummonmonster4,fa_cummonmonster4_assets)
