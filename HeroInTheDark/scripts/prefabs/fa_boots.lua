local assets=
{
    Asset("ANIM", "anim/fa_walkingshoes.zip"),
}
local socksassets={
    Asset("ANIM", "anim/fa_dorf_socks.zip"),
}

local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("fa_walkingshoes")
		inst.AnimState:SetBuild("fa_walkingshoes")
		inst.AnimState:PlayAnimation("idle")
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_walkingshoes.tex" )

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_walkingshoes"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
	    
		inst:AddComponent("tradable")
	    
		return inst
	end

local function socks()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    anim:SetBank("fa_dorf_socks")
    anim:SetBuild("fa_dorf_socks")
    anim:PlayAnimation("idle",true)
		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_dorf_socks"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
	
    return inst
end
return Prefab( "common/inventory/fa_walkingshoes", fn, assets),
Prefab("common/inventory/fa_dorf_socks",socks,socksassets)