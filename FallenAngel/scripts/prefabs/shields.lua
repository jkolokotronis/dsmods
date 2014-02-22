local assets=
{
  Asset("ANIM", "anim/wdshield.zip"),
  Asset("ANIM", "anim/swap_wdshield.zip"),
  Asset("ANIM", "anim/shield.zip"),
  Asset("ANIM", "anim/swap_shield.zip"),
  Asset("ATLAS", "images/inventoryimages/wdshield.xml"),
  Asset("ATLAS", "images/inventoryimages/shield.xml"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "swap_body")
--    owner.components.inventory.overflow = inst
end

local function wdonequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_wdshield", "swap_body")
--    owner.components.inventory.overflow = inst
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
--    owner.components.inventory.overflow = nil
end

local WOOD_SHIELD_ABSO=0.10
local WOOD_SHIELD_DURA=100

local ROCK_SHIELD_ABSO=0.20
local ROCL_SHIELD_DURA=200

local MARBLE_SHIELD_ABSO=0.40
local MARBLE_SHIELD_DURA=400

local BONE_SHIELD_ABSO=0.20
local BONE_SHIELD_DURA=200

local function fn()
  local inst = CreateEntity()
    
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
  inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

  local minimap = inst.entity:AddMiniMapEntity()
  minimap:SetIcon("backpack.png")
    
     inst:AddComponent("inventoryitem")
    inst:AddComponent("equippable")
  if EQUIPSLOTS["BACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.BACK
  elseif EQUIPSLOTS["PACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.PACK
  else
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
  end
    
    
    inst.components.equippable:SetOnUnequip( onunequip )
    inst:AddComponent("armor")
    inst:AddComponent("inspectable")
    
    return inst
end


local function MakeWoodenShield()
    local inst=fn()
    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_wdshield")
    inst.AnimState:PlayAnimation("anim")

    inst.components.inventoryitem.atlasname = "images/inventoryimages/wdshield.xml"
    inst.components.inventoryitem.imagename="wdshield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"

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
 inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_shield")
    inst.AnimState:PlayAnimation("anim")

     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(ROCK_SHIELD_ABSO, ROCK_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( onequip )
    return inst
end

local function MakeMarbleShield()
    local inst=fn()
 inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_shield")
    inst.AnimState:PlayAnimation("anim")

    
     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(MARBLE_SHIELD_DURA, MARBLE_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( onequip )
    return inst
end

local function MakeBoneShield()
    local inst=fn()
 inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_shield")
    inst.AnimState:PlayAnimation("anim")

    
     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/backpack"
    inst.components.armor:InitCondition(BONE_SHIELD_DURA, BONE_SHIELD_ABSO )
    inst.components.equippable:SetOnEquip( onequip )
    return inst
end


return Prefab( "common/inventory/woodenshield", MakeWoodenShield, assets), 
        Prefab( "common/inventory/rockshield", MakeRockShield, assets), 
        Prefab( "common/inventory/marbleshield", MakeMarbleShield, assets), 
        Prefab( "common/inventory/boneshield", MakeBoneShield, assets)
