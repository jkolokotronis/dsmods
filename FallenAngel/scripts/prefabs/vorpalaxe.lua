local assets=
{
    Asset("ANIM", "anim/vorpalaxe.zip"),
    Asset("ANIM", "anim/swap_vorpalaxe.zip"),    
    Asset("ATLAS", "images/inventoryimages/vorpalaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/vorpalaxe.tex"),
}

local DK_SWORD_DAMAGE=30

local function onattack(inst, attacker, target)
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_vorpalaxe", "swap_vorpalaxe")
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
  
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "vorpalaxe.tex" )

    inst.AnimState:SetBank("vorpalaxe")
    inst.AnimState:SetBuild("vorpalaxe")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="vorpalaxe"
    inst.components.inventoryitem.atlasname="images/inventoryimages/vorpalaxe.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/vorpalaxe", fn, assets) 
