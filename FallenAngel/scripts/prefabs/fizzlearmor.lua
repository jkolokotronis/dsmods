local assets=
{
  Asset("ANIM", "anim/shield.zip"),
  Asset("ANIM", "anim/swap_shield.zip"),
  Asset("ATLAS", "images/inventoryimages/shield.xml"),
}
local REFLECT_DAMAGE=60
local ARMOR_ABSO=0
local ARMOR_DURABILITY=100

local function OnBlocked(owner,data) 
    local inst = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BACK or EQUIPSLOTS.PACK or EQUIPSLOTS.BODY)
    if(not inst) then return end
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
    if(data and data.attacker and data.attacker.components.combat)then
        print("reflecting to",data.attacker)
        data.attacker.components.combat:GetAttacked(owner, REFLECT_DAMAGE, nil)
        inst.components.armor:SetPercent(inst.components.armor:GetPercent()-3)
    end
end

local function onequip(inst, owner) 

    owner.AnimState:OverrideSymbol("swap_body", "swap_shield", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_shield", "swap_body")
    inst:ListenForEvent("attacked", OnBlocked,owner)
    inst:ListenForEvent("blocked",OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
 inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_shield")
    inst.AnimState:PlayAnimation("anim")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "evilsword.tex" )
    
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"

    inst:AddComponent("equippable")
  if EQUIPSLOTS["BACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.BACK
  elseif EQUIPSLOTS["PACK"] then
      inst.components.equippable.equipslot = EQUIPSLOTS.PACK
  else
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
  end
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY, ARMOR_ABSO)
    
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/fizzlearmor", fn, assets) 
