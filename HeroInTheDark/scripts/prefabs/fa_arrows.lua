local assets_wood=
{
    Asset("ANIM", "anim/fa_woodarrows.zip"),
    Asset("ANIM", "anim/fa_woodarrows_projectile.zip"),
}
local assets_ice=
{
    Asset("ANIM", "anim/fa_icearrows.zip"),
    Asset("ANIM", "anim/fa_icearrows_projectile.zip"),
}
local assets_poison=
{
    Asset("ANIM", "anim/fa_poisonarrows.zip"),
    Asset("ANIM", "anim/fa_poisonarrows_projectile.zip"),
}
local assets_fire=
{
    Asset("ANIM", "anim/fa_firearrows.zip"),
    Asset("ANIM", "anim/fa_firearrows_projectile.zip"),
}

local function onsewn(inst, target, doer)
    if doer.SoundEmitter then
        doer.SoundEmitter:PlaySound("dontstarve/HUD/repair_clothing")
    end
end
local function fn(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.AnimState:SetBank("fa_"..name.."arrows")
    inst.AnimState:SetBuild("fa_"..name.."arrows")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_"..name.."arrows"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot =EQUIPSLOTS.QUIVER


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
    return fn("wood")
end

local function icefn(Sim)
    return fn("ice")
end

local function firefn(Sim)
     return fn("fire")
end

local function poisonfn(Sim)
    return fn("poison")
end

local function OnHit(inst, owner, target)
    inst:Remove()
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
end

local function oncollide(inst, other)
--    print("collision with ",other)
    if(inst.components.projectile.target and inst.components.projectile.target==other)then
        print("hit the target, ignore, should never happen")
    else
        if(other)then
--            print("target",inst.components.projectile.target,"other",other)
            inst.components.projectile:Hit(other)
        else
            inst.components.projectile:Miss()--the hell does target mean here?
        end
    end
end

local function fnprojectile(name)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    inst.Physics:SetCollisionCallback(oncollide)
--    RemovePhysicsColliders(inst)
    inst.AnimState:SetBank("fa_"..name+"_projectile")
    inst.AnimState:SetBuild("fa_"..name.."_projectile")
    inst.AnimState:PlayAnimation("idle", true)
    
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
    return fnprojectile("woodarrows")
end

local function iceprojectile(Sim)
    return fnprojectile("icearrows")
end

local function fireprojectile(Sim)
    return fnprojectile("firearrows")
end

local function poisonprojectile(Sim)
    return fnprojectile("poisonarrows")
end

return Prefab( "common/inventory/fa_woodarrows", woodfn, assets_wood),
 Prefab( "common/inventory/fa_woodarrowsprojectile", woodprojectile, assets_wood),
  Prefab( "common/inventory/fa_icearrows", icefn, assets_ice),
   Prefab( "common/inventory/fa_icearrowsprojectile", iceprojectile, assets_ice),
    Prefab( "common/inventory/fa_poisonarrows", poisonfn, assets_poison),
    Prefab( "common/inventory/fa_poisonarrowsprojectile", poisonprojectile, assets_poison),
    Prefab( "common/inventory/fa_firearrows", firefn, assets_fire),
    Prefab( "common/inventory/fa_firearrowsprojectile", fireprojectile, assets_fire)


