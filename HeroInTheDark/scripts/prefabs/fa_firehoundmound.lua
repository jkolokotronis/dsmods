local assets =
{
    Asset("ANIM", "anim/hound_base.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{
	"hound",
    "firehound",
    "icehound",
    "houndstooth",
    "boneshard"
}

SetSharedLootTable( 'fa_firehoundmound',
{
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'boneshard',   1.00},
    {'boneshard',   1.00},
    {'redgem',      0.11},
})


local        HOUNDMOUND_HOUNDS_MIN = 2
local        HOUNDMOUND_HOUNDS_MAX = 3
local        HOUNDMOUND_REGEN_TIME = 30 * 4
local        HOUNDMOUND_RELEASE_TIME = 30

local function GetSpecialHoundChance()
    return 0.7
end

local function SpawnGuardHound(inst, attacker)
    local prefab = "hound"
    if math.random() < GetSpecialHoundChance() then
        if GetSeasonManager():IsWinter() or GetSeasonManager():IsSpring() then
            prefab = "icehound"
        else
	        prefab = "firehound"
	    end
	end
    local defender = inst.components.childspawner:SpawnChild(attacker, prefab)
    if defender and attacker and defender.components.combat then
        defender.components.combat:SetTarget(attacker)
        defender.components.combat:BlankOutAttacks(1.5 + math.random()*2)
    end
end

local function SpawnGuards(inst)
    if not inst.components.health:IsDead() and inst.components.childspawner then
        local num_to_release = math.min(3, inst.components.childspawner.childreninside)
        for k = 1,num_to_release do
            SpawnGuardHound(inst)
        end
    end
end

local function SpawnAllGuards(inst, attacker)
    if not inst.components.health:IsDead() and inst.components.childspawner then
        inst.AnimState:PlayAnimation("hit")
        inst.AnimState:PushAnimation("idle", false)
        local num_to_release = inst.components.childspawner.childreninside
        for k = 1,num_to_release do
            SpawnGuardHound(inst)
        end
    end
end

local function OnKilled(inst)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
    inst.AnimState:PlayAnimation("death", false)
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
    inst:AddTag("houndmound")

    -------------------
	inst:AddComponent("health")
    inst.components.health:SetMaxHealth(300)

    inst:ListenForEvent("death", OnKilled)

    -------------------
	inst:AddComponent("childspawner")
	inst.components.childspawner.childname = "firehound"
    inst.components.childspawner:SetRareChild("hound", 0.3)

	inst.components.childspawner:SetRegenPeriod(HOUNDMOUND_REGEN_TIME)
	inst.components.childspawner:SetSpawnPeriod(HOUNDMOUND_RELEASE_TIME)

	inst.components.childspawner:SetMaxChildren(math.random(HOUNDMOUND_HOUNDS_MIN, HOUNDMOUND_HOUNDS_MAX))

    ---------------------
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetChanceLootTable('fa_firehoundmound')

    inst:AddComponent("combat")
    inst.components.combat:SetOnHit(SpawnAllGuards)


    ---------------------
    inst:AddComponent("inspectable")
	inst.OnEntitySleep = OnEntitySleep
	inst.OnEntityWake = OnEntityWake
	MakeSnowCovered(inst)
    
	return inst
end

return Prefab( "forest/fa_firehoundmound", fn, assets, prefabs ) 

