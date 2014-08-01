local assets =
{

    Asset("ANIM", "anim/ds_spider_basic.zip"),
    Asset("ANIM", "anim/ds_spider_warrior.zip"),
    Asset("ANIM", "anim/poisonspider.zip"),
    Asset("SOUND", "sound/spider.fsb"),
	Asset("ANIM", "anim/spider_build.zip"),
}

local warrior_assets =
{
	Asset("ANIM", "anim/ds_spider_white.zip"),
	Asset("ANIM", "anim/ds_spider_warrior.zip"),
	Asset("ANIM", "anim/spider_warrior_build.zip"),
    Asset("ANIM", "anim/poisonspider.zip"),
	Asset("SOUND", "sound/spider.fsb"),
}
    
    
local prefabs =
{
	"poisonspidergland",
    "spidergland",
    "monstermeat",
    "silk",
    "fa_poisonfx"
}

local FA_BuffUtil=require "buffutil"

local POISON_LENGTH=10
local POISON_DAMAGE=5
local POISON_PERIOD=2

local function NormalRetarget(inst)
    local targetDist = TUNING.SPIDER_TARGET_DIST
    if inst.components.knownlocations:GetLocation("investigate") then
        targetDist = TUNING.SPIDER_INVESTIGATETARGET_DIST
    end
    return FindEntity(inst, targetDist, 
        function(guy) 
            if inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy) then
                return guy:HasTag("character") and  guy.prefab~="webber"
            end
    end)
end

local function WarriorRetarget(inst)
    return FindEntity(inst, TUNING.SPIDER_WARRIOR_TARGET_DIST, function(guy)
		return ((guy:HasTag("character") and  guy.prefab~="webber") or guy:HasTag("pig"))
               and inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy)
	end)
end

local function FindWarriorTargets(guy)
	return ((guy:HasTag("character") and  guy.prefab~="webber") or guy:HasTag("pig"))
               and inst.components.combat:CanTarget(guy)
               and not (inst.components.follower and inst.components.follower.leader == guy)
end

local function keeptargetfn(inst, target)
   return target
          and target.components.combat
          and target.components.health
          and not target.components.health:IsDead()
          and not (inst.components.follower and inst.components.follower.leader == target)
end

local function ShouldSleep(inst)
    return GetClock():IsDay()
           and not (inst.components.combat and inst.components.combat.target)
           and not (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           and not (inst.components.burnable and inst.components.burnable:IsBurning() )
           and not (inst.components.follower and inst.components.follower.leader)
end

local function ShouldWake(inst)
    return GetClock():IsNight()
           or (inst.components.combat and inst.components.combat.target)
           or (inst.components.homeseeker and inst.components.homeseeker:HasHome() )
           or (inst.components.burnable and inst.components.burnable:IsBurning() )
           or (inst.components.follower and inst.components.follower.leader)
           or (inst:HasTag("spider_warrior") and FindEntity(inst, TUNING.SPIDER_WARRIOR_WAKE_RADIUS, function(...) return FindWarriorTargets(inst, ...) end ))
end

local function DoReturn(inst)
	if inst.components.homeseeker and inst.components.homeseeker.home and inst.components.homeseeker.home.components.childspawner then
		inst.components.homeseeker.home.components.childspawner:GoHome(inst)
	end
end

local function StartDay(inst)
	if inst:IsAsleep() then
		DoReturn(inst)	
	end
end

local function OnAttackOther(spider, data)
    local target=data.target
    local variables={}
    variables.strength=POISON_DAMAGE
    variables.period=POISON_PERIOD
        variables.buttontint={
                r=0.5,
                g=1,
                b=0.5,
                a=0.7
            }

    if(target and target.components.fa_bufftimers)then
        target.components.fa_bufftimers:AddBuff("poison","Poison","Poison",POISON_LENGTH,variables)
    else
        FA_BuffUtil.Poison(target,POISON_LENGTH,variables,spider)
    end
end

local function OnEntitySleep(inst)
	if GetClock():IsDay() then
		DoReturn(inst)
	end
end

local function SummonFriends(inst, attacker)
	local den = GetClosestInstWithTag("spiderden",inst, TUNING.SPIDER_SUMMON_WARRIORS_RADIUS)
	if den and den.components.combat and den.components.combat.onhitfn then
		den.components.combat.onhitfn(den, attacker)
	end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, 30, function(dude)
        return dude:HasTag("spider")
               and not dude.components.health:IsDead()
               and dude.components.follower
               and dude.components.follower.leader == inst.components.follower.leader
    end, 10)
end

local function StartNight(inst)
    inst.components.sleeper:WakeUp()
end

local function create_common(Sim)
	local inst = CreateEntity()
	
	inst:ListenForEvent( "daytime", function(i, data) StartDay( inst ) end, GetWorld())	
	inst.OnEntitySleep = OnEntitySleep
	
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 1.5, .5 )
    inst.Transform:SetFourFaced()
    
    
    ----------
    
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
    inst:AddTag("monster")
    inst:AddTag("hostile")
	inst:AddTag("scarytoprey")    
    inst:AddTag("canbetrapped")    
    
    MakeCharacterPhysics(inst, 10, .5)

    
    inst:AddTag("spider")
    inst.AnimState:SetBank("poisonspider")
    inst.AnimState:PlayAnimation("idle")
    
    -- locomotor must be constructed before the stategraph!
    inst:AddComponent("locomotor")
	inst.components.locomotor:SetSlowMultiplier( 1 )
	inst.components.locomotor:SetTriggersCreep(false)
    inst.components.locomotor.pathcaps = { ignorecreep = true }
  
    inst:SetStateGraph("SGspider")
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddRandomLoot("monstermeat", 1)
    inst.components.lootdropper:AddRandomLoot("silk", .5)
--    inst.components.lootdropper:AddRandomLoot("spidergland", .4)
    inst.components.lootdropper:AddChanceLoot("poisonspidergland", .1)
    inst.components.lootdropper.numrandomloot = 1
    
    inst:AddComponent("follower")
    
   
    ---------------------        
    MakeMediumBurnableCharacter(inst, "body")
    MakeMediumFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       
    
    
    ------------------
    inst:AddComponent("health")
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1
    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "body"
    inst.components.combat:SetKeepTargetFunction(keeptargetfn)
	inst.components.combat:SetOnHit(SummonFriends)
    
    ------------------
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(2)
    inst.components.sleeper:SetSleepTest(ShouldSleep)
    inst.components.sleeper:SetWakeTest(ShouldWake)
    ------------------
    
    inst:AddComponent("knownlocations")

    ------------------
    
    inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    
    ------------------
    
    inst:AddComponent("inspectable")
    
    ------------------
    
	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_SMALL
    
    
    local brain = require "brains/spiderbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("dusktime", function() StartNight(inst) end, GetWorld())

    return inst
end

local function create_spider(Sim)
    local inst = create_common(Sim)
    
    inst.AnimState:SetBuild("poisonspider")

    inst.components.health:SetMaxHealth(TUNING.SPIDER_HEALTH)

    inst.components.combat:SetDefaultDamage(TUNING.SPIDER_DAMAGE)
    inst.components.combat:SetAttackPeriod(TUNING.SPIDER_ATTACK_PERIOD)
    inst.components.combat:SetRetargetFunction(1, NormalRetarget)

    inst.components.locomotor.walkspeed = TUNING.SPIDER_WALK_SPEED
    inst.components.locomotor.runspeed = TUNING.SPIDER_RUN_SPEED


    inst:ListenForEvent("onattackother", OnAttackOther)

    return inst
end



return Prefab( "forest/monsters/poisonspider", create_spider, assets, prefabs)