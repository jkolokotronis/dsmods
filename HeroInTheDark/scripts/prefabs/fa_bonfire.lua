local assets =
{
	Asset("ANIM", "anim/bonfire.zip"),
}

 local function onignite(inst)
    if not inst.components.cooker then
        inst:AddComponent("cooker")
    end
end

local function onextinguish(inst)
    if inst.components.cooker then
        inst:RemoveComponent("cooker")
    end
    if inst.components.fueled then
        inst.components.fueled:InitializeFuelLevel(0)
    end
end
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

--	local light = inst.entity:AddLight()
	local sound = inst.entity:AddSoundEmitter()

    
    MakeObstaclePhysics(inst, .3)    
    
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "village.png" )
    
    inst:AddComponent("burnable")
    inst:AddComponent("inspectable")
    inst.components.burnable:AddBurnFX("campfirefire", Vector3(0,1.5,0) )
    inst:ListenForEvent("onextinguish", onextinguish)
    inst:ListenForEvent("onignite", onignite)
    inst.components.burnable:SetFXLevel(4, 1)
    inst.components.burnable:Ignite()

--    inst:AddTag("bonfire")
    anim:SetBank("bonfire")
    anim:SetBuild("bonfire")
	anim:PlayAnimation("on",true)
	inst:DoTaskInTime(0,function()
    inst.components.burnable:Ignite()
	end)
    return inst
end

return Prefab( "common/objects/fa_bonfire", fn, assets) 

