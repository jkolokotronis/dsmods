local assets=
{


        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),

    Asset("SOUND", "sound/hound.fsb"),
    Asset("SOUND", "sound/ghost.fsb"),
    Asset("ANIM", "anim/wilton.zip"),
    Asset("ANIM", "anim/drybones.zip"),
    Asset("ANIM", "anim/fa_skull.zip"),
    Asset("ANIM", "anim/swap_nightmaresword.zip")
}

local PET_HEALTH=300

local function GetFireDart(inst)
 inst:DoTaskInTime(0,function()

        if(inst.loadedSpawn)then
            return
        end
            local dart=SpawnPrefab("blowdart_fire")
            dart.components.stackable:SetStackSize(20)
            inst.components.inventory:Equip(dart)
    end)
end

local function GetInventory(inst)
    --inv doesnt reload fully on load, have to prevent double spawning
    inst:DoTaskInTime(0,function()

        if(inst.loadedSpawn)then
            return
        end
    local rng = math.random()
    local item=nil
    if(rng<0.5)then
--empty
    elseif(rng<0.75)then        
--spawn weap
        item=SpawnPrefab("hambat")
    elseif(rng<0.85)then
--spawn helm
        item=SpawnPrefab("footballhat") 
    else
--spawn armor
        item=SpawnPrefab("armorgrass")
    end
    if(item)then
        inst.components.inventory:Equip(item)
    end
         inst.loadedSpawn=true

    end)
end
    


local onloadfn = function(inst, data)
     if(data)then
        inst.loadedSpawn=data.loadedSpawn
    end
end

local onsavefn = function(inst, data)
    data.loadedSpawn=inst.loadedSpawn
end


local function OnEat(inst, food)
    
    if food.components.edible and food.components.edible.foodtype == "MEAT" then
        local poo = SpawnPrefab("spoiled_food")
        poo.Transform:SetPosition(inst.Transform:GetWorldPosition())        
    end

end    


local function RetargetFn(inst)
    local invader = FindEntity(inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("undead")
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

local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 2.5, 1.5 )
--    inst.Transform:SetTwoFaced()
    inst.Transform:SetFourFaced()

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst.entity:AddPhysics()
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)


    anim:SetBank("wilson")
    anim:SetBuild("wilton")
    anim:PlayAnimation("idle")
    
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
    inst:AddTag("skeleton")
    inst:AddTag("undead")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")

    MakeCharacterPhysics(inst, 20, .5)
 
inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boneshard","boneshard"})

    inst:AddComponent("inventory")
--    inst:AddComponent("sanity")
    
--    inst.components.inventory.starting_inventory = inventoryrng



    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
--    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*2

    inst:AddComponent("follower")
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
--    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat.areahitdamagepercent=0.0

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health.fa_resistances={}
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGskeletonspawn")

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    
    return inst
end

local function spawn(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState

    inst.components.inventory.dropondeath = true
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    GetInventory(inst)
    return inst
end

local function drybones(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState
    inst.Transform:SetScale(2, 2, 2)
    anim:SetBank("wilson")
    anim:SetBuild("drybones")
    anim:PlayAnimation("idle")

    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
    return inst
end

local function skull(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState
--    inst.Transform:SetScale(2, 2, 2)
    anim:SetBank("wilson")
    anim:SetBuild("fa_skull")
    anim:PlayAnimation("idle")

    return inst
end

local function firedartspawn(Sim)
     local inst=drybones(Sim)
    local anim=inst.AnimState
    inst.components.inventory.dropondeath = true
    GetFireDart(inst)
    return inst
end


return Prefab( "common/skeletonspawn", spawn, assets),
     Prefab( "common/fa_drybones", drybones, assets),
     Prefab("common/fa_dartdrybones", firedartspawn, assets),
     Prefab("common/fa_skull", skull, assets)