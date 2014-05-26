local assets =
{
	Asset("ANIM", "anim/fa_bbq.zip"),
}

local prefabs =
{
	"smallmeat",
	"smallmeat_dried",
	"monstermeat",
	"monstermeat_dried",
	"meat",
	"meat_dried",
}

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
--    inst.AnimState:OverrideSymbol("swap_dried", "meat_rack_food", dryable)
end

local function setdone(inst, product)
    inst.AnimState:PlayAnimation("idle",true)
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
	minimap:SetIcon( "meatrack.png" )
	
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

	inst.components.dryer:SetStartDryingFn(onstartdrying)
	inst.components.dryer:SetDoneDryingFn(setdone)
	inst.components.dryer:SetContinueDryingFn(onstartdrying)
	inst.components.dryer:SetContinueDoneFn(setdone)
	inst.components.dryer:SetOnHarvestFn(onharvested)
    
    inst:AddComponent("inspectable")
    
    inst.components.inspectable.getstatus = getstatus
	MakeSnowCovered(inst, .01)	
	inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end

return Prefab( "common/objects/fa_bbq", fn, assets, prefabs )