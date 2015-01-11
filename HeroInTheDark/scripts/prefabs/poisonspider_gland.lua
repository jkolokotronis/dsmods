local assets=
{
	Asset("ANIM", "anim/poisonspider_gland.zip"),
}

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("spider_gland")
    inst.AnimState:SetBuild("poisonspider_gland")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
    
	MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
    MakeSmallPropagator(inst)

    ---------------------       
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="poisonspidergland"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    
    
    return inst
end

return Prefab( "common/inventory/poisonspidergland", fn, assets) 

