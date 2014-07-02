local assets=
{
  Asset("ANIM", "anim/armor_marble.zip"),
}
local STONESKINARMOR_ABSO=1
local STONESKINARMOR_DURABILITY=1000
local STONESKIN_DURATION=8*60
local MAGEARMOR_ABSO=0.6
local MAGEARMOR_DURABILITY=2^30
local MAGEARMOR_DURATION=4*60

--TODO what's the best way to deal with timers? fuel would do the trick, but it would mess display. And how do I tell the timer anyway?


local function OnBlocked(owner,data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
end

local function stoneskinonequip(inst, owner) 

    owner.AnimState:OverrideSymbol("swap_body", "armor_marble", "swap_body")
    inst:ListenForEvent("attacked", OnBlocked,owner)
    inst:ListenForEvent("blocked",OnBlocked, owner)
end

local function stoneskinonunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
end

local function stoneskinfn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_marble")
    inst.AnimState:PlayAnimation("anim")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "evilsword.tex" )
    
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"

    inst:AddComponent("equippable")
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(STONESKINARMOR_DURABILITY, STONESKINARMOR_ABSO)
    
    
    inst.components.equippable:SetOnEquip( stoneskinonequip )
    inst.components.equippable:SetOnUnequip( stoneskinonunequip )
    
    return inst
end

local function magearmoronequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function magearmoronunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end


local magearmoronloadfn = function(inst, data)
    if(data and data.countdown and data.countdown>0)then
        if inst.shutdowntask then
            inst.shutdowntask:Cancel()
        end
    inst.shutdowntask=inst:DoTaskInTime(data.countdown, function()
      inst:Remove()
    end)
    inst.shutdowntime=GetTime()+data.countdown
    end
end

local magearmoronsavefn = function(inst, data)
    data.countdown=inst.shutdowntime-GetTime()
end

local function magearmorfn(Sim)
  local inst = CreateEntity()
    
  inst.entity:AddTransform()
  inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_marble")
    inst.AnimState:PlayAnimation("anim")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "evilsword.tex" )
    
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
     inst.components.inventoryitem.atlasname = "images/inventoryimages/shield.xml"
    inst.components.inventoryitem.imagename="shield"

    inst:AddComponent("equippable")
      inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(MAGEARMOR_DURABILITY, MAGEARMOR_ABSO)
    
    
    inst.components.equippable:SetOnEquip( magearmoronequip )
    inst.components.equippable:SetOnUnequip( magearmoronunequip )

    inst.OnLoad = magearmoronloadfn
    inst.OnSave = magearmoronsavefn

    inst.shutdowntime=GetTime()+MAGEARMOR_DURATION
    inst.shutdowntask=inst:DoTaskInTime(MAGEARMOR_DURATION, function()
      inst:Remove()
    end)
    
    return inst
end

return Prefab( "common/inventory/fa_spell_magearmor", magearmorfn, assets),
Prefab( "common/inventory/fa_spell_stoneskin", stoneskinfn, assets)
