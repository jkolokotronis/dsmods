

function MakeSetpieceRoom(blocker_name)
	return	{
				colour={r=0.2,g=0.0,b=0.2,a=0.3},
				value = GROUND.MUD,
--				tags = {"ForceConnected","RoadPoison"},
				contents =  {
								countstaticlayouts= {
									[blocker_name]=1,
								}, 
							}
			}
end

AddRoom("FA_dungeonexit",{
	colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.DIRT,
					contents =  {
						countprefabs = {
						}
					}
	})

AddRoom("FA_MineEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_ASH,
					contents =  {
									countprefabs = {
										houndmound=1,
										fa_mine_entrance=1
									},
					                prefabdata = {
										fa_mine_entrance = function() return {fa_cavename="ORC_MINES"}
															end,
									},
					            }
					})

AddRoom("FA_MineEntranceEvil", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.MARSH,
					contents =  {
									countstaticlayouts = 
									{
										["FAOrcSetEvil"] = 1,
									}, 
									countprefabs = {
										fa_mine_entrance=1
									},
					                prefabdata = {
										fa_mine_entrance = function() return {fa_cavename="ORC_MINES"}
															end,
									},
					            }
					})

AddRoom("FA_MineEntranceHound", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.DESERT_DIRT,
					contents =  {
									countstaticlayouts = 
									{
										["FAOrcSetHound"] = 1,
									}, 
									countprefabs = {
										fa_mine_entrance=1
									},
					                prefabdata = {
										fa_mine_entrance = function() return {fa_cavename="ORC_MINES"}
															end,
									},
					            }
					})

AddRoom("FA_MineEntranceRocky", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.ROCKY,
					contents =  {
									countstaticlayouts = 
									{
										["FAOrcSetRocky"] = 1,
									}, 
									countprefabs = {
										fa_mine_entrance_grass=1
									},
					                prefabdata = {
										fa_mine_entrance_grass = function() return {fa_cavename="ORC_MINES"}
															end,
									},
					            }
					})


AddRoom("FA_OrcEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_GREEN,
					contents =  {
									countprefabs = {
										fa_orchut=5,
										fa_adamantinerock=2,
										fa_orcfort=1
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
						            },
					                prefabdata = {
										fa_orcfort = function() return {fa_cavename="ORC_FORTRESS"}
															end,
									},
					            }
					})

AddRoom("FA_MineOrcRoom", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_GREEN,
					contents =  {
									countprefabs = {
										fa_orchut=6,
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										fa_lavarock = .25,
					                	fa_ironrock = .25,
						            }
					            }
					})

AddRoom("FA_DwarfEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_SHINY,
					contents =  {
									countprefabs = {
										fa_dorfhut=6, 
										rock2=3,
										fa_dorffort=1
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										rock2 = .25,
					                	stalagmite_med = .25,
						            },
					                prefabdata = {
										fa_dorffort = function() return {fa_cavename="DWARF_FORTRESS"}
															end,
									},
					            }
					})

AddRoom("FA_MineDwarfRoom", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_SHINY,
					contents =  {
									countprefabs = {
										fa_dorfhut=5, 
										fa_dorfbed=5
									},
									distributepercent = 0.1,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										fa_limestonerock = .25,
					                	fa_copperrock = .25,
						            }
					            }
					})

AddRoom("FA_MineHoundRoom", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_TERRAIN2,
					contents =  {
									countprefabs = {
										fa_firehoundmound=5, 
									},
									distributepercent = 0.1,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										fa_coalrock = .25,
					                	fa_ironrock = .25,
					                	rock2 = .25,
						            }
					            }
					})

AddRoom("FA_MineMoundRoom", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FA_LAVA_ASH,
					contents =  {
									countprefabs = {
										fa_lavamound=7, 
										fa_firegoblinhut=2
									},
									distributepercent = 0.1,
					                distributeprefabs= 
					                {
					                	fa_lavaflies = 0.5,
										fa_limestonerock = .25,
					                	fa_coalrock = .25,
					                	rock2 = .15,
					                	rock1 = .15,
						            }
					            }
					})
AddRoom("FA_GoblinEntrance", {
					colour={r=0.5,g=.18,b=.35,a=.50},
					value = GROUND.MARSH,
					contents =  {
									countprefabs={
										pighead=function() return math.random(5) end,
										goblinhut = function () return 1 + math.random(5) end,
					                    fa_dungeon_entrance = function () return 1 end,
					                    gravestone = function () return 1 + math.random(2) end,
					                    --mound = function () return 1 + math.random(1) end
									},
									prefabdata = {
										fa_dungeon_entrance = function() return {fa_cavename="GOBLIN_CAVE"}-- {fa_cavename=}"GOBLIN_CAVE_BOSSLEVEL"}
															end,
									},
									
					            }
					})

AddRoom("FA_GoblinRoom_1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					
					contents =  {

									countstaticlayouts = 
									{
										["FAGoblinRoom_1"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinRoomEntry",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
--					tags ={"ForceConnected",	"MazeEntrance"},
					contents =  {
									countprefabs={
										goblinhut = function () return 2 + math.random(3) end,
										pighead=function() return math.random(8) end,
										fa_bonfire=1
									},
									distributepercent = 0.01,
					                distributeprefabs= 
					                {
					                	dropperweb = 1,
					                    rock_flintless = 0.66,
					                }
					            }
	})
AddRoom("FA_GoblinRoom1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA5x5GoblinRoom_1"] = 1,
										["FA5x5GoblinRoom_2"] =1,
										["FA7x7GoblinRoom_6"] = 1,
										["FA10x10GoblinRoom_1"] = 1,
										["FA10x10GoblinRoom_12"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom2",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA5x5GoblinRoom_6"] = 1,
										["FA5x5GoblinRoom_7"] = 1,
										["FA10x10GoblinRoom_15"] = 1,
										["FA7x7GoblinRoom1_goblintrap_2"] = 1,
										["FA10x10GoblinRoom_5"] = 1,
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_2"] = 1,
										["FA10x10GoblinRoom_3"] = 1,
										["FA10x10GoblinRoom_4"] = 1,
										["FA5x5GoblinRoom_5"] = math.random(2),
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom4",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_6"] = 1,
										["FA10x10GoblinRoom_7"] = 1,
										["FA7x7GoblinRoom_5"] = 1,
										["FA5x5GoblinRoom_10"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom5",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_9"] = 1,
										["FA10x10GoblinRoom_10"] = 1,
										["FA7x7GoblinRoom_7"] = 1,
										["FA5x5GoblinRoom_4"] =1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom6",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA7x7GoblinRoom1_goblintrap_3"] = 1,
										["FA7x7GoblinRoom1_goblintrap_4"] = 1,
										["FA7x7GoblinRoom1_goblintrap_5"] = 1,
										["FA7x7GoblinRoom1_houndtrap_4"] = 1,
										["FA5x5GoblinRoom_9"] = 1,
										["FA10x10GoblinRoom_16"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom7",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_13"] = 1,
										["FA10x10GoblinRoom_14"] = 1,
										["FA5x5GoblinRoom_8"] = 1,
										["FA7x7GoblinRoom1_houndtrap_5"] = 1,
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinRoom8",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA7x7GoblinRoom_2"] = 1,
										["FA7x7GoblinRoom_3"] = 1,
										["FA7x7GoblinRoom_4"] = 1,
										["FA5x5GoblinRoom_3"] = 1,
										["FA10x10GoblinRoom_8"] = 1,
										["FA10x10GoblinRoom_11"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                	fa_ironrock = .05,
					                	fa_coalrock = .1,
					                	fa_copperrock = .1,
										fa_limestonerock = .05,
						            }
					            }
	})
AddRoom("FA_GoblinMaze1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze_1"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
						            }
					            }
	})
AddRoom("FA_GoblinMaze2",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze_2"] = 1,
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
						            } 
					            }
	})
AddRoom("FA_GoblinMaze3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze_3"] = 1,
									}, 
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	fireflies = 0.5,
										stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
						            }
					            }
	})


AddRoom("FA_GoblinBossroom2",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
--					tags = {"ForceConnected","RoadPoison"},
					contents =  {

									countstaticlayouts = 
									{
										["FAGoblinBossroom2"] = 1,
--										["MaxwellHome"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinBossroom3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
--					tags = {"ForceConnected","RoadPoison"},
					contents =  {

									countstaticlayouts = 
									{
										["FAGoblinBossroom3"] = 1,
--										["MaxwellHome"] = 1,
									}, 
					            }
	})

AddRoom("FA_DwarfFortressStartRoom",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.ROCKY,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressStartRoom"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressRoom",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressBase1"] = 1,
									}, 
					            }
	})

AddRoom("FA_DwarfFortressGrowRoom",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressGrowRoom"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressMerchants",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressMerchants"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressSmelting",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSmelting"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressForge",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressForge"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressThrone",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressThrone"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressStorage",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressStorage"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressBedrooms",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressBedrooms"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressAlcohol",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressAlcohol"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressDungeon",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressDungeon"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressDiningRoom",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressDiningRoom"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressGraveyard",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressGraveyard"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressArmory",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressArmory"] = 1,
									}, 
					            }
	})


AddRoom("FA_DwarfFortressTreasure",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressTreasure"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressSecretEntrance",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecretEntrance"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressSecret1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecret1"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressSecret2",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecret2"] = 1,
									}, 
					            }
	})
AddRoom("FA_DwarfFortressSecret3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecret3"] = 1,
									}, 
					            }
	})

AddRoom("FA_DwarfFortressSecret4",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecret4"] = 1,
									}, 
					            }
	})

AddRoom("FA_DwarfFortressSecret5",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressSecret5"] = 1,
									}, 
					            }
	})



AddRoom("FA_DwarfFortressRoom1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
--					tags = {"ForceDisconnected"},
--					tags = {"ForceConnected","RoadPoison"},
					contents =  {

									countstaticlayouts = 
									{
										["FADorfFortressStartRoom"] = 1,
									}, 
					            }
	})

AddRoom("FA_DwarfFortressTestRoom",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.FUNGUSGREEN,	
--					tags = {"ForceDisconnected"},
--					tags = {"ForceConnected","RoadPoison"},
					contents =  {

									countstaticlayouts = 
									{
										["FATestwithimpass"] = 1,
									}, 
					            }
	})




AddRoom("FA_5x5GoblinRoom_1", MakeSetpieceRoom("FA5x5GoblinRoom_1"))
AddRoom("FA_5x5GoblinRoom_2", MakeSetpieceRoom("FA5x5GoblinRoom_2"))
AddRoom("FA_5x5GoblinRoom_3", MakeSetpieceRoom("FA5x5GoblinRoom_3"))
AddRoom("FA_5x5GoblinRoom_4", MakeSetpieceRoom("FA5x5GoblinRoom_4"))
AddRoom("FA_5x5GoblinRoom_5", MakeSetpieceRoom("FA5x5GoblinRoom_5"))

AddRoom("FA_BGDwarfFortress",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value =GROUND.IMPASSABLE, 
					contents =  {
									
					            }
					})

AddRoom("FA_BGDwarfFortressStart",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value =GROUND.FUNGUSGREEN, 
					contents =  {
									
					            }
					})
AddRoom("FA_BGGoblin",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.IMPASSABLE, 
					contents =  {
									countprefabs={
										goblinhut = function () return 2 + math.random(3) end,
										pighead=function() return math.random(8) end,
										fa_bonfire=1
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	stalagmite = .25,
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	dropperweb = 0.5,
					                	mushtree_tall = 0.2,
										mushtree_medium = 0.2,
										mushtree_small = 0.2,
					                }
					            }
					})
AddRoom("FA_BGLava",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_TERRAIN2, 
					contents =  {
									countprefabs={
										fa_fissure_red=1
									},
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_lavarock = .5,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGLava_Ash",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_ASH, 
					contents =  {
									countprefabs={
										fa_fissure_red=1
									},
									distributepercent = 0.2,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_ironrock = .5,
					                	fa_coalrock = .1,
					                	rock1=0.1,
					                	rock2=0.1,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGLava_OF_Ash",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_ASH, 
					contents =  {
									countprefabs={
										fa_fissure_red=1,
										fa_orchut=2
									},
									distributepercent = 0.2,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_ironrock = .5,
					                	fa_coalrock = .1,
					                	rock1=0.1,
					                	rock2=0.1,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGLava_Shiny",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_SHINY, 
					contents =  {
									countprefabs={
										fa_fissure_red=1
									},
									distributepercent = 0.2,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_copperrock = .5,
					                	fa_coalrock = .1,
					                	rock1=0.1,
					                	rock2=0.1,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGLava_DF_Shiny",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_SHINY, 
					contents =  {
									countprefabs={
										fa_fissure_red=1,
										fa_dorfhut=2,
									},
									distributepercent = 0.2,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_copperrock = .5,
					                	fa_coalrock = .1,
					                	rock1=0.1,
					                	fa_ironrock = .1,
					                	rock2=0.1,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGLava_Green",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
--					value =GROUND.IMPASSABLE, 
					value =GROUND.FA_LAVA_GREEN, 
					contents =  {
									countprefabs={
										fa_fissure_red=1
									},
									distributepercent = 0.2,
					                distributeprefabs= 
					                {
					                	stalagmite_med = .25,
					                	stalagmite_low = .25,
					                	fa_ironrock = .5,
					                	rock1=0.1,
					                	fa_copperrock = .1,
					                	rock2=0.1,
					                	fa_fissure_red = 0.25,
					                }
					            }
					})
AddRoom("FA_BGBlocker",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value =GROUND.IMPASSABLE, 
					contents =  {
									
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	dropperweb = 1,
					                    rock_flintless = 0.66,
					                }
					            }
					})

AddRoom("FA_BGEmpty",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value =GROUND.UNDERROCK, 
					
					contents =  {
					
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	dropperweb = 1,
					                    rock_flintless = 0.66,
					                }
					            }
					})

										