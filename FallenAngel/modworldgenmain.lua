GLOBAL.require("map/tasks")
GLOBAL.require("constants")

print("in mod world gen")
for k,name in pairs({"SpiderfieldEasy","Spiderfield","SinkholeRoom","SunkenMarsh","ChessForest","SpiderCity","SpiderVillage","SpiderVillageSwamp","TallbirdNests","BGCrappyForest"
	,"BGForest","BGDeepForest","CrappyDeepForest","SpiderForest","BGGrassBurnt","BGGrass","BGMarsh","Marsh","SpiderMarsh","BGNoise","BGSavanna","BGSinkholeRoom"}) do
	AddRoomPreInit(name, function(room)
		print("in preinit",room)
		if room.contents.distributeprefabs and room.contents.distributeprefabs.spiderden then
			local origspider=room.contents.distributeprefabs.spiderden
			print("orig ",room.contents.distributeprefabs.spiderden)
			if(origspider and type(origspider)=="number")then
				room.contents.distributeprefabs.spiderden=origspider/2
				room.contents.distributeprefabs.poisonspiderden=origspider/2
			end
		end
	end)
end

