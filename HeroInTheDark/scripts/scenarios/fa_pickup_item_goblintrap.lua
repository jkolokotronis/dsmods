
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")


local function OnWakeUp(inst, scenariorunner)
-- Spawn spider queen here, disable scenario.

FA_ScenarioUtil.FA_SpawnPrefabInProx(inst,"goblin",4)

	scenariorunner:ClearScenario()
end


local function OnCreate(inst, scenariorunner)
--Anything that needs to happen only once. IE: Putting loot in a chest.
--"I'm different."
end


local function OnLoad(inst, scenariorunner)
--Anything that needs to happen every time the game loads.
	inst.scene_putininventoryfn = function() OnWakeUp(inst, scenariorunner) end
    inst:ListenForEvent("onputininventory",inst.scene_putininventoryfn )
end


local function OnDestroy(inst)
    --Stop any event listeners here.
    inst:RemoveEventCallback("onputininventory",inst.scene_putininventoryfn)
    inst.scene_putininventoryfn=nil
end

return 
{
	OnCreate = OnCreate,
	OnLoad = OnLoad,
	OnDestroy = OnDestroy
}