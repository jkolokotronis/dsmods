
local assets =
{
    Asset("ANIM", "anim/fa_bucket.zip"),
}

local WATER_REGEN=120
        
local function onhammered(inst, worker)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onwork(inst, worker, workleft)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
--	local minimap = inst.entity:AddMiniMapEntity()
--	minimap:SetIcon( "fa_alchemytable.tex" )
	
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, .5)
    
    inst.AnimState:SetBank("fa_bucket")
    inst.AnimState:SetBuild("fa_bucket")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.15, 1.15, 1.15)


    inst.full=false
    inst:AddComponent("inspectable")
	inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "boards","boards","boards","boards"})
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(2)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable.onwork=onwork
	MakeSnowCovered(inst, .01)    
    return inst
end

local function fnwater()
    local inst=fn()

    inst:AddComponent("harvestable")
    local function onharvest(bucket, picker, produce)
        if(picker and picker.components.temperature)then
            picker.components.temperature.current = math.max( picker.components.temperature.current-40, picker.components.temperature.mintemp)
        end
        inst.AnimState:PlayAnimation("idle")        
    end
    local function ongrow(  )
        inst.AnimState:PlayAnimation("full")        
    end
    inst.components.harvestable:SetUp(nil, nil, WATER_REGEN, onharvest, ongrow)
    inst.components.harvestable:Grow()
    inst.components.harvestable.getverb=function(target, doer)
        return "USE"
    end

    return inst
end

return Prefab( "common/fa_bucket", fn, assets),
Prefab("common/fa_dorf_bucket_water",fnwater,assets)