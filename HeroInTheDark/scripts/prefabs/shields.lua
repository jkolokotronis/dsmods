local assets=
{
  Asset("ANIM", "anim/swap_marbleshield.zip"),
  Asset("ANIM", "anim/swap_rockshield.zip"),
}

local boneshield_assets={
  Asset("ANIM", "anim/fa_boneshield.zip"),
}
local woodenshield_assets={
  Asset("ANIM", "anim/fa_woodenshield.zip"),
}
local coppershield_assets={
  Asset("ANIM", "anim/fa_coppershield.zip"),
}
local ironshield_assets={
  Asset("ANIM", "anim/fa_ironshield.zip"),
}
local silvershield_assets={
  Asset("ANIM", "anim/fa_silvershield.zip"),
}
local goldshield_assets={
  Asset("ANIM", "anim/fa_goldshield.zip"),
}
local steelshield_assets={
  Asset("ANIM", "anim/fa_steelshield.zip"),
}
local adamantshield_assets={
  Asset("ANIM", "anim/fa_adamantineshield.zip"),
}
local reflectshield_assets={
  Asset("ANIM", "anim/fa_reflectshield.zip"),
}
--[[
local function boneonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_boneshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_boneshield", "swap_body")
end
local function marbleonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_marbleshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_marbleshield", "swap_body")
end
local function rockonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_rockshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_rockshield", "swap_body")
end

local function wdonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_woodshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_woodshield", "swap_body")
end

local function reflectonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_reflectshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_reflectshield", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
end
]]


local ROCK_SHIELD_ABSO=0.20
local ROCK_SHIELD_DURA=200

local MARBLE_SHIELD_ABSO=0.40
local MARBLE_SHIELD_DURA=400

local WOOD_SHIELD_ABSO=0.10
local WOOD_SHIELD_DURA=100
local COPPER_SHIELD_ABSO=0.30
local COPPER_SHIELD_DURA=200
local IRON_SHIELD_ABSO=0.50
local IRON_SHIELD_DURA=600
local GOLD_SHIELD_ABSO=0.40
local GOLD_SHIELD_DURA=500
local SILVER_SHIELD_ABSO=0.40
local SILVER_SHIELD_DURA=500
local STEEL_SHIELD_ABSO=0.80
local STEEL_SHIELD_DURA=1000
local ADAMANT_SHIELD_ABSO=0.95
local ADAMANT_SHIELD_DURA=3000
local BONE_SHIELD_ABSO=0.20
local BONE_SHIELD_DURA=200
local BONE_FEAR_CHANCE=0.2
local FEAR_DURATION=10
local REFLECT_SHIELD_ABSO=0.20
local REFLECT_SHIELD_DURA=400

local SHIELD_WALKMULT=0.95
-- this is dumb but so are the changes
if(FA_SWACCESS or FA_PORKACCESS)then
    SHIELD_WALKMULT=SHIELD_WALKMULT-1
end


local function fn(name)
  local inst = CreateEntity()
    
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  MakeInventoryPhysics(inst)
  local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( name..".tex" )
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

  inst:AddComponent("inventoryitem")
  inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
  inst.components.inventoryitem.imagename=name
  inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"

  inst:AddComponent("equippable")
  function inst.components.equippable:CollectInventoryActions(doer, actions)
    if not self.isequipped then
      if not(doer:HasTag("player")) or (doer:HasTag("fa_shielduser"))then
        table.insert(actions, ACTIONS.EQUIP)
      end
    else
        table.insert(actions, ACTIONS.UNEQUIP)
    end
  end

--[[  
  check done in inv calls, this was too late
  local old_equip=inst.components.equippable.Equip
  function inst.components.equippable:Equip(owner, slot)
    if not(owner:HasTag("player")) or (owner:HasTag("fa_shielduser"))then
      old_equip(self,owner,slot)
    end
  end
]]

  inst.components.equippable.fa_canequip=function(owner)
    return not(owner:HasTag("player")) or (owner:HasTag("fa_shielduser"))
  end
  
      inst.components.equippable.equipslot = EQUIPSLOTS.PACK
  
  inst:AddTag("shield")    
--    inst.components.equippable:SetOnUnequip( onunequip )
    inst:AddComponent("armor")
    inst:AddComponent("inspectable")
    
    return inst
end



local function MakeRockShield()
    local inst=fn("fa_rockshield")
    inst.AnimState:SetBank("swap_rockshield")
    inst.AnimState:SetBuild("swap_rockshield")
    inst.AnimState:PlayAnimation("anim")
    inst.components.armor:InitCondition(ROCK_SHIELD_DURA, ROCK_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
--    inst.components.equippable:SetOnEquip( rockonequip )
    return inst
end

local function MakeMarbleShield()
    local inst=fn("fa_marbleshield")
    inst.AnimState:SetBank("swap_marbleshield")
    inst.AnimState:SetBuild("swap_marbleshield")
    inst.AnimState:PlayAnimation("anim")
    inst.components.armor:InitCondition(MARBLE_SHIELD_DURA, MARBLE_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
--    inst.components.equippable:SetOnEquip( marbleonequip )
    return inst
end

local function MakeWoodenShield()
    local inst=fn("fa_woodenshield")

    inst:AddTag("wood")
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

--    inst.components.equippable:SetOnEquip( wdonequip )
    inst.components.armor:InitCondition(WOOD_SHIELD_DURA, WOOD_SHIELD_ABSO )
    return inst
end

local function MakeCopperShield()
    local inst=fn("fa_coppershield")
    inst.components.armor:InitCondition(COPPER_SHIELD_DURA, COPPER_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.3
    return inst
end
local function MakeIronShield()
    local inst=fn("fa_ironshield")
    inst.components.armor:InitCondition(IRON_SHIELD_DURA, IRON_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.5
    return inst
end
local function MakeSilverShield()
    local inst=fn("fa_silvershield")
    inst.components.armor:InitCondition(SILVER_SHIELD_DURA, SILVER_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.5
    return inst
end
local function MakeGoldShield()
    local inst=fn("fa_goldshield")
    inst.components.armor:InitCondition(GOLD_SHIELD_DURA, GOLD_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.5
    return inst
end
local function MakeSteelShield()
    local inst=fn("fa_steelshield")
    inst.components.armor:InitCondition(STEEL_SHIELD_DURA, STEEL_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.7
    return inst
end
local function MakeAdamantShield()
    local inst=fn("fa_adamantineshield")
    inst.components.armor:InitCondition(ADAMANT_SHIELD_DURA,ADAMANT_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.95
    return inst
end

local function OnBoneBlocked(owner,data) 
    if(data and data.attacker and math.random()<=BONE_FEAR_CHANCE)then
        local target=data.attacker
        if(target.fa_fear)then target.fa_fear.components.spell:OnFinish() end
        
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_fear"
        inst.components.spell.duration = FEAR_DURATION
        inst.components.spell.ontargetfn = function(inst,target)
            target.fa_fear = inst
        end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_fear = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true
        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end

end

local function onboneequip(inst, owner) 
    inst:ListenForEvent("attacked",OnBoneBlocked,owner)
    inst:ListenForEvent("blocked",OnBoneBlocked, owner)
end


local function onboneunequip(inst, owner) 
    inst:RemoveEventCallback("blocked", OnBoneBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBoneBlocked, owner)
end

local function MakeBoneShield()
    local inst=fn("fa_boneshield")
    inst.components.armor:InitCondition(BONE_SHIELD_DURA, BONE_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
    inst.components.armor.fa_stunresistance=0.4
    inst.components.equippable:SetOnUnequip( onboneunequip )
    inst.components.equippable:SetOnEquip(onboneequip)
    return inst
end

local function MakeReflectShield()
    local inst=fn("fa_reflectshield")
    inst.components.armor.fa_stunresistance=0.4
    inst.components.armor.fa_spellreflect=1
    inst.components.armor.fa_spellreflectdrain=20
    inst.components.armor:InitCondition(REFLECT_SHIELD_DURA, REFLECT_SHIELD_ABSO )
    inst.components.equippable.walkspeedmult = SHIELD_WALKMULT
--    inst.components.equippable:SetOnEquip( reflectonequip )
    return inst
end

return Prefab( "common/inventory/fa_woodenshield", MakeWoodenShield, woodenshield_assets), 
        Prefab( "common/inventory/fa_rockshield", MakeRockShield, assets), 
        Prefab( "common/inventory/fa_marbleshield", MakeMarbleShield, assets), 
        Prefab( "common/inventory/fa_boneshield", MakeBoneShield, boneshield_assets),
        Prefab( "common/inventory/fa_reflectshield", MakeReflectShield, reflectshield_assets),
        Prefab( "common/inventory/fa_coppershield", MakeCopperShield, coppershield_assets),
        Prefab( "common/inventory/fa_ironshield", MakeIronShield, ironshield_assets),
        Prefab( "common/inventory/fa_silvershield", MakeSilverShield, silvershield_assets),
        Prefab( "common/inventory/fa_goldshield", MakeGoldShield, goldshield_assets),
        Prefab( "common/inventory/fa_steelshield", MakeSteelShield, steelshield_assets),
        Prefab( "common/inventory/fa_adamantineshield", MakeAdamantShield, adamantshield_assets)
