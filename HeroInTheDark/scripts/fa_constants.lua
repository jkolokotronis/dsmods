require "constants"

TUNING.ARMORGRASS = 220
TUNING.ARMORGRASS_ABSORPTION = .2
TUNING.ARMORWOOD = 450
TUNING.ARMORWOOD_ABSORPTION = .4
TUNING.ARMORMARBLE = 1050
TUNING.ARMORMARBLE_ABSORPTION = .60
TUNING.ARMORSNURTLESHELL_ABSORPTION = 0.8
TUNING.ARMORSNURTLESHELL = 1050
TUNING.ARMORMARBLE_SLOW = 0.7
TUNING.ARMORRUINS_ABSORPTION = 0.9
TUNING.ARMORRUINS = 1800
TUNING.ARMORSLURPER_ABSORPTION = 0.6
TUNING.ARMORSLURPER_SLOW_HUNGER = 0.6
TUNING.ARMORSLURPER = 300
TUNING.ARMOR_SANITY = 750
TUNING.ARMOR_SANITY_ABSORPTION = .8
TUNING.ARMOR_SANITY_DMG_AS_SANITY = 0.10

TUNING.STONEWALL_HEALTH=TUNING.STONEWALL_HEALTH*2
TUNING.WOODWALL_HEALTH=TUNING.WOODWALL_HEALTH*2
TUNING.HAYWALL_HEALTH=TUNING.HAYWALL_HEALTH*2
TUNING.RUINSWALL_HEALTH=TUNING.RUINSWALL_HEALTH*2

TUNING.GHOST_SPEED = 5
TUNING.GHOST_HEALTH = 300
TUNING.GHOST_DAMAGE=30

--since tech.lost doesnt exist in vanilla, and since dnd is devil's work, it's only right
TECH.FA_SPELL={MAGIC = 666, SCIENCE = 666, ANCIENT = 666}

SANITY_DAY_LOSS=-100.0/(300*10)
PROTOTYPE_XP=50
SKELETONSPAWNDELAY=960
GHOST_MOUND_SPAWN_CHANCE=0.5
GHOST_MOUND_ITEM_CHANCE=0.5
GHOST_MOUND_SCROLL_CHANCE=0.05

MOUND_RESET_PERIOD=20*480
FISHING_MERM_SPAWN_CHANCE=0.3
FISHING_SCROLL_SPAWN_CHANCE=0.01

FA_TILES_START=40

FA_DAMAGETYPE={
	PHYSICAL=0,--shouldn't be used unless for specific purposes
	POISON=1,
	FIRE=2,
	ACID=3,
	ELECTRIC=4,
	COLD=5,
	DEATH=6,
	HOLY=7,
	FORCE=8
}

FA_DAMAGE_INDICATORS={
	[FA_DAMAGETYPE.PHYSICAL]={0.7,0.7,0.7,1},
	[FA_DAMAGETYPE.POISON]={0,1,0,1},
	[FA_DAMAGETYPE.FIRE]={1,0,0,1},
	[FA_DAMAGETYPE.ACID]={0,0.5,0,1},
	[FA_DAMAGETYPE.ELECTRIC]={0,0,1,1},
	[FA_DAMAGETYPE.COLD]={0.5,0.5,1,1},
	[FA_DAMAGETYPE.DEATH]={0,0,0,1},
	[FA_DAMAGETYPE.HOLY]={0.2,1,1,1},
	[FA_DAMAGETYPE.FORCE]={0,0,0.5,1},
}
FA_DEFAULT_DAMAGE_INDICATOR={0,0,0,1}
FA_DEFAULT_HEAL_INDICATOR={0,0.7,0,1}

FA_WETTNESS_DAMAGE_MODIFIER={
	[FA_DAMAGETYPE.COLD]=0.2,
	[FA_DAMAGETYPE.FIRE]=-0.4,
	[FA_DAMAGETYPE.ELECTRIC]=0.4
}


FALLENLOOTTABLE={
    tier1={ 

            armorfire=50,
            armorfrost=50,
            dagger=50,
            flamingsword=50,
            frostsword=50,
            undeadbanesword=50,
            vorpalaxe=50,
            fa_lightningsword=50,
            fa_bottle_r=50,
            fa_bottle_y=50,
            fa_bottle_g=50,
            fa_bottle_b=50,
            fa_fireaxe=50,
            fa_iceaxe=50, 
            fa_ring_poop=50,       
    },
    tier2={
            armorfire2=35,
            armorfrost2=35,
            dagger2=35,
            flamingsword2=35,
            frostsword2=35,
            undeadbanesword2=35,
            vorpalaxe2=35,
            fa_lightningsword=35,
            fa_fireaxe2=35,
            fa_iceaxe2=35,
            fa_ring_speed=35
    },
    tier3={
            armorfire3=15,
            armorfrost3=15,
            dagger3=15,
            flamingsword3=15,
            frostsword3=15,
            undeadbanesword3=15,
            vorpalaxe3=15,
            fa_lightningsword=15,
            fa_fireaxe3=15,
            fa_iceaxe3=15,
            fa_redtotem_item=15,
            fa_bluetotem_item=15,
            fa_ring_frozen=15,
            fa_ring_burning=15,
            fa_ring_light=15
    },
    keys1={
    	fa_key_generic=70,
    	fa_key_skeleton=20,
    	fa_key_jewel=9,
    	fa_key_swift=1
	},
	keys2={
		fa_key_generic=40,
    	fa_key_skeleton=30,
    	fa_key_jewel=19,
    	fa_key_swift=11
	},
    keys3={
    	fa_key_generic=7.5,
    	fa_key_skeleton=4.5,
    	fa_key_jewel=2.25,
    	fa_key_swift=0.75
	},
    TABLE_WEIGHT=1360,
    TABLE_TIER1_WEIGHT=750,
    TABLE_TIER2_WEIGHT=385,
    TABLE_TIER3_WEIGHT=225,
    TABLE_KEYS1_WEIGHT=100,
    TABLE_KEYS2_WEIGHT=100,
    TABLE_KEYS3_WEIGHT=15
}
FALLENLOOTTABLEMERGED=MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"],FALLENLOOTTABLE["tier3"])


FA_QUAKER_LOOT_OVERRIDE ={}
FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE"] ={
	common = 
	{
		"rocks",
		"flint"
	},
	rare = 
	{
		"goldnugget",
		"nitre",
		"thulecite_pieces"
	},
	veryrare =
	{
		"redgem",
		"bluegem",
		"marble",
	},
}
FA_QUAKER_LOOT_OVERRIDE["ORC_MINES"]={
	common = 
	{"fa_lavapebble",},
	rare = 
	{
		"rocks",
		"fa_lavapebble",
	},
	veryrare =
	{
		"thulecite_pieces",
		"redgem",
		"marble",
	},
}
-- shouldn't be using strings, too lazy to rename files etc
FA_SPELL_SCHOOLS={
	EVOCATION="evocation",
	TRANSMUTATION="transmutation",
	CONJURATION="conjuration",
	ENCHANTMENT="enchantment",
	NECROMANCY="necromancy",
	ILLUSION="illusion",
	ABJURATION="abjuration",
	DIVINATION="divination",
}

--just in case
FA_QUAKER_LOOT_OVERRIDE["ORC_FORTRESS"]=deepcopy(FA_QUAKER_LOOT_OVERRIDE["ORC_MINES"])
FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE_2"]=deepcopy(FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE"])
FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE_3"]=deepcopy(FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE"])
FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE_BOSSLEVEL"]=deepcopy(FA_QUAKER_LOOT_OVERRIDE["GOBLIN_CAVE"])


FA_LEVEL_THREATS={}
FA_LEVEL_THREATS["GOBLIN_CAVE"]={"DUNGEON_GOBLINS"}
FA_LEVEL_THREATS["GOBLIN_CAVE_2"]={"DUNGEON_GOBLINS"}
FA_LEVEL_THREATS["GOBLIN_CAVE_3"]={"DUNGEON_GOBLINS"}

