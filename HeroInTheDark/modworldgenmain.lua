local require=GLOBAL.require
require("constants")
require("fa_constants")
modimport 'tile_adder.lua'
local GROUND = GLOBAL.GROUND
--local WorldSim = GLOBAL.WorldSim


-- The parameters passed are, in order:
-- The key to be used inside GROUND.
-- The numerical id to be used for the GROUND entry (i.e., the value of the new entry). This MUST be unique and CANNOT conflict with other mods.
-- The name of the tile (should match the texture and atlas in levels/tiles/).
-- The tile specification.
-- The minimap tile specification.
--
-- See tile_adder.lua for more details on the tile and minimap tile specifications.
--
-- The following will create a new tile type, GROUND.MODTEST.
AddTile("FA_LAVA_ASH", GLOBAL.FA_TILES_START, "lava_ash")
AddTile("FA_LAVA_GREEN", GLOBAL.FA_TILES_START+1, "lava_green")
AddTile("FA_LAVA_SHINY", GLOBAL.FA_TILES_START+2, "lava_shiny")
AddTile("FA_LAVA_TERRAIN2", GLOBAL.FA_TILES_START+3, "lava_terrain2")
--print("not a number?",FA_TILES_START)
--AddTile("MODTEST", GLOBAL.FA_TILES_START, "modtest", {noise_texture = "levels/textures/noise_modtest.tex"}, {noise_texture = "levels/textures/mini_noise_modtest.tex"})

local rooms=require("map/rooms")
require("map/tasks")
require("map/level")
local levels = require("map/levels")
require("map/terrain")
local Layouts = require("map/layouts").Layouts
local StaticLayout = require("map/static_layout")
--patching for custom layout support - there is no external table to mod, and if i put it into tileadder id need to override same function 4 times
local oldget=StaticLayout.Get
StaticLayout.Get=function(...)
	local oldlayout=oldget(...)
	oldlayout.ground_types[GLOBAL.FA_TILES_START]=GROUND.FA_LAVA_ASH
	oldlayout.ground_types[GLOBAL.FA_TILES_START+1]=GROUND.FA_LAVA_GREEN
	oldlayout.ground_types[GLOBAL.FA_TILES_START+2]=GROUND.FA_LAVA_SHINY
	oldlayout.ground_types[GLOBAL.FA_TILES_START+3]=GROUND.FA_LAVA_TERRAIN2
	return oldlayout
end

require "map/levels/fa_levels"
require "map/rooms/fa_rooms"
require "map/tasks/fa_tasks"
require "map/fa_layouts"

local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
table.insert(TRANSLATE_TO_PREFABS["spiders"],"poisonspiderden")

--for k,name in pairs({"SpiderfieldEasy","Spiderfield","SinkholeRoom","SunkenMarsh","ChessForest","SpiderCity","SpiderVillage","SpiderVillageSwamp","TallbirdNests","BGCrappyForest"
--	,"BGForest","BGDeepForest","CrappyDeepForest","SpiderForest","BGGrassBurnt","BGGrass","BGMarsh","Marsh","SpiderMarsh","BGNoise","BGSavanna","BGSinkholeRoom"}) do
for k,name in pairs({"SpiderfieldEasy","Spiderfield","SunkenMarsh","SpiderCity","SpiderVillage","SpiderVillageSwamp","BGCrappyForest",
	"CrappyDeepForest","SpiderForest","BGMarsh","Marsh","SpiderMarsh"}) do
--this is apparently 1. too late 2. fires on every freaking thing, so lets try overwriting stuff manually 
	local room=rooms[name]
	if(room)then
--	AddRoomPreInit(name, function(room)
--		print("in preinit",name)
		if room.contents.distributeprefabs and room.contents.distributeprefabs.spiderden then
			local origspider=room.contents.distributeprefabs.spiderden
			if(origspider and type(origspider)=="number")then
--				room.contents.distributeprefabs.spiderden=origspider/2.0
				room.contents.distributeprefabs.poisonspiderden=origspider/30.0
				
			end
		end
--	end)
	else
		print("warning: room",name,"could not be loaded")
	end
end

local function AddCaveRocksPreInit(room)
	room.contents.distributeprefabs.fa_coalrock=0.2
	room.contents.distributeprefabs.fa_copperrock=0.2
	room.contents.distributeprefabs.fa_limestonerock=0.1
end
local function AddCaveRocksPreInit2(room)
	room.contents.distributeprefabs.fa_coalrock=0.025
	room.contents.distributeprefabs.fa_copperrock=0.025
	room.contents.distributeprefabs.fa_limestonerock=0.025
	room.contents.distributeprefabs.fa_ironrock=0.1
end
AddRoomPreInit("CaveBase", AddCaveRocksPreInit)
AddRoomPreInit("BGNoisyCave", AddCaveRocksPreInit)
AddRoomPreInit("BGCaveRoom", AddCaveRocksPreInit)
AddRoomPreInit("BatCaveRoom", AddCaveRocksPreInit)
AddRoomPreInit("BatCaveRoomAntichamber", AddCaveRocksPreInit)
AddRoomPreInit("PitCave", AddCaveRocksPreInit)
AddRoomPreInit("RockLobsterPlains", AddCaveRocksPreInit)

AddRoomPreInit("CaveRoom", AddCaveRocksPreInit2)
AddRoomPreInit("NoisyCave", AddCaveRocksPreInit2)
AddRoomPreInit("FungusRoom", AddCaveRocksPreInit2)

AddRoomPreInit("VolcanoNoise", AddCaveRocksPreInit2)


local function AddGoblinEntrancePreInit(task)
	-- Insert the custom room we created above into the task.
	-- We could modify the task here as well.
	task.room_choices["FA_GoblinEntrance"] = 1
	
end
local function AddMineEntrancePreInit(task)
	task.room_choices["FA_MineEntrance"] = 1
end
--AddTaskPreInit("Make a pick", AddMineEntrancePreInit)
AddTaskPreInit("Make a pick", AddGoblinEntrancePreInit)
AddTaskPreInit("The Deep Forest", AddGoblinEntrancePreInit)
AddTaskPreInit("Squeltch", AddGoblinEntrancePreInit)
AddTaskPreInit("Squeltch", function(task)
		task.room_choices["FA_MineEntranceEvil"] = 1
	end)
AddTaskPreInit("Badlands", function(task)
		task.room_choices["FA_MineEntranceHound"] = 1
	end)
AddTaskPreInit("Dig that rock", function(task)
		task.room_choices["FA_MineEntranceRocky"] = 1
	end)
AddTaskPreInit("Swamp start", AddGoblinEntrancePreInit)
AddTaskPreInit("The charcoal forest", AddGoblinEntrancePreInit)

local function AddOrcPieces(level)
	level.set_pieces["FAOrcSetRocky"]= { count=5, tasks={"Kill the spiders","Mole Colony Rocks", "Dig that rock"} }
	level.set_pieces["FAOrcSetEvil"]= { count=5, tasks={"Squeltch"} }
	level.set_pieces["FAOrcSetHound"]= { count=5, tasks={"Badlands","Oasis"} }
end

local function AddScrollBoons(level)
	level.set_pieces["FAevilbiome_scrollchest_2"]= { count=2, tasks={"Squeltch","Merms ahoy"} }
	
	local Boons=require("map/boons").Sandbox
	local BoonsLayouts=require("map/boons").Layouts
	--TODO figure if oer-floortype works here 
	Boons["Any"]["FAflooring_scrollchest_1"]=Layouts["FAflooring_scrollchest_1"]
	Boons["Any"]["FAflooring_scrollchest_1_B"]=Layouts["FAflooring_scrollchest_1_B"]
	Boons["Any"]["FAgrass_scrollchest_1"]=Layouts["FAgrass_scrollchest_1"]
	Boons["Any"]["FAgrass_scrollchest_1_B"]=Layouts["FAgrass_scrollchest_1_B"]
	Boons["Any"]["FAgrass_scrollchest_1_C"]=Layouts["FAgrass_scrollchest_1_C"]
	Boons["Any"]["FArock_scrollchest_1"]=Layouts["FArock_scrollchest_1"]
	Boons["Any"]["FArock_scrollchest_B"]=Layouts["FArock_scrollchest_B"]
	Boons["Any"]["FArock_scrollchest_C"]=Layouts["FArock_scrollchest_C"]

	BoonsLayouts["FAflooring_scrollchest_1"]=Layouts["FAflooring_scrollchest_1"]
	BoonsLayouts["FAflooring_scrollchest_1_B"]=Layouts["FAflooring_scrollchest_1_B"]
	BoonsLayouts["FAgrass_scrollchest_1"]=Layouts["FAgrass_scrollchest_1"]
	BoonsLayouts["FAgrass_scrollchest_1_B"]=Layouts["FAgrass_scrollchest_1_B"]
	BoonsLayouts["FAgrass_scrollchest_1_C"]=Layouts["FAgrass_scrollchest_1_C"]
	BoonsLayouts["FArock_scrollchest_1"]=Layouts["FArock_scrollchest_1"]
	BoonsLayouts["FArock_scrollchest_B"]=Layouts["FArock_scrollchest_B"]
	BoonsLayouts["FArock_scrollchest_C"]=Layouts["FArock_scrollchest_C"]
end

local function OrcMineBoonsOverride(level)
	--wonder if there's a cleaner way here.. 
	local Boons=require("map/boons").Sandbox
	local BoonsLayouts=require("map/boons").Layouts
	Boons["Any"]={}
	Boons["Rare"]={}
	Boons["Any"]["FAOrcMineBasicset1"]=Layouts["FAOrcMineBasicset1"]
	Boons["Any"]["FAOrcMineBasicset2"]=Layouts["FAOrcMineBasicset2"]
	Boons["Any"]["FAOrcMineBasicset3"]=Layouts["FAOrcMineBasicset3"]
	Boons["Any"]["FAOrcMineBasicset4"]=Layouts["FAOrcMineBasicset4"]
	Boons["Any"]["FAOrcMineBasicset5"]=Layouts["FAOrcMineBasicset5"]
	Boons["Any"]["FAOrcMineBasicset6"]=Layouts["FAOrcMineBasicset6"]
	Boons["Any"]["FAOrcMineBasicset7"]=Layouts["FAOrcMineBasicset7"]
	Boons["Any"]["FAOrcMineBasicset8"]=Layouts["FAOrcMineBasicset8"]
	Boons["Any"]["FAOrcMineBasicset9"]=Layouts["FAOrcMineBasicset9"]
	Boons["Any"]["FAOrcMineBasicset10"]=Layouts["FAOrcMineBasicset10"]
	Boons["Any"]["FAOrcMineBasicset11"]=Layouts["FAOrcMineBasicset11"]
	Boons["Any"]["FAOrcMineBasicset12"]=Layouts["FAOrcMineBasicset12"]
	Boons["Any"]["FAOrcMineBasicset13"]=Layouts["FAOrcMineBasicset13"]
	Boons["Any"]["FAOrcMineBasicset14"]=Layouts["FAOrcMineBasicset14"]
--[[
	Boons["Any"]["FAOrcMineBasicsetTrap1"]=Layouts["FAOrcMineBasicsetTrap1"]
	Boons["Any"]["FAOrcMineBasicsetTrap2"]=Layouts["FAOrcMineBasicsetTrap2"]
	Boons["Any"]["FAOrcMineBasicsetTrap3"]=Layouts["FAOrcMineBasicsetTrap3"]
	Boons["Any"]["FAOrcMineBasicsetTrap4"]=Layouts["FAOrcMineBasicsetTrap4"]
]]
	BoonsLayouts={}
	for k,area in pairs(Boons) do
		for name, layout in pairs(area) do
			BoonsLayouts[name] = layout
		end
	end

--[[
	local Traps=require("map/traps").Sandbox
	local TrapsLayouts=require("map/traps").Layouts
--	Traps={}
	Traps["Any"]={}
	Traps["Rare"]={}
	Traps["Any"]["FAOrcMineBasicsetTrap1"]=Layouts["FAOrcMineBasicsetTrap1"]
	Traps["Any"]["FAOrcMineBasicsetTrap2"]=Layouts["FAOrcMineBasicsetTrap2"]
	Traps["Any"]["FAOrcMineBasicsetTrap3"]=Layouts["FAOrcMineBasicsetTrap3"]
	Traps["Any"]["FAOrcMineBasicsetTrap4"]=Layouts["FAOrcMineBasicsetTrap4"]

--	TrapsLayouts={}
	for k,area in pairs(Traps) do
		for name, layout in pairs(area) do
			TrapsLayouts[name] = layout
		end
	end
	]]
end

AddLevelPreInit("SURVIVAL_DEFAULT", AddScrollBoons)
AddLevelPreInit("SHIPWRECKED_DEFAULT", AddScrollBoons)
AddLevelPreInit("PORKLAND_DEFAULT", AddScrollBoons)
AddLevelPreInit("SURVIVAL_DEFAULT_PLUS", AddScrollBoons)
AddLevelPreInit("ORC_MINES", OrcMineBoonsOverride)

require "wgtest"
-- Squeltch
--badlands and oasis 
--"Kill the spiders"  "Mole Colony Rocks" "Dig that rock" ??

--local task = GLOBAL.tasks.GetTaskByName("Forest hunters", GLOBAL.tasks.sampletasks)