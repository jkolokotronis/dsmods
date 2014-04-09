require("map/level")
local Levels=require("map/levels")
require("fa_constants")
FA_LEVELDATA={}

-- Cave levels
----------------------------------


FA_LEVELDATA["DUNGEON_LEVEL_1"]={
		id="DUNGEON_LEVEL_1",
		name="DUNGEON_LEVEL_1",
		overrides={
			{"world_size", 		"medium"},
			-- {"day", 			"onlynight"}, 
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"CaveStart"},
			{"start_node",		"BGSinkholeRoom"},
		},
		tasks={
			"CavesStart",
			"CavesAlternateStart",
			"FungalBatCave",
			"BatCaves",
			"TentacledCave",
			"SingleBatCaveTask",
			"RabbitsAndFungs",
			"FungalPlain",
			"Cavern",
		},
		numoptionaltasks = math.random(2,3),
		optionaltasks = {
			"CaveBase",
			"MushBase",
			"SinkBase",
			"RabbitTown",
			"RedFungalComplex",
			"GreenFungalComplex",
			"BlueFungalComplex",
		},
	}

FA_LEVELDATA["GOBLIN_CAVE"]={
		id="GOBLIN_CAVE",
		name="GOBLIN_CAVE",
		overrides={
			{"world_size", 		"medium"},
			-- {"day", 			"onlynight"}, 
			{"branching",		"never"},
			{"islands", 		"never"},	
			{"loop",			"always"},
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"FADungeonStart"},
			{"start_node",		"FA_GoblinRoom_1"},
		},
		tasks={
			
			"FAGoblinDungeon1",
			"FAGoblinDungeon2",
			"FAGoblinDungeon3",
			"FAGoblinDungeon4",
			"FAGoblinDungeon5",
--			"TheLabyrinth",
--			"Residential",
--			"Military"
--			"Sacred"
		},
		--[[
		numoptionaltasks = math.random(1,2),
		optionaltasks = {
			"MoreAltars",
			"SacredDanger"
		},]]
		required_prefabs = {
		"fa_dungeon_exit",
		},

	}

FA_LEVELDATA["ORC_STRONGHOLD"]={
		id="ORC_STRONGHOLD",
		name="ORC_STRONGHOLD",
		overrides={
			{"world_size", 		"tiny"},
--			{"day", 			"onlynight"}, 
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"RuinsStart"},
			{"start_node",		"BGWilds"},
		},
		tasks={
			"RuinsStart",
			"TheLabyrinth",
			"Residential",
			"Military",
			"Sacred",
		},
		numoptionaltasks = math.random(1,2),
		optionaltasks = {
			"MoreAltars",
			"SacredDanger",
			"FailedCamp",
			"Residential2",
			"Residential3",
			"Military2",
			"Sacred2",
		},

	}

FA_LEVELDATA["CRYPT_LEVEL_1"]={
		id="CRYPT_LEVEL_1",
		name="CRYPT_LEVEL_1",
		overrides={
			{"world_size", 		"tiny"},
--			{"day", 			"onlynight"}, 
			{"waves", 			"off"},
			{"location",		"cave"},
			{"boons", 			"never"},
			{"poi", 			"never"},
			{"traps", 			"never"},
			{"protected", 		"never"},
			{"start_setpeice", 	"RuinsStart"},
			{"start_node",		"BGWilds"},
		},
		tasks={
			"RuinsStart",
			"TheLabyrinth",
			"Residential",
			"Military",
			"Sacred",
		},
		numoptionaltasks = math.random(1,2),
		optionaltasks = {
			"MoreAltars",
			"SacredDanger",
			"FailedCamp",
			"Residential2",
			"Residential3",
			"Military2",
			"Sacred2",
		},

	}


function AddNewCaveLevel(cavename)
	local data=FA_LEVELDATA[cavename]
	if(not FA_LEVELS[cavename]) then FA_LEVELS[cavename]={} end
	local existing_levels=FA_LEVELS[cavename]
	--the above should be using 'default' array mode so # should hopefully work
	local lvl=nil
	if(#existing_levels>0)then
		--just use old handle, they should all be same anyway? DO NOT destroy elements after created (there should never be a reason to anyway)
		--dont care which one
		lvl=existing_levels[1]
	else
		AddLevel(LEVELTYPE.CAVE, data)
		--is there a saner way of doing this? table.insert returns nil so does addlevel
		lvl=table.remove(Levels.cave_levels)
	end
	--ok, now, if someone fucks up ordering?
	--local index=#Levels.cave_levels
	local index=3 --we know first 3 are in use
	while Levels.cave_levels[index] do
		index=index+1
	end
	Levels.cave_levels[index]=lvl
	table.insert(FA_LEVELS[cavename],index)
	return index
end

AddNewCaveLevel("DUNGEON_LEVEL_1")
AddNewCaveLevel("GOBLIN_CAVE")
AddNewCaveLevel("ORC_STRONGHOLD")
AddNewCaveLevel("CRYPT_LEVEL_1")
