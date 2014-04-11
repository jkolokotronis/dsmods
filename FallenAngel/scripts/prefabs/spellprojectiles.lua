local assets=
{
    Asset("ANIM", "anim/fireball.zip"),
        Asset("ANIM","anim/fireball_hit.zip"),
    Asset("ANIM", "anim/swap_blowdart.zip"),
    Asset("ANIM", "anim/blow_dart.zip"),
}

local function OnHitFb(inst, owner, target)
    print("fbhit")
    local pos =inst:GetPosition()
    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    anim:SetBank("fireball_hit")
    boom:AddTag("FX")
    boom:AddTag("NOCLICK")
    anim:SetBuild("fireball_hit")
     local pos = inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    anim:PlayAnimation("idle",false)
    boom:ListenForEvent("animover", function()  boom:Remove() end)
    inst:Remove()
end

local function OnHit(inst, owner, target)
    inst:Remove()
end

local function onthrown(inst, data)

end

local function oncollide(inst, other)
    print("collision with ",other)
    if(inst.components.projectile.target and inst.components.projectile.target==other)then
        print("hit the target, ignore, should never happen")
    else
        if(other)then
            inst.components.projectile:Hit(other)
        else
            inst.components.projectile:Miss()--the hell does target mean here?
        end
    end
    --[[
    local v1 = Vector3(inst.Physics:GetVelocity())
    local v2 = Vector3(other.Physics:GetVelocity()) 
    if v1:LengthSq() > .1 or v2:LengthSq() > .1 then

    end
    ]]
end
local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()

--regular projectiles pass through walls, i want this to actually HIT whatever is on its path and stop in its tracks
    MakeInventoryPhysics(inst)
--    MakeCharacterPhysics(inst, 10, .25)
--    RemovePhysicsColliders(inst)
    local oldcb=
    inst.Physics:SetCollisionCallback(oncollide)
    
    anim:SetBank("fireball")
    anim:SetBuild("fireball")
    inst.AnimState:PlayAnimation("idle", true)
--    inst:AddTag("blowdart")
    
    inst:AddTag("projectile")
    inst.Transform:SetScale(1, 1, 1)

    
    inst:AddComponent("projectile")
    inst:ListenForEvent("onthrown", onthrown)
    inst.components.projectile:SetSpeed(50)
    inst.components.projectile:SetOnHitFn(OnHit)
    inst.components.projectile:SetRange(30)
    inst.components.projectile:SetOnMissFn(OnHit)
    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
--[[
function Projectile:Miss(target)
    local owner = self.owner
    self:Stop()
    if self.onmiss then
        self.onmiss(self.inst, owner, target)
    end
end]]
    
    return inst
end


local function fire()
    local inst = common()
    inst.components.projectile:SetOnHitFn(OnHitFb)
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetOnMissFn(OnHitFb)
    return inst
end

local function firekos()
    local inst = common()
    inst.components.projectile:SetOnHitFn(OnHitFb)
    inst.components.projectile:SetSpeed(20)
    inst.components.projectile:SetHoming(false)
    inst.components.projectile:SetOnMissFn(OnHitFb)
    return inst
end
local function acid()
    local inst = common()
    inst.AnimState:SetBank("blow_dart")
    inst.AnimState:SetBuild("blow_dart")
    inst.AnimState:PlayAnimation("idle_pipe")
    inst.AnimState:SetMultColour(0,1,0,1)
    return inst
end

return  
       Prefab("common/inventory/fireballprojectile", fire, assets),
       Prefab("common/inventory/fireballprojectilekos", firekos, assets),
       Prefab("common/inventory/acidarrowprojectile", acid, assets)