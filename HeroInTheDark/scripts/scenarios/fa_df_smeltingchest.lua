chestfunctions = require("scenarios/chestfunctions")
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
chest_openfunctions = require("scenarios/chest_openfunctions")

local function OnCreate(inst, scenariorunner)


	local items = 
	{
		{
			item = {"fa_lavapebble", "fa_ironpebble", "fa_coalpebble","fa_diamondpebble","fa_limestonepebble","fa_copperpebble","fa_silverpebble"},
			count = 10,
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
