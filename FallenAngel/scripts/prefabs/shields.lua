local assets=
{
  Asset("ANIM", "anim/swap_boneshield.zip"),
  Asset("ANIM", "anim/swap_marbleshield.zip"),
  Asset("ANIM", "anim/swap_rockshield.zip"),
  Asset("ANIM", "anim/swap_woodshield.zip"),
  Asset("ANIM", "anim/swap_reflectshield.zip"),


}

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

local WOOD_SHIELD_ABSO=0.10
local WOOD_SHIELD_DURA=100

local ROCK_SHIELD_ABSO=0.20
local ROCK_SHIELD_DURA=200

local MARBLE_SHIELD_ABSO=0.40
local MARBLE_SHIELD_DURA=400

local BONE_SHIELD_ABSO=0.20
local BONE_SHIELD_DURA=200

local REFLECT_SHIELD_ABSO=0.20
local REFLECT_SHIELD_DURA=200

local function fn()
  local inst = CreateEntity()
    
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
  MakeInventoryPhysics(inst)

  inst:AddComponent("inventoryitem")
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
  
  if EQUIPSLOTS["BACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.BACK
  elseif EQUIPSLOTS["PACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.PACK
  else
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
  end    

  inst:AddTag("shield")    
    inst.components.equippable:SetOnUnequip( onunequip )
    inst:AddComponent("armor")
    inst:AddComponent("inspectable")
    
    return inst
end


local function MakeWoodenShield()
    local inst=fn()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "woodshield.tex" )
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_woodshield")
    inst.AnimState:PlayAnimation("anim")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/woodshield.xml"
    inst.components.inventoryitem.imagename="woodshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"

    inst:AddTag("wood")
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.SMALL_FUEL

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "WOOD"
    inst.components.edible.woodiness = 5

    MakeSmallBurnable(inst, TUNING.SMALL_BURNTIME)
    MakeSmallPropagator(inst)

    inst.components.equippable:SetOnEquip( wdonequip )
    
    inst.components.armor:InitCondition(WOOD_SHIELD_DURA, WOOD_SHIELD_ABSO )
    return inst
end

local function MakeRockShield()
    local inst=fn()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "rockshield.tex" )
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_rockshield")
    inst.AnimState:PlayAnimation("anim")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/rockshield.xml"
    inst.components.inventoryitem.imagename="rockshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(ROCK_SHIELD_DURA, ROCK_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( rockonequip )
    return inst
end

local function MakeMarbleShield()
    local inst=fn()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "marbleshield.tex" )
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_marbleshield")
    inst.AnimState:PlayAnimation("anim")
    
    inst.components.inventoryitem.atlasname = "images/inventoryimages/marbleshield.xml"
    inst.components.inventoryitem.imagename="marbleshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(MARBLE_SHIELD_DURA, MARBLE_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( marbleonequip )
    return inst
end

local function MakeBoneShield()
    local inst=fn()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "boneshield.tex" )
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_boneshield")
    inst.AnimState:PlayAnimation("anim")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/boneshield.xml"
    inst.components.inventoryitem.imagename="boneshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(BONE_SHIELD_DURA, BONE_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( boneonequip )
    return inst
end

local function MakeReflectShield()
    local inst=fn()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "reflectshield.tex" )
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_reflectshield")
    inst.AnimState:PlayAnimation("anim")

    
    inst.components.inventoryitem.atlasname = "images/inventoryimages/reflectshield.xml"
    inst.components.inventoryitem.imagename="reflectshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(REFLECT_SHIELD_DURA, REFLECT_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( reflectonequip )
    return inst
end

return Prefab( "common/inventory/woodenshield", MakeWoodenShield, assets), 
        Prefab( "common/inventory/rockshield", MakeRockShield, assets), 
        Prefab( "common/inventory/marbleshield", MakeMarbleShield, assets), 
        Prefab( "common/inventory/boneshield", MakeBoneShield, assets),
        Prefab( "common/inventory/reflectshield", MakeReflectShield, assets)
