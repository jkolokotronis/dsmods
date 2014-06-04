local assets =
{
}

local prefabs = 
{
	"fa_dorf",
}


        
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
    if(inst.fa_flag)then
        inst.fa_flag:Remove()
    end
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local light = inst.entity:AddLight()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3 )
--    inst.Transform:SetScale(2,2, 2)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "fa_dorf.tex" )
    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(2)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 4)

    anim:SetBank("fa_dorfhut")
    anim:SetBuild("fa_dorfhut")
    anim:PlayAnimation("idle",true)

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks","cutgrass","cutgrass","cutgrass","cutgrass","boards","boards","boards","boards"})
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
	inst.components.workable:SetOnFinishCallback(onhammered)
--	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dorf"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()


    inst:AddComponent("inspectable")
    
	MakeSnowCovered(inst, .01)

    return inst
end

return Prefab( "common/objects/fa_dorfhut", fn, assets, prefabs )
