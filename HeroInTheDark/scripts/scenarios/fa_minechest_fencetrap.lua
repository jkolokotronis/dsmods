chestfunctions = require("scenarios/chestfunctions")
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
chest_openfunctions = require("scenarios/chest_openfunctions")

local function OnCreate(inst, scenariorunner)


	local items = 
	{
	--[[
		{
			--Body Items
			item = {"armorwood", "footballhat"},
			chance = 0.2,
			initfn = function(item) item.components.armor:SetCondition(math.random(item.components.armor.maxcondition * 0.33, item.components.armor.maxcondition * 0.8))end
		},]]
		{
			item = {"fa_bottle_r","fa_bottle_y","fa_bottle_g","fa_bottle_b","fa_bottle_curepoison"},
			count = 2,
			chance = 1,
		},
		{
			item = {"yellowgem", "orangegem", "greengem","redgem", "bluegem", "purplegem"},
			count = 4,
			chance = 1,
		},
	}

	local loots=FA_ScenarioUtil.FA_GenerateLoot(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,1)
	for k,prefab in pairs(loots) do
		inst.components.container:GiveItem(SpawnPrefab(prefab))
	end
	chestfunctions.AddChestItems(inst, items)

end

local function triggertrap(inst,scenariorunner)
	FA_ScenarioUtil.FA_SpawnPrefabInProx(inst,"fa_bluetotem_kos",4)
	scenariorunner:ClearScenario()
end

local function OnLoad(inst, scenariorunner) 
	print("fencetrap")
    FA_ScenarioUtil.InitializeChestTrap(inst, scenariorunner, function() triggertrap(inst,scenariorunner) end)
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
