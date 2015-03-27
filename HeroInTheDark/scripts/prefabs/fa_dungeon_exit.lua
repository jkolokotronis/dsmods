local PopupDialogScreen = require "screens/popupdialog"
require "fa_constants"
require "map/levels/fa_levels"

local assets=
{
	Asset("ANIM", "anim/fa_dungeon_exit.zip"),
}

local mineassets=
{
	Asset("ANIM", "anim/fa_mine_exit.zip"),

}

local cageassets=
{
    Asset( "ANIM", "anim/player_cage_drop.zip" ),
    Asset( "ANIM", "anim/fa_cagechains.zip" ),
	Asset("ANIM", "anim/fa_orcfort_cage.zip"),

}
local dfcageassets=
{
    Asset( "ANIM", "anim/player_cage_drop.zip" ),
    Asset( "ANIM", "anim/fa_cagechains.zip" ),
	Asset("ANIM", "anim/fa_dorffort_rcage.zip"),

}
local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.CLIMB
end



local function onsave(inst, data)
	data.fa_cavename=inst.fa_cavename
	data.fa_level_up=inst.fa_level_up	
end           

local function onload(inst, data)
	inst.fa_cavename=data and data.fa_cavename
	inst.fa_level_up=data and data.fa_level_up
	--no clue how to avoid this.... world is getting reset so can't send data there, saveindex doesnt tell me what level i got here from, i dont know where to go
	if(not inst.fa_level_up)then
		inst:DoTaskInTime(0,function()
			inst.fa_level_up=GetPlayer().fa_prevcavelevel
			print("where am I?",GetWorld().topology.level_number,inst.fa_level_up)
		end)
	end
--	if GetWorld():IsCave() then
--		MakeRuins(inst)
--	end
end

local function OnActivate(inst,doer)

--	SetPause(true)
	local level = GetWorld().topology.level_number or 1
	local function head_upwards()
		SaveGameIndex:GetSaveFollowers(GetPlayer())
		if(FA_DLCACCESS and inst.saveseasons)then
			SaveGameIndex:SetSaveSeasonData(GetPlayer())
		end

		local function onsaved()
		    SetPause(false)
		    print("onsaved")
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end

		local cave_num =  SaveGameIndex:GetCurrentCaveNum()
		---
		if inst.fa_level_up==0 then
			SaveGameIndex:SaveCurrent(function() 
				SaveGameIndex:LeaveCave(onsaved) 
				if(FA_ModCompat.memspikefixed and doer)then
    					Sleep(FA_ModCompat.memspikefix_delay)
				end
			end, "ascend", cave_num)
		else
			-- Ascend
--			local level = level - 1
			
			SaveGameIndex:SaveCurrent(function() SaveGameIndex:EnterCave(onsaved,nil, cave_num, inst.fa_level_up)
				if(FA_ModCompat.memspikefixed and doer)then
    					Sleep(FA_ModCompat.memspikefix_delay)
				end
			end, "ascend", cave_num)
		end
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


local function dungfn()
	local inst=fn()
	inst.saveseasons=true
	inst.AnimState:SetBuild("fa_dungeon_exit")
	inst.AnimState:SetBank("fa_dungeon_exit")
	return inst
end

local function minefn()
	local inst=fn()
	inst.AnimState:SetBuild("fa_mine_exit")
	inst.AnimState:SetBank("fa_mine_exit")
    inst.Transform:SetScale(4, 4, 4)
	return inst
end

local function cagefn()
local inst=fn()
	inst.AnimState:SetBuild("fa_orcfort_cage")
	inst.AnimState:SetBank("fa_orcfort_cage")
    inst.Transform:SetScale(1, 1, 1)
    inst.components.activatable.OnActivate = function(inst,doer)
--    	SetPause(true)
    	doer.AnimState:OverrideSymbol("chains", "fa_cagechains", "chains")
	    doer.AnimState:OverrideSymbol("cage", "fa_orcfort_cage", "cage")
	    inst:RemoveFromScene()
	    doer.AnimState:PlayAnimation("fa_cagedrop",true)
	    doer:DoTaskInTime(2,function() OnActivate(inst,doer) end)
    end
	return inst
end

local function dorfcagefn()
local inst=fn()
    inst.Transform:SetScale(1, 1, 1)
	inst.AnimState:SetBuild("fa_dorffort_rcage")
	inst.AnimState:SetBank("fa_dorffort_rcage")
    inst.components.activatable.OnActivate = function(inst,doer)
--    	SetPause(true)
    	doer.AnimState:OverrideSymbol("chains", "fa_cagechains", "chains")
	    doer.AnimState:OverrideSymbol("cage", "fa_dorffort_rcage", "cage")
	    inst:RemoveFromScene()
	    doer.AnimState:PlayAnimation("fa_cagedrop",true)
	    doer:DoTaskInTime(2,function() OnActivate(inst,doer) end)
    end
	return inst
end
return Prefab( "common/fa_dungeon_exit", dungfn, assets) ,
Prefab( "common/fa_mine_exit", minefn, mineassets),
Prefab( "common/fa_orccage_exit", cagefn, cageassets),
Prefab( "common/fa_dorfcage_exit", dorfcagefn, dfcageassets)
