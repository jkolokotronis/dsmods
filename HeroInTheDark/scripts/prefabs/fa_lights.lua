local assets =
{
}

local DAYLIGHT_INTENSITY = 2
local DAYLIGHT_FALLOFF=9.75
local DAYLIGHT_RADIUS=2
local DAYLIGHT_DURATION=8*60


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

local point=CreateEntity()
    point:AddTag("FX")
    point:AddTag("NOCLICK")
    point.entity:AddTransform()
    local light = point.entity:AddLight()
    light:SetFalloff(0.75)
    light:SetIntensity(2)
    light:SetRadius(2)
    light:SetColour(255/255, 255/255, 255/255)
    light:Enable(true)
    
    point.OnLoad = onloadfn
    point.OnSave = onsavefn

    inst.shutdowntime=GetTime()+DAYLIGHT_DURATION
    inst.shutdowntask=inst:DoTaskInTime(DAYLIGHT_DURATION, shutdown)

    return point
end

return Prefab( "common/objects/fa_daylightfx", fn, assets) 

