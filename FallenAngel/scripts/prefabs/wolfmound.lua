local assets =
{
    Asset("ANIM", "anim/hound_base.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
	"wolf",
}


local function SpawnAllGuards(inst, attacker)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
end

local function OnKilled(inst)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
    inst.SoundEmitter:KillSound("loop")
    inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))
end



local function OnEntityWake(inst)
    inst.components.childspawner:StartSpawning()
    inst.SoundEmitter:PlaySound("dontstarve/creatures/hound/mound_LP", "loop")
end

local function OnEntitySleep(inst)
	inst.SoundEmitter:KillSound("loop")
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, .5)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "hound_mound.png" )

	anim:SetBank("houndbase")
	anim:SetBuild("hound_base")
	anim:PlayAnimation("idle")

    inst:AddTag("structure")
    inst:AddTag("wolfmound")

    -------------------
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)
    inst:ListenForEvent("death", OnKilled)

    -------------------
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "hound"
	inst.components.childspawner:SetRegenPeriod(TUNING.HOUNDMOUND_REGEN_TIME)
	inst.components.childspawner:SetSpawnPeriod(TUNING.HOUNDMOUND_RELEASE_TIME)

	inst.components.childspawner:SetMaxChildren(4)
 
    ---------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "monstermeat","houndstooth","houndstooth"})

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(SpawnAllGuards)


    ---------------------
    inst:AddComponent("inspectable")
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	MakeSnowCovered(inst)
    
	return inst
end

return Prefab( "forest/monsters/wolfmound", fn, assets, prefabs ) 

