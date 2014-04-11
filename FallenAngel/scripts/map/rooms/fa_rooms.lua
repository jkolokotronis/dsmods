--[[
------------------------------------------------------------------------------------
-- Ruins ---------------------------------------------------------------------------
------------------------------------------------------------------------------------
AddRoom("Labyrinth", {-- Not a real Labyrinth.. more of a maze really.
					colour={r=.25,g=.28,b=.25,a=.50},
					value = GROUND.MUD,
					tags = {"Labyrinth"},
					internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
				})
AddRoom("LabyrinthEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.MUD,
					tags = {"ForceConnected",  "LabyrinthEntrance"},--"Labyrinth",
					contents =  {
					                distributepercent = .2,
					                distributeprefabs=
					                {
					                	lichen = .8,
					                	cave_fern = 1,
					                    pillar_algae = .05,	

					                    flower_cave = .2,
					                    flower_cave_double = .1,
					                    flower_cave_triple = .05,
					                },
					            }
					})

-- TODO: need a way to force connect to previous story? ForceConnected doesnt seem to work
AddRoom("LabyrinthCityEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.MUD,
					tags = {"ForceConnected",  "MazeEntrance", "LabyrinthEntrance"}, -- MazeExit?
					contents =  {
					                distributepercent = .2,
					                distributeprefabs=
					                {
					                	lichen = .8,
					                	cave_fern = 1,
					                },
					            }
					})

AddRoom("RuinedCity", {-- Maze used to define room connectivity
					colour={r=.25,g=.28,b=.25,a=.50},
					value = GROUND.CAVE,
					tags = {"Maze"},
					internal_type = NODE_INTERNAL_CONNECTION_TYPE.EdgeCentroid,
				})
AddRoom("RuinedCityEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.MUD,	
					tags = {"ForceConnected",   "MazeEntrance"},--"Maze",
					contents =  {
					                distributepercent = .07,
					                distributeprefabs=
					                {
					                    blue_mushroom = 1,
					                    cave_fern = 1,
					                    lichen = .5,
					                },
					            }
					})



AddRoom("RuinedGuarden", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.FUNGUS, 
					contents =  {

					                countprefabs= {
					                	mushtree = function () return 3 + math.random(3) end,
					                    flower_cave = function () return 5 + math.random(3) end,
					                    gravestone = function () return 4 + math.random(4) end,
					                    mound = function () return 4 + math.random(4) end
					                }
					            }
					})


---SACRED

AddRoom("SacredEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.TILES,
					tags = {"ForceConnected",   "MazeEntrance"},--"Maze",
					contents =  {
									distributepercent = 0.1,
					                distributeprefabs= 
					                {
					                	nightmarelight = 1,
					                },
					            }
					})

AddRoom("BGSacredGround", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									distributepercent = 0.03,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .07,
					                    knight_nightmare = .07,
					                }
					            }
					})

AddRoom("Altar", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									countstaticlayouts = 
									{
										["AltarRoom"] = 1,
									},
									distributepercent = 0.03,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .07,
					                    knight_nightmare = .07,
					                }

					            }
					})

AddRoom("Barracks",{
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									countstaticlayouts = 
									{
										["Barracks"] = 1,
									},

									distributepercent = 0.03,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .07,
					                    knight_nightmare = .07,
					                    

					                }
					            }
					})

AddRoom("Bishops",{
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									countstaticlayouts = 
									{
										["Barracks2"] = 1,
									},
									distributepercent = 0.03,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .1,
					                    knight_nightmare = .07,
					                }

					            }
					})

AddRoom("Spiral",{
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									countstaticlayouts = 
									{
										["Spiral"] = 1,
									},

									distributepercent = 0.03,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .07,
					                    knight_nightmare = .07,
					                }
					            }
					})

AddRoom("BrokenAltar", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.TILES, 
					contents =  {
									countstaticlayouts = 
									{
										["BrokenAltar"] = 1,
									},

									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	chessjunk1 = .1,
					                	chessjunk2 = .1,
					                	chessjunk3 = .1,

					                    nightmarelight = 1,

					                    ruins_statue_head = .1,
					                    ruins_statue_head_nogem = .2,

					                    ruins_statue_mage =.1,
					                    ruins_statue_mage_nogem = .2,

					                    rook_nightmare = .07,
					                    bishop_nightmare = .07,
					                    knight_nightmare = .07,
					                }

					            }
					})

					--"MILITARY"


AddRoom("BGMilitary",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.UNDERROCK, 
					tags = {"Maze"},
					contents =  {
									distributepercent = 0.05,
					                distributeprefabs= 
					                {
					                	dropperweb = 1,
					                	pillar_ruins = 0.33,					                    
					                    nightmarelight = 0.33,
					                    rock_flintless = 0.66,
					                }
					            }
					})

AddRoom("MilitaryEntrance", {
					colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					tags = {"ForceConnected",   "MazeEntrance"},
					contents =  {

									countstaticlayouts = 
									{
										["MilitaryEntrance"] = 1,
									}, 
					            }
					})


----"VILLAGE"


AddRoom("BGMonkeyWilds", {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.MUD, 
					tags = {"Maze"},
					contents =  {
									distributepercent = 0.09,
					                distributeprefabs= 
					                {
					                	lichen = .3,
					                	cave_fern = 1,
					                    pillar_algae = .05,

					                    cave_banana_tree = 0.1,
					                    monkeybarrel = 0.06,
					                    slurper = 0.06,
					                    pond_cave = 0.07,
					                    fissure_lower = 0.04,
					                    worm = 0.04,
					                }
					            }
					})

AddRoom("Vacant", {
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value = GROUND.MUD, 
					contents =  {
									countstaticlayouts =
									{
										["CornerWall"] = math.random(1,3),
										["StraightWall"] = math.random(1,2),
										["CornerWall2"] = math.random(1,2),
										["StraightWall2"] = math.random(1,3),
									},
									distributepercent = 0.12,
					                distributeprefabs= 
					                {
					                	lichen = .4,
					                	cave_fern = .6,
					                    pillar_algae = .01,
					                    slurper = .15,
					                    cave_banana_tree = .1,
					                    monkeybarrel = .2,
					                    dropperweb = .1,
					                    ruins_rubble_table = 0.1,
					                    ruins_rubble_chair = 0.1,
					                    ruins_rubble_vase = 0.1,
					                }
					            }
					})]]


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

AddRoom("FA_GoblinEntrance", {
					colour={r=0.5,g=.18,b=.35,a=.50},
					value = GROUND.MARSH,
					contents =  {
									countprefabs={
										pighead=function() return math.random(5) end,
										goblinhut = function () return 1 + math.random(2) end,
					                    fa_dungeon_entrance = function () return 1 end,
					                    gravestone = function () return 1 + math.random(2) end,
					                    mound = function () return 1 + math.random(1) end
									},
									prefabdata = {
										fa_dungeon_entrance = function() return {fa_cavename="GOBLIN_CAVE"}
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
									countstaticlayouts = 
									{
										["FA5x5GoblinRoom_1"] = 1,
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
										["FA5x5GoblinRoom_1"] = math.random(2),
										["FA5x5GoblinRoom_2"] = math.random(2),
										["FA5x5GoblinRoom_3"] = math.random(2),
										["FA5x5GoblinRoom_4"] = math.random(2),
										["FA5x5GoblinRoom_5"] = math.random(2),
									}, 
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
										["FA5x5GoblinRoom_8"] = 1,
										["FA5x5GoblinRoom_9"] = 1,
										["FA5x5GoblinRoom_10"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinRoom3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_1"] = 1,
										["FA10x10GoblinRoom_2"] = 1,
										["FA10x10GoblinRoom_3"] = 1,
										["FA10x10GoblinRoom_4"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinRoom4",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA10x10GoblinRoom_5"] = 1,
										["FA10x10GoblinRoom_6"] = 1,
										["FA10x10GoblinRoom_7"] = 1,
										["FA10x10GoblinRoom_8"] = 1,
									}, 
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
										["FA10x10GoblinRoom_11"] = 1,
										["FA10x10GoblinRoom_12"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinRoom6",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA7x7GoblinRoom1_goblintrap_2"] = 1,
										["FA7x7GoblinRoom1_goblintrap_3"] = 1,
										["FA7x7GoblinRoom1_goblintrap_4"] = 1,
										["FA7x7GoblinRoom1_goblintrap_5"] = 1,
										["FA7x7GoblinRoom1_houndtrap_4"] = 1,
										["FA7x7GoblinRoom1_houndtrap_5"] = 1,
									}, 
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
										["FA10x10GoblinRoom_15"] = 1,
										["FA10x10GoblinRoom_16"] = 1,
									}, 
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
										["FA7x7GoblinRoom_5"] = 1,
										["FA7x7GoblinRoom_6"] = 1,
										["FA7x7GoblinRoom_7"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinMaze1",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze1"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinMaze2",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze2"] = 1,
									}, 
					            }
	})
AddRoom("FA_GoblinMaze3",{
		colour={r=0.2,g=0.0,b=0.2,a=0.3},
					value = GROUND.UNDERROCK,	
					contents =  {

									countstaticlayouts = 
									{
										["FA25x25GoblinMaze3"] = 1,
									}, 
					            }
	})

AddRoom("FA_5x5GoblinRoom_1", MakeSetpieceRoom("FA5x5GoblinRoom_1"))
AddRoom("FA_5x5GoblinRoom_2", MakeSetpieceRoom("FA5x5GoblinRoom_2"))
AddRoom("FA_5x5GoblinRoom_3", MakeSetpieceRoom("FA5x5GoblinRoom_3"))
AddRoom("FA_5x5GoblinRoom_4", MakeSetpieceRoom("FA5x5GoblinRoom_4"))
AddRoom("FA_5x5GoblinRoom_5", MakeSetpieceRoom("FA5x5GoblinRoom_5"))

AddRoom("FA_BGGoblin",  {	
					colour={r=0.3,g=0.2,b=0.1,a=0.3},
					value =GROUND.IMPASSABLE, 
					
					contents =  {
									distributepercent = 0.01,
					                distributeprefabs= 
					                {
					                	dropperweb = 1,
					                    rock_flintless = 0.66,
					                }
					            }
					})