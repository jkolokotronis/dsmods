local assets=
{
    Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip"), 
    Asset("ANIM", "anim/explode.zip"),
    Asset("ANIM", "anim/smoke_right.zip"),
}

local prefabs = 
{
    "ice_projectile",
    "boomstickprojectile",
    "fire_projectile",
    "staffcastfx",
    "stafflight",
     "impact",
}

local BOOM_USES=1
local BOOM_DAMAGE=200
local BOOM_AOE=5
local BOOM_RANGE=10

---------RED STAFF---------

local function onattack_red(inst, attacker, target)

    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
        if target.sg and target.sg.sg.states.hit then
            target.sg:GoToState("hit")
        end
    end
    --since i cant set weapon to aoe...
    local pos=Vector3(target.Transform:GetWorldPosition())
    local lightning = SpawnPrefab("lightning")
    lightning.Transform:SetPosition(pos:Get())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BOOM_AOE,nil,{"pet","player","companion","INLIMBO"})
            for k,v in pairs(ents) do
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not v==target and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(attacker, BOOM_DAMAGE, nil)
                    end
            end
    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local explode = PlayFX(pos,"explode", "explode", "small")
    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetLightOverride(1)

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function onlight(inst, target)
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
end


local function onfinished(inst)
--    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
--    inst:Remove()
end


local function commonfn(colour)

    local onequip = function(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_staffs", colour.."staff")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local onunequip = function(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("staffs")
    anim:SetBuild("staffs")
    anim:PlayAnimation(colour.."staff")
    -------   
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )


    
    return inst
end


---------COLOUR SPECIFIC CONSTRUCTIONS---------

local function red()
    local inst = commonfn("red")

    
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "evilsword.tex" )

    inst:AddTag("rangedfireweapon")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(BOOM_DAMAGE)
    inst.components.weapon:SetRange(BOOM_RANGE-2, BOOM_RANGE)
    inst.components.weapon:SetOnAttack(onattack_red)
    inst.components.weapon:SetProjectile("boomstickprojectile")

    inst.components.finiteuses:SetMaxUses(BOOM_USES)
    inst.components.finiteuses:SetUses(BOOM_USES)

    inst:AddComponent("reloadable")
    inst.components.reloadable.ammotype="gunpowder"

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="nightsword"

    return inst
end



return Prefab("common/inventory/fizzleboomstick", red, assets, prefabs)