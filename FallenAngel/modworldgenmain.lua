GLOBAL.require("map/tasks")
GLOBAL.require "map/levels/fa_levels"
local rooms=GLOBAL.require("map/rooms")
GLOBAL.require("constants")
local GROUND = GLOBAL.GROUND

local TRANSLATE_TO_PREFABS = GLOBAL.require("map/forest_map").TRANSLATE_TO_PREFABS
table.insert(TRANSLATE_TO_PREFABS["spiders"],"poisonspiderden")

for k,name in pairs({"SpiderfieldEasy","Spiderfield","SinkholeRoom","SunkenMarsh","ChessForest","SpiderCity","SpiderVillage","SpiderVillageSwamp","TallbirdNests","BGCrappyForest"
	,"BGForest","BGDeepForest","CrappyDeepForest","SpiderForest","BGGrassBurnt","BGGrass","BGMarsh","Marsh","SpiderMarsh","BGNoise","BGSavanna","BGSinkholeRoom"}) do
--for k,name in pairs({"SpiderfieldEasy","Spiderfield","SunkenMarsh","SpiderCity","SpiderVillage","SpiderVillageSwamp","BGCrappyForest",
--	"CrappyDeepForest","SpiderForest","BGMarsh","Marsh","SpiderMarsh"}) do
--this is apparently 1. too late 2. fires on every freaking thing, so lets try overwriting stuff manually 
	local room=rooms[name]
	if(room)then
--	AddRoomPreInit(name, function(room)
		print("in preinit",name)
		if room.contents.distributeprefabs and room.contents.distributeprefabs.spiderden then
			local origspider=room.contents.distributeprefabs.spiderden
			if(origspider and type(origspider)=="number")then
--				room.contents.distributeprefabs.spiderden=origspider/2.0
				room.contents.distributeprefabs.poisonspiderden=origspider/5.0
				
			end
		end
--	end)
	else
		print("warning: room",name,"could not be loaded")
	end
end

