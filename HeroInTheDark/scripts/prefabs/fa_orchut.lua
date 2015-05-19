local assets =
{
	Asset("ANIM", "anim/fa_orchut.zip"),
    Asset("ANIM", "anim/fa_orcflag.zip"),
    Asset("SOUND", "sound/pig.fsb"),
}
local bedassets={
    Asset("ANIM", "anim/fa_orcbed.zip"),    
}

local throneassets =
{
    Asset("ANIM", "anim/fa_orcthrone.zip"),    
}
local prefabs = 
{
	"fa_orc",
    "boneshards"
}

SetSharedLootTable( 'fa_orchut',
{
    {'rocks',  1},
    {'rocks',  1},
    {'cutgrass',  1},
    {'boards', 1},
    {'boards', 1},
    {'boards', 1},
    {'boards', 1},
    {'boneshards',  0.8},
    {'boneshards',  0.8},
    {'boneshards',  0.5},
    {'boneshards',  0.5},
    {'boneshards',  0.2},
    {'boneshards',  0.2},
})

        
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

local function onhit(inst, worker)
--	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end

local function common(name)
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    anim:SetBank(name)
    anim:SetBuild(name)
    anim:PlayAnimation("idle",true)
    return inst
end

local function fn(Sim)
    local inst=common("fa_orchut")
    local light = inst.entity:AddLight()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 20, 10 )
    inst.Transform:SetScale(2,2, 2)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "fa_orc.tex" )
    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(2)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 4)


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
    inst.components.childspawner.childname = "fa_orc"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
--    inst.components.childspawner.spawnoffscreen=true
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()
--        inst.components.childspawner:SetSpawnedFn(onspawnspider)


    inst:AddComponent("inspectable")
    
	MakeSnowCovered(inst, .01)

    if(true)then

local flag = CreateEntity()
    local trans = flag.entity:AddTransform()
    local anim = flag.entity:AddAnimState()
    local sound = flag.entity:AddSoundEmitter()
    flag.Transform:SetScale(2,2, 2)

    anim:SetBank("fa_orcflag")
    anim:SetBuild("fa_orcflag")
    anim:PlayAnimation("Flag_Breeze",true)
    flag:AddTag("NOCLICK")
    flag:AddTag("FX")

    flag.fa_rotate=function(dest)
        anim:SetOrientation( ANIM_ORIENTATION.OnGround )
        local angle = flag:GetAngleToPoint(dest:GetPosition())
        flag.Transform:SetRotation(angle)
    end
    local follower = flag.entity:AddFollower()
    follower:FollowSymbol(inst.GUID, "orchut", 220, -540, 0.1)
--   flag.entity:SetParent(inst.entity)
--    flag.Transform:SetPosition(5, 10, 0)
    --ogre homeEast
    flag.persists=false
    inst.fa_flag=flag
    end
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


local function fnthrone()
    local inst=common("fa_orcthrone")
    local light = inst.entity:AddLight()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 5, 5 )
    
    MakeObstaclePhysics(inst, 1)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_orc_king"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
--    inst.components.childspawner.spawnoffscreen=true
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()
--        inst.components.childspawner:SetSpawnedFn(onspawnspider)

    inst:AddComponent("inspectable")
    
    MakeSnowCovered(inst, .01)

    return inst
end

local function fnbed()
    local inst=common("fa_orcbed")
    inst:AddComponent("inspectable")
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_orc_iron"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
--    inst.components.childspawner.spawnoffscreen=true
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()
    MakeSnowCovered(inst, .01)
    return inst
end

return Prefab( "common/objects/fa_orchut", fn, assets, prefabs ),
Prefab( "common/objects/fa_orcthrone", fnthrone, throneassets, prefabs ),
Prefab( "common/objects/fa_orcbed", fnbed, bedassets, prefabs )

