local assets=
{
    Asset("ANIM", "anim/smoke_right.zip"),
        Asset("ANIM","anim/blood_drop.zip"),
    Asset("ANIM", "anim/swap_blowdart.zip"),
}

local function OnHit(inst, owner, target)
    inst:Remove()
end

local function onthrown(inst, data)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
end
local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
--    RemovePhysicsColliders(inst)
    
    anim:SetBank("blood_drop")
    anim:SetBuild("blood_drop")
--    inst:AddTag("blowdart")
    
    inst:AddTag("projectile")
                inst.Transform:SetScale(1, 1, 1)
    
    inst:AddComponent("projectile")
    inst:ListenForEvent("onthrown", onthrown)
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetOnMissFn(OnHit)
    
    return inst
end


local function fire()
    local inst = common()
    inst.AnimState:PlayAnimation("idle", true)
    return inst
end

return  
       Prefab("common/inventory/boomstickprojectile", fire, assets) 
