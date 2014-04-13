require "prefabutil"
	local assets =
	{
		Asset("ANIM", "anim/wall.zip"),
		Asset("ANIM", "anim/wall_stone.zip"),
	Asset("ANIM", "anim/marble_pillar.zip"),
	}

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
		elseif percent < 1 then
			anim_to_play = "3_4"
		else
			anim_to_play = "1"
		end
		return anim_to_play
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
	local function fn(Sim)
		local inst = CreateEntity()
		local trans = inst.entity:AddTransform()
		local anim = inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		--trans:SetScale(1.3,1.3,1.3)
		inst:AddTag("wall")
		MakeObstaclePhysics(inst, .7)    
		inst.entity:SetCanSleep(false)
		anim:SetBank("wall")
		anim:SetBuild("wall_stone")
	    anim:PlayAnimation("3_4", false)
		
		MakeSnowCovered(inst)
		
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

return Prefab( "common/fa_dungeon_wall", fn, assets),
Prefab( "common/fa_dungeon_marblepillar", pillarfn, assets)