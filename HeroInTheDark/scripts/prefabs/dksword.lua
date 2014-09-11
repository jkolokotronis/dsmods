local assets=
{
    Asset("ANIM", "anim/fa_evilsword.zip"),
    
    Asset("ATLAS", "images/inventoryimages/evilsword.xml"),
    Asset("IMAGE", "images/inventoryimages/evilsword.tex"),
}

local DK_SWORD_LEECH=5
local DK_SWORD_DAMAGE=40

local function onattack(inst, attacker, target)
    if(attacker and attacker.components.health)then
        attacker.components.health:DoDelta(DK_SWORD_LEECH)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_evilsword", "swap_evilsword")
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
    minimap:SetIcon( "evilsword.tex" )

    inst.AnimState:SetBank("fa_evilsword")
    inst.AnimState:SetBuild("fa_evilsword")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("shadow")
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="evilsword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/evilsword.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/dksword", fn, assets) 
