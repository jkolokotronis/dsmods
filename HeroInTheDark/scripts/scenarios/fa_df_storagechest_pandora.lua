chestfunctions = require("scenarios/chestfunctions")
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
chest_openfunctions = require("scenarios/chest_openfunctions")

local function OnCreate(inst, scenariorunner)


	local items = 
	{
		{
			item = {"fa_barrel_darkrum","fa_barrel_goldrum","fa_barrel_water","fa_barrel_bourbon","fa_barrel_flavoredrum","fa_barrel_lightale","fa_barrel_ronsale","fa_barrel_drakeale","fa_barrel_oriansale",
			"fa_barrel_dorfale","fa_barrel_molasses","fa_barrel_deathbrew","fa_barrel_lightrum","fa_barrel_clearbourbon","fa_barrel_vodka","fa_barrel_gin","fa_barrel_tequila","fa_barrel_whiskey","fa_barrel_baijui",
			"fa_barrel_soju","fa_pomegranate_wine","fa_durian_wine","fa_dragon_wine","fa_melon_wine","fa_red_wine","fa_goodberry_wine","fa_glowing_wine","fa_cactus_wine","fa_mead"},
			count = 15,
			chance = 1,
		},
	}   

	chestfunctions.AddChestItems(inst, items)

end

local function OnLoad(inst, scenariorunner) 
--   	chestfunctions.InitializeChestTrap(inst, scenariorunner, GetRandomItem(chest_openfunctions))
end

local function OnDestroy(inst)
    chestfunctions.OnDestroy(inst)
end


return
{
    OnCreate = OnCreate,
    OnLoad = OnLoad,
    OnDestroy = OnDestroy
}
