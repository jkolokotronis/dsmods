local assets_wood =
{
	Asset("ANIM", "anim/fa_barrel_wood.zip"),	
}
local assets_hotrum =
{
	Asset("ANIM", "anim/fa_barrel_hotrum.zip"),	
}
local assets_darkrum =
{
	Asset("ANIM", "anim/fa_barrel_darkrum.zip"),	
}
local function fn(name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
	inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.healthvalue=0
    inst.components.edible.hungervalue=0
    inst.components.edible.sanityvalue=0
    --this might need to change but... I see no reason to care
    inst.components.edible.foodtype = "FA_POTION"
    inst:AddComponent("tradable")

    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=name
    inst.components.inventoryitem.atlasname="images/inventoryimages/"..name..".xml"

	return inst
end

local function woodfn(Sim)
	return fn("fa_barrel_wood")
end 
local function hotrumfn(Sim)
	return fn("fa_barrel_hotrum")
end 
local function darkrumfn(Sim)
	return fn("fa_barrel_darkrum")
end 
return Prefab( "common/fa_barrel_wood", woodfn, assets_wood),
Prefab( "common/fa_barrel_hotrum", hotrumfn, assets_hotrum),
Prefab( "common/fa_barrel_darkrum", darkrumfn, assets_darkrum)