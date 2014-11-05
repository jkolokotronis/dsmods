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
			item = "nightmarefuel",
			count = math.random(1, 3),
			chance = 0.2,
		},
		{
			item = {"redgem", "bluegem", "purplegem"},
			count = math.random(1,2),
			chance = 0.15,
		},
		{
			item = {"yellowgem", "orangegem", "greengem"},
			count = 1,
			chance = 0.07,
		},
		{
			item={"fa_scroll_12"},
			count=1,
			chance=0.15
		}
	}

	local loots=FA_ScenarioUtil.FA_GenerateLoot(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,1)
	for k,prefab in pairs(loots) do
		inst.components.container:GiveItem(SpawnPrefab(prefab))
	end
	chestfunctions.AddChestItems(inst, items)

end

local function triggertrap(inst,scenariorunner)
	FA_ScenarioUtil.FA_SpawnPrefabInProx(inst,"hound",4)
	scenariorunner:ClearScenario()
end

local function OnLoad(inst, scenariorunner) 
    FA_ScenarioUtil.InitializeChestTrap(inst, scenariorunner, function() triggertrap(inst,scenariorunner) end)
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
