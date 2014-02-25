local assets=
{
	Asset("ANIM", "anim/boards.zip"),
}

local BURN_TIME=TUNING.MED_BURNTIME*5
local FUEL_VALUE=TUNING.MED_FUEL*5
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("boards")
    inst.AnimState:SetBuild("boards")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM

    inst:AddComponent("inspectable")
    
	MakeSmallBurnable(inst, BURN_TIME)
    MakeSmallPropagator(inst)
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="boards"
    
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = FUEL_VALUE
    
    return inst
end

return Prefab( "common/inventory/poopbricks", fn, assets) 
