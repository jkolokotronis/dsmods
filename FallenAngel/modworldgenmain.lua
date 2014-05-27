local require=GLOBAL.require
require("constants")
require("fa_constants")
modimport 'tile_adder.lua'
local GROUND = GLOBAL.GROUND


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

--AddLevelPreInit("SURVIVAL_DEFAULT", AddOrcPieces)
--AddLevelPreInit("SURVIVAL_DEFAULT_PLUS", AddOrcPieces)
-- Squeltch
--badlands and oasis 
--"Kill the spiders"  "Mole Colony Rocks" "Dig that rock" ??

--local task = GLOBAL.tasks.GetTaskByName("Forest hunters", GLOBAL.tasks.sampletasks)
--task.room_choices["tut08_room"] = 50
