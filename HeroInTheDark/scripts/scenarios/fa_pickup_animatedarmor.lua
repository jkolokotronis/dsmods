
local FA_ScenarioUtil=require("scenarios/fa_helperfunctions")
local PREFAB_TRANSFORM={
    armorruins="fa_animatedarmor",
    fa_copperarmor="fa_animatedarmor_copper",
    fa_steelarmor="fa_animatedarmor_steel",
    fa_adamantinearmor="fa_animatedarmor_adamant",
    fa_ironarmor="fa_animatedarmor_iron",
    fa_goldarmor="fa_animatedarmor_gold",
    fa_silverarmor="fa_animatedarmor_silver",
}
local DEFAULT_MOB="fa_animatedarmor"
local function OnLoad(inst, scenariorunner)
	inst.scene_pickupfn = function(inst, pickguy)
    local player = GetPlayer()
		local pt = Vector3(player.Transform:GetWorldPosition())
		local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( pt.x, pt.y, pt.z )

            local prefabname=PREFAB_TRANSFORM[inst.prefab] or DEFAULT_MOB
            local spider = SpawnPrefab(prefabname)
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