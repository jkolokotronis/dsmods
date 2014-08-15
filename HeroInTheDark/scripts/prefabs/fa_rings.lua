local assets=
{
    Asset("ANIM", "anim/fa_rings.zip"),
    
    Asset("ATLAS", "images/inventoryimages/fa_rings.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_rings.tex"),
}

local function fn(color,type)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
    inst.AnimState:SetBank("fa_ring_"..color.."_"..type)
    inst.AnimState:SetBuild("fa_rings")
    inst.AnimState:PlayAnimation("idle")
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_key.tex" )

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_ring_"..color.."_"..type
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_rings.xml"
	    
		inst:AddComponent("tradable")
	    
		return inst
	end

local function fnfoli()
	return fn("green","gold")
end


return	Prefab( "common/inventory/fa_ring_green_gold", fnfoli, assets)