local assets=
{
    Asset("ANIM", "anim/undeadbanesword.zip"),
    Asset("ANIM", "anim/swap_undeadbanesword.zip"),    
    Asset("ATLAS", "images/inventoryimages/undeadbanesword.xml"),
    Asset("IMAGE", "images/inventoryimages/undeadbanesword.tex"),
}

local DK_SWORD_DAMAGE=40

local function onattack(inst, attacker, target)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_undeadbanesword", "swap_undeadbanesword")
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
    MakeInventoryPhysics(inst)
  
    inst:AddTag("irreplaceable")
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "lucy_axe.png" )

    inst.AnimState:SetBank("undeadbanesword")
    inst.AnimState:SetBuild("undeadbanesword")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
--    inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="undeadbanesword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/undeadbanesword.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/undeadbanesword", fn, assets) 
