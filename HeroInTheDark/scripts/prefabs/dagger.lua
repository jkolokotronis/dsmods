local assets=
{
    Asset("ANIM", "anim/fa_dagger.zip"),
    Asset("ATLAS", "images/inventoryimages/dagger.xml"),
    Asset("IMAGE", "images/inventoryimages/dagger.tex"),
}
local assets_iron={
    Asset("ANIM", "anim/fa_irondagger.zip"),    
}
local assets_silver={
    Asset("ANIM", "anim/fa_silverdagger.zip"),
}
local assets_steel={
    Asset("ANIM", "anim/fa_steeldagger.zip"), 
}
local assets_copper={
    Asset("ANIM", "anim/fa_copperdagger.zip"),
}

local DAGGER_DAMAGE_T1=40
local DAGGER_DAMAGE_T2=50
local DAGGER_DAMAGE_T3=60
local DAGGER_PROC_T1=0.05
local DAGGER_PROC_T2=0.15
local DAGGER_PROC_T3=0.30
local DAGGER_USES_T1=100
local DAGGER_USES_T2=125
local DAGGER_USES_T3=150

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    --is there a way not to cause 2 hits here? i have no access to calcdamage from weapon and it's weapon proc not a damage mod...
     if(attacker:HasTag("player") and attacker.prefab=="thief" and target.components.combat  and math.random()<=inst.procRate) then
          target.components.combat:GetAttacked(attacker, inst.components.weapon.damage*2, nil)
     end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_dagger", "swap_dagger")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end
local function common()

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst:AddTag("sharp")
    inst:AddTag("dagger")
    inst:AddComponent("weapon")
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnUnequip( onunequip )

    return inst
end

local function fn(Sim)
    local inst=common()
  
    inst.AnimState:SetBank("fa_dagger")
    inst.AnimState:SetBuild("fa_dagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )

    inst.Transform:SetScale(2, 2, 1)
    
    inst.components.weapon:SetOnAttack(onattack)
    
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"

    
    inst.components.equippable:SetOnEquip( onequip )
    
    return inst
end

local function t1()
    local inst =fn()
    inst:AddTag("tier1")
    inst.procRate=DAGGER_PROC_T1
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T1)
    inst.components.finiteuses:SetUses(DAGGER_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=DAGGER_PROC_T2
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T2)
    inst.components.finiteuses:SetUses(DAGGER_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=DAGGER_PROC_T3
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T3)
    inst.components.finiteuses:SetUses(DAGGER_USES_T3)
    return inst
end

local function onequipcopper(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_copperdagger", "swap_dagger")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
local function copper()
    local inst=common()
  
    inst.AnimState:SetBank("fa_copperdagger")
    inst.AnimState:SetBuild("fa_copperdagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
    inst.components.equippable:SetOnEquip( onequipcopper )

    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T1)
    inst.components.finiteuses:SetUses(DAGGER_USES_T1)
    return inst
end

local function onequipiron(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_irondagger", "swap_dagger")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
local function iron()
    local inst=common()
  
    inst.AnimState:SetBank("fa_irondagger")
    inst.AnimState:SetBuild("fa_irondagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
    inst.components.equippable:SetOnEquip( onequipiron )

    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T2)
    inst.components.finiteuses:SetUses(DAGGER_USES_T2)
    return inst
end

local function onequipsteel(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_steeldagger", "swap_dagger")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
local function steel()
    local inst=common()
  
    inst.AnimState:SetBank("fa_steeldagger")
    inst.AnimState:SetBuild("fa_steeldagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
    inst.components.equippable:SetOnEquip( onequipsteel )

    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T3)
    inst.components.finiteuses:SetUses(DAGGER_USES_T3)
    return inst
end

local function onequipsilver(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_silverdagger", "swap_dagger")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
end
local function silver()
    local inst=common()
  
    inst.AnimState:SetBank("fa_silverdagger")
    inst.AnimState:SetBuild("fa_silverdagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
    inst.components.equippable:SetOnEquip( onequipsilver )

    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T2)
    inst.components.finiteuses:SetUses(DAGGER_USES_T2)
    return inst
end

return Prefab( "common/inventory/dagger", t1, assets),
    Prefab( "common/inventory/dagger2", t2, assets),
    Prefab( "common/inventory/dagger3", t3, assets),
    Prefab( "common/inventory/fa_copperdagger",copper, assets_copper),
    Prefab( "common/inventory/fa_steeldagger",steel, assets_steel),
    Prefab( "common/inventory/fa_irondagger", iron, assets_iron),
    Prefab( "common/inventory/fa_silverdagger", silver, assets_silver)