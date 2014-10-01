local assets=
{
    Asset("ANIM", "anim/goodberries.zip"),
    
    Asset("ATLAS", "images/inventoryimages/goodberries.xml"),
    Asset("IMAGE", "images/inventoryimages/goodberries.tex"),
}

local cutwheat_assets={
    Asset("ANIM", "anim/fa_cutwheat.zip"),	
    Asset("ATLAS", "images/inventoryimages/fa_cutwheat.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_cutwheat.tex"),
}

local wheat_assets={
    Asset("ANIM", "anim/fa_wheat.zip"),	
    Asset("ATLAS", "images/inventoryimages/fa_wheat.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_wheat.tex"),
}

local nut_assets={
    Asset("ANIM", "anim/fa_nuts.zip"),	
    Asset("ATLAS", "images/inventoryimages/fa_nuts.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_nuts.tex"),
}

local flour_assets={
    Asset("ANIM", "anim/fa_flour.zip"),	
    Asset("ATLAS", "images/inventoryimages/fa_flour.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_flour.tex"),	
}

local function common(name)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)

		inst.AnimState:SetBank(name)
		inst.AnimState:SetBuild(name)
		inst.AnimState:PlayAnimation("idle")

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")

    	inst.components.inventoryitem.imagename=name
    	inst.components.inventoryitem.atlasname="images/inventoryimages/"..name..".xml"

		inst:AddComponent("stackable")
	    inst.components.stackable.maxsize = 40

	    return inst
end

local function fn(Sim)
		local inst = common("goodberries")
		
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 5
		inst.components.edible.hungervalue = 1
		inst.components.edible.sanityvalue = 10
		inst.components.edible.foodtype = "VEGGIE"

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
		
	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		inst:AddComponent("bait")
		inst:AddComponent("tradable")

		return inst
	end

local function fnnuts(Sim)
		local inst = common("fa_nuts")
		
		inst:AddComponent("edible")
		inst.components.edible.healthvalue = 5
		inst.components.edible.hungervalue = 1
		inst.components.edible.sanityvalue = 10
		inst.components.edible.foodtype = "VEGGIE"
		
	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		inst:AddComponent("bait")
		inst:AddComponent("tradable")

		return inst
	end

local function fnflour(Sim)
		local inst = common("fa_flour")

		inst:AddComponent("perishable")
		inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
		inst.components.perishable:StartPerishing()
		inst.components.perishable.onperishreplacement = "spoiled_food"
		
	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		inst:AddComponent("bait")
		inst:AddComponent("tradable")

		return inst
	end

local function fncutwheat(Sim)
	--what's the proper inv/drop for cut? is it in the pack at all?
		local inst = common("fa_cutwheat")

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL		
	    MakeSmallBurnable(inst)
		MakeSmallPropagator(inst)

		inst:AddComponent("bait")
		inst:AddComponent("tradable")

		return inst
	end

	--should i even allow this?
	local function fndugwheat(Sim)
		local inst = common("fa_wheat")
		inst.AnimState:PlayAnimation("dropped")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_LARGEITEM
		
--		inst.components.inspectable.nameoverride = data.inspectoverride or "dug_"..data.name
	    
		inst:AddComponent("fuel")
		inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
	    

        MakeMediumBurnable(inst, TUNING.LARGE_BURNTIME)
		MakeSmallPropagator(inst)
		
	    inst:AddComponent("deployable")
	    --inst.components.deployable.test = function() return true end
	    inst.components.deployable.ondeploy =function(inst, pt)
			local tree = SpawnPrefab("fa_wheat") 
			if tree then 
				tree.Transform:SetPosition(pt.x, pt.y, pt.z) 
				inst.components.stackable:Get():Remove()
				tree.components.pickable:OnTransplant()
			end 
		end
--	    inst.components.deployable.test = test_ground
	    inst.components.deployable.min_spacing =  2
	    
		return inst      
	end



-- would someone try to keep this alive if it were witherable in an env built around fire? it shouldve adapted to be more resistant than crap outdoors
-- besides, i always hated the spontaneous combustion to begin with, and hopefully dorfs knew how to select the best seeds
	local function fnwheat(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
	    local sound = inst.entity:AddSoundEmitter()
		local minimap = inst.entity:AddMiniMapEntity()

		minimap:SetIcon( "fa_wheat.tex" )
	    
	    anim:SetBank("fa_wheat")
	    anim:SetBuild("fa_wheat")
	    anim:PlayAnimation("idle",true)
	    anim:SetTime(math.random()*2)
	    local color = 0.75 + math.random() * 0.25
	    anim:SetMultColour(color, color, color, 1)

		inst:AddComponent("pickable")
		inst.components.pickable.picksound = "dontstarve/wilson/pickup_reeds"


local function ontransplantfn(inst)
	if inst.components.pickable then
		inst.components.pickable:MakeBarren()
	end
end

local function dig_up(inst, chopper)
	if inst.components.pickable and inst.components.pickable:CanBePicked() then
		inst.components.lootdropper:SpawnLootPrefab("fa_cutwheat")
	end
	if inst.components.pickable and not inst.components.pickable.withered then
		local bush = inst.components.lootdropper:SpawnLootPrefab("fa_dug_wheat")
	else
		inst.components.lootdropper:SpawnLootPrefab("fa_cutwheat")
	end
	inst:Remove()
end

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("grow") 
	inst.AnimState:PushAnimation("idle", true)
end

local function makeemptyfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		inst.AnimState:PlayAnimation("dead_to_empty")
		inst.AnimState:PushAnimation("picked")
	else
		inst.AnimState:PlayAnimation("picked")
	end
end

local function makebarrenfn(inst)
	if inst.components.pickable and inst.components.pickable.withered then
		if not inst.components.pickable.hasbeenpicked then
			inst.AnimState:PlayAnimation("full_to_dead")
		else
			inst.AnimState:PlayAnimation("empty_to_dead")
		end
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PlayAnimation("idle_dead")
	end
end


local function onpickedfn(inst)
	inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	inst.AnimState:PlayAnimation("picking") 
	
	if inst.components.pickable and inst.components.pickable:IsBarren() then
		inst.AnimState:PushAnimation("idle_dead")
	else
		inst.AnimState:PushAnimation("picked")
	end

end
		
		inst.components.pickable:SetUp("fa_cutwheat", TUNING.GRASS_REGROW_TIME)
		inst.components.pickable.onregenfn = onregenfn
		inst.components.pickable.onpickedfn = onpickedfn
		inst.components.pickable.makeemptyfn = makeemptyfn
		inst.components.pickable.makebarrenfn = makebarrenfn
		inst.components.pickable.max_cycles = 20
		inst.components.pickable.cycles_left = 20   
		inst.components.pickable.ontransplantfn = ontransplantfn


		inst:AddComponent("lootdropper")
	    inst:AddComponent("inspectable")    
	    
		inst:AddComponent("workable")
	    inst.components.workable:SetWorkAction(ACTIONS.DIG)
	    inst.components.workable:SetOnFinishCallback(dig_up)
	    inst.components.workable:SetWorkLeft(1)
	    
	    ---------------------        

	    MakeMediumBurnable(inst)
	    MakeSmallPropagator(inst)

--		MakeNoGrowInWinter(inst)  
		  
	    ---------------------   
	    
	    return inst
	end


return Prefab( "common/inventory/fa_goodberries", fn, assets),
Prefab( "common/inventory/fa_nuts", fnnuts, nut_assets),
Prefab( "common/inventory/fa_flour", fnflour, flour_assets),
Prefab( "common/inventory/fa_cutwheat", fncutwheat, cutwheat_assets),
Prefab( "common/inventory/fa_dug_wheat", fndugwheat, wheat_assets),
Prefab( "common/inventory/fa_wheat", fnwheat, wheat_assets)