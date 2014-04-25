

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

local function onfar(inst)
	inst.components.container:Close()
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")	
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.components.container:DropEverything()
	inst.AnimState:PushAnimation("closed", false)
	inst.components.container:Close()
end


local function chest(style)
	local fn = function(Sim)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		local minimap = inst.entity:AddMiniMapEntity()
		
		minimap:SetIcon( style..".png" )


		inst:AddTag("structure")
		inst.AnimState:SetBank(chests[style].bank)
		inst.AnimState:SetBuild(chests[style].build)
		inst.AnimState:PlayAnimation("closed")
		
		inst:AddComponent("inspectable")
		inst:AddComponent("container")
		inst.components.container:SetNumSlots(#slotpos)
		
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose
	    inst.components.container.itemtestfn = itemtest
		
		inst.components.container.widgetslotpos = slotpos
	    inst.components.container.widgetanimbank = "ui_cookpot_1x4"
    	inst.components.container.widgetanimbuild = "ui_cookpot_1x4"
	    inst.components.container.widgetpos = Vector3(200,0,0)
    	inst.components.container.side_align_tip = 100
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = true

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose


    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)
		
		inst:AddComponent("lootdropper")
		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(2)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit) 
		
		MakeSnowCovered(inst, .01)	

		inst:AddComponent( "spawner" )
	    inst.components.spawner.spawnsleft=1
	    inst.components.spawner.onoutofspawns=onhammered
	    inst.components.spawner:Configure( "fa_dorf_trader", 2)
--    	inst.components.spawner.onoccupied = onoccupied
--    	inst.components.spawner.onvacate = onvacate
		return inst
	end
	return fn
end

return Prefab( "common/fa_dorftrader_chest", chest("skull_chest"), assets)