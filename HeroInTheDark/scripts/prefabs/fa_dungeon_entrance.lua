local PopupDialogScreen = require "screens/popupdialog"
require "fa_constants"
local Levels=require("map/levels")
require "map/levels/fa_levels"
local assets=
{
	Asset("ANIM", "anim/fa_dungeon_entrance.zip"),

}
local mineassets=
{
	Asset("ANIM", "anim/fa_mine_entrance.zip"),

}
local minegrassassets=
{
	Asset("ANIM", "anim/fa_mine_entrance_grass.zip"),

}
local orcfortassets=
{
	Asset("ANIM", "anim/fa_orcfort.zip"),
	Asset("ANIM", "anim/fa_orcfort_back.zip"),

}
local dorffortassets=
{
	Asset("ANIM", "anim/fa_dorffortentrance.zip"),
	Asset("ANIM", "anim/fa_dorffort_rcage.zip"),
	Asset("ANIM", "anim/fa_dorffort_lcage.zip"),
	Asset("ANIM", "anim/fa_dorffortentrance_back.zip"),
	
}

local hellgateassets={
	Asset("ANIM", "anim/fa_hellgate.zip"),
}


local prefabs = 
{
	"bat",
	"exitcavelight"
}

local SECRET_ENTRANCE_WORKLEFT=100

local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.ENTER
end

local function ReturnChildren(inst)
	for k,child in pairs(inst.components.childspawner.childrenoutside) do
		if child.components.homeseeker then
			child.components.homeseeker:GoHome()
		end
		child:PushEvent("gohome")
	end
end

local function OnActivate(inst,doer)

    ProfileStatsSet("cave_entrance_used", true)

	SetPause(true)

	local function go_spelunking()
		SaveGameIndex:GetSaveFollowers(GetPlayer())
		if(FA_DLCACCESS and inst.saveseasons)then
			SaveGameIndex:SetSaveSeasonData(GetPlayer())
		end

		local function onsaved()
		    SetPause(false)
		    print("onsaved")
		    StartNextInstance({reset_action=RESET_ACTION.LOAD_SLOT, save_slot = SaveGameIndex:GetCurrentSaveSlot()}, true)
		end

		local function doenter()
			local level = 1
			--we are looking for the first level that has preset for cave type we want to enter... BUT it has to be below the current level, to ensure we dont overwrite the existing saves
			--inst.fa_cavename
			if GetWorld().prefab == "cave" then
				level = (GetWorld().topology.level_number or 1 ) + 1
				print("entering levels <=",level)
				GetPlayer().fa_prevcavelevel=GetWorld().topology.level_number
			else
				GetPlayer().fa_prevcavelevel=0  
			end
			local fa_levels=FA_LEVELS[inst.fa_cavename]
--			there has to be at least one by now if(not fa_levels) 
--			level above is not +1 to index but +2, because level=1 for outdoors where it should be 0, cave indices start at 1=cave not 1=outdoors! 
--			local level_index=level-1
			local level_to_go=nil
			for k,v in ipairs(fa_levels) do
				if(v>=level) then
					level_to_go=v
					break
				end
			end
			if(not level_to_go) then
				level_to_go=AddNewCaveLevel(inst.fa_cavename)
			end
			print("actually descending into",level_to_go,"from",GetWorld().topology.level_number)
			print("level", Levels.cave_levels[level_to_go].name)
			SaveGameIndex:SaveCurrent(function() 
				SaveGameIndex:EnterCave(onsaved,nil, inst.cavenum, level_to_go) 
				if(FA_ModCompat.memspikefixed and doer)then
   					Sleep(FA_ModCompat.memspikefix_delay)
				end
			 end, "descend", inst.cavenum)
			
		end

		if not inst.cavenum then
			-- We need to make sure we only ever have one cave underground
			-- this is because caves are verticle and dont have sub caves
			if GetWorld().prefab == "cave"  then
				inst.cavenum = SaveGameIndex:GetCurrentCaveNum()
				doenter()
			else
				inst.cavenum = SaveGameIndex:GetNumCaves() + 1
				SaveGameIndex:AddCave(nil, doenter)
			end
		else
			doenter()
		end
	end
	GetPlayer().HUD:Hide()

	TheFrontEnd:Fade(false, 2, function()
									go_spelunking()
								end)
end

local function MakeRuins(inst)

	inst.MiniMapEntity:SetIcon("ruins_closed.png")

end

local function Open(inst)

	if(inst.components.childspawner)then
		inst.startspawningfn = function()	
			inst.components.childspawner:StopRegen()	
			inst.components.childspawner:StartSpawning()
		end
		inst.stopspawningfn = function()
			inst.components.childspawner:StartRegen()
			inst.components.childspawner:StopSpawning()
			ReturnChildren(inst)
		end
		inst.components.childspawner:StopSpawning()
		inst:ListenForEvent("dusktime", inst.startspawningfn, GetWorld())
		inst:ListenForEvent("daytime", inst.stopspawningfn, GetWorld())
	end

    inst.AnimState:PlayAnimation("idle_open", true)
    inst:RemoveComponent("workable")
    
    inst.open = true

	inst:RemoveComponent("lootdropper")

	inst.MiniMapEntity:SetIcon("cave_open.png")

			inst:AddComponent("activatable")
		    inst.components.activatable.OnActivate = OnActivate
		    inst.components.activatable.inactive = true
		    inst.components.activatable.getverb = GetVerb
			inst.components.activatable.quickaction = true

end      

local function OnWork(inst, worker, workleft)
	local pt = Point(inst.Transform:GetWorldPosition())
	if workleft <= 0 then
		inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
		inst.components.lootdropper:DropLoot(pt)
		Open(inst)
	end
end


local function Close(inst)

	if inst.open and inst.components.childspawner then
		inst:RemoveEventCallback("daytime", inst.stopspawningfn)
		inst:RemoveEventCallback("dusktime", inst.startspawningfn)
	end
	inst:RemoveComponent("activatable")
    inst.AnimState:PlayAnimation("idle_closed", true)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	inst.components.workable:SetOnWorkCallback(OnWork)
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks", "rocks", "flint", "flint", "flint"})

    inst.open = false
end      


local function onsave(inst, data)
	data.cavenum = inst.cavenum
	data.fa_cavename=inst.fa_cavename
	data.open = inst.open
end           

local function onload(inst, data)
	inst.cavenum = data and data.cavenum 
	inst.fa_cavename=data and data.fa_cavename

end

local function GetStatus(inst)
    if inst.open then
        return "OPEN"
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
    anim:SetBank("fa_dungeon_entrance")
    anim:SetBuild("fa_dungeon_entrance")

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
	inst.components.inspectable.getstatus = GetStatus

--    Close(inst)
	inst.OnSave = onsave
	inst.OnLoad = onload
	
	--this is a hack to make sure these don't show up in adventure mode
	if SaveGameIndex:GetCurrentMode() == "adventure" then
		inst:DoTaskInTime(0, function() inst:Remove() end)
	end
	
    return inst
end

local function dungfn()
	local inst=fn()
	inst.saveseasons=true

	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetRegenPeriod(60)
	inst.components.childspawner:SetSpawnPeriod(.1)
	inst.components.childspawner:SetMaxChildren(6)
	inst.components.childspawner.childname = "bat"

	Open(inst)
	return inst
end

local function minefn()
	local inst=fn()
	inst.AnimState:SetBuild("fa_mine_entrance")
	inst.AnimState:SetBank("fa_mine_entrance")
    inst.Transform:SetScale(1.3,1.3, 1.3)

	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetRegenPeriod(60)
	inst.components.childspawner:SetSpawnPeriod(.1)
	inst.components.childspawner:SetMaxChildren(6)
	inst.components.childspawner.childname = "bat"

	Open(inst)
	return inst
end
local function minegrassfn()
	local inst=fn()
	inst.AnimState:SetBuild("fa_mine_entrance_grass")
	inst.AnimState:SetBank("fa_mine_entrance_grass")
    inst.Transform:SetScale(1.3,1.3, 1.3)

	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetRegenPeriod(60)
	inst.components.childspawner:SetSpawnPeriod(.1)
	inst.components.childspawner:SetMaxChildren(6)
	inst.components.childspawner.childname = "bat"

	Open(inst)
	return inst
end
local function orcfort()
	local inst=fn()
	inst.AnimState:SetBuild("fa_orcfort")
	inst.AnimState:SetBank("fa_orcfort")
	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetMaxChildren(3)
	inst.components.childspawner.childname = "fa_orc_iron"
	inst.components.childspawner:StartRegen()	
	inst.components.childspawner:StartSpawning()

    inst.AnimState:PlayAnimation("idle", true)
    inst.AnimState:OverrideSymbol("fortback", "fa_orcfort_back", "fortback_swap")
    inst:RemoveComponent("workable")
    inst.open = true

	inst.MiniMapEntity:SetIcon("cave_open.png")
	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = function(inst)

    	GetPlayer().components.talker:Say("The entrance is blocked")
    	--[[
		SetPause(true)
		inst.AnimState.PlayAnimation("opening")
		inst.AnimState.PushAnimation("open",true)
		inst:ListenForEvent("animover",function()
			OnActivate(inst)
		end)]]
	end
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true

	return inst
end

local function createcage(parent,animname)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.AnimState:SetBuild(animname)
	inst.AnimState:SetBank(animname)
	inst.AnimState:PlayAnimation("idle")
    inst.entity:AddSoundEmitter()

    inst:AddComponent("inspectable")
	inst:AddComponent("activatable")
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true
    inst.components.activatable.OnActivate = function(inst)
--    	GetPlayer().components.talker:Say("The entrance is blocked")
    	OnActivate(parent)
	end
	return inst
end

local function dorffort()
	local inst=fn()
	inst.AnimState:SetBuild("fa_dorffortentrance")
	inst.AnimState:SetBank("fa_dorffortentrance")
	inst:AddComponent( "childspawner" )
	inst.components.childspawner:SetMaxChildren(3)
	inst.components.childspawner.childname = "fa_dorf"
	inst.components.childspawner:StartRegen()	
	inst.components.childspawner:StartSpawning()
	
	inst.MiniMapEntity:SetIcon("cave_open.png")

    inst.AnimState:OverrideSymbol("back", "fa_dorffortentrance_back", "back_swap")
    inst.AnimState:PlayAnimation("idle", true)
    inst:RemoveComponent("workable")
    inst.open = true
    inst.fa_dorffort_rcage=createcage(inst,"fa_dorffort_rcage")
    local follower = inst.fa_dorffort_rcage.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "lift_r", 0, 0, 0.1 )
    inst.fa_dorffort_lcage=createcage(inst,"fa_dorffort_lcage")
    local follower = inst.fa_dorffort_lcage.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "lift_l", 0, 0, 0.1 )

	return inst
end

local function dorfsecretfn()
	local inst=fn()
	inst.AnimState:SetBank("ruins_entrance")
	inst.AnimState:SetBuild("ruins_entrance")
	inst.MiniMapEntity:SetIcon("ruins_closed.png")

    inst.AnimState:PlayAnimation("idle_closed", true)

	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable.savestate=true
	inst.components.workable:SetWorkLeft(SECRET_ENTRANCE_WORKLEFT)
	inst:AddComponent("lootdropper")
	inst.components.lootdropper:SetLoot({"rocks", "rocks", "flint", "flint", "flint"})

	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)
			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				Open(inst)
			elseif workleft < SECRET_ENTRANCE_WORKLEFT*(1/3) then
					inst.AnimState:PlayAnimation("low")
			elseif workleft <SECRET_ENTRANCE_WORKLEFT*(2/3) then
					inst.AnimState:PlayAnimation("med")
			else
					inst.AnimState:PlayAnimation("idle_closed")
			end
		end)     

	inst.OnLoad = function(inst, data)
		inst.cavenum = data and data.cavenum 
		inst.fa_cavename=data and data.fa_cavename
		if data and data.open then
			Open(inst)
		end
	end
	return inst
end

local function hellgate()
	local inst=fn()
	inst.AnimState:SetBuild("fa_hellgate")
	inst.AnimState:SetBank("fa_hellgate")
	inst.MiniMapEntity:SetIcon("cave_open.png")

    local light = inst.entity:AddLight()
    inst.Light:Enable(true)
	inst.Light:SetRadius(3)
    inst.Light:SetFalloff(0.7)
    inst.Light:SetIntensity(.7)
    inst.Light:SetColour(235/255,62/255,12/255)


    inst:RemoveComponent("workable")
    inst.open = true
	inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = function(inst)

    	GetPlayer().components.talker:Say("The entrance is blocked")
	end
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true

	return inst
end

return Prefab( "common/fa_dungeon_entrance", dungfn, assets, prefabs),
Prefab( "common/fa_mine_entrance", minefn, mineassets, prefabs),
Prefab( "common/fa_mine_entrance_grass", minegrassfn, minegrassassets, prefabs),
Prefab( "common/fa_orcfort", orcfort, orcfortassets, prefabs),
Prefab("common/fa_dorffort",dorffort, dorffortassets,prefabs),
Prefab("common/fa_hellgate",hellgate, hellgateassets,prefabs),
Prefab("common/fa_dorfsecret_entrance",dorfsecretfn, {},{})