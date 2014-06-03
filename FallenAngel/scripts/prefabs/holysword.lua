local assets=
{
    Asset("ANIM", "anim/holysword.zip"),
    Asset("ANIM", "anim/swap_holysword.zip"),
    Asset("ATLAS", "images/inventoryimages/holysword.xml"),
    Asset("IMAGE", "images/inventoryimages/holysword.tex"),
    
}

local HOLY_SWORD_LEECH=5
local HOLY_SWORD_DAMAGE=40

local function onattack(inst, attacker, target)
    if(attacker and attacker.components.health)then
        attacker.components.sanity:DoDelta(HOLY_SWORD_LEECH)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_holysword", "swap_holysword")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
  
    inst:AddTag("irreplaceable")
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "holysword.tex" )

    inst.AnimState:SetBank("holysword")
    inst.AnimState:SetBuild("holysword")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetMultColour(2, 2, 1, 0.6)
    
    inst:AddTag("shadow")
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(HOLY_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="holysword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/holysword.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/holysword", fn, assets) 
