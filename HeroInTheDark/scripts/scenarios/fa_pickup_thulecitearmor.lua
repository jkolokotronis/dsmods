
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
local function OnLoad(inst, scenariorunner)
	inst.scene_pickupfn = function()
    local player = GetPlayer()
		local pt = Vector3(player.Transform:GetWorldPosition())
		local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( pt.x, pt.y, pt.z )

            local spider = SpawnPrefab("fa_animatedarmor")
            spider.Transform:SetPosition( pt.x, pt.y, pt.z )
            if(spider.components.combat)then
                spider.components.combat:SuggestTarget(player)
            end
		scenariorunner:ClearScenario()
        inst:Remove()
        return true
	end
	inst.components.inventoryitem.onpickupfn=inst.scene_pickupfn
--	inst:ListenForEvent("onputininventory", inst.scene_pickupfn)
end

local function OnDestory(inst)
--	if inst.scene_pickupfn then
--		inst:RemoveEventCallback("onputininventory", inst.scene_pickupfn)
--		inst.scene_pickupfn = nil
--	end
end	


return
{
	OnLoad = OnLoad,
	OnDestory = OnDestory
}