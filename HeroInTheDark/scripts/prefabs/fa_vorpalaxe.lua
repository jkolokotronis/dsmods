local assets=
{
    Asset("ANIM", "anim/fa_vorpalaxe.zip"),
}

local VORPALAXE_DAMAGE_T1=55
local VORPALAXE_DAMAGE_T2=75
local VORPALAXE_DAMAGE_T3=90
local VORPALAXE_PROC_T1=0.03
local VORPALAXE_PROC_T2=0.07
local VORPALAXE_PROC_T3=0.12
local VORPALAXE_USES_T1=150
local VORPALAXE_USES_T2=250
local VORPALAXE_USES_T3=375

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function onattack(inst, attacker, target)
    local rng=math.random()
    if(target and (not target:HasTag("epic")) and target.components.health and target.components.combat  and math.random()<=inst.procRate) then
          target.components.health:Kill()
          attacker:PushEvent("killed", {victim = target})
          if target.onkilledbyother then
              target.onkilledbyother(target.inst, attacker)
          end
     end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_vorpalaxe", "swap_weapon")
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
    minimap:SetIcon( "fa_vorpalaxe.tex" )

    inst.AnimState:SetBank("fa_vorpalaxe")
    inst.AnimState:SetBuild("fa_vorpalaxe")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddTag("sharp")
    inst:AddTag("axe")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_vorpalaxe"
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
    inst.procRate=VORPALAXE_PROC_T1
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T1)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T1)
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=VORPALAXE_PROC_T2
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T2)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T2)
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=VORPALAXE_PROC_T3
    inst.components.weapon:SetDamage(VORPALAXE_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(VORPALAXE_USES_T3)
    inst.components.finiteuses:SetUses(VORPALAXE_USES_T3)
    return inst
end
return Prefab( "common/inventory/fa_vorpalaxe", t1, assets),
    Prefab( "common/inventory/fa_vorpalaxe2", t2, assets),
    Prefab( "common/inventory/fa_vorpalaxe3", t3, assets)
