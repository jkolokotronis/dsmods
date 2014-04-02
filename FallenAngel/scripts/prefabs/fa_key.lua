local assets=
{
    Asset("ANIM", "anim/fa_key.zip"),
    
    Asset("ATLAS", "images/inventoryimages/fa_key.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_key.tex"),
}

local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("fa_key")
		inst.AnimState:SetBuild("fa_key")
		inst.AnimState:PlayAnimation("idle")
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_key.tex" )

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_key"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_key.xml"
	    
		inst:AddComponent("tradable")
	    
		return inst
	end

return Prefab( "common/inventory/fa_key", fn, assets)