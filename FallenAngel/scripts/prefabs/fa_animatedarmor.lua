local assets=
{
    Asset("SOUND", "sound/ghost.fsb"),
    Asset("ANIM", "anim/fa_invisible.zip"),
}

local PET_HEALTH=100


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

    end)
end
    

local onloadfn = function(inst, data)
    inst.loadedSpawn=true
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

    MakeCharacterPhysics(inst, 20, .5)
 
    inst:AddComponent("eater")    
    inst:AddComponent("lootdropper")
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
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
--    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat.areahitdamagepercent=0.0

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health:SetInvincible(false)

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGanimated")

    local brain = require "brains/animatedarmorbrain"
    inst:SetBrain(brain)

    return inst
end

local function spawn(Sim)
    local inst=fn(Sim)
    local anim=inst.AnimState

    inst.components.inventory.dropondeath = true
    GetInventory(inst)
    return inst
end

return Prefab( "common/fa_animatedarmor", spawn, assets)
