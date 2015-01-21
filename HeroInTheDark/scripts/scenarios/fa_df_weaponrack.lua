chestfunctions = require("scenarios/chestfunctions")
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
chest_openfunctions = require("scenarios/chest_openfunctions")

local function OnCreate(inst, scenariorunner)

	local rack_type=inst.rack_type
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."dagger"))
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."dagger"))
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."sword"))
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."sword"))
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."axe"))
	inst.components.container:GiveItem(SpawnPrefab("fa_"..rack_type.."axe"))
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
