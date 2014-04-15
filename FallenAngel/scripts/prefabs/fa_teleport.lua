
local assets=
{
	Asset("ANIM", "anim/teleportato.zip"),
	Asset("ANIM", "anim/teleportato_build.zip"),

}

local prefabs={}

local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function OnActivate(inst,doer)
		inst.SoundEmitter:PlaySound("dontstarve/common/teleportato/teleportato_activate", "teleportato_activate")
	inst.AnimState:PlayAnimation("power_on", false)
	inst.AnimState:PushAnimation("idle_on", true)
	local dest=TheSim:FindFirstEntityWithTag(inst.targettag)
	if(dest)then
			doer.components.locomotor:Stop()
			doer.components.health:SetInvincible(true)
			doer.components.playercontroller:Enable(false)
			GetPlayer().HUD:Hide()
			TheFrontEnd:Fade(false,1)
			doer:DoTaskInTime(1.2, function() 
				local loc=dest:GetPosition()
				doer.Transform:SetPosition(loc.x, 0, loc.z)
				GetPlayer().HUD:Show()
				TheFrontEnd:Fade(true,1) 
				doer.components.health:SetInvincible(false)
				doer.components.playercontroller:Enable(true)
			end)

	end
end

local function onsave(inst, data)
	data.targettag = inst.targettag
	data.sourcetag=inst.sourcetag
end           

local function onload(inst, data)
	inst.targettag = data and data.targettag 
	inst.sourcetag=data and data.sourcetag
	if(inst.sourcetag)then
		inst:AddTag(data.sourcetag)
	end
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 1)
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_closed.png")
	anim:SetBank("teleporter")
    anim:SetBuild("teleportato_build")
	anim:PlayAnimation("idle_off", true)

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
--	inst.components.inspectable.getstatus = GetStatus

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true
--    Close(inst)
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	
    return inst
end

return Prefab( "common/fa_teleport", fn, assets, prefabs) 