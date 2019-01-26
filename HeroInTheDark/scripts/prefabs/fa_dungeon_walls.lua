require "prefabutil"
	local assets =
	{
		Asset("ANIM", "anim/fa_wall.zip"),
		Asset("ANIM", "anim/marble_pillar.zip"),
	}
local lava_assets={
		Asset("ANIM", "anim/fa_lavawall.zip"),
}
local orc_assets={
	Asset("ANIM", "anim/fa_orcwall_1.zip"),
}
local bloody_orc_assets={
	Asset("ANIM", "anim/fa_orcwall_2.zip"),
}
local LAVAWALL_HEALTH=2000

	local function makeobstacle(inst)
	
	
		inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)	
	    inst.Physics:ClearCollisionMask()
		--inst.Physics:CollidesWith(COLLISION.WORLD)
		inst.Physics:SetMass(0)
		inst.Physics:CollidesWith(COLLISION.ITEMS)
		inst.Physics:CollidesWith(COLLISION.CHARACTERS)
		inst.Physics:SetActive(true)
	    local ground = GetWorld()
	    if ground then
	    	local pt = Point(inst.Transform:GetWorldPosition())
			--print("    at: ", pt)
	    	ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
	    end
	end

	local function resolveanimtoplay(percent)
		local anim_to_play = nil
		if percent <= 0 then
			anim_to_play = "0"
		elseif percent <= .4 then
			anim_to_play = "1_4"
		elseif percent <= .5 then
			anim_to_play = "1_2"
		elseif percent < 0.95 then
			anim_to_play = "3_4"
		else
			anim_to_play = "1"
		end
		return anim_to_play
	end

local function clearobstacle(inst)
	    local ground = GetWorld()
	    if ground then
	    	local pt = Point(inst.Transform:GetWorldPosition())
	    	ground.Pathfinder:RemoveWall(pt.x, pt.y, pt.z)
	    end
	end
	
	local function onhealthchange(inst, old_percent, new_percent)
		
		if old_percent <= 0 and new_percent > 0 then makeobstacle(inst) end
		if old_percent > 0 and new_percent <= 0 then clearobstacle(inst) end

		local anim_to_play = resolveanimtoplay(new_percent)
		if new_percent > 0 then
			inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
			inst.AnimState:PushAnimation(anim_to_play, false)		
		else
			inst.AnimState:PlayAnimation(anim_to_play)		
		end
	end


	local function test_wall(inst, pt)
		local tiletype = GetGroundTypeAtPosition(pt)
		local ground_OK = tiletype ~= GROUND.IMPASSABLE 
		
		if ground_OK then
			local ents = TheSim:FindEntities(pt.x,pt.y,pt.z, 2, nil, {"NOBLOCK", "player", "FX", "INLIMBO", "DECOR"}) -- or we could include a flag to the search?

			for k, v in pairs(ents) do
				if v ~= inst and v.entity:IsValid() and v.entity:IsVisible() and not v.components.placer and v.parent == nil then
					local dsq = distsq( Vector3(v.Transform:GetWorldPosition()), pt)
					if v:HasTag("wall") then
						if dsq < .1 then return false end
					else
						if  dsq< 1 then return false end
					end
				end
			end
			
			return true

		end
		return false
		
	end
	local function onremoveentity(inst)
		clearobstacle(inst)
	end

	local function onload(inst, data)
		--print("walls - onload")
		if(data and data.fakewall==true)then
			inst:AddTag("fa_secretwall")
			inst.Physics:SetCollides(false)
		else
			makeobstacle(inst)
		end
		if inst.components.health and inst.components.health:GetPercent() <= 0 then
			clearobstacle(inst)
		end

	end

	local function stonewallfn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst:AddTag("wall")
		MakeObstaclePhysics(inst, .7)    
		inst.entity:SetCanSleep(false)
		anim:SetBank("fa_wall")
		anim:SetBuild("fa_wall")
	    anim:PlayAnimation("3_4", false)
		
		MakeSnowCovered(inst)
	    inst.OnLoad = onload
	    inst.OnRemoveEntity = onremoveentity
		
		return inst
	end

	local function pillarfn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()

	MakeObstaclePhysics(inst, 1)

	anim:SetBank("marble_pillar")
	anim:SetBuild("marble_pillar")
	anim:PlayAnimation("full")
--[[
	                inst.AnimState:PlayAnimation("low")
	                inst.AnimState:PlayAnimation("med")
	                inst.AnimState:PlayAnimation("full")
]]
	MakeSnowCovered(inst, 0.1)
	return inst
	end

local function ondeploywall(inst, pt, deployer,data)
		local wall = SpawnPrefab("fa_"..data.name.."wall") 
		if wall then 
			pt = Vector3(math.floor(pt.x)+.5, 0, math.floor(pt.z)+.5)
			wall.Physics:SetCollides(false)
			wall.Physics:Teleport(pt.x, pt.y, pt.z) 
			wall.Physics:SetCollides(true)
			inst.components.stackable:Get():Remove()

		    local ground = GetWorld()
		    if ground then
		    	ground.Pathfinder:AddWall(pt.x, pt.y, pt.z)
		    end
		end 		
	end

	local function onhammered(inst, worker,data)
		if data.maxloots and data.loot then
			local num_loots = math.max(1, math.floor(data.maxloots*inst.components.health:GetPercent()))
			for k = 1, num_loots do
				inst.components.lootdropper:SpawnLootPrefab(data.loot)
			end
		end		
		
		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		if data.destroysound then
			inst.SoundEmitter:PlaySound(data.destroysound)		
		end
		
		inst:Remove()
	end



	local function itemfn(data)

		local inst = CreateEntity()
		inst:AddTag("wallbuilder")
		
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
	    
		inst.AnimState:SetBank("fa_"..data.name.."wall")
		inst.AnimState:SetBuild("fa_"..data.name.."wall")
		inst.AnimState:PlayAnimation("idle")

		inst:AddComponent("stackable")
		inst.components.stackable.maxsize = TUNING.STACK_SIZE_MEDITEM

		inst:AddComponent("inspectable")
    	inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_"..data.name.."wall"
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
		
		inst:AddComponent("repairer")
	    inst.components.repairer.repairmaterial = data.name

		inst.components.repairer.healthrepairvalue = data.maxhealth / 6
	    
		
		if data.flammable then
			MakeSmallBurnable(inst, TUNING.MED_BURNTIME)
			MakeSmallPropagator(inst)
			
			inst:AddComponent("fuel")
			inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL
		end
		
		inst:AddComponent("deployable") 
		inst.components.deployable.ondeploy = function(inst, pt, deployer) ondeploywall(inst, pt, deployer,data) end
		inst.components.deployable.test = test_wall
		inst.components.deployable.min_spacing = 0
		inst.components.deployable.placer = "fa_"..data.name.."wall_placer"
		
		return inst
	end

	local function onhit(inst,data)
		if data.destroysound then
			inst.SoundEmitter:PlaySound(data.destroysound)		
		end

		local healthpercent = inst.components.health:GetPercent()
		local anim_to_play = resolveanimtoplay(healthpercent)
		if healthpercent > 0 then
			inst.AnimState:PlayAnimation(anim_to_play.."_hit")		
			inst.AnimState:PushAnimation(anim_to_play, false)	
		end	

	end

	local function onrepaired(inst,data)
		if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)		
		end
		makeobstacle(inst)
	end
	    


	local function normfn(data)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		--trans:SetScale(1.3,1.3,1.3)
		inst:AddTag("wall")
		MakeObstaclePhysics(inst, .5)    
		inst.entity:SetCanSleep(false)
		anim:SetBank("fa_"..data.name.."wall")
		anim:SetBuild("fa_"..data.name.."wall")
	    anim:PlayAnimation("1_2", false)
	    
		inst:AddComponent("inspectable")
		inst:AddComponent("lootdropper")
		
		for k,v in ipairs(data.tags) do
		    inst:AddTag(v)
		end
				
		inst:AddComponent("repairable")
	    inst.components.repairable.repairmaterial = data.name
		inst.components.repairable.onrepaired = function(inst) onrepaired(inst,data) end
		
		inst:AddComponent("combat")
		inst.components.combat.onhitfn = function(inst)onhit(inst,data)end
		
		inst:AddComponent("health")
		inst.components.health:SetMaxHealth(data.maxhealth)
		inst.components.health.currenthealth = data.maxhealth / 2
		inst.components.health.ondelta = onhealthchange
		inst.components.health.nofadeout = true
		inst.components.health.canheal = false
		inst:AddTag("noauradamage")
		
		if data.flammable then
			MakeLargeBurnable(inst)
			MakeLargePropagator(inst)
			inst.components.burnable.flammability = .5
		else
			inst.components.health.fire_damage_scale = 0
		end

		if data.buildsound then
			inst.SoundEmitter:PlaySound(data.buildsound)		
		end
		
		if(data.heater)then
			inst:AddComponent("heater")
			if(data.heater<0)then
				inst.components.heater.iscooler=true
			end
			inst.components.heater.heat=data.heater		
		end

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(3)
		inst.components.workable:SetOnFinishCallback(function(inst, worker) onhammered(inst, worker,data) end)
		inst.components.workable:SetOnWorkCallback(function(inst) onhit(inst,data) end) 
				
		
	    inst.OnLoad = onload
	    inst.OnRemoveEntity = onremoveentity
		
		MakeSnowCovered(inst)
		
		return inst
	end

local lavawall_data={name = "lava", tags={"stone"}, heater=50, loot = "fa_lavapebble", maxloots = 2, maxhealth=LAVAWALL_HEALTH, buildsound="dontstarve/common/place_structure_stone", destroysound="dontstarve/common/destroy_stone"}

local function lavafn()
	local inst=normfn(lavawall_data)
	return inst
end
local function lavaitemfn()
	return itemfn(lavawall_data)
end
local function dorfwallfn()
	local inst=stonewallfn()
	inst.AnimState:SetBank("fa_lavawall")
	inst.AnimState:SetBuild("fa_lavawall")
	return inst
end
local function fa_orcwall_1()
	local inst=stonewallfn()
	inst.AnimState:SetBank("fa_orcwall_1")
	inst.AnimState:SetBuild("fa_orcwall_1")
	return inst
end
local function fa_orcwall_2()
	local inst=stonewallfn()
	inst.AnimState:SetBank("fa_orcwall_2")
	inst.AnimState:SetBuild("fa_orcwall_2")
	return inst
end


return Prefab( "common/fa_dungeon_wall", stonewallfn, assets),
	Prefab( "common/fa_dorf_wall_1", dorfwallfn, lava_assets),
	Prefab( "common/fa_dungeon_marblepillar", pillarfn, assets),
	Prefab( "common/fa_lavawall",lavafn , lava_assets),
	Prefab( "common/fa_orcwall_1",fa_orcwall_1 , orc_assets),
	Prefab( "common/fa_orcwall_2",fa_orcwall_2 , bloody_orc_assets),
	Prefab( "common/fa_lavawall_item", lavaitemfn, lava_assets, {"fa_lavawall", "fa_lavawall_placer"}),
	MakePlacer("common/fa_lavawall_placer", "fa_lavawall", "fa_lavawall", "1_2", false, false, true) 
	