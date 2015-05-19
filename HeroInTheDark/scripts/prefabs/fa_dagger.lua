local assets=
{
    Asset("ANIM", "anim/fa_dagger.zip"),
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
local assets_adamantine={
    Asset("ANIM", "anim/fa_adamantinedagger.zip"), 
}
local assets_copper={
    Asset("ANIM", "anim/fa_copperdagger.zip"),
}
local assets_venom1={
    Asset("ANIM", "anim/fa_venomdagger1.zip"),
}
local assets_venom2={
    Asset("ANIM", "anim/fa_venomdagger2.zip"),
}
local assets_venom3={
    Asset("ANIM", "anim/fa_venomdagger3.zip"),
}

local FA_BuffUtil=require "buffutil"

local DAGGER_DAMAGE_T1=45
local DAGGER_DAMAGE_T2=55
local DAGGER_DAMAGE_T3=70
local DAGGER_PROC_T1=0.05
local DAGGER_PROC_T2=0.15
local DAGGER_PROC_T3=0.30

local DAGGER_USES_T1=150
local DAGGER_USES_T2=250
local DAGGER_USES_T3=375

local DAGGER_USES_COPPER=115
local DAGGER_USES_IRON=225
local DAGGER_USES_STEEL=350

local DAGGER_DAMAGE_ADAMANTINE=105
local DAGGER_USE_ADAMANTINE=1000

local POISON_PERIOD=5
local POISON_LENGTH=25
local POISON_DAMAGE = 50
local POISON_TIC=10

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
    owner.AnimState:OverrideSymbol("swap_object", "fa_dagger", "swap_weapon")
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal") 
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

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( name..".tex" )

    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("sharp")
    inst:AddTag("dagger")
    inst:AddComponent("weapon")
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=name
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_object", name, "swap_weapon")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end)
    inst.components.equippable:SetOnUnequip( onunequip )
    return inst
end

local function fn(Sim)
    local inst=common("fa_dagger")

    
    inst.components.weapon:SetOnAttack(onattack)
    return inst
end

local function t1()
    local inst =fn()
    inst.Transform:SetScale(2, 2, 1)
    inst:AddTag("tier1")
    inst.procRate=DAGGER_PROC_T1
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T1)
    inst.components.finiteuses:SetUses(DAGGER_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst.Transform:SetScale(2, 2, 1)
    inst:AddTag("tier2")
    inst.procRate=DAGGER_PROC_T2
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T2)
    inst.components.finiteuses:SetUses(DAGGER_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst.Transform:SetScale(2, 2, 1)
    inst:AddTag("tier3")
    inst.procRate=DAGGER_PROC_T3
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T3)
    inst.components.finiteuses:SetUses(DAGGER_USES_T3)
    return inst
end

local function copper()
    local inst=common("fa_copperdagger")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_COPPER)
    inst.components.finiteuses:SetUses(DAGGER_USES_COPPER)
    return inst
end

local function iron()
    local inst=common("fa_irondagger")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_IRON)
    inst.components.finiteuses:SetUses(DAGGER_USES_IRON)
    return inst
end

local function steel()
    local inst=common("fa_steeldagger")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_STEEL)
    inst.components.finiteuses:SetUses(DAGGER_USES_STEEL)
    return inst
end

local function adamantine()
    local inst=common("fa_adamantinedagger")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_ADAMANTINE)
    inst.components.finiteuses:SetMaxUses(DAGGER_USE_ADAMANTINE)
    inst.components.finiteuses:SetUses(DAGGER_USE_ADAMANTINE)
    return inst
end
local function silver()
    local inst=common("fa_silverdagger")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_IRON)
    inst.components.finiteuses:SetUses(DAGGER_USES_IRON)
    return inst
end

local function onattackvenom(inst, attacker, target)
    if( math.random()<=inst.procRate)then
        local variables={}
        variables.strength=POISON_TIC
        variables.period=POISON_PERIOD
        if(target and target.components.fa_bufftimers)then
            target.components.fa_bufftimers:AddBuff("poison","Poison","Poison",POISON_LENGTH,variables)
        else
            FA_BuffUtil.Poison(target,POISON_LENGTH,variables,attacker)
        end
        target.components.combat:GetAttacked(attacker, POISON_DAMAGE, nil,nil,FA_DAMAGETYPE.POISON)

     end
 end

local function venom1()
    local inst=common("fa_venomdagger1")

    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T1)
    inst.components.finiteuses:SetUses(DAGGER_USES_T1)
    inst.procRate=DAGGER_PROC_T1
    inst.components.weapon:SetOnAttack(onattackvenom)
    return inst
end

local function venom2()
    local inst=common("fa_venomdagger2")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T2)
    inst.components.finiteuses:SetUses(DAGGER_USES_T2)
    inst.procRate=DAGGER_PROC_T2
    inst.components.weapon:SetOnAttack(onattackvenom)
    return inst
end

local function venom3()
    local inst=common("fa_venomdagger3")
    inst.components.weapon:SetDamage(DAGGER_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(DAGGER_USES_T3)
    inst.components.finiteuses:SetUses(DAGGER_USES_T3)
    inst.procRate=DAGGER_PROC_T3
    inst.components.weapon:SetOnAttack(onattackvenom)
    return inst
end


return Prefab( "common/inventory/fa_dagger", t1, assets),
    Prefab( "common/inventory/fa_dagger2", t2, assets),
    Prefab( "common/inventory/fa_dagger3", t3, assets),
    Prefab( "common/inventory/fa_copperdagger",copper, assets_copper),
    Prefab( "common/inventory/fa_steeldagger",steel, assets_steel),
    Prefab( "common/inventory/fa_adamantinedagger",adamantine, assets_adamantine),
    Prefab( "common/inventory/fa_irondagger", iron, assets_iron),
    Prefab( "common/inventory/fa_silverdagger", silver, assets_silver),
    Prefab( "common/inventory/fa_venomdagger1",venom1, assets_venom1),
    Prefab( "common/inventory/fa_venomdagger2",venom2, assets_venom2),
    Prefab( "common/inventory/fa_venomdagger3", venom3, assets_venom3)