
local assets_ironsword={
    Asset("ANIM", "anim/fa_ironsword.zip"),    
    Asset("ATLAS", "images/inventoryimages/fa_ironsword.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_ironsword.tex"),
}
local assets_silversword={
    Asset("ANIM", "anim/fa_silversword.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_silversword.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_silversword.tex"),
}
local assets_steelsword={
    Asset("ANIM", "anim/fa_steelsword.zip"), 
    Asset("ATLAS", "images/inventoryimages/fa_steelsword.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_steelsword.tex"),
}
local assets_coppersword={
    Asset("ANIM", "anim/fa_coppersword.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_coppersword.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_coppersword.tex"),
}

local assets_ironaxe={
    Asset("ANIM", "anim/fa_ironaxe.zip"),    
    Asset("ATLAS", "images/inventoryimages/fa_ironaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_ironaxe.tex"),
}
local assets_silveraxe={
    Asset("ANIM", "anim/fa_silveraxe.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_silveraxe.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_silveraxe.tex"),
}
local assets_steelaxe={
    Asset("ANIM", "anim/fa_steelaxe.zip"), 
    Asset("ATLAS", "images/inventoryimages/fa_steelaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_steelaxe.tex"),
}
local assets_copperaxe={
    Asset("ANIM", "anim/fa_copperaxe.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_copperaxe.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_copperaxe.tex"),
}

local AXE_DAMAGE_T1=55
local AXE_DAMAGE_T2=75
local AXE_DAMAGE_T3=90
local AXE_USES_T1=115
local AXE_USES_T2=225
local AXE_USES_T3=350
local SWORD_DAMAGE_T1=50
local SWORD_DAMAGE_T2=70
local SWORD_DAMAGE_T3=85
local SWORD_USES_T1=115
local SWORD_USES_T2=225
local SWORD_USES_T3=350


local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end


local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function common(name)

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst:AddTag("sharp")
    inst:AddComponent("weapon")
    inst:AddComponent("inspectable")
    
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    --local minimap = inst.entity:AddMiniMapEntity()
    --minimap:SetIcon( "dagger.tex" )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=name
    inst.components.inventoryitem.atlasname="images/inventoryimages/"..name..".xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnUnequip( onunequip )
    inst.components.equippable:SetOnEquip(function(inst,owner)
    	owner.AnimState:OverrideSymbol("swap_object", name, "swap_weapon")
    	owner.AnimState:Show("ARM_carry") 
	    owner.AnimState:Hide("ARM_normal") 
    end)
    return inst
end

local function coppersword()
    local inst=common("fa_coppersword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T1)
    inst.components.finiteuses:SetUses(SWORD_USES_T1)
    return inst
end
local function steelsword()
    local inst=common("fa_steelsword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T3)
    inst.components.finiteuses:SetUses(SWORD_USES_T3)
    return inst
end
local function ironsword()
    local inst=common("fa_ironsword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T2)
    inst.components.finiteuses:SetUses(SWORD_USES_T2)
    return inst
end
local function silversword()
    local inst=common("fa_silversword")

    inst:AddTag("fa_silver")
    inst.components.weapon:SetDamage(SWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T2)
    inst.components.finiteuses:SetUses(SWORD_USES_T2)
    return inst
end
local function copperaxe()
    local inst=common("fa_copperaxe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T1)
    inst.components.finiteuses:SetUses(AXE_USES_T1)
    return inst
end
local function steelaxe()
    local inst=common("fa_steelaxe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T3)
    inst.components.finiteuses:SetUses(AXE_USES_T3)
    return inst
end
local function ironaxe()
    local inst=common("fa_ironaxe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end
local function silveraxe()
    local inst=common("fa_silveraxe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end

return
    Prefab( "common/inventory/fa_coppersword",coppersword, assets_coppersword),
    Prefab( "common/inventory/fa_steelsword",steelsword, assets_steelsword),
    Prefab( "common/inventory/fa_ironsword", ironsword, assets_ironsword),
    Prefab( "common/inventory/fa_silversword", silversword, assets_silversword),
    Prefab( "common/inventory/fa_copperaxe",copperaxe, assets_copperaxe),
    Prefab( "common/inventory/fa_steelaxe",steelaxe, assets_steelaxe),
    Prefab( "common/inventory/fa_ironaxe", ironaxe, assets_ironaxe),
    Prefab( "common/inventory/fa_silveraxe", silveraxe, assets_silveraxe)