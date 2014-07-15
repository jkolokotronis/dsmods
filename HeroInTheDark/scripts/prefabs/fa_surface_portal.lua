local PopupDialogScreen = require "screens/popupdialog"
require "fa_constants"
require "map/levels/fa_levels"

local assets=
{
	Asset("ANIM", "anim/fa_dungeon_exit.zip"),
}


local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end



local function onsave(inst, data)
	data.fa_cavename=inst.fa_cavename
end           

local function onload(inst, data)
	inst.fa_cavename=data and data.fa_cavename
end

local function OnActivate(inst)

	SetPause(true)
	local level = GetWorld().topology.level_number or 1
	local function head_upwards()
		SaveGameIndex:GetSaveFollowers(GetPlayer())
		if(FA_DLCACCESS)then
			SaveGameIndex:SetSaveSeasonData(GetPlayer())
		end

		local function onsaved()
		    SetPause(false)
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end

		local cave_num =  SaveGameIndex:GetCurrentCaveNum()
		SaveGameIndex:SaveCurrent(function() 
			SaveGameIndex:LeaveCave(onsaved) 
			if(FA_ModCompat.memspikefixed)then
					Sleep(FA_ModCompat.memspikefix_delay)
			end
		end, "ascend", cave_num)
		
	end
	GetPlayer().HUD:Hide()
	TheFrontEnd:Fade(false, 2, function()
									head_upwards()
								end)
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
     
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "cave_open2.png" )
    
    anim:SetBank("fa_dungeon_exit")
    anim:SetBuild("fa_dungeon_exit")
	inst.AnimState:PlayAnimation("idle",true)
    inst.Transform:SetScale(2, 2, 2)


    inst:AddComponent("inspectable")

	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true


	inst.OnSave = onsave
	inst.OnLoad = onload

    return inst
end

return Prefab( "common/fa_surface_portal", fn, assets) 
