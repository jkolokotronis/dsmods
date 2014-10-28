local easing = require("easing")

local AVERAGE_WALK_SPEED = 4
local WALK_SPEED_VARIATION = 2
local SPEED_VAR_INTERVAL = .5
local ANGLE_VARIANCE = 10

local assets =
{
	Asset("ANIM", "anim/fa_fireboulder.zip"),
}

local prefabs = 
{
    "fa_lavapebble",
    "fa_ironpebble",
    "fa_coalpebble",
    "fa_limestonepebble",
    "fa_copperpebble",
    "fa_silverpebble"
}

local LOOT_TABLE={
    fa_lavapebble=1,
    fa_ironpebble=1,
    fa_coalpebble=1,
    fa_limestonepebble=1,
    fa_copperpebble=1,
    fa_silverpebble=1
}
local TOTAL_WEIGHT=6

local SFX_COOLDOWN = 5
local BOULDER_DAMAGE=20

local function onplayerprox(inst)
    if not inst.last_prox_sfx_time or (GetTime() - inst.last_prox_sfx_time > SFX_COOLDOWN) then
	   inst.last_prox_sfx_time = GetTime()
       inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_choir")
    end
end

local function CheckGround(inst)
    if not inst:IsOnValidGround() then
        local fx = SpawnPrefab("splash_ocean")
        local pos = inst:GetPosition()
        fx.Transform:SetPosition(pos.x, pos.y, pos.z)
        -- Shut down all the possible tasks
        if inst.bouncepretask then
            inst.bouncepretask:Cancel()
            inst.bouncepretask = nil
        end
        if inst.bouncetask then
            inst.bouncetask:Cancel()
            inst.bouncetask = nil
        end
        if inst.restartmovementtask then
            inst.restartmovementtask:Cancel()
            inst.restartmovementtask = nil
        end
        if inst.bouncepst1 then
            inst.bouncepst1:Cancel()
            inst.bouncepst1 = nil
        end
        if inst.bouncepst2 then
            inst.bouncepst2:Cancel()
            inst.bouncepst2 = nil
        end
        -- And remove the tumbleweed
        inst:Remove()
    end
end

local function startmoving(inst)
    inst.AnimState:PushAnimation("move_loop", true)
    inst.bouncepretask = inst:DoTaskInTime(10*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncetask = inst:DoPeriodicTask(24*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            CheckGround(inst)
        end)
    end)
    inst:RemoveEventCallback("animover", startmoving, inst)
end

local function onpickup(inst, owner)
	if owner and owner.components.inventory then
		if inst.owner and inst.owner.components.childspawner then 
			inst:PushEvent("pickedup")
		end

		local item = nil
		for i, v in ipairs(inst.loot) do
			item = SpawnPrefab(v)
            item.Transform:SetPosition(inst.Transform:GetWorldPosition())
            if item.components.inventoryitem and item.components.inventoryitem.ondropfn then
                item.components.inventoryitem.ondropfn(item)
            end
            if inst.lootaggro[i] and item.components.combat and GetPlayer() then
                if not (GetPlayer():HasTag("spiderwhisperer") and item:HasTag("spider")) and not (GetPlayer():HasTag("monster") and item:HasTag("spider")) then
                    item.components.combat:SuggestTarget(GetPlayer())
                end
            end
    	end
    end
    inst:RemoveEventCallback("animover", startmoving, inst)
    inst.AnimState:PlayAnimation("break")
    inst.DynamicShadow:Enable(false)
    inst:ListenForEvent("animover", function(inst) inst:Remove() end)
    return true --This makes the inventoryitem component not actually give the tumbleweed to the player
end


local function DoDirectionChange(inst, data)

    if not inst.entity:IsAwake() then return end

    if data and data.angle and data.velocity  then
        if inst.angle == nil then
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:Start(inst.angle, data.velocity)
        else
            inst.angle = math.clamp(GetRandomWithVariance(data.angle, ANGLE_VARIANCE), 0, 360)
            inst.components.blowinwind:ChangeDirection(inst.angle, data.velocity)
        end
    end
end


local function CancelRunningTasks(inst)
    if inst.bouncepretask then
       inst.bouncepretask:Cancel()
        inst.bouncepretask = nil
    end
    if inst.bouncetask then
        inst.bouncetask:Cancel()
        inst.bouncetask = nil
    end
    if inst.restartmovementtask then
        inst.restartmovementtask:Cancel()
        inst.restartmovementtask = nil
    end
    if inst.bouncepst1 then
       inst.bouncepst1:Cancel()
        inst.bouncepst1 = nil
    end
    if inst.bouncepst2 then
        inst.bouncepst2:Cancel()
        inst.bouncepst2 = nil
    end
    if inst.collisionhandlermk2 then
        inst.collisionhandlermk2:Cancel()
        inst.collisionhandlermk2=nil
    end
end


local function OnEntitySleep(inst)
	CancelRunningTasks(inst)
end

local function OnEntityWake(inst)
    inst.AnimState:PlayAnimation("move_loop", true)
    inst.bouncepretask = inst:DoTaskInTime(10*FRAMES, function(inst)
        inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
        inst.bouncetask = inst:DoPeriodicTask(24*FRAMES, function(inst)
            inst.SoundEmitter:PlaySound("dontstarve_DLC001/common/tumbleweed_bounce")
            CheckGround(inst)
        end)
    end)
end


local function oncollide(inst, other)
    if(other and (other:HasTag("player") or other:HasTag("companion")))then
        inst.components.propagator:StopSpreading()
        inst.components.burnable:Extinguish()
        inst.components.lootdropper:DropLoot()
        CancelRunningTasks(inst)
        inst.Physics:Stop()
        RemovePhysicsColliders(inst)
        inst.AnimState:PlayAnimation("break")
        inst.DynamicShadow:Enable(false)
        inst:ListenForEvent("animover", function(inst) 
            inst:Remove() 
        end)
        local fx=SpawnPrefab("fa_fireball_hit")
        local pos =other:GetPosition()    
        fx.Transform:SetPosition(pos.x, pos.y, pos.z)
        fx:ListenForEvent("animover", function()  fx:Remove() end)
        if(other.components.combat)then
            other.components.combat:GetAttacked(nil, BOULDER_DAMAGE, nil,nil,FA_DAMAGETYPE.FIRE)
        end
    else
        if(inst.currentAngle==nil)then
            local v=Vector3(inst.Physics:GetVelocity())
            inst.currentAngle = math.atan2(v.z, v.x)/DEGREES
        end
        inst.currentAngle=((inst.currentAngle*DEGREES+180+ (math.random()-0.5)*60)%360)/DEGREES
        inst.Transform:SetRotation(inst.currentAngle)
        inst.components.locomotor:WalkForward(true)
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()

    inst.Transform:SetFourFaced()
    shadow:SetSize( 1.7, .8 )

    anim:SetBuild("fa_fireboulder")
    anim:SetBank("fa_fireboulder")
    anim:PlayAnimation("move_loop", true)
    
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 4

    MakeCharacterPhysics(inst, .5, 1)

    inst.Physics:SetCollisionCallback(oncollide)

    inst:DoTaskInTime(0,function(inst)
        startmoving(inst)
        inst.currentAngle=math.random()*360
        inst.Transform:SetRotation(inst.currentAngle)
        inst.components.locomotor:WalkForward(true)
        inst.collisionhandlermk2=inst:DoPeriodicTask(0.2,function()
            local pt=inst:GetPosition()
            local v=Vector3(inst.Physics:GetVelocity())
            local newpos=pt+v*0.2
            local tile=GetGroundTypeAtPosition(newpos)
            if(not tile or  ( tile == GROUND.IMPASSABLE or tile >= GROUND.UNDERGROUND))then
                if(inst.currentAngle==nil)then
                    local v=Vector3(inst.Physics:GetVelocity())
                    inst.currentAngle = math.atan2(v.z, v.x)/DEGREES
                end
                inst.currentAngle=((inst.currentAngle*DEGREES+180+ (math.random()-0.5)*180)%360)/DEGREES
                inst.Transform:SetRotation(inst.currentAngle)
                inst.components.locomotor:WalkForward(true)
            end
        end)
    end)

	inst:AddComponent("playerprox")
	inst.components.playerprox:SetOnPlayerNear(onplayerprox)
	inst.components.playerprox:SetDist(5,10)

	inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddFallenLootTable(LOOT_TABLE,TOTAL_WEIGHT,1)
	
    inst:AddComponent("inspectable")


    inst:AddComponent("burnable")
--    inst.components.burnable:SetFXLevel(1)
--    inst.components.burnable:AddBurnFX("character_fire", Vector3(.1, 0, .1), "swap_fire")
    inst.components.burnable.canlight = true

    MakeSmallPropagator(inst)
    inst.components.propagator.flashpoint = 5 + math.random()*3
    inst.components.propagator.propagaterange = 5
    inst.components.burnable:Ignite()

   	inst.OnEntityWake = OnEntityWake
   	inst.OnEntitySleep = OnEntitySleep  

    return inst
end

return Prefab( "badlands/objects/fa_fireboulder", fn, assets, prefabs) 
