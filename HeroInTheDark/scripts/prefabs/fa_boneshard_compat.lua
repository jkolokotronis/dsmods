--I might be breaking some rules here, but it's totally stupid to break vanilla compat because of it, or jump through hoops 
local assets = 
{
	Asset("ANIM", "anim/bone_shards_compat.zip")
}

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)

    anim:SetBank("bone_shards_compat")
    anim:SetBuild("bone_shards_compat")
    anim:PlayAnimation("idle",false)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="bone_shards_compat"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("stackable")

	return inst
end

return Prefab("common/inventory/boneshard", fn, assets)