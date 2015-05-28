local assets =
{
	Asset("ANIM", "anim/fa_bbq.zip"),
}

local prefabs =
{
}


local function onextinguish(inst)
end

local function onignite(inst)
end

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst:Remove()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
end
        
local function onhit(inst, worker)
end

local function getstatus(inst)
    if inst.components.dryer and inst.components.dryer:IsDrying() then
        return "DRYING"
    elseif inst.components.dryer and inst.components.dryer:IsDone() then
        return "DONE"
    end
end

local function onstartdrying(inst, dryable)
--    inst.AnimState:PlayAnimation("drying_pre")
	inst.AnimState:PlayAnimation("idle", true)
    inst.components.burnable:Ignite()
--    inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food", dryable)
end

local function setdone(inst, product)
    inst.AnimState:PlayAnimation("idle",true)
    inst.components.burnable:Extinguish()
--    inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food", product)
end


local function onharvested(inst)
    inst.AnimState:PlayAnimation("empty")
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("empty", false)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
 
 	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "village.png" )
	
    inst.entity:AddSoundEmitter()
    inst:AddTag("structure")

    anim:SetBank("fa_bbq")
    anim:SetBuild("fa_bbq")
    anim:PlayAnimation("empty")

    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER) -- should be DRY
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
	inst:AddComponent("dryer")
	--I want to avoid rog logic so i can actually put something on it  - not like you can build it deliberately anyway
local function DoDry(inst)
    local dryer = inst.components.dryer
    if dryer then
	    dryer.task = nil
	    dryer.paused = nil
	    dryer.remainingtime = nil
    	
	    if dryer.ondonecooking then
		    dryer.ondonecooking(inst, dryer.product)
	    end

	    dryer.spoiltargettime = nil
    end
end

--turn off the rain thing, rescale timers and such
	function inst.components.dryer:StartDrying(dryable)
	if self:CanDry(dryable) then
	    self.ingredient = dryable.prefab
	    if self.onstartcooking then
		    self.onstartcooking(self.inst, dryable.prefab)
	    end
	    local cooktime = dryable.components.dryable:GetDryingTime()/4
	    self.product = dryable.components.dryable:GetProduct()

	    	self.targettime = GetTime() + cooktime
	    	self.task = self.inst:DoTaskInTime(cooktime, DoDry)

	    dryable:Remove()
		return true
	end
	end

	local old_harvest=inst.components.dryer.Harvest
	function inst.components.dryer:Harvest( harvester )
	if self:IsDone() then
		local loot = SpawnPrefab(self.product)
				if loot then
					if loot.components.perishable then
					    loot.components.perishable:SetPercent(1) --always full perishable
					end
					if(loot.components.stackable)then
						loot.components.stackable.stacksize=2
					else
						local cpy=SpawnPrefab(self.product)
						harvester.components.inventory:GiveItem(cpy, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
					end
					harvester.components.inventory:GiveItem(loot, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
				end

		if self.onharvest then
			self.onharvest(self.inst)
		end
		return true
	end

end


	inst.components.dryer:SetStartDryingFn(onstartdrying)
	inst.components.dryer:SetDoneDryingFn(setdone)
	inst.components.dryer:SetContinueDryingFn(onstartdrying)
	inst.components.dryer:SetContinueDoneFn(setdone)
	inst.components.dryer:SetOnHarvestFn(onharvested)
    
    inst:AddComponent("inspectable")


    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0,1,0) )
    inst:ListenForEvent("onextinguish", onextinguish)
    inst:ListenForEvent("onignite", onignite)
    inst.components.burnable:SetFXLevel(1, 1)
    
    inst.components.inspectable.getstatus = getstatus
	MakeSnowCovered(inst, .01)	
	inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end

return Prefab( "common/objects/fa_bbq", fn, assets, prefabs )