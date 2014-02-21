local assets=
{
    Asset("ANIM", "anim/arrows.zip"),
    Asset("ATLAS", "images/inventoryimages/arrows.xml")
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
    
    inst.AnimState:SetBank("moditem")
    inst.AnimState:SetBuild("arrows")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/arrows.xml"

    inst:AddComponent("inspectable")
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 99

--[[
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(1)
    inst.components.finiteuses:SetUses(1)
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("sewing")
    inst.components.sewing.repair_value = TUNING.SEWINGKIT_REPAIR_VALUE
    inst.components.sewing.onsewn = onsewn
    
    ----------------------------------------------------------------

    ---------------------
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
]]
    inst:AddComponent("reloading")
    inst.components.reloading.returnuses=7
    inst.components.reloading.ammotype="arrows"

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    ---------------------        
    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

----------------------------------------------------------------
    
    return inst
end

return Prefab( "common/inventory/arrows", fn, assets)
