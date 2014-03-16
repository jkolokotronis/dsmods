local assets=
{
    Asset("ANIM", "anim/dagger.zip"),
    Asset("ANIM", "anim/swap_dagger.zip"),
    
    Asset("ATLAS", "images/inventoryimages/dagger.xml"),
    Asset("IMAGE", "images/inventoryimages/dagger.tex"),
}

local DAGGER_DAMAGE=30

local function onattack(inst, attacker, target)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_dagger", "swap_dagger")
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
  
    inst.AnimState:SetBank("dagger")
    inst.AnimState:SetBuild("dagger")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/dagger", fn, assets) 
