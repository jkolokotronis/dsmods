require "prefabutil"

local cooking = require("cooking")

local assets=
{
	Asset("ANIM", "anim/manuremachine.zip"),
}

local prefabs={
	"poopbricks"
}

local BUILD_DURATION=10

local function onhammered(inst, worker)
	if inst.components.stewer.product and inst.components.stewer.done then
		inst.components.lootdropper:AddChanceLoot(inst.components.stewer.product, 1)
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	
	inst.AnimState:PlayAnimation("hit_empty")
	
	if inst.components.stewer.cooking then
		inst.AnimState:PushAnimation("cooking_loop")
	elseif inst.components.stewer.done then
		inst.AnimState:PushAnimation("idle_full")
	else
		inst.AnimState:PushAnimation("idle_empty")
	end
	
end



local slotpos = {	Vector3(0,64+32+8+4,0), 
					Vector3(0,32+4,0),
					Vector3(0,-(32+4),0), 
					Vector3(0,-(64+32+8+4),0)}

local widgetbuttoninfo = {
	text = "Cook",
	position = Vector3(0, -165, 0),
	fn = function(inst)
		inst.components.stewer:StartCooking()	
	end,
	
	validfn = function(inst)
		return inst.components.stewer:CanCook()
	end,
}

local function itemtest(inst, item, slot)
	if item.prefab=="poop" then
		return true
	end
end


--anim and sound callbacks

local function startcookfn(inst)
	inst.AnimState:PlayAnimation("player feeds poop")
	inst.AnimState:PushAnimation("cooking", true)
	--play a looping sound
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
	inst.Light:Enable(true)
end


local function onopen(inst)
--	inst.AnimState:PlayAnimation("player_feeds_poop", true)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
	if not inst.cooldowntask then
--		inst.AnimState:PlayAnimation("idle player close empty",true)
		inst.SoundEmitter:KillSound("snd")
	else
--		inst.AnimState:PlayAnimation("cooking", true)
	end
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end


local function continuedonefn(inst)
	inst.AnimState:PlayAnimation("idle player close empty",true)
--	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.stewer.product)
end

local function continuecookfn(inst)
	inst.AnimState:PlayAnimation("cooking", true)
	--play a looping sound
	inst.Light:Enable(true)

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function harvestfn(inst)
	inst.AnimState:PlayAnimation("idle_empty")
end


local function onfar(inst)
	inst.components.container:Close()
end


local function fueltest(inst)
	if inst.cooldowntask then
		return true
	end

        local items=inst.components.container:FindItems(function(item)
            if(item.prefab=="poop")then
                return true
            else
                return false
            end
        end)
        local taken={}
        local counter=5
        for k,v in pairs(items) do
        	if(counter>0)then
        	if(v.components.stackable )then
        		if(v.components.stackable.stacksize<counter)then
        			table.insert(taken,{item=v,count=-1})
        			counter=counter-v.components.stackable.stacksize
        		else
        			table.insert(taken,{item=v,count=counter})
        			counter=0
        			break
        		end
        	else
        		table.insert(taken, {item=v,count=-1})
        		counter=counter-1
        	end
        	end
        end

        if(counter==0)then
        	print("starting shit")
        	for k,v in pairs(taken) do
        		local count=v.count
        		local it=v.item
        		if(count>0)then
        			for k = 1,count do
        				inst.components.container:RemoveItem(it,false):Remove()
        			end
        		else
	        		inst.components.container:RemoveItem(v.item,true):Remove()
	        	end
        	end
        	 startcookfn(inst)
	        inst.buildCooldown=BUILD_DURATION+GetTime()
    	    inst.cooldowntask=inst:DoTaskInTime(BUILD_DURATION, function() inst.donecookfn(inst) end)
        end
        
end


local donecookfn=function(inst)
	inst.AnimState:PlayAnimation("brick is made")
--	inst.AnimState:PushAnimation("idle player close empty",true)
--	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.stewer.product)
	
	
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
	inst.Light:Enable(false)
	--play a one-off sound
	local loot = SpawnPrefab("poopbricks")
        
	local pt = Point(inst.Transform:GetWorldPosition())
	        
	loot.Transform:SetPosition(pt.x,pt.y,pt.z)
	        
		local angle = math.random()*2*PI
		loot.Physics:SetVel(2*math.cos(angle), 10, 2*math.sin(angle))

		if loot and loot.Physics  then
		pt = pt + Vector3(math.cos(angle), 0, math.sin(angle))*((loot.Physics:GetRadius() or 1) )
		loot.Transform:SetPosition(pt.x,pt.y,pt.z)
	end
--	inst.AnimState:PlayAnimation("idle_empty")
	inst.cooldowntask:Cancel()
	inst.cooldowntask=nil
	fueltest(inst)
end


local onloadfn = function(inst, data)
	if(data.buildCooldown and data.buildCooldown>0)then
		startcookfn(inst)
  	    inst.cooldowntask=inst:DoTaskInTime(data.buildCooldown, function() inst.donecookfn(inst) end)
	end
end

local onsavefn = function(inst, data)
	if(inst.cooldowntask)then
	    data.buildCooldown=GetTime()-inst.buildCooldown
	end
end


local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("idle player close empty",true)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "cookpot.png" )
	
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("manuremachine")
    inst.AnimState:SetBuild("manuremachine")
    inst.AnimState:PlayAnimation("idle player close empty",true)

    inst.buildCooldown=0
    inst.building=false
    
    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(4)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_cookpot_1x4"
    inst.components.container.widgetanimbuild = "ui_cookpot_1x4"
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.side_align_tip = 100
--    inst.components.container.widgetbuttoninfo = widgetbuttoninfo

    inst:ListenForEvent("itemget",fueltest)
--    inst.components.container.acceptsstacks = false

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose



    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)


    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst, .01)    
	inst:ListenForEvent( "onbuilt", onbuilt)

	inst.donecookfn=donecookfn

    return inst
end


return Prefab( "common/fizzlemanipulator", fn, assets, prefabs),
		MakePlacer( "common/fizzlemanipulator_placer", "manuremachine", "manuremachine", "idle player far empty" ) 
