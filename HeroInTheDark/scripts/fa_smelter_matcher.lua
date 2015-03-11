--yeah i should break it some day when I have a reason to
local FAIL_TIMER=60

local FAIL_PERSISTANT={
	fa_adamantinepebble="fa_adamantinepebble",
	fa_diamondpebble="fa_diamondpebble",
	fa_adamantinebar="fa_adamantinebar"
}

local FN_DESCRIPTION={}

local function isfuel(ing)
	return ing=="charcoal" or ing=="fa_coalbar"
end

local function bottleany(ing)
	return (ing=="fa_bottle_oil") or (ing=="fa_bottle_mineralwater") or (ing=="fa_bottle_water")
end
local function heavywater(ing)
	return (ing=="fa_bottle_mineralwater") or (ing=="fa_bottle_oil") 
end 
local function anyanimal(ing)
	return (ing=="mole" or ing=="rabbit" or ing=="crow" or ing=="robin" or ing=="robin_winter")
end
local function anymetalore(ing)
	return (ing=="fa_lavapebble" or ing=="fa_ironpebble" or ing=="fa_adamantinepebble" or ing=="fa_copperpebble" or ing=="fa_silverpebble" or ing=="goldnugget")
end
local function anyore(ing)
	return (anymetalore(ing) or ing=="fa_coalpebble" or ing=="fa_limestonepebble" or ing=="rocks" or ing=="flint" )
end
local function anymeat(ing)
	return (ing=="smallmeat" or ing=="meat" or ing=="monstermeat" or ing=="drumstick" or ing=="batwing")
end
local function cornorwheat(ing)
	return (ing=="fa_cutwheat" or ing=="corn")
end

-- fun stuff - TODO move this crap into strings?
FN_DESCRIPTION[isfuel]="Fuel"
FN_DESCRIPTION[bottleany]="Water"
FN_DESCRIPTION[heavywater]="Heavy Water"
FN_DESCRIPTION[anyanimal]="Animal"
FN_DESCRIPTION[anymetalore]="Metal Ore"
FN_DESCRIPTION[anyore]="Ore"
FN_DESCRIPTION[anymeat]="Meat"
FN_DESCRIPTION[cornorwheat]="Corn or Wheat"

local keg_recipes={
	{
		match={product={"fa_barrel_molasses"},cooktime=60},
		test={
			{ingred="pomegranate",count=4,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_barrel_darkrum"},cooktime=1440},
		test={
			{ingred="fa_barrel_lightrum",count=3},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_bourbon"},cooktime=960},
		test={
			{ingred="fa_barrel_clearbourbon",count=3},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_goldrum"},cooktime=960},
		test={
			{ingred="fa_barrel_lightrum",count=2},
			{ingred="goldnugget",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_flavoredrum"},cooktime=960},
		test={
			{ingred="fa_barrel_lightrum",count=2},
			{ingred="dragonfruit",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_hotrum"},cooktime=960},
		test={
			{ingred="fa_barrel_lightrum",count=2},
			{ingred="fa_lavapebble",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_mash"},cooktime=120},
		test={
			{ingred=cornorwheat,count=4},
		},
	},
	{
		match={product={"fa_bottle_wort"},cooktime=120},
		test={
			{ingred="fa_mash",count=2},
			{ingred="fa_bottle_water",count=2},
		},
	},
	{
		match={product={"fa_lightalemug"},cooktime=480},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_emptymug",count=1},
		},
	},
	{
		match={product={"fa_ronsalemug"},cooktime=480},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="fa_mash",count=1},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_emptymug",count=1},
		},
	},
	{
		match={product={"fa_barrel_lightale"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_ronsale"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="fa_mash",count=1},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_drakeale"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="mandrake",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_oriansale"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="pumpkin",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_barrel_dorfale"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="cutlichen",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_dwarfalemug"},cooktime=480},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="cutlichen",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_emptymug",count=1},
		},
	},
	{
		match={product={"fa_barrel_deathbrew"},cooktime=960},
		test={
			{ingred="fa_bottle_wort",count=1},
			{ingred="nightmarefuel",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_brewingyeast",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_pomegranate_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="pomegranate",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_durian_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="durian",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_dragon_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="dragonfruit",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_melon_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="watermelon",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_red_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="berries",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_goodberry_wine"},cooktime=960},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="fa_goodberries",count=1},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_glowing_wine"},cooktime=960},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="wormlight",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_cactus_wine"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="cactus_meat",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
	{
		match={product={"fa_mead"},cooktime=480},
		test={
			{ingred="fa_wineyeast",count=1},
			{ingred="fa_bottle_water",count=1},
			{ingred="honey",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_barrel_wood",count=1},
		},
	},
}



local distiller_recipes={
	{
		match={product={"fa_barrel_lightrum"},cooktime=480},
		test={
			{ingred="fa_barrel_molasses",count=2},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_clearbourbon"},cooktime=480},
		test={
			{ingred="corn",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_cutwheat",count=1},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_vodka"},cooktime=480},
		test={
			{ingred="fa_mash",count=1},
			{ingred="fa_cutwheat",count=1},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_gin"},cooktime=480},
		test={
			{ingred="fa_mash",count=1},
			{ingred="acorn",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_tequila"},cooktime=480},
		test={
			{ingred="fa_mash",count=1},
			{ingred="cutlichen",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_whiskey"},cooktime=480},
		test={
			{ingred="fa_mash",count=1},
			{ingred="corn",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_baijui"},cooktime=480},
		test={
			{ingred="fa_mash",count=2},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
	{
		match={product={"fa_barrel_soju"},cooktime=480},
		test={
			{ingred="fa_cutwheat",count=2},
			{ingred="fa_distillingyeast",count=1},
			{ingred="fa_barrel_water",count=1},
		},
	},
}

local alchemy_recipes={
	{
		match={product={"fa_boneshield"},cooktime=120},
		test={
			{ingred="houndstooth",count=5,atlas="images/inventoryimages.xml"},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred="nightmarefuel",count=2},
		},
	},
	{
		match={product={"fa_reflectshield"},cooktime=120},
		test={
			{ingred="fa_sand",count=4},
			{ingred="fa_coppershield",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred="torch",count=1,atlas="images/inventoryimages.xml"},
			{ingred="nightmarefuel",count=1},
		},
	},
	{
		match={product={"fa_bottle_r"},cooktime=960},
		test={
			{ingred="spidergland",count=4,atlas="images/inventoryimages.xml"},
			{ingred="stinger",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_y"},cooktime=960},
		test={
			{ingred="petals",count=5,atlas="images/inventoryimages.xml"},
			{ingred="fa_orcskin",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_y"},cooktime=960},
		test={
			{ingred="petals",count=5,atlas="images/inventoryimages.xml"},
			{ingred="fa_goblinskin",count=2},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_g"},cooktime=960},
		test={
			{ingred="petals",count=5,atlas="images/inventoryimages.xml"},
			{ingred="nightmarefuel",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
	--yeah i need a freaking counter somewhere
		match={product={"fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand","fa_sand"}
		,cooktime=30},
		test={
			{ingred="rocks",count=8,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_bottle_frozenessence"},cooktime=30},
		test={
			{ingred="ice",count=5,atlas="images/inventoryimages.xml"},
			{ingred="nightmarefuel",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_lifeessence"},cooktime=30},
		test={
			{ingred=anyanimal,count=6},
			{ingred="nightmarefuel",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_lightningessence"},cooktime=30},
		test={
			{ingred="fireflies",count=4,atlas="images/inventoryimages.xml"},
			{ingred=anymetalore,count=1},
			{ingred="nightmarefuel",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_mineralwater"},cooktime=60},
		test={
			{ingred=anyore,count=6},
			{ingred="fa_bottle_water",count=1},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_oil"},cooktime=120},
		test={
			{ingred=anymeat,count=7},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_water"},cooktime=30},
		test={
			{ingred="ice",count=4,atlas="images/inventoryimages.xml"},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_bottle_poisonessence"},cooktime=30},
		test={
			{ingred="poisonspidergland",count=7},
			{ingred="fa_bottle_empty",count=1},
		},
	},
	{
		match={product={"fa_key_generic"},cooktime=30},
		test={
			{ingred="nightmarefuel",count=1,atlas="images/inventoryimages.xml"},
			{ingred="boards",count=2,atlas="images/inventoryimages.xml"},
			{ingred="razor",count=1,atlas="images/inventoryimages.xml"}
		},
	},
	{
		match={product={"fa_wineyeast"},cooktime=30},
		test={
			{ingred="fa_greenshroomcap",count=2},
		},
	},
	{
		match={product={"fa_distillingyeast"},cooktime=30},
		test={
			{ingred="fa_pinkshroomcap",count=2},
		},
	},
	{
		match={product={"fa_brewingyeast"},cooktime=30},
		test={
			{ingred="fa_redshroomcap",count=2},
		},
	},

}

local smelt_recipes={
	{
		match={product={"fa_goldbar"},cooktime=72},
		test={
			{ingred="goldnugget",count=4,atlas="images/inventoryimages.xml"},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_goldbar"},cooktime=120},
		test={
			{ingred="goldnugget",count=4,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=4}
		},
	},
	{
		match={product={"fa_ironbar"},cooktime=360},
		test={
			{ingred="fa_ironpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_pigironbar"},cooktime=360},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="marble",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_pigironbar"},cooktime=360},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_limestonepebble",count=2},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_coalbar","fa_coalbar","fa_coalbar"},cooktime=144},
		test={
			{ingred="fa_coalpebble",count=6},
			{ingred="fa_coalbar",count=2},
		},
	},
	{
		match={product={"fa_coalbar","fa_coalbar","fa_coalbar"},cooktime=240},
		test={
			{ingred="fa_coalpebble",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_steelbar"},cooktime=480},
		test={
			{ingred="fa_coalbar",count=2},
			{ingred="fa_ironbar",count=2},
			{ingred="fa_pigironbar",count=2},
			{ingred="fa_limestonepebble",count=2},
		},
	},
	{
		match={product={"fa_steelbar"},cooktime=480},
		test={
			{ingred="fa_coalbar",count=2},
			{ingred="fa_ironbar",count=2},
			{ingred="fa_pigironbar",count=2},
			{ingred="marble",count=2,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_copperbar"},cooktime=72},
		test={
			{ingred="fa_copperpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_copperbar"},cooktime=120},
		test={
			{ingred="fa_copperpebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
	{
		match={product={"fa_silverbar"},cooktime=144},
		test={
			{ingred="fa_silverpebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_silverbar"},cooktime=240},
		test={
			{ingred="fa_silverpebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
	{
		match={product={"fa_adamantinebar"},cooktime=960},
		test={
			{ingred="fa_adamantinepebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_lavabar"},cooktime=144},
		test={
			{ingred="fa_lavapebble",count=4},
			{ingred="fa_coalbar",count=4},
		},
	},
	{
		match={product={"fa_lavabar"},cooktime=240},
		test={
			{ingred="fa_lavapebble",count=4},
			{ingred=isfuel,count=4},
		},
	},
	{
		match={product={"fa_lavapebble","fa_lavapebble","fa_lavapebble","fa_lavapebble","fa_lavapebble","fa_lavapebble"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_lavaslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_ironpebble","fa_ironpebble","fa_ironpebble","fa_ironpebble","fa_ironpebble","fa_ironpebble"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_ironslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_silverpebble","fa_silverpebble","fa_silverpebble","fa_silverpebble","fa_silverpebble","fa_silverpebble"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_silverslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_copperpebble","fa_copperpebble","fa_copperpebble","fa_copperpebble","fa_copperpebble","fa_copperpebble"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_copperslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
}

local forge_recipes={
	{
		match={product={"fa_coppersword","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_coppersword","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred=isfuel,count=4},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperaxe","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperaxe","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred=isfuel,count=3},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_copperdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_copperdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=3},
			{ingred=isfuel,count=3},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_ironsword","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironsword","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred=isfuel,count=4},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironaxe","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_ironaxe","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred=isfuel,count=3},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_irondagger","fa_bottle_empty","fa_bottle_empty"},cooktime=144},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_irondagger","fa_bottle_empty","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_ironbar",count=3},
			{ingred=isfuel,count=3},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_steelsword","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_steelaxe","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_steeldagger","fa_bottle_empty","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_steelbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_silversword","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=3},
			{ingred="fa_coalbar",count=4},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_silveraxe","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=4},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_silverdagger","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_copperarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_copperarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=4},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=2},
		},
	},
	{
		match={product={"fa_ironarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_ironbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=2},
		},
	},
	{
		match={product={"fa_steelarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_steelbar",count=4},
			{ingred="fa_coalbar",count=2},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_goldarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_goldbar",count=5},
			{ingred="fa_coalbar",count=1},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_silverarmor","fa_bottle_empty","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_silverbar",count=5},
			{ingred="fa_coalbar",count=1},
			{ingred="fa_bottle_oil", count=2},
		},
	},
	{
		match={product={"fa_hat_copper","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=72},
		test={
			{ingred="fa_copperbar",count=2},
			{ingred="fa_coalbar",count=3},
			{ingred=bottleany, count=3},
		},
	},
	{
		match={product={"fa_hat_copper","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_copperbar",count=2},
			{ingred=isfuel,count=3},
			{ingred=bottleany, count=3},
		},
	},
	{
		match={product={"fa_hat_iron","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=216},
		test={
			{ingred="fa_ironbar",count=2},
			{ingred=isfuel,count=3},
			{ingred=heavywater, count=3},
		},
	},
	{
		match={product={"fa_hat_iron","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=360},
		test={
			{ingred="fa_ironbar",count=2},
			{ingred="fa_coalbar",count=3},
			{ingred=heavywater, count=3},
		},
	},
	{
		match={product={"fa_hat_steel","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=840},
		test={
			{ingred="fa_steelbar",count=2},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=3},
		},
	},
	{
		match={product={"fa_hat_gold","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=720},
		test={
			{ingred="fa_goldbar",count=2},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=3},
		},
	},
	{
		match={product={"fa_hat_silver","fa_bottle_empty","fa_bottle_empty","fa_bottle_empty"},cooktime=840},
		test={
			{ingred="fa_silverbar",count=2},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=3},
		},
	},
	{
		match={product={"armorfire","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"armorfire2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"armorfire3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=1},
			{ingred="fa_steelarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"armorfrost","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"armorfrost2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"armorfrost3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=1,atlas="images/inventoryimages.xml"},
			{ingred="fa_steelarmor",count=1},
			{ingred=isfuel,count=2},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_fireaxe","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_fireaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_fireaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"flamingsword","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_lavabar",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_coppersword",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"flamingsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_lavabar",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironsword",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"flamingsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_lavabar",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelsword",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"frostsword","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_coppersword",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"frostsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironsword",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"frostsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelsword",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_iceaxe","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_frozenessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_iceaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_frozenessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_iceaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_frozenessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"vorpalaxe","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_lifeessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperaxe",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"vorpalaxe2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lifeessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironaxe",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"vorpalaxe3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lifeessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steelaxe",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"dagger","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_lifeessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperdagger",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"dagger2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lifeessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_irondagger",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"dagger3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lifeessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steeldagger",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_venomdagger1","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_poisonessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_copperdagger",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_venomdagger2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_poisonessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_irondagger",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_venomdagger3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_poisonessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steeldagger",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_lightningsword","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_bottle_lightningessence",count=1},
			{ingred="charcoal",count=3,atlas="images/inventoryimages.xml"},
			{ingred="fa_coppersword",count=1},
			{ingred=isfuel,count=2},
			{ingred=bottleany, count=1},
		},
	},
	{
		match={product={"fa_lightningsword2","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lightningessence",count=2},
			{ingred="charcoal",count=2,atlas="images/inventoryimages.xml"},
			{ingred="fa_ironsword",count=1},
			{ingred="fa_coalbar",count=2},
			{ingred=heavywater, count=1},
		},
	},
	{
		match={product={"fa_lightningsword3","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_bottle_lightningessence",count=3},
			{ingred="fa_steelword",count=1},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_coppershield","fa_bottle_empty"},cooktime=60},
		test={
			{ingred="fa_copperbar",count=1},
			{ingred=bottleany,count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_ironshield","fa_bottle_empty"},cooktime=120},
		test={
			{ingred="fa_ironbar",count=1},
			{ingred="fa_bottle_oil",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_goldshield","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_goldbar",count=1},
			{ingred="fa_bottle_oil",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_silvershield","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_silverbar",count=1},
			{ingred="fa_bottle_oil",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_steelshield","fa_bottle_empty"},cooktime=240},
		test={
			{ingred="fa_steelbar",count=1},
			{ingred="fa_bottle_oil",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_adamantshield","fa_bottle_empty"},cooktime=480},
		test={
			{ingred="fa_adamantbar",count=1},
			{ingred="fa_bottle_oil",count=1},
			{ingred="hammer",count=1,atlas="images/inventoryimages.xml"},
			{ingred=isfuel,count=5},
		},
	},
	{
		match={product={"fa_lightningsword3","fa_bottle_empty"},cooktime=960},
		test={
			{ingred="fa_bottle_lightningessence",count=3},
			{ingred="fa_coalbar",count=3},
			{ingred="fa_steeldagger",count=1},
			{ingred="fa_bottle_oil", count=1},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_sleep"},cooktime=120,ignorehash=true},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_sleep",count=1,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_fire"},cooktime=120,ignorehash=true},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_fire",count=1,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_bottle_empty","blowdart_pipe"},cooktime=120},
		test={
			{ingred="fa_sand",count=5},
			{ingred="blowdart_pipe",count=1,atlas="images/inventoryimages.xml"},
		},
	},
	{
		match={product={"fa_ironbar","fa_ironbar","fa_ironbar","fa_ironbar","fa_ironbar","fa_ironbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_ironbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_pigironbar","fa_pigironbar","fa_pigironbar","fa_pigironbar","fa_pigironbar","fa_pigironbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_pigironbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_copperbar","fa_copperbar","fa_copperbar","fa_copperbar","fa_copperbar","fa_copperbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_copperbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_steelbar","fa_steelbar","fa_steelbar","fa_steelbar","fa_steelbar","fa_steelbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_steelbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_silverbar","fa_silverbar","fa_silverbar","fa_silverbar","fa_silverbar","fa_silverbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_silverbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_goldbar","fa_goldbar","fa_goldbar","fa_goldbar","fa_goldbar","fa_goldbar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_goldbarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
	{
		match={product={"fa_lavabar","fa_lavabar","fa_lavabar","fa_lavabar","fa_lavabar","fa_lavabar"},cooktime=60,ignorehash=true},
		test={
			{ingred="fa_lavabarslag",count=6},
			{ingred=isfuel,count=2},
		},
	},
}

local FA_Matcher=Class(function(self, craftlists)
	self.craftlists=craftlists
	self:BuildHash()
end)


-- I'll need hash matches for books, but ipairs are 250% faster for any other purpose
function FA_Matcher:BuildHash()
	self.hashtable={}
	for k,v in ipairs(self.craftlists) do 
		if not(v.match.ignorehash==true) then
			local product=v.match.product
			local first=product[1]
		--remember just first? or last?
--		if(self.hashtable[first]==nil)then
			self.hashtable[first]=v
--		end
		end
	end
end


function FA_Matcher:GetProduct(itemlist)
	for k,v in ipairs(self.craftlists) do
		local test=true
		local copylist=deepcopy(itemlist)
		for k1,t in ipairs(v.test) do
			local count=t.count
			if(type(t.ingred)=="function")then
				for ping,pc in pairs(copylist) do
					if(t.ingred(ping))then
						if count<=pc then
							copylist[ping]=pc-count
							count=0
							break
						else
							copylist[ping]=0
							count=count-pc
						end
					end
				end
				if(count and count>0)then
					test=false
					break
				end
			else
				if(copylist[t.ingred] and copylist[t.ingred]>=count)then
					copylist[t.ingred]=copylist[t.ingred]-count
				else
					test=false
					break
				end
			end
		end
		if(test)then
			return v.match
		end
	end
end

function FA_Matcher:GetFailResult(itemlist)
	local product={}
	for k,v in pairs(itemlist) do
		local slag=FAIL_PERSISTANT[k]
		--too lazy to read lua string/regex options
		if(not slag)then
			local index=string.find(k,"slag")
			if(index and index>0)then
				slag=k
			end
			if(not index or index<=0)then 
				index=string.find(k,"bar")
				if(index and index>0)then
					slag=k.."slag"
				end
			end
			if(not index or index<=0)then 
				index=string.find(k,"pebble")
				if(index and index>0)then
					slag=string.sub(k,1,index-1).."slag"
				end
			end
		end
		if(not slag)then
			local index=string.find(k,"bottle")
			if(index and index>0) then 
				slag="fa_bottle_empty"
			end
		end
		if(slag)then
			print("adding slag",slag)
			for i=1,v do
				table.insert(product,slag)
			end
		end
	end
	return {product=product,cooktime=FAIL_TIMER}
end

function FA_Matcher:Match(itemlist)
	
	local product=self:GetProduct(itemlist)
	if(product)then 
		return product
	else
		return self:GetFailResult(itemlist)
	end
	
end

function FA_Matcher:TryMatch(itemlist)
	return true
end

local FA_StandMatcher=Class(FA_Matcher,function(self, craftlists)
    FA_Matcher._ctor(self, craftlists)
end)

function FA_StandMatcher:GetFailResult(itemlist)
	local product={}
	for k,v in pairs(itemlist) do
		for i=1,v do
			table.insert(product,k)
		end
	end
	return  {product=product, cooktime=0,fail=true}
end


local matchers={
	SmelterMatcher=FA_Matcher(smelt_recipes),
	AlchemyMatcher=FA_Matcher(alchemy_recipes),
	ForgeMatcher=FA_Matcher(forge_recipes),
	KegMatcher=FA_Matcher(keg_recipes),
	DistillerMatcher=FA_Matcher(distiller_recipes),
	FN_DESCRIPTION=FN_DESCRIPTION
}



return matchers