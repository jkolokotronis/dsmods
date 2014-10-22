local assets =
{
	Asset("ANIM", "anim/nightmare_crack_red.zip"),
	Asset("ANIM", "anim/nightmare_crack_white.zip"),
}

local prefabs =
{
	"nightmarebeak",
	"crawlingnightmare",
    "nightmare_crack_white_fx",
    "nightmare_crack_red_fx"
}

local transitionTime = 1

local topLightColour = {239/255, 194/255, 194/255}

local function returnchildren(inst)
    for k,child in pairs(inst.components.childspawner.childrenoutside) do
        if child.components.combat then
            child.components.combat:SetTarget(nil)
        end

        if child.components.lootdropper then
            child.components.lootdropper:SetLoot({})
        end

        if child.components.health then
            child.components.health:Kill()
        end
    end
end

local function spawnchildren(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StartSpawning()
--        inst.components.childspawner:StopRegen()
    end 
end

local function stopspawning(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StartRegen()
    end 
end

local function killchildren(inst)
    if inst.components.childspawner then
        inst.components.childspawner:StopSpawning()
        inst.components.childspawner:StartRegen()
        returnchildren(inst)
    end 
end

local function dofx(inst)
    fx = SpawnPrefab("statue_transition")
    if fx then
        fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
        fx.AnimState:SetScale(1,1.5,1)
    end
end

local function turnoff(inst, light)
    if light then
        light:Enable(false)
    end
end

local function spawnfx(inst)
    if not inst.fx then
        inst.fx = SpawnPrefab(inst.fxprefab)
        local pos = inst:GetPosition()
        inst.fx.Transform:SetPosition(pos.x, pos.y, pos.z)

    local follower = inst.fx.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "crack", 0, -10, -0.0001 )
    end
end

local states =
{
    

    warn = function(inst, instant)

        ChangeToObstaclePhysics(inst)
        inst.Light:Enable(true)
        inst.components.lighttweener:StartTween(nil, 2, nil, nil, nil, (instant and 0) or  0.5)
        inst.AnimState:PlayAnimation("open_1") 
        inst.fx.AnimState:PlayAnimation("open_1")
        inst.SoundEmitter:KillSound("loop")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_warning")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")
    end,

    nightmare = function(inst, instant)

        ChangeToObstaclePhysics(inst)
        inst.Light:Enable(true)
        inst.components.lighttweener:StartTween(nil, 5, nil, nil, nil, (instant and 0) or 0.5)
        inst.SoundEmitter:KillSound("loop")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")


        if not instant then
            inst.AnimState:PlayAnimation("open_2")
            inst.AnimState:PushAnimation("idle_open")

            inst.fx.AnimState:PlayAnimation("open_2")
            inst.fx.AnimState:PushAnimation("idle_open")
            inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open")
        else
            inst.AnimState:PlayAnimation("idle_open")

            inst.fx.AnimState:PlayAnimation("idle_open")
        end

        spawnchildren(inst)
    end,

    dawn = function(inst, instant)
        ChangeToObstaclePhysics(inst)
        inst.Light:Enable(true)
        inst.components.lighttweener:StartTween(nil, 2, nil, nil, nil, (instant and 0) or 0.5)
        inst.SoundEmitter:KillSound("loop")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")

        inst.AnimState:PlayAnimation("close_1")
        inst.fx.AnimState:PlayAnimation("close_1")
       
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_spawner_open")

        spawnchildren(inst)
    end
}


local function phasechange(inst, data)
    local statefn = states[data.newphase]

    if statefn then
        spawnfx(inst)
        inst.state = data.newphase
        inst:DoTaskInTime(math.random() * 2, statefn)
    end
end

local function getsanityaura(inst)
    return 0
    --[[
    if inst.state == "calm" then
        return 0
    elseif inst.state == "warn" then
        return -TUNING.SANITY_SMALL
    else
        return -TUNING.SANITY_MED
    end]]
end

local function nextphase(inst)
    spawnfx(inst)
    local nexttime = 0
    if inst.state =="calm" then
        inst.state = "warn"
        nexttime = math.random(TUNING.FISSURE_WARNTIME_MIN, TUNING.FISSURE_WARNTIME_MAX)
    elseif inst.state == "warn" then
        inst.state = "nightmare"
        nexttime = math.random(TUNING.FISSURE_NIGHTMARETIME_MIN, TUNING.FISSURE_NIGHTMARETIME_MAX)
    else--if inst.state == "nightmare" then
        inst.state = "dawn"
        nexttime = math.random(TUNING.FISSURE_DAWNTIME_MIN, TUNING.FISSURE_DAWNTIME_MAX)
 --[[   else
        inst.state = "calm"
        nexttime = math.random(TUNING.FISSURE_CALMTIME_MIN, TUNING.FISSURE_CALMTIME_MAX)]]
    end


    local statefn = states[inst.state]
    if statefn then
        inst:DoTaskInTime(math.random() * 2, statefn)
    end

    if inst.task then inst.task:Cancel() inst.task = nil end
    inst.taskinfo = nil

    inst.task, inst.taskinfo = inst:ResumeTask(nexttime, nextphase)

end

local function onload(inst, data)
    if not data then
        return
    end
    if data.state then
        inst.state = data.state
        spawnfx(inst)
        states[inst.state](inst, true)
    end

    if data.timeleft then
        if inst.task then inst.task:Cancel() inst.task = nil end
        inst.taskinfo = nil
        inst.task, inst.taskinfo = inst:ResumeTask(data.timeleft, nextphase)
    end
end


local function onsave(inst, data)
    if inst.state then
        data.state = inst.state
    end

    if inst.taskinfo then
        data.timeleft = inst:TimeRemainingInTask(inst.taskinfo)
    end
end

local function commonfn(type,bank)

	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    
    MakeObstaclePhysics(inst, 1.2)
    RemovePhysicsColliders(inst)

    anim:SetBuild(type)
    anim:SetBank(type)
    anim:PlayAnimation("idle_closed")

    inst:AddComponent( "childspawner" )
    inst.components.childspawner:SetRegenPeriod(120)
    inst.components.childspawner:SetSpawnPeriod(30)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner.childname = "fa_fireboulder"
--    inst.components.childspawner:SetRareChild("fa_fireboulder", 0.35)
--it doesnt seem it clears children proper if they dont have natural 'death'

    local old_own=inst.components.childspawner.TakeOwnership
    function inst.components.childspawner:TakeOwnership(child)
        local ret=old_own(self,child)
        self.inst:ListenForEvent( "onremove", function() self:OnChildKilled( child ) end, child )
        return ret
    end

    inst:AddComponent("lighttweener")
    inst.entity:AddLight()

    inst.OnLoad = onload
    inst.OnSave = onsave

    return inst
end


local function posteffects(inst)
        spawnfx(inst)
        inst.state = "warn"
        local nexttime = math.random(TUNING.FISSURE_WARNTIME_MIN, TUNING.FISSURE_WARNTIME_MAX)
         ChangeToObstaclePhysics(inst)
        inst.Light:Enable(true)
        inst.components.lighttweener:StartTween(inst.Light, 2, .9, 0.9, {255/255,140/255,0}, 0)
--        inst.components.lighttweener:StartTween(nil, 2, nil, nil, nil,0)
        inst.AnimState:PlayAnimation("open_1") 
        inst.fx.AnimState:PlayAnimation("open_1")
        inst.SoundEmitter:PlaySound("dontstarve/cave/nightmare_fissure_open_LP", "loop")
        inst.task, inst.taskinfo = inst:ResumeTask(nexttime, nextphase)
end

local function upper()
    local inst = commonfn("nightmare_crack_red")
    inst.fxprefab = "nightmare_crack_red_fx"
    posteffects(inst)
    return inst
end

local function lower()
	local inst = commonfn("nightmare_crack_white")
    inst.fxprefab = "nightmare_crack_white_fx"
    posteffects(inst)

	return inst
end


return Prefab( "cave/objects/fa_fissure_white", lower, assets, prefabs),
Prefab("cave/objects/fa_fissure_red",upper , assets, prefabs)


