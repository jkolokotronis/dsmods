local assets=
{
    Asset("ANIM", "anim/goodberries.zip"),
    
    Asset("ATLAS", "images/inventoryimages/goodberries.xml"),
    Asset("IMAGE", "images/inventoryimages/goodberries.tex"),
}

local function fn(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
		inst.AnimState:SetBank("goodberries")
		inst.AnimState:SetBuild("goodberries")
		inst.AnimState:PlayAnimation("idle")
	    
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 5
		inst.components.edible.hungervalue = 1
		inst.components.edible.sanityvalue = 10
		inst.components.edible.foodtype = "VEGGIE"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
		
		inst:AddComponent("stackable")
		

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="goodberries"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/goodberries.xml"
	    
	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)
		---------------------        

		inst:AddComponent("bait")
	    
		------------------------------------------------
		inst:AddComponent("tradable")
	    
		------------------------------------------------  
	    

		return inst
	end

return Prefab( "common/inventory/fa_goodberries", fn, assets)