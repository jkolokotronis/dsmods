local assets=
{
    Asset("ANIM", "anim/flamingsword.zip"),
    Asset("ANIM", "anim/swap_flamingsword.zip"),
    
    Asset("ATLAS", "images/inventoryimages/flamingsword.xml"),
    Asset("IMAGE", "images/inventoryimages/flamingsword.tex"),
}

local DK_SWORD_DAMAGE=40

local function onattack(inst, attacker, target)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_flamingsword", "swap_flamingsword")
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
  

    inst.AnimState:SetBank("flamingsword")
    inst.AnimState:SetBuild("flamingsword")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("shadow")
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="flamingsword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/flamingsword.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/flamingsword", fn, assets) 
