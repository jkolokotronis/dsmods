local brain = require "brains/treeguardianbrain"

local assets =
{
	Asset("ANIM", "anim/leif_walking.zip"),
	Asset("ANIM", "anim/leif_actions.zip"),
	Asset("ANIM", "anim/leif_attacks.zip"),
	Asset("ANIM", "anim/leif_idles.zip"),
	Asset("ANIM", "anim/leif_build.zip"),
	Asset("ANIM", "anim/leif_lumpy_build.zip"),
	Asset("SOUND", "sound/leif.fsb"),
}

local prefabs =
{
	"meat",
	"log", 
	"character_fire",
    "livinglog",
}

local GUARDIAN_DAMAGE=80
local GUARDIAN_HP=1200
local GUARDIAN_ATK_SPEED=3
local GUARDIAN_SUMMON_TIME=480

local function guardianshutdown(inst)
    if(inst.shutdowntask)then
        inst.shutdowntask:Cancel()
    end
    inst.brain:Stop()
    inst.Physics:Stop()
    inst.AnimState:PlayAnimation("transform_tree", false)
    inst.SoundEmitter:PlaySound("dontstarve/creatures/leif/transform_VO")
    local spawn_point= Vector3(inst.Transform:GetWorldPosition())
    inst:Remove()
    local tree=SpawnPrefab("evergreen_tall")
    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
    tree.Transform:SetPosition(pt:Get() )
--    inst.SoundEmitter:PlaySound("dontstarve/wilson/plant_tree")
end

local onloadfn = function(inst, data)
    if(data and data.countdown and data.countdown>0)then
        if inst.shutdowntask then
            inst.shutdowntask:Cancel()
        end
    inst.shutdowntask=inst:DoTaskInTime(data.countdown, guardianshutdown)
    inst.shutdowntime=GetTime()+data.countdown
    end
end

local onsavefn = function(inst, data)
    data.countdown=inst.shutdowntime-GetTime()
end

local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker

    if attacker and attacker:HasTag("player") then
--        inst.components.health:SetVal(0)
    else
        inst.components.combat:SetTarget(attacker)
    end
end


local function OnBurnt(inst)
    if inst.components.propagator and inst.components.health and not inst.components.health:IsDead() then
        inst.components.propagator.acceptsheat = true
    end
end


local function fn(Sim)
    
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()

	shadow:SetSize( 4, 1.5 )
    inst.Transform:SetFourFaced()
	
	MakeCharacterPhysics(inst, 1000, .5)

    inst:AddTag("leif")
    inst:AddTag("tree")
    inst:AddTag("largecreature")
    inst:AddTag("fa_summon")
    inst:AddTag("fa_exclusive")

    inst:AddComponent("follower")

    ---------------------       
    inst:AddTag("companion")

    anim:SetBank("leif")
    anim:SetBuild("leif_build")
    anim:PlayAnimation("idle_loop", true)
    
    ------------------------------------------

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = 1.0*TUNING.WILSON_RUN_SPEED    
    
    ------------------------------------------
    inst:SetStateGraph("SGLeif")

    ------------------------------------------

    MakeLargeBurnableCharacter(inst, "marker")
    inst.components.burnable.flammability = TUNING.LEIF_FLAMMABILITY
    inst.components.burnable:SetOnBurntFn(OnBurnt)
    inst.components.propagator.acceptsheat = true

    MakeHugeFreezableCharacter(inst, "marker")
    ------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(GUARDIAN_HP)
    inst.components.health:StartRegen(5, 5)

    ------------------
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(GUARDIAN_DAMAGE)
--    inst.components.combat.playerdamagepercent = .33
    inst.components.combat.hiteffectsymbol = "marker"
    inst.components.combat:SetAttackPeriod(GUARDIAN_ATK_SPEED)
    inst.components.combat:SetRetargetFunction(0.5, Retarget)
    
    ------------------------------------------
    
    inst:AddComponent("sleeper")
    inst.components.sleeper:SetResistance(3)
    
    ------------------------------------------

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"livinglog",  "monstermeat"})
    
    ------------------------------------------

    inst:AddComponent("inspectable")
    ------------------------------------------
    
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)

    inst.forceShutdown=guardianshutdown
    inst.shutdowntime=GetTime()+GUARDIAN_SUMMON_TIME
    inst.shutdowntask=inst:DoTaskInTime(GUARDIAN_SUMMON_TIME, guardianshutdown)

    
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    return inst
end


return Prefab( "common/treeguardian", fn, assets, prefabs)
