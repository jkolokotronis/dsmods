local assets=
{
    Asset("ANIM", "anim/fa_lightningsword.zip"),
    
}


local LIGHTNINGSWORD_DAMAGE_T1=50
local LIGHTNINGSWORD_DAMAGE_T2=75
local LIGHTNINGSWORD_DAMAGE_T3=85
local LIGHTNINGSWORD_PROC_T1=0.05
local LIGHTNINGSWORD_PROC_T2=0.15
local LIGHTNINGSWORD_PROC_T3=0.30
local LIGHTNINGSWORD_LIGHT_PROC=50
local LIGHTNINGSWORD_USES_T1=150
local LIGHTNINGSWORD_USES_T2=250
local LIGHTNINGSWORD_USES_T3=375

local LIGHTNINGSWORD_STUN_DURATION=5

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function stunfx(inst,attacker,target)

        if(target.fa_stun)then
            if (target.fa_stun.components.spell.duration-target.fa_stun.components.spell.lifetime)>LIGHTNINGSWORD_STUN_DURATION then
                return
            else
                target.fa_stun.components.spell:OnFinish() 
            end
        end

        local inst=SpawnPrefab("fa_spinningstarsfx")
        inst.persists=false
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_lightningstun"
        inst.components.spell.duration = LIGHTNINGSWORD_STUN_DURATION
        inst.components.spell.ontargetfn = function(inst,target)
            local follower = inst.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0, -200, -0.0001 )
            target.fa_stun = inst
        end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_stun = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
end

local function onattack(inst, attacker, target)
    if(target.components.health:IsInvincible() == false and target.components.burnable and not target.components.fueled and math.random()<=inst.procRate)then
        if not(target:HasTag("fa_undead") or target:HasTag("fa_contruct") or target:HasTag("player")) then
            stunfx(inst,attacker,target)
        end
        local pos=Vector3(target.Transform:GetWorldPosition())
        local lightning = SpawnPrefab("lightning")
        lightning.Transform:SetPosition(pos:Get())

        target.components.combat:GetAttacked(attacker, LIGHTNINGSWORD_LIGHT_PROC, nil,nil,FA_DAMAGETYPE.ELECTRIC)
    end
end

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "fa_lightningsword", "swap_weapon")
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

    
    inst:AddTag("sharp")
    inst:AddTag("sword")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_lightningsword"
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
