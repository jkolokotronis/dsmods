local assets=
{
    Asset("ANIM", "anim/fa_keys.zip"),
    
    Asset("ATLAS", "images/inventoryimages/fa_keys.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_keys.tex"),
}

local function fn(type)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("fa_keys")
		inst.AnimState:SetBuild("fa_keys")
		inst.AnimState:PlayAnimation(type)
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_key.tex" )

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_key_"..type
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_keys.xml"
	    
		inst:AddComponent("tradable")
	    
		return inst
	end

local function fnfoli()
	return fn("foli")
end
local function fnjewel()
	return fn("jewel")
end
local function fnskeleton()
	return fn("skeleton")
end
local function fngeneric()
	return fn("generic")
end
local function fnswift()
	return fn("swift")
end


return Prefab( "common/inventory/fa_key_foli", fnfoli, assets),
Prefab( "common/inventory/fa_key_jewel", fnjewel, assets),
Prefab( "common/inventory/fa_key_skeleton", fnskeleton, assets),
Prefab( "common/inventory/fa_key_generic", fngeneric, assets),
Prefab( "common/inventory/fa_key_swift", fnswift, assets)