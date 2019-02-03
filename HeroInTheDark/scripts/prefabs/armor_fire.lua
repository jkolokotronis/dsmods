local assets=
{
	Asset("ANIM", "anim/fa_firearmor.zip"),
}

local ARMORFIRE_ABSORPTION_T1=0.70
local ARMORFIRE_ABSORPTION_T2=0.80
local ARMORFIRE_ABSORPTION_T3=0.95
local ARMORFIRE_DURABILITY_T1=1800
local ARMORFIRE_DURABILITY_T2=2800
local ARMORFIRE_DURABILITY_T3=4000
local ARMORFIRE_SLOW_T1 = 0.9
local ARMORFIRE_SLOW_T2 = 0.93
local ARMORFIRE_SLOW_T3 = 0.95
local ARMORFIRE_PROC_T1=0.1
local ARMORFIRE_PROC_T2=0.2
local ARMORFIRE_PROC_T3=0.3
-- this is dumb but so are the changes
if(FA_SWACCESS or FA_PORKACCESS)then
    ARMORFIRE_SLOW_T1=ARMORFIRE_SLOW_T1-1
    ARMORFIRE_SLOW_T2=ARMORFIRE_SLOW_T2-1
    ARMORFIRE_SLOW_T3=ARMORFIRE_SLOW_T3-1
end

local function OnBlocked(owner,data) 
    local inst = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
    if(not inst) then return end

    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
    if(data and data.attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
        if(math.random()<=inst.procRate)then
            print("reflecting to",data.attacker)
            data.attacker.components.burnable:Ignite()
        end
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "fa_firearmor", "swap_body")
     inst:ListenForEvent("attacked",OnBlocked,owner)
    inst:ListenForEvent("blocked",OnBlocked, owner)
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
    minimap:SetIcon( "armorfire.tex" )
    
    inst.AnimState:SetBank("fa_firearmor")
    inst.AnimState:SetBuild("fa_firearmor")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="armorfire"
    
    inst:AddComponent("armor")
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.7

    inst:AddComponent("heater")
    inst.components.heater.equippedheat = 10
    
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
