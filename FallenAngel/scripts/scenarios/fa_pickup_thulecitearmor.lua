
require("scenarios/fa_helperfunctions")
local function OnLoad(inst, scenariorunner)
	inst.moundlist = FindGraves(inst)
	inst.scene_pickupfn = function()
		local pt = Vector3(inst.Transform:GetWorldPosition())
		local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( pt.x, pt.y, pt.z )

            local spider = SpawnPrefab("fa_animatedarmor")
            spider.Transform:SetPosition( pt.x, pt.y, pt.z )
            if(spider.components.combat)then
                spider.components.combat:SuggestTarget(player)
            end
		scenariorunner:ClearScenario()
	end
	inst:ListenForEvent("onpickup", inst.scene_pickupfn)
end

local function OnDestory(inst)
	if inst.scene_pickupfn then
		inst:RemoveEventCallback("onpickup", inst.scene_pickupfn)
		inst.scene_pickupfn = nil
	end
end	


return
{
	OnLoad = OnLoad,
	OnDestory = OnDestory
}