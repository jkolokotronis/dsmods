local assets=
{
    Asset("ANIM", "anim/fa_lightningsword.zip"),
    Asset("ANIM", "anim/swap_fa_lightningsword.zip"),
    
    Asset("ATLAS", "images/inventoryimages/fa_lightningsword.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_lightningsword.tex"),
}


local LIGHTNINGSWORD_DAMAGE_T1=55
local LIGHTNINGSWORD_DAMAGE_T2=65
local LIGHTNINGSWORD_DAMAGE_T3=80
local LIGHTNINGSWORD_PROC_T1=0.05
local LIGHTNINGSWORD_PROC_T2=0.15
local LIGHTNINGSWORD_PROC_T3=0.30
local LIGHTNINGSWORD_LIGHT_PROC=100
local LIGHTNINGSWORD_USES_T1=50
local LIGHTNINGSWORD_USES_T2=100
local LIGHTNINGSWORD_USES_T3=150

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    if(target.components.health:IsInvincible() == false and target.components.burnable and not target.components.fueled and math.random()<=inst.procRate)then
        target.components.burnable:Ignite()
        target.components.combat:GetAttacked(attacker, LIGHTNINGSWORD_LIGHT_PROC, nil,FA_DAMAGETYPE.ELECTRIC)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_fa_lightningsword", "swap_fa_lightningsword")
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
    minimap:SetIcon( "fa_lightningsword.tex" )
  
    inst.AnimState:SetBank("fa_lightningsword")
    inst.AnimState:SetBuild("fa_lightningsword")
    inst.AnimState:PlayAnimation("idle")

    inst.Transform:SetScale(2, 2, 1)
    
    inst:AddTag("sharp")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_lightningsword"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_lightningsword.xml"
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
    inst.procRate=LIGHTNINGSWORD_PROC_T1
    inst.components.weapon:SetDamage(LIGHTNINGSWORD_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(LIGHTNINGSWORD_USES_T1)
    inst.components.finiteuses:SetUses(LIGHTNINGSWORD_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=LIGHTNINGSWORD_PROC_T2
    inst.components.weapon:SetDamage(LIGHTNINGSWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(LIGHTNINGSWORD_USES_T2)
    inst.components.finiteuses:SetUses(LIGHTNINGSWORD_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=LIGHTNINGSWORD_PROC_T3
    inst.components.weapon:SetDamage(LIGHTNINGSWORD_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(LIGHTNINGSWORD_USES_T3)
    inst.components.finiteuses:SetUses(LIGHTNINGSWORD_USES_T3)
    return inst
end

return Prefab( "common/inventory/fa_lightningsword", t1, assets),
Prefab( "common/inventory/fa_lightningsword2", t2, assets),
Prefab( "common/inventory/fa_lightningsword3", t3, assets) 
