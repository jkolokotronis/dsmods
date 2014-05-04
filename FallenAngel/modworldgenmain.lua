GLOBAL.require("map/tasks")
modimport 'tile_adder.lua'
GLOBAL.require("map/level")
local levels = GLOBAL.require("map/levels")
GLOBAL.require("map/terrain")
local rooms=GLOBAL.require("map/rooms")
local Layouts = GLOBAL.require("map/layouts").Layouts
local StaticLayout = GLOBAL.require("map/static_layout")
GLOBAL.require("constants")
local GROUND = GLOBAL.GROUND
GLOBAL.require "map/levels/fa_levels"
GLOBAL.require "map/rooms/fa_rooms"
GLOBAL.require "map/tasks/fa_tasks"
GLOBAL.require "map/fa_layouts"

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
		print("in preinit",name)
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
AddTaskPreInit("Make a pick", AddMineEntrancePreInit)
AddTaskPreInit("Make a pick", AddGoblinEntrancePreInit)
AddTaskPreInit("The Deep Forest", AddGoblinEntrancePreInit)
AddTaskPreInit("Squeltch", AddGoblinEntrancePreInit)
AddTaskPreInit("Swamp start", AddGoblinEntrancePreInit)
AddTaskPreInit("The charcoal forest", AddGoblinEntrancePreInit)

--local task = GLOBAL.tasks.GetTaskByName("Forest hunters", GLOBAL.tasks.sampletasks)
--task.room_choices["tut08_room"] = 50

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
--AddTile("MODTEST", 40, "modtest", {noise_texture = "levels/textures/noise_modtest.tex"}, {noise_texture = "levels/textures/mini_noise_modtest.tex"})
