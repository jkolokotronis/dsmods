local assets=
{
    Asset("ANIM", "anim/fa_woodarrows.zip"),
    Asset("ANIM", "anim/fa_icearrows.zip"),
    Asset("ANIM", "anim/fa_poisonarrows.zip"),
    Asset("ANIM", "anim/fa_firearrows.zip"),
    Asset("ANIM", "anim/fa_woodarrows_projectile.zip"),
    Asset("ANIM", "anim/fa_icearrows_projectile.zip"),
    Asset("ANIM", "anim/fa_poisonarrows_projectile.zip"),
    Asset("ANIM", "anim/fa_firearrows_projectile.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_woodarrows.xml"),
    Asset("ATLAS", "images/inventoryimages/fa_icearrows.xml"),
    Asset("ATLAS", "images/inventoryimages/fa_poisonarrows.xml"),
    Asset("ATLAS", "images/inventoryimages/fa_firearrows.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_woodarrows.tex"),
    Asset("IMAGE", "images/inventoryimages/fa_icearrows.tex"),
    Asset("IMAGE", "images/inventoryimages/fa_poisonarrows.tex"),
    Asset("IMAGE", "images/inventoryimages/fa_firearrows.tex"),
}

local function onsewn(inst, target, doer)
    if doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("dontstarve/HUD/repair_clothing")
    end
end
local function fn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst:AddComponent("inventoryitem")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 99

    inst:AddComponent("reloading")
    inst.components.reloading.returnuses=7
    inst.components.reloading.ammotype="arrows"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    return inst
end

local function woodfn(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBank("fa_woodarrows")
    inst.AnimState:SetBuild("fa_woodarrows")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_woodarrows.xml"
    inst.components.inventoryitem.imagename="fa_woodarrows"
    return inst
end

local function icefn(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBank("fa_icearrows")
    inst.AnimState:SetBuild("fa_icearrows")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_icearrows.xml"
    inst.components.inventoryitem.imagename="fa_icearrows"
    return inst
end

local function firefn(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBank("fa_firearrows")
    inst.AnimState:SetBuild("fa_firearrows")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_firearrows.xml"
    inst.components.inventoryitem.imagename="fa_firearrows"
    return inst
end

local function poisonfn(Sim)
    local inst=fn(Sim)
    inst.AnimState:SetBank("fa_poisonarrows")
    inst.AnimState:SetBuild("fa_poisonarrows")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_poisonarrows.xml"
    inst.components.inventoryitem.imagename="fa_poisonarrows"
    return inst
end

local function OnHit(inst, owner, target)
    inst:Remove()
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
end
local function projectile()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
--    RemovePhysicsColliders(inst)
    
    inst:AddTag("projectile")
    inst.Transform:SetScale(1, 1, 1)
    
    inst:AddComponent("projectile")
    inst:ListenForEvent("onthrown", onthrown)
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnHit)
    
    return inst
end

local function woodprojectile(Sim)
    local inst = common()
    inst.AnimState:SetBank("fa_woodarrows_projectile")
    inst.AnimState:SetBuild("fa_woodarrows_projectile")
    inst.AnimState:PlayAnimation("idle", true)

    return inst
end

local function iceprojectile(Sim)
    local inst = common()
    inst.AnimState:SetBank("fa_icearrows_projectile")
    inst.AnimState:SetBuild("fa_icearrows_projectile")
    inst.AnimState:PlayAnimation("idle", true)

    return inst
end

local function fireprojectile(Sim)
    local inst = common()
    inst.AnimState:SetBank("fa_firearrows_projectile")
    inst.AnimState:SetBuild("fa_firearrows_projectile")
    inst.AnimState:PlayAnimation("idle", true)

    return inst
end

local function poisonprojectile(Sim)
    local inst = common()
    inst.AnimState:SetBank("fa_poisonarrows_projectile")
    inst.AnimState:SetBuild("fa_poisonarrows_projectile")
    inst.AnimState:PlayAnimation("idle", true)

    return inst
end

return Prefab( "common/inventory/fa_woodarrows", woodfn, assets),
 Prefab( "common/inventory/fa_woodarrowsprojectile", woodprojectile, assets),
  Prefab( "common/inventory/fa_icearrows", icefn, assets),
   Prefab( "common/inventory/fa_icearrowsprojectile", iceprojectile, assets),
    Prefab( "common/inventory/fa_poisonarrows", poisonfn, assets),
    Prefab( "common/inventory/fa_poisonarrowsprojectile", poisonprojectile, assets),
    Prefab( "common/inventory/fa_firearrows", firefn, assets),
    Prefab( "common/inventory/fa_firearrowsprojectile", fireprojectile, assets)


