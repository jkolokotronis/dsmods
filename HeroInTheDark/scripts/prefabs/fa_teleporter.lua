
local assets=
{
	Asset("ANIM", "anim/fa_teleporter.zip"),

}

local dungeonentranceassets=
{
	Asset("ANIM", "anim/fa_dungeon_entrance.zip"),

}
local dungeonexitassets=
{
	Asset("ANIM", "anim/fa_dungeon_exit.zip"),
}
local prefabs={}

local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function OnActivate(inst,doer)
	if(inst.soundfx)then
		inst.SoundEmitter:PlaySound(inst.soundfx)
	end
	--inst.AnimState:PushAnimation("idle_on", true)
	
	local dest=TheSim:FindFirstEntityWithTag(inst.targettag)
	if(dest)then
			doer.components.locomotor:Stop()
			doer.components.health:SetInvincible(true)
			doer.components.playercontroller:Enable(false)
			GetPlayer().HUD:Hide()
			TheFrontEnd:Fade(false,1)
			doer:DoTaskInTime(2, function() 
				local loc=dest:GetPosition()
				doer.Transform:SetPosition(loc.x, 0, loc.z)
				GetPlayer().HUD:Show()
				TheFrontEnd:Fade(true,1) 
				doer.components.health:SetInvincible(false)
				doer.components.playercontroller:Enable(true)

				if(dest.fa_reactivate)then
					local reactivated=TheSim:FindFirstEntityWithTag(dest.fa_reactivate)
					if(reactivated)then
						reactivated:RemoveTag("fa_hidden")
						reactivated.entity:Show()
						dest.fa_reactivate=nil
					end
				end
			end)

	end
	inst.components.activatable.inactive = true
end

local function onsave(inst, data)
	data.targettag = inst.targettag
	data.sourcetag=inst.sourcetag
	data.inactive=inst.components.activatable.inactive
	if(inst.nameindex)then
		data.nameindex=inst.nameindex
	end
	if(inst:HasTag("fa_hidden"))then
		data.hidden=true
	end
	data.reactivate=inst.fa_reactivate
end           

local function onload(inst, data)
	inst.targettag = data and data.targettag 
	inst.sourcetag=data and data.sourcetag
	if(inst.sourcetag)then
		inst:AddTag(data.sourcetag)
	end
	if(data.inactive~=nil)then
		inst.components.activatable.inactive=data.inactive
	end
	if(data.nameindex)then
		inst.nameindex=data.nameindex
		inst.name=STRINGS.NAMES[string.upper(data.nameindex)]
	end
	if(data.hidden)then
		inst:AddTag("fa_hidden")
    	inst.entity:Hide()
	end
	if(data.reactivate)then
		inst.fa_reactivate=data.reactivate
	end
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.soundfx="fa/teleporter/activate"
    MakeObstaclePhysics(inst, 0.7)
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("teleportato.png")
	anim:SetBank("fa_teleporter")
    anim:SetBuild("fa_teleporter")
	anim:PlayAnimation("idle_on", true)

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

local function stairs_down()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeObstaclePhysics(inst, 0.7)
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_open.png")
    anim:SetBank("fa_dungeon_entrance")
    anim:SetBuild("fa_dungeon_entrance")
    inst.AnimState:PlayAnimation("idle_open", true)

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.getverb = function()
		return STRINGS.ACTIONS.ACTIVATE.ENTER
	end
	inst.components.activatable.quickaction = true
	inst.OnSave = onsave
	inst.OnLoad = onload
	return inst
end

local function stairs_up()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.Transform:SetScale(2, 2, 2)
    MakeObstaclePhysics(inst, 0.7)
    local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon("cave_open2.png")
	inst.AnimState:SetBuild("fa_dungeon_exit")
	inst.AnimState:SetBank("fa_dungeon_exit")
    inst.AnimState:PlayAnimation("idle", true)

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.getverb = function()
		return STRINGS.ACTIONS.ACTIVATE.CLIMB
	end
	inst.components.activatable.quickaction = true
	inst.OnSave = onsave
	inst.OnLoad = onload
	return inst

end

return Prefab( "common/fa_teleporter", fn, assets, prefabs),
Prefab( "common/fa_teleporter_dorf", fn, assets, prefabs),
Prefab( "common/fa_stairs_down", stairs_down, dungeonentranceassets, prefabs),
Prefab( "common/fa_stairs_up", stairs_up, dungeonexitassets, prefabs)