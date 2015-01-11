local goblinassets=
{
	Asset("ANIM", "anim/fa_goblinskin.zip"),
}
local orcassets=
{
    Asset("ANIM", "anim/fa_goblinskin.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    inst.AnimState:SetBank("fa_goblinskin")
    inst.AnimState:SetBuild("fa_goblinskin")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("inspectable")
    
	MakeSmallBurnable(inst)
    MakeSmallPropagator(inst)
    

	inst:AddComponent("tradable")    
	inst.components.tradable.goldvalue = TUNING.GOLD_VALUES.MEAT
	
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_goblinskin"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    
    inst:AddComponent("edible")
    inst.components.edible.foodtype = "HORRIBLE"
    

    return inst
end

local function goblinskin()
    local inst=fn()

    return inst
end

local function orcskin()
    local inst=fn()

    return inst
end

return Prefab( "common/inventory/fa_goblinskin", goblinskin, goblinassets),
Prefab( "common/inventory/fa_orcskin", orcskin, orcassets)