local assets=
{
    Asset("ANIM", "anim/fa_keys.zip"),
}
local lockpick_assets=
{
    Asset("ANIM", "anim/fa_lockpick.zip"),
}
local function fn(type,keylevel)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("fa_keys")
		inst.AnimState:SetBuild("fa_keys")
		inst.AnimState:PlayAnimation(type)
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_key.tex" )

    	
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_key_"..type
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    	inst:AddComponent("key")
    	inst.components.key.keytype="chest"
    	if(keylevel)then
    		inst.components.key.keytype=inst.components.key.keytype.."_t"..keylevel
    	end
	    
		inst:AddComponent("tradable")
	    
		return inst
	end

local function fnfoli()
	return fn("foli")
end
local function fnjewel()
	return fn("jewel",3)
end
local function fnskeleton()
	return fn("skeleton",2)
end
local function fngeneric()
	return fn("generic",1)
end
local function fnswift()
	return fn("swift",4)
end

local function lockpickfn()
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("fa_lockpick")
		inst.AnimState:SetBuild("fa_lockpick")
		inst.AnimState:PlayAnimation("idle")
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_lockpick.tex" )

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = 99

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_lockpick"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("fa_lockpick")

    return inst

end

return Prefab( "common/inventory/fa_key_foli", fnfoli, assets),
Prefab( "common/inventory/fa_key_jewel", fnjewel, assets),
Prefab( "common/inventory/fa_key_skeleton", fnskeleton, assets),
Prefab( "common/inventory/fa_key_generic", fngeneric, assets),
Prefab( "common/inventory/fa_key_swift", fnswift, assets),
Prefab( "common/inventory/fa_lockpick", lockpickfn, lockpick_assets)