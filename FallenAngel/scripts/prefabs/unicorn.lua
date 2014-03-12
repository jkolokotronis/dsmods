local assets=
{
    Asset("ANIM", "anim/beefalo_basic.zip"),
    Asset("ANIM", "anim/beefalo_actions.zip"),
    Asset("ANIM", "anim/beefalo_build.zip"),
}

local PET_HEALTH=300



local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    
    shadow:SetSize( 6, 2 )
    inst.Transform:SetFourFaced()

    MakeCharacterPhysics(inst, 100, .5)

    inst.entity:AddPhysics()
 
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)
    
    inst:AddTag("animal")
    inst:AddTag("largecreature")
    inst:AddTag("prey")

    anim:SetBank("beefalo")
    anim:SetBuild("beefalo_build")

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "livinglog", "meat"})
    
    anim:PlayAnimation("idle")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.walkspeed = TUNING.WILSON_RUN_SPEED
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*3

    inst:AddComponent("follower")
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
        

    MakeLargeBurnableCharacter(inst, "beefalo_body")
    MakeLargeFreezableCharacter(inst, "beefalo_body")

    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "beefalo_body"
    inst.components.combat:SetDefaultDamage(TUNING.BEEFALO_DAMAGE)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health:SetInvincible(false)

--    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGBeefalo")

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    return inst
end

return Prefab( "common/unicorn", fn, assets)
