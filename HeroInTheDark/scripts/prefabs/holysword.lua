local assets=
{
    Asset("ANIM", "anim/fa_holysword.zip"),
}
local assets2=
{
    Asset("ANIM", "anim/fa_holysword2.zip"),
    
}
local assets3=
{
    Asset("ANIM", "anim/fa_holysword3.zip"),
    
}

local HOLY_SWORD_LEECH=5
local HOLY_SWORD_DAMAGE=40
local HOLY_SWORD_DAMAGE_2=50
local HOLY_SWORD_DAMAGE_3=70

local function onattack(inst, attacker, target)
    if(attacker and attacker.components.health)then
        attacker.components.sanity:DoDelta(HOLY_SWORD_LEECH)
    end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(name)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
  
    inst:AddTag("irreplaceable")
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "fa_holysword.tex" )

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("shadow")
    inst:AddTag("sharp")
    inst:AddTag("sword")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(HOLY_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_holysword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    
    inst:AddComponent("equippable")
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", name, "swap_weapon")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function base()
    local inst=fn("fa_holysword")
    return inst
end
local function up2()
    local inst=fn("fa_holysword2")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE_2)
    return inst
end

local function up3()
    local inst=fn("fa_holysword3")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE_3)
    return inst
end

return Prefab( "common/inventory/holysword", base, assets),
Prefab( "common/inventory/fa_holysword2", up2, assets2),
Prefab( "common/inventory/fa_holysword3", up3, assets3)
