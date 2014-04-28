local assets=
{
	Asset("ANIM", "anim/blow_dart.zip"),
	Asset("ANIM", "anim/swap_blowdart.zip"),
	Asset("ANIM", "anim/swap_blowdart_pipe.zip"),
    Asset("ANIM", "anim/woodbow.zip"),
    Asset("ANIM", "anim/swap_woodbow.zip"),
    Asset("ATLAS", "images/inventoryimages/woodbow.xml"),
    Asset("IMAGE", "images/inventoryimages/woodbow.tex"),
}

local prefabs = 
{
    "ice_projectile",
    "fire_projectile",
    "staffcastfx",
    "stafflight",
     "impact",
}

local BOW_USES=20
local BOW_DAMAGE=20
local BOW_RANGE=15

---------RED STAFF---------

local function onattack_red(inst, attacker, target)

--[[
    if target.components.sleeper and target.components.sleeper:IsAsleep() then
        target.components.sleeper:WakeUp()
    end

    if target.components.combat then
        target.components.combat:SuggestTarget(attacker)
        if target.sg and target.sg.sg.states.hit then
            target.sg:GoToState("hit")
        end
    end


    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
    ]]
end


local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
--    inst:Remove()
end


local function commonfn(colour)

    local onequip = function(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_woodbow", "swap_woodbow")
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

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "woodbow.tex" )
    
    inst:AddTag("bow")
    anim:SetBank("woodbow")
    anim:SetBuild("woodbow")
    anim:PlayAnimation("idle")
    -------   
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="woodbow"
    inst.components.inventoryitem.atlasname="images/inventoryimages/woodbow.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )


    
    return inst
end


---------COLOUR SPECIFIC CONSTRUCTIONS---------

local function red()
    local inst = commonfn("red")

    inst:AddTag("rangedfireweapon")

    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(BOW_DAMAGE)
    inst.components.weapon:SetRange(BOW_RANGE-2, BOW_RANGE)
    inst.components.weapon:SetOnAttack(onattack_red)
    inst.components.weapon:SetProjectile("fire_projectile")

    inst.components.finiteuses:SetMaxUses(BOW_USES)
    inst.components.finiteuses:SetUses(BOW_USES)

    inst:AddComponent("reloadable")
    inst.components.reloadable.ammotype="arrows"

    return inst
end



return Prefab("common/inventory/bow", red, assets, prefabs)