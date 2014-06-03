local assets=
{

    Asset("SOUND", "sound/hound.fsb"),
    Asset("SOUND", "sound/ghost.fsb"),
    Asset("ANIM", "anim/waxwell_shadow_mod.zip"),
    Asset("SOUND", "sound/maxwell.fsb"),
    Asset("ANIM", "anim/swap_pickaxe.zip"),
    Asset("ANIM", "anim/swap_axe.zip"),
    Asset("ANIM", "anim/swap_nightmaresword.zip"),
}

local items =
{
    AXE = "swap_axe",
    PICK = "swap_pickaxe",
    SWORD = "swap_nightmaresword"
}
local PET_HEALTH=300

    
local function EquipItem(inst, item)
    if item then
        inst.AnimState:OverrideSymbol("swap_object", item, item)
        inst.AnimState:Show("ARM_carry") 
        inst.AnimState:Hide("ARM_normal")
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
    --print(inst, "OnAttacked")
    local attacker = data.attacker

    if attacker and attacker:HasTag("player") then
--        inst.components.health:SetVal(0)
    else
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

local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 2.5, 1.5 )
    inst.Transform:SetTwoFaced()
    inst.Transform:SetScale(0.75, 0.75, 0.75)

    
    inst.entity:AddPhysics()
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)
    
    inst:AddTag("pet")
    inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")

    MakeCharacterPhysics(inst, 10, .5)
 

    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    
    anim:SetBank("wilson")
    anim:SetBuild("waxwell_shadow_mod")

    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
    inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = false

    inst.items = items
    inst.equipfn = EquipItem

    EquipItem(inst)

    anim:PlayAnimation("idle")


    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--  inst.components.locomotor.groundspeedmultiplier = 10
    inst.components.locomotor.walkspeed = TUNING.WILSON_RUN_SPEED
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*3
    inst.components.locomotor:SetTriggersCreep(false)
    

    inst:SetStateGraph("SGshadowwaxwell")

    inst:AddComponent("inspectable")
        
    inst:AddComponent("follower")

    ---------------------       
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    ------------------

    
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(0.75)
    inst.components.combat:SetRetargetFunction(0.1, Retarget)
--    inst.components.combat:SetKeepTargetFunction(KeepTarget)
    inst.components.combat.areahitdamagepercent=0.0

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health:StartRegen(5,5)
    inst.components.health:SetInvincible(false)

    local brain = require "brains/darkknightpetbrain"
    inst:SetBrain(brain)

    
    return inst
end

return Prefab( "common/darkknightpet", fn, assets)
