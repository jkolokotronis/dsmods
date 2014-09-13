require "prefabutil"
require "recipes"

local assets =
{
    Asset("ANIM", "anim/pig_house.zip"),
	Asset("ANIM", "anim/goblinhut.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}

local prefabs = 
{
	"goblin",
}


local function onfar(inst) 
    if inst.components.spawner:IsOccupied() then
        LightsOn(inst)
    end
end

local function getstatus(inst)
    if inst.components.spawner and inst.components.spawner:IsOccupied() then
        if inst.lightson then
            return "FULL"
        else
            return "LIGHTSOUT"
        end
    end
end

local function onnear(inst) 
    if inst.components.spawner:IsOccupied() then
        LightsOff(inst)
    end
end
        
        
local function onhammered(inst, worker)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
--	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function OnDay(inst)
    --print(inst, "OnDay")
    if inst.components.spawner:IsOccupied() then
        LightsOff(inst)
        if inst.doortask then
            inst.doortask:Cancel()
            inst.doortask = nil
        end
        inst.doortask = inst:DoTaskInTime(1 + math.random()*2, function() inst.components.spawner:ReleaseChild() end)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 10, 8.5 )

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "goblin.tex" )
    light:SetFalloff(1)
    light:SetIntensity(.5)
    light:SetRadius(1)
    light:Enable(false)
    light:SetColour(180/255, 195/255, 50/255)
    
    MakeObstaclePhysics(inst, 1)

    anim:SetBank("goblinhut")
    anim:SetBuild("goblinhut")
    anim:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks","cutgrass","cutgrass","cutgrass","cutgrass","boards","boards","boards","boards"})
    
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.keys3),FALLENLOOTTABLE.TABLE_WEIGHT+FALLENLOOTTABLE.TABLE_KEYS3_WEIGHT,0.15)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_12",0.15)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "goblin"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
--    inst.components.childspawner.spawnoffscreen=true
    inst.components.childspawner:SetMaxChildren(3)
    inst.components.childspawner:StartSpawning()
--        inst.components.childspawner:SetSpawnedFn(onspawnspider)


    inst:AddComponent("inspectable")
    
	MakeSnowCovered(inst, .01)

    MakeLargeBurnable(inst, nil, nil, true)

    inst:ListenForEvent("burntup", function(inst)
        inst:Remove()
    end)
    inst:ListenForEvent("onignite", function(inst)
        if inst.components.spawner then
            inst.components.spawner:ReleaseChild()
        end
    end)

    --[[
    inst:DoTaskInTime(math.random(), function() 
        --print(inst, "spawn check day")
        if GetClock():IsDay() then 
            OnDay(inst)
        end 
    end)
]]
    return inst
end

local function fnfire()
    local inst=fn()
    inst.components.childspawner.childname="fa_redgoblin"
    return inst
end

return Prefab( "common/objects/goblinhut", fn, assets, prefabs ),
Prefab( "common/objects/fa_firegoblinhut", fnfire, assets, prefabs )