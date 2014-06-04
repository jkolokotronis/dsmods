local assets=
	{
		Asset("ANIM", "anim/cook_pot_food.zip"),
	}
	
	local prefabs = 
	{
		"spoiled_food",
	}
	
	local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBuild("cook_pot_food")
		inst.AnimState:SetBank("food")
		inst.AnimState:PlayAnimation("fruitmedley", false)
	    

		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 75
		inst.components.edible.hungervalue = 5
		inst.components.edible.foodtype = "GENERIC"
		inst.components.edible.sanityvalue = 5

		inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename="fruitmedley"
		
		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = 20


	    
		return inst
	end

	return Prefab( "common/inventory/natureshealing", fn, assets, prefabs)