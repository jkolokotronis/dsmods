
require("scenarios/fa_helperfunctions")


local function OnWakeUp(inst, scenariorunner)
-- Spawn spider queen here, disable scenario.

FA_SpawnPrefabInProx(inst,"goblin",4)

	scenariorunner:ClearScenario()
end


local function OnCreate(inst, scenariorunner)
--Anything that needs to happen only once. IE: Putting loot in a chest.
--"I'm different."
end


local function OnLoad(inst, scenariorunner)
--Anything that needs to happen every time the game loads.
    inst:ListenForEvent("onputininventory", function() OnWakeUp(inst, scenariorunner) end)
end


local function OnDestroy(inst)
    --Stop any event listeners here.
    --if you're destroying the object, why do you care about manually removin handler that would otherwise get killed anyway?
--    inst:RemoveEventCallback("onputininventory")
end

return 
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy
}