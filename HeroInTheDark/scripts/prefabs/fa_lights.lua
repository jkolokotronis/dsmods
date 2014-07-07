local assets =
{
}

local DAYLIGHT_INTENSITY = 2
local DAYLIGHT_FALLOFF=9.75
local DAYLIGHT_RADIUS=2
local DAYLIGHT_DURATION=8*60

local CONTINUALFLAME_DURATION=5*8*60

local function shutdown(inst)
    if(inst.shutdowntask)then
        inst.shutdowntask:Cancel()
    end
    inst:Remove()
end

local onloadfn = function(inst, data)
    if(data and data.countdown and data.countdown>0)then
        if inst.shutdowntask then
            inst.shutdowntask:Cancel()
        end
    inst.shutdowntask=inst:DoTaskInTime(data.countdown, shutdown)
    inst.shutdowntime=GetTime()+data.countdown
    end
end

local onsavefn = function(inst, data)
    data.countdown=inst.shutdowntime-GetTime()
end

local function fn(Sim)


    local inst = CreateEntity()

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    

      inst:AddComponent("lighttweener")
      local light = inst.entity:AddLight()
      inst.components.lighttweener:StartTween(light, 0, .9, 0.9, {1,1,1}, 0)
      inst.components.lighttweener:StartTween(nil, 9, .9, 0.9, nil, .2)
--[[ 
    local light = inst.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(1)
    light:SetRadius(1)
    light:SetColour(255/255, 150/255, 150/255)
    light:Enable(true)]]
    

    inst.AnimState:SetRayTestOnBB(true);
    
    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "SPELLDURATION"
    inst.components.fueled:InitializeFuelLevel(DAYLIGHT_DURATION)
    inst.components.fueled:StartConsuming()        
    inst.components.fueled:SetDepletedFn(function() inst:Remove() end)
    return inst

end

local function continualflamefx()

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

--  local light = inst.entity:AddLight()
    local sound = inst.entity:AddSoundEmitter()

    
    MakeObstaclePhysics(inst, .1)    
    
    
    inst:AddComponent("burnable")
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0,1.5,0) )
    inst.components.burnable:SetFXLevel(2, 1)
    inst.components.burnable:Ignite()

    inst:DoTaskInTime(0,function()
        inst.components.burnable:Ignite()
    end)


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst.shutdowntime=GetTime()+CONTINUALFLAME_DURATION
    inst.shutdowntask=inst:DoTaskInTime(CONTINUALFLAME_DURATION, shutdown)

    return inst
end

return Prefab( "common/objects/fa_daylightfx", fn, assets),
Prefab( "common/objects/fa_continualflamefx", continualflamefx, assets)  

