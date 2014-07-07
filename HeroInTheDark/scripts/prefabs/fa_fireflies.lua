local assets =
{
	Asset("ANIM", "anim/fa_lavaflies.zip"),
}

local INTENSITY = .5



local function fadein(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("swarm_pre")
    inst.AnimState:PushAnimation("swarm_loop", true)
    inst.Light:Enable(true)
    inst.Light:SetIntensity(0)
    inst.components.fader:Fade(0, INTENSITY, 3+math.random()*2, function(v) inst.Light:SetIntensity(v) end)
end

local function fadeout(inst)
    inst.components.fader:StopAll()
    inst.AnimState:PlayAnimation("swarm_pst")
    inst.components.fader:Fade(INTENSITY, 0, .75+math.random()*1, function(v) inst.Light:SetIntensity(v) end, function() inst:AddTag("NOCLICK") inst.Light:Enable(false) end)
end

local function ondropped(inst)
    inst.components.workable:SetWorkLeft(1)
    fadein(inst)
    inst.lighton = true
    inst:DoTaskInTime(2+math.random()*1, function() updatelight(inst) end)
end

local function getstatus(inst)
    if inst.components.inventoryitem.owner then
        return "HELD"
    end
end


local function fn(Sim)


	local inst = CreateEntity()

    inst:AddTag("NOBLOCK")
    inst:AddTag("NOCLICK")
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    inst.entity:AddPhysics()
 
    local light = inst.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(INTENSITY)
    light:SetRadius(1)
    light:SetColour(255/255, 150/255, 150/255)
    light:Enable(true)
    
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    inst.AnimState:SetBank("fa_lavaflies")
    inst.AnimState:SetBuild("fa_lavaflies")
    inst.AnimState:PushAnimation("swarm_loop", true)

    inst.AnimState:SetRayTestOnBB(true);

--    inst:AddComponent("fader")  
--    fadein(inst)
     inst.lighton = true
    
    return inst
end

return Prefab( "common/objects/fa_lavaflies", fn, assets) 

