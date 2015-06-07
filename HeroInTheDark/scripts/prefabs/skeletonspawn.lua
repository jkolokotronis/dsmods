local assets=
{
    Asset("ANIM", "anim/wilton.zip"),
}
local drybones_assets={
    Asset("ANIM", "anim/drybones.zip"),
}
local skull_assets={
    Asset("ANIM", "anim/fa_skull.zip"),
}
local zombie_assets={
    Asset("ANIM", "anim/fa_zombie.zip"),
}
local ghoul_assets={
    Asset("ANIM", "anim/fa_ghoul.zip"),
}
local mummy_assets={
    Asset("ANIM", "anim/fa_mummy.zip"),
}
local leprechaun_assets={
    Asset("ANIM", "anim/fa_leprechaun.zip"),
}
local vampire_assets={
    Asset("ANIM", "anim/fa_vampire.zip"),
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
--    light:Enable(true)


    anim:SetBank("wilson")
    anim:SetBuild("wilton")
    anim:PlayAnimation("idle")
    
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
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
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)

    inst:AddComponent("inventory")
--    inst:AddComponent("sanity")
    
--    inst.components.inventory.starting_inventory = inventoryrng



    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
--    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED+2

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
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.4
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGskeletonspawn")

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    
    return inst
end

local function spawn(Sim)
    local inst=fn(Sim)
    inst:AddTag("skeleton")
    inst.components.lootdropper:SetLoot({ "boneshard","boneshard"})

    inst.components.inventory.dropondeath = true
    GetInventory(inst)
    return inst
end

local function drybones(Sim)
    local inst=fn(Sim)
    inst:AddTag("skeleton")
    local anim=inst.AnimState
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    anim:SetBank("wilson")
    anim:SetBuild("drybones")
    anim:PlayAnimation("idle")
    inst.components.lootdropper:SetLoot({ "boneshard","boneshard"})
    

    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
    return inst
end

local function skull(Sim)
    local inst=fn(Sim)
    inst:AddTag("skeleton")
    local anim=inst.AnimState
--    inst.Transform:SetScale(2, 2, 2)
    anim:SetBank("wilson")
    anim:SetBuild("fa_skull")
    anim:PlayAnimation("idle")
    inst.components.lootdropper:SetLoot({ "boneshard","boneshard"})

    return inst
end

local function firedartspawn(Sim)
     local inst=drybones(Sim)
    inst:AddTag("skeleton")
    local anim=inst.AnimState
    inst.components.inventory.dropondeath = true
    GetFireDart(inst)
    inst.components.lootdropper:SetLoot({ "boneshard","boneshard"})
    return inst
end

local function fa_zombie(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState
    anim:SetBuild("fa_zombie")
    return inst
end
local function fa_ghoul(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState
    anim:SetBuild("fa_ghoul")
    return inst
end
local function fa_mummy(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBuild("fa_mummy")
    return inst
end
local function fa_leprechaun(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBuild("fa_leprechaun")
    return inst
end
local function fa_vampire(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBuild("fa_vampire")
    inst.aggroed=false

    inst.components.combat:SetRetargetFunction(1, function(inst)
        local invader = FindEntity(inst, TUNING.MERM_TARGET_DIST, function(guy)
            return guy:HasTag("character") and not guy:HasTag("undead")
        end)
        if(invader)then
            if not inst.aggroed then
                inst.aggroed=true
                inst.AnimState:OverrideSymbol("face", "fa_vampire", "face_aggro")
            end
        elseif inst.aggroed==true then
            inst.aggroed=false
            inst.AnimState:ClearOverrideSymbol("face")
        end
        return invader
    end)

    return inst
end


return Prefab( "common/skeletonspawn", spawn, assets),
     Prefab( "common/fa_drybones", drybones, drybones_assets),
     Prefab("common/fa_dartdrybones", firedartspawn, drybones_assets),
     Prefab("common/fa_skull", skull, skull_assets),
     Prefab("common/fa_zombie", fa_zombie, zombie_assets),
     Prefab("common/fa_ghoul", fa_ghoul, ghoul_assets),
     Prefab("common/fa_mummy", fa_mummy, mummy_assets),
     Prefab("common/fa_leprechaun", fa_leprechaun, leprechaun_assets),
     Prefab("common/fa_vampire", fa_vampire, vampire_assets)