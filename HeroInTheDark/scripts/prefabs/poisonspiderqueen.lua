local assets =
{
	Asset("ANIM", "anim/poisonspider_queen.zip"),
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
local FA_BuffUtil=require "buffutil"

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

local function OnAttackOther(spider, data)
  if(math.random()>POISON_CHANCE)then return end

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
    
    inst:AddTag("fa_animal")
    inst:AddTag("fa_evil")
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
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_35",0.25)
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,0.15)
     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys2,FALLENLOOTTABLE.TABLE_KEYS2_WEIGHT,0.15)
    
    ---------------------        
    MakeLargeBurnableCharacter(inst, "body")
    MakeLargeFreezableCharacter(inst, "body")
    inst.components.burnable.flammability = TUNING.SPIDER_FLAMMABILITY
    ---------------------       
    
    
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(SPIDERQUEEN_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1

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

return Prefab( "forest/monsters/poisonspiderqueen", fn, assets, prefabs)
    
