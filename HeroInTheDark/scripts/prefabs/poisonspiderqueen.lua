local assets =
{
	Asset("ANIM", "anim/poisonspider_queen.zip"),
    Asset("ANIM", "anim/poisonspider_queen2.zip"),
}

local prefabs =
{
    "monstermeat",
    "silk",
    "spiderhat",
    "poisonspidereggsack",
}

local loot =
{
    "monstermeat",
    "monstermeat",
    "monstermeat",
    "monstermeat",
    "silk",
    "silk",
    "silk",
    "silk",
    "poisonspidereggsack",
    "spiderhat",
}

local SPIDERQUEEN_WALKSPEED = 1.75
local SPIDERQUEEN_HEALTH = 2200
local SPIDERQUEEN_DAMAGE = 80--, 35% chance to poison on hit ("Spider Queen poison" does 30 dmg every 5 sec for 30 sec)
local SPIDERQUEEN_ATTACKPERIOD = 3
local   SPIDERQUEEN_ATTACKRANGE = 5

local POISON_DAMAGE=30
local POISON_PERIOD=5
local POISON_LENGTH=30
local POISON_CHANCE=0.35

local SHARE_TARGET_DIST = 30


local function dopoison(inst,target)
    if(target and not target.components.health:IsDead())then
        --bypassing armor - but this also bypasses potential retarget
--        target.components.health:DoDelta(-POISON_DAMAGE)
            target.components.combat:GetAttacked(inst.caster, POISON_DAMAGE, nil,nil,FA_DAMAGETYPE.POISON)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end

local function OnAttackOther(spider, data)
  if(math.random()>POISON_CHANCE)then return end
  
  local target=data.target

  if(target and target.components.health and target.components.combat and not target.components.health:IsDead())then

    if target.fa_poison then
        if(target.fa_poison.strength and target.fa_poison.strength==POISON_DAMAGE)then
            print("resetting poison timer")
            target.fa_poison.components.spell.lifetime = 0
        --        reader.fa_inspiregreatness.components.spell:ResumeSpell()
            return true
        elseif(target.fa_poison.strength and target.fa_poison.strength>POISON_DAMAGE)then
            print("don't overwrite stronger poison")
            return true
        else
            target.fa_poison.components.spell:OnFinish() 
        end
    end

      local inst = CreateEntity()
      inst.persists=false
      local caster=spider
      local trans = inst.entity:AddTransform()

    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_poison"
    inst.strength=POISON_DAMAGE
    inst.components.spell.duration = POISON_LENGTH
    inst.components.spell.fn = dopoison
    inst.components.spell.period=POISON_PERIOD
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=caster
        target.fa_poison = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_poison = nil
    end
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
  end
end

local function Retarget(inst)
    if not inst.components.health:IsDead() and not inst.components.sleeper:IsAsleep() then
        local oldtarget = inst.components.combat.target

        local newtarget = FindEntity(inst, 10, 
            function(guy) 
                if inst.components.combat:CanTarget(guy) then
                    return guy:HasTag("character")
                end
            end)
        
        if newtarget and newtarget ~= oldtarget then
			inst.components.combat:SetTarget(newtarget)
        end
    end
end

local function OnAttacked(inst, data)
    inst.components.combat:SetTarget(data.attacker)
    inst.components.combat:ShareTarget(data.attacker, SHARE_TARGET_DIST, function(dude) return dude.prefab == "spiderqueen" and not dude.components.health:IsDead() end, 2)
end
    
local function fn(Sim)
	local inst = CreateEntity()

    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddLightWatcher()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 7, 3 )
    inst.Transform:SetFourFaced()
    
    
    ----------
    
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("epic")    
    inst:AddTag("largecreature")
    inst:AddTag("spiderqueen")    
    inst:AddTag("spider")    
    
    MakeCharacterPhysics(inst, 1000, 1)

    
    inst.AnimState:SetBank("spider_queen")
    inst.AnimState:SetBuild("poisonspider_queen")
    inst.AnimState:PlayAnimation("idle", true)
    
    inst:SetStateGraph("SGpoisonspiderqueen")
    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot(loot)
    
    ---------------------        
    MakeLargeBurnableCharacter(inst, "body")
    MakeLargeFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       
    
    
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(SPIDERQUEEN_HEALTH)

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat:SetRange(SPIDERQUEEN_ATTACKRANGE)
    inst.components.combat:SetDefaultDamage(SPIDERQUEEN_DAMAGE)
    inst.components.combat:SetAttackPeriod(SPIDERQUEEN_ATTACKPERIOD)
    inst.components.combat:SetRetargetFunction(3, Retarget)
    
    ------------------

	inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_HUGE

   
    ------------------
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(4)
    ------------------
    
    inst:AddComponent("locomotor")
	inst.components.locomotor:SetSlowMultiplier( 1 )
	inst.components.locomotor:SetTriggersCreep(false)
	inst.components.locomotor.pathcaps = { ignorecreep = true }
	inst.components.locomotor.walkspeed = SPIDERQUEEN_WALKSPEED

    ------------------
    
    inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    
    ------------------
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("leader")
    
    ------------------
    
    local brain = require "brains/poisonspiderqueenbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onattackother", OnAttackOther)

    return inst
end

local pos2=function()
    local inst=fn()
    inst.AnimState:SetBuild("poisonspider_queen2")
    return inst
end

return Prefab( "forest/monsters/poisonspiderqueen", fn, assets, prefabs),
Prefab( "forest/monsters/poisonspiderqueen2", pos2, assets, prefabs)
    
