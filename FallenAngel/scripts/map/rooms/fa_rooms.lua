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
AddRoom("FA_GoblinEntrance", {
					colour={r=0.5,g=.18,b=.35,a=.50},
					value = GROUND.MARSH,
					contents =  {
									countprefabs={
										pighead=function() return math.random(6) end,
										goblinhut = function () return 1 + math.random(2) end,
					                    fa_dungeon_entrance = function () return 1 end,
					                    gravestone = function () return 1 + math.random(2) end,
					                    mound = function () return 1 + math.random(2) end
									},
									prefabdata = {
										fa_dungeon_entrance = function() return {fa_cavename="GOBLIN_CAVE"}
															end,
									},
									
					            }
					})