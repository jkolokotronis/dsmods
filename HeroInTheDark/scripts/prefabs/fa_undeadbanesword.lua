local assets=
{
    Asset("ANIM", "anim/fa_undeadbanesword.zip"),
}


local UBSWORD_DAMAGE_T1=55
local UBSWORD_DAMAGE_T2=65
local UBSWORD_DAMAGE_T3=75
local UBSWORD_UNDEAD_DAMAGE_T1=10
local UBSWORD_UNDEAD_DAMAGE_T2=10
local UBSWORD_UNDEAD_DAMAGE_T3=15
local UBSWORD_PROC_T1=0.05
local UBSWORD_PROC_T2=0.10
local UBSWORD_PROC_T3=0.20
local UBSWORD_USES_T1=50
local UBSWORD_USES_T2=100
local UBSWORD_USES_T3=150

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    if(target:HasTag("undead") and target.components.combat ) then
          target.components.combat:GetAttacked(attacker, UBSWORD_UNDEAD_DAMAGE_T1, nil,nil,FA_DAMAGETYPE.HOLY)
          if( math.random()<=inst.procRate)then
            target.components.health:Kill()
          end
     end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_undeadbanesword", "swap_weapon")
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
  
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "fa_undeadbanesword.tex" )

    inst.AnimState:SetBank("fa_undeadbanesword")
    inst.AnimState:SetBuild("fa_undeadbanesword")
    inst.AnimState:PlayAnimation("idle")

--    inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("sharp")
    inst:AddTag("sword")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_undeadbanesword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
--    inst:AddComponent("dapperness")
--    inst.components.dapperness.dapperness = TUNING.CRAZINESS_MED,
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function t1()
    local inst =fn()
    inst:AddTag("tier1")
    inst.procRate=UBSWORD_PROC_T1
    inst.components.weapon:SetDamage(UBSWORD_UNDEAD_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(UBSWORD_USES_T1)
    inst.components.finiteuses:SetUses(UBSWORD_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=UBSWORD_PROC_T2
    inst.components.weapon:SetDamage(UBSWORD_UNDEAD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(UBSWORD_USES_T2)
    inst.components.finiteuses:SetUses(UBSWORD_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=UBSWORD_PROC_T3
    inst.components.weapon:SetDamage(UBSWORD_UNDEAD_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(UBSWORD_USES_T3)
    inst.components.finiteuses:SetUses(UBSWORD_USES_T3)
    return inst
end
return Prefab( "common/inventory/fa_undeadbanesword", t1, assets),
    Prefab( "common/inventory/fa_undeadbanesword2", t2, assets),
    Prefab( "common/inventory/fa_undeadbanesword3", t3, assets) 
