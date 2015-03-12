local assets=
{
    Asset("ANIM", "anim/fa_flamingsword.zip"),
}


local FLAMINGSWORD_DAMAGE_T1=50
local FLAMINGSWORD_DAMAGE_T2=70
local FLAMINGSWORD_DAMAGE_T3=85
local FLAMINGSWORD_PROC_T1=0.05
local FLAMINGSWORD_PROC_T2=0.15
local FLAMINGSWORD_PROC_T3=0.30
local FLAMINGSWORD_FIRE_PROC=50
local FLAMINGSWORD_USES_T1=150
local FLAMINGSWORD_USES_T2=250
local FLAMINGSWORD_USES_T3=375

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    if(target.components.health:IsInvincible() == false and target.components.burnable and not target.components.fueled and math.random()<=inst.procRate)then
        target.components.burnable:Ignite()
        target.components.combat:GetAttacked(attacker, FLAMINGSWORD_FIRE_PROC, nil,nil,FA_DAMAGETYPE.FIRE)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_flamingsword", "swap_weapon")
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
    minimap:SetIcon( "fa_flamingsword.tex" )
  
    inst.AnimState:SetBank("fa_flamingsword")
    inst.AnimState:SetBuild("fa_flamingsword")
    inst.AnimState:PlayAnimation("idle")

    
    inst:AddTag("sharp")
    inst:AddTag("sword")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_flamingsword"
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
    inst.procRate=FLAMINGSWORD_PROC_T1
    inst.components.weapon:SetDamage(FLAMINGSWORD_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(FLAMINGSWORD_USES_T1)
    inst.components.finiteuses:SetUses(FLAMINGSWORD_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=FLAMINGSWORD_PROC_T2
    inst.components.weapon:SetDamage(FLAMINGSWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(FLAMINGSWORD_USES_T2)
    inst.components.finiteuses:SetUses(FLAMINGSWORD_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=FLAMINGSWORD_PROC_T3
    inst.components.weapon:SetDamage(FLAMINGSWORD_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(FLAMINGSWORD_USES_T3)
    inst.components.finiteuses:SetUses(FLAMINGSWORD_USES_T3)
    return inst
end

return Prefab( "common/inventory/fa_flamingsword", t1, assets),
Prefab( "common/inventory/fa_flamingsword2", t2, assets),
Prefab( "common/inventory/fa_flamingsword3", t3, assets) 
