local assets=
{
    Asset("ANIM", "anim/dagger.zip"),
    Asset("ANIM", "anim/swap_dagger.zip"),
    
    Asset("ATLAS", "images/inventoryimages/dagger.xml"),
    Asset("IMAGE", "images/inventoryimages/dagger.tex"),
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
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
  
    inst.AnimState:SetBank("dagger")
    inst.AnimState:SetBuild("dagger")
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "dagger.tex" )

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("sharp")
    inst:AddTag("dagger")

    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="dagger"
    inst.components.inventoryitem.atlasname="images/inventoryimages/dagger.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
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

return Prefab( "common/inventory/dagger", t1, assets),
    Prefab( "common/inventory/dagger2", t2, assets),
    Prefab( "common/inventory/dagger3", t3, assets) 
