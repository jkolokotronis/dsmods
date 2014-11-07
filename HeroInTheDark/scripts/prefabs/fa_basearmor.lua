local assets_copper=
{
    Asset("ANIM", "anim/fa_copperarmor.zip"),
}
local assets_iron=
{
    Asset("ANIM", "anim/fa_ironarmor.zip"),
}
local assets_steel=
{
    Asset("ANIM", "anim/fa_steelarmor.zip"),
}
local assets_silver=
{
    Asset("ANIM", "anim/fa_silverarmor.zip"),
}
local assets_gold=
{
    Asset("ANIM", "anim/fa_goldarmor.zip"),
}

local ARMOR_ABSORPTION_T1=0.70
local ARMOR_ABSORPTION_T2=0.80
local ARMOR_ABSORPTION_T3=0.95
local ARMOR_DURABILITY_T1=1800
local ARMOR_DURABILITY_T2=2800
local ARMOR_DURABILITY_T3=4000



local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn(name)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( name..".tex" )
    
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_basearmors.xml"
    inst.components.inventoryitem.imagename=name
    
    inst:AddComponent("armor")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip(function(inst,owner)
    	owner.AnimState:OverrideSymbol("swap_body", name, "swap_body")
    end)
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function copperarmor()
    local inst =fn("fa_copperarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T1, ARMOR_ABSORPTION_T1)
    return inst
end
local function steelarmor()
    local inst =fn("fa_steelarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T3, ARMOR_ABSORPTION_T3)
    return inst
end
local function ironarmor()
    local inst =fn("fa_ironarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T2, ARMOR_ABSORPTION_T2)
    return inst
end
local function silverarmor()
    local inst =fn("fa_silverarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T2, ARMOR_ABSORPTION_T2)
    return inst
end
local function goldarmor()
    local inst =fn("fa_goldarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T2, ARMOR_ABSORPTION_T2)
    return inst
end

return
    Prefab( "common/inventory/fa_copperarmor",copperarmor, assets_copper),
    Prefab( "common/inventory/fa_steelarmor",steelarmor, assets_steel),
    Prefab( "common/inventory/fa_ironarmor", ironarmor, assets_iron),
    Prefab( "common/inventory/fa_silverarmor", silverarmor, assets_silver),
    Prefab( "common/inventory/fa_goldarmor", goldarmor, assets_gold)