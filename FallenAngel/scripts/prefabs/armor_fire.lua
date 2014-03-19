local assets=
{
	Asset("ANIM", "anim/armor_fire.zip"),
  Asset("ATLAS", "images/inventoryimages/firearmor.xml"),
  Asset("IMAGE", "images/inventoryimages/firearmor.tex"),
}

local ARMORFIRE_ABSORPTION_T1=0.70
local ARMORFIRE_ABSORPTION_T2=0.80
local ARMORFIRE_ABSORPTION_T3=0.95
local ARMORFIRE_DURABILITY_T1=1000
local ARMORFIRE_DURABILITY_T2=1500
local ARMORFIRE_DURABILITY_T3=2000
local ARMORFIRE_SLOW_T1 = 0.9
local ARMORFIRE_SLOW_T2 = 0.93
local ARMORFIRE_SLOW_T3 = 0.95
local ARMORFIRE_PROC_T1=0.1
local ARMORFIRE_PROC_T2=0.2
local ARMORFIRE_PROC_T3=0.3

local function OnBlocked(inst,owner,data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
    if(data and data.attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
        if(math.random()<=inst.procRate)then
            print("reflecting to",data.attacker)
            data.attacker.components.burnable:Ignite()
        end
    end
end

local function onequip(inst, owner) 
--    owner.AnimState:OverrideSymbol("swap_body", "armor_marble", "swap_body")
     inst:ListenForEvent("attacked", function(owner,data) OnBlocked(inst,owner,data) end,owner)
    inst:ListenForEvent("blocked",function(owner,data) OnBlocked(inst,owner,data) end, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:RemoveEventCallback("attacked", OnBlocked, owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "firearmor.tex" )
    
    inst.AnimState:SetBank("armor_marble")
    inst.AnimState:SetBuild("armor_fire")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/firearmor.xml"
    inst.components.inventoryitem.imagename="firearmor"
    
    inst:AddComponent("armor")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function t1()
    local inst =fn()
    inst:AddTag("tier1")
    inst.procRate=ARMORFIRE_PROC_T1
    inst.components.armor:InitCondition(ARMORFIRE_DURABILITY_T1, ARMORFIRE_ABSORPTION_T1)
    inst.components.equippable.walkspeedmult = ARMORFIRE_SLOW_T1
    return inst
end

local function t2()
    local inst =fn()
    inst:AddTag("tier2")
    inst.procRate=ARMORFIRE_PROC_T2
    inst.components.armor:InitCondition(ARMORFIRE_DURABILITY_T2, ARMORFIRE_ABSORPTION_T2)
    inst.components.equippable.walkspeedmult =  ARMORFIRE_SLOW_T2
    return inst
end

local function t3()
    local inst =fn()
    inst:AddTag("tier3")
    inst.procRate=ARMORFIRE_PROC_T3
    inst.components.armor:InitCondition(ARMORFIRE_DURABILITY_T3, ARMORFIRE_ABSORPTION_T3)
    inst.components.equippable.walkspeedmult =  ARMORFIRE_SLOW_T3
    return inst
end

return Prefab( "common/inventory/armorfire", t1, assets), 
Prefab( "common/inventory/armorfire2", t2, assets),
Prefab( "common/inventory/armorfire3", t3, assets)
