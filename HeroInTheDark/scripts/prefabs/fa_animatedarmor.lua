local assets=
{
    Asset("SOUND", "sound/ghost.fsb"),
    Asset("ANIM", "anim/fa_invisible.zip"),
}

local THULECITE_HP=100
local COPPER_HP = 50
local IRON_HP = 75
local STEEL_HP= 150
local GOLD_HP= 150
local SILVER_HP= 150
local ADAMANT_HP= 300




local function GetInventory(inst)
    --inv doesnt reload fully on load, have to prevent double spawning
    inst:DoTaskInTime(0,function()

        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("ruinshat")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("armorruins")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("ruins_bat")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true

    end)
end
local function GetCopper(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_copper")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_copperarmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_coppersword")
        else
            item=SpawnPrefab("fa_copperaxe")
        end
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function GetIron(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_iron")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_ironarmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_ironsword")
        else
            item=SpawnPrefab("fa_ironaxe")
        end
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function GetSteel(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_steel")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_steelarmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_steelsword")
        else
            item=SpawnPrefab("fa_steelaxe")
        end
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function GetGold(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_gold")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_goldarmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_silversword")
        else
            item=SpawnPrefab("fa_silveraxe")
        end
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function GetSilver(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_silver")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_silverarmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_silversword")
        else
            item=SpawnPrefab("fa_silveraxe")
        end
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function GetAdamant(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_hat_adamantine")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_adamantinearmor")
        inst.components.inventory:Equip(item)
        if(math.random()<0.5)then
            item=SpawnPrefab("fa_adamantinesword")
        else
            item=SpawnPrefab("fa_adamantineaxe")
        end
        inst.components.inventory:Equip(item)
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

local function RetargetFn(inst)
    local invader = FindEntity(inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") 
    end)
    return invader
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
    anim:SetBuild("fa_invisible")
    anim:PlayAnimation("idle")
    
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddTag("fa_neutral")
    inst:AddTag("fa_construct")

    MakeCharacterPhysics(inst, 20, .5)
 
    inst:AddComponent("eater")    
    inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = true
    inst:AddComponent("lootdropper")
--    inst:AddComponent("sanity")
    
--    inst.components.inventory.starting_inventory = inventoryrng



    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
--    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*2

    inst:AddComponent("follower")
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
--    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat.areahitdamagepercent=0.0

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(THULECITE_HP)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.25
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FORCE]=-0.30

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGanimated")

    local brain = require "brains/animatedarmorbrain"
    inst:SetBrain(brain)

    return inst
end

local function spawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(THULECITE_HP)
    GetInventory(inst)
    return inst
end

local function copperspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(COPPER_HP)
    GetCopper(inst)
    return inst
end

local function ironspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(IRON_HP)
    GetIron(inst)
    return inst
end

local function steelspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(STEEL_HP)
    GetSteel(inst)
    return inst
end

local function goldspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(GOLD_HP)
    GetGold(inst)
    return inst
end

local function silverspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(SILVER_HP)
    GetSilver(inst)
    return inst
end

local function adamantspawn(Sim)
    local inst=fn(Sim)
    inst.components.inventory.dropondeath = true
    inst.components.health:SetMaxHealth(ADAMANT_HP)
    GetAdamant(inst)
    return inst
end
return Prefab( "common/fa_animatedarmor", spawn, assets),
Prefab( "common/fa_animatedarmor_copper", copperspawn, assets),
Prefab( "common/fa_animatedarmor_iron", ironspawn, assets),
Prefab( "common/fa_animatedarmor_steel", steelspawn, assets),
Prefab( "common/fa_animatedarmor_gold", goldspawn, assets),
Prefab( "common/fa_animatedarmor_silver", silverspawn, assets),
Prefab( "common/fa_animatedarmor_adamantine", adamantspawn, assets)

