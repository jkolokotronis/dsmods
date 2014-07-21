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
local fa_decoy_assets=
{
        Asset( "ANIM", "anim/wizard.zip" ),
}
    

local WAKE_TO_FOLLOW_DISTANCE = 8
local SLEEP_NEAR_HOME_DISTANCE = 10
local SHARE_TARGET_DIST = 30
local HOME_TELEPORT_DIST = 30
local PET_HEALTH=300
local DECOY_HEALTH=300
local DECOY_SPEED=8
local DECOY_DURATION=60
local DANCINGLIGHT_DURATION=16*60
local UNDEADTIMER=4*60
local UNDEADBREAKCHANCE=0.4

local guardianshutdown=function(inst)
    inst.components.health:Kill()
end


local onloadfn = function(inst, data)
    if(data and data.countdown and data.countdown>0)then
        if inst.shutdowntask then
            inst.shutdowntask:Cancel()
        end
    inst.shutdowntask=inst:DoTaskInTime(data.countdown, guardianshutdown)
    inst.shutdowntime=GetTime()+data.countdown
    end
end

local onsavefn = function(inst, data)
    data.countdown=inst.shutdowntime-GetTime()
end


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
    local newtarget=nil
    if(inst.components.follower.leader and inst.components.follower.leader:HasTag("player"))then 
        newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    ((guy.components.combat.target == GetPlayer()) or (GetPlayer().components.combat.target == guy))
        end)
    else
        --and the demons have lost their way...
         newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    guy:HasTag("character")
        end)
    end
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
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()

--    inst.LoadPostPass=loadpostpass
    
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

    inst:ListenForEvent("stopfollowing",guardianshutdown)

    return inst
end

local function fa_summonmonster1()
    
    local inst=common()

    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst:AddTag("spider")
    inst.entity:AddLightWatcher()
    inst.AnimState:SetBank("spider")
    inst.AnimState:SetBuild("spider_build")
    inst.AnimState:PlayAnimation("idle")

    inst.components.locomotor:SetSlowMultiplier( 1 )
    inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
    inst.components.locomotor.walkspeed = TUNING.SPIDER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.SPIDER_RUN_SPEED

    inst:AddComponent("eater")

    inst:SetStateGraph("SGspider")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY

    inst:AddComponent("knownlocations")
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleepSpider)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetDefaultDamage(TUNING.SPIDER_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
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
    inst.DynamicShadow:SetSize( 1.5, .75 )

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
    inst:AddComponent("eater")
    inst:AddComponent("knownlocations")

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
    inst.components.combat:SetRetargetFunction(1, Retarget)

    inst:AddComponent("inventory")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.MERM_HEALTH)
    inst.components.combat:SetDefaultDamage(TUNING.MERM_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.MERM_ATTACK_PERIOD)
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/magesummonbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_summonmonster3()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 50, .5)
    inst.DynamicShadow:SetSize( 1.5, .75 )

    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst:AddTag("pig")
    inst.AnimState:SetBank("pigman")
    inst.AnimState:SetBuild("pig_build")
    inst.AnimState:PlayAnimation("idle_loop")
    inst.AnimState:Hide("hat")

    inst.components.locomotor.runspeed = TUNING.PIG_RUN_SPEED
    inst.components.locomotor.walkspeed = TUNING.PIG_WALK_SPEED

    inst:AddComponent("eater")
    inst:AddComponent("trader")
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
    inst.components.combat:SetRetargetFunction(1, Retarget)

    inst:AddComponent("inventory")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.PIG_HEALTH)
    inst.components.health:StartRegen(5,5)

--    local brain = require "brains/pigbrain"
    local brain=require "brains/magesummonbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_summonmonster4()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("hound_ice")
    inst.AnimState:PlayAnimation("idle")

    inst.components.locomotor.runspeed = TUNING.ICEHOUND_SPEED

    inst:SetStateGraph("SGhound")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "hound_body")

    inst:AddComponent("eater")
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TUNING.ICEHOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.ICEHOUND_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
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

local checkforturning=function(inst)
    local leader=inst.components.follower.leader
    if(leader and leader.fa_protevil) then return 
    elseif(leader)then
        if(math.random()<=UNDEADBREAKCHANCE)then
            inst:RemoveEventCallback("StopFollowing",guardianshutdown)
            inst.components.follower:StopFollowing()
            inst.components.combat:SetTarget(leader)
        end
    end
end

local undeadonloadfn = function(inst, data)
    if(data and data.countdown and data.countdown>0)then
        if inst.breaktask then
            inst.breaktask:Cancel()
        end
    inst.breaktask=inst:DoTaskInTime(data.countdown, checkforturning)
    inst.breaktimer=GetTime()+data.countdown
    end
end

local undeadonsavefn = function(inst, data)
    data.countdown=inst.breaktimer-GetTime()
end


local function fa_animatedead()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
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

    MakeMediumBurnableCharacter(inst, "torso")

    inst:AddComponent("inventory")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst.components.combat:SetAttackPeriod(2)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health.fa_resistances={}
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health:StartRegen(10,5)

    inst.breaktimer=GetTime()+UNDEADTIMER
    inst.breaktask=inst:DoTaskInTime(UNDEADTIMER, guardianshutdown)

    inst.OnLoad = undeadonloadfn
    inst.OnSave = undeadonsavefn

    local brain = require "brains/magesummonbrain"
    inst:SetBrain(brain)

    return inst
end

local function fa_horrorpet()
    
    local inst=common()

    --meh, the only thing worse than klei coding practices - copying them yourself... 
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
    inst.sounds = sounds
    
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")
        inst.AnimState:SetBank("shadowcreature1")
        inst.AnimState:SetBuild("shadow_insanity1_basic")
        inst.AnimState:PlayAnimation("idle_loop")
        inst.AnimState:SetMultColour(1, 1, 1, 0.5)
    inst:AddTag("shadow")
    inst:AddTag("undead")

    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*3
    inst.components.locomotor.walkspeed = TUNING.WILSON_RUN_SPEED*2

        inst:SetStateGraph("SGshadowcreature")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst)


    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.CRAWLINGHORROR_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.CRAWLINGHORROR_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, Retarget)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CRAWLINGHORROR_HEALTH)
    inst.components.health.fa_resistances={}
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health:StartRegen(5,5)

        local brain = require "brains/shadowcreaturebrain"
        inst:SetBrain(brain)

    return inst
end


local function fa_magedecoy()
    
    local inst=common()
    
    MakeCharacterPhysics(inst, 10, .5)
    inst.DynamicShadow:SetSize( 2.5, 1.5 )
    
    inst:AddTag("fa_summon")
    inst.AnimState:SetBank("wilson")
    --i'm flat out cheating
    inst.AnimState:SetBuild("wizard")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("hat_hair")
    inst.AnimState:SetMultColour(1, 1, 1, 0.5)

    inst.components.locomotor.runspeed = DECOY_SPEED

    inst:SetStateGraph("SGskeletonspawn")
    
    inst:AddTag("notraptrigger")

    MakeMediumBurnableCharacter(inst, "torso")

    inst:AddComponent("combat")
    inst.components.combat:SetRetargetFunction(1, Retarget)
    inst:AddComponent("inventory")
    inst.components.combat.hiteffectsymbol = "torso"
    --if it did 'no damage' it would never take aggro!
    inst.components.combat:SetDefaultDamage(1)
    inst.components.combat:SetAttackPeriod(1)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(DECOY_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health:StartRegen(5,5)

    local brain = require "brains/magesummonbrain"
    inst:SetBrain(brain)


    inst.forceShutdown=guardianshutdown
    inst.shutdowntime=GetTime()+DECOY_DURATION
    inst.shutdowntask=inst:DoTaskInTime(DECOY_DURATION, guardianshutdown)

    
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    return inst
end


local slotpos_3x3 = {}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos_3x3, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
    end
end

local function fa_magehound()
    local inst=common()
    
    inst:AddTag("character")
    inst:AddTag("notraptrigger")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "chester.png" )

    inst.AnimState:SetBank("hound")
    inst.AnimState:SetBuild("hound_ice")
    inst.AnimState:PlayAnimation("idle")

    inst.DynamicShadow:SetSize( 2, 1.5 )
    
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    MakeCharacterPhysics(inst, 75, .5)

    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "chester_body"
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.CHESTER_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst:AddTag("noauradamage")


    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 7

    inst:AddComponent("knownlocations")

    MakeSmallBurnableCharacter(inst)
    
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos_3x3)
    
--    inst.components.container.onopenfn = OnOpen
--    inst.components.container.onclosefn = OnClose
    
    inst.components.container.widgetslotpos = slotpos_3x3
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160

    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    inst.components.sleeper.testperiod = GetRandomWithVariance(6, 2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWakeUp)

    inst:SetStateGraph("SGhound")

-- it's just a blind non combat follower, im lazy to make a new one
    local brain = require "brains/chesterbrain"
    inst:SetBrain(brain)

    return inst
end


local function dancinglight()
    -- spawnprefab would probably not be what i want, copy pasting isnt either so there we go
--    TheSim:LoadPrefabs( {"stafflight"} )
    local inst = Prefabs["stafflight"].fn()
    inst.init_time=DANCINGLIGHT_DURATION
    local kill_light=function()inst:Remove()end
    if inst.death then
        kill_light=inst.death.fn
        inst.death:Cancel()
        inst.death = nil
    end
    inst.timeleft = DANCINGLIGHT_DURATION
    inst.death = inst:DoTaskInTime(DANCINGLIGHT_DURATION, kill_light)


    inst.entity:AddPhysics()
    MakeGhostPhysics(inst, 1, .5)
    inst.components.propagator.spreading = false
    inst:AddComponent("follower")
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 2
    inst.components.locomotor.runspeed = 3
    inst.components.locomotor.directdrive = true
    inst:AddComponent("knownlocations")

    local brain = require "brains/wandererbrain"
    inst:SetBrain(brain)

    return inst
end

return Prefab( "common/fa_summonmonster1", fa_summonmonster1, fa_summonmonster1_assets),
    Prefab("common/fa_summonmonster2",fa_summonmonster2,fa_summonmonster2_assets),
    Prefab("common/fa_summonmonster3",fa_summonmonster3,fa_summonmonster3_assets),
    Prefab("common/fa_summonmonster4",fa_summonmonster4,fa_summonmonster4_assets),
    Prefab("common/fa_animatedead",fa_animatedead,fa_animated_assets),
    Prefab("common/fa_horrorpet",fa_horrorpet,fa_summonmonster1_assets),
    Prefab("common/fa_magedecoy",fa_magedecoy,fa_decoy_assets),
    Prefab("common/fa_magehound",fa_magehound,fa_summonmonster1_assets),
    Prefab("common/fa_dancinglight",dancinglight,fa_summonmonster1_assets)