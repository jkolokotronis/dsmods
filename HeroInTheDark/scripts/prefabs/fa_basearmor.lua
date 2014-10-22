local assets_copper=
{
}
local assets_iron=
{
}
local assets_steel=
{
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
    minimap:SetIcon( "firearmor.tex" )
    
--    inst.AnimState:SetBank(name)
--    inst.AnimState:SetBuild(name)
    inst.AnimState:SetBank("torso_dragonfly")
    inst.AnimState:SetBuild("torso_dragonfly")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/firearmor.xml"
    inst.components.inventoryitem.imagename="firearmor"
    
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

return
    Prefab( "common/inventory/fa_copperarmor",copperarmor, assets_copper),
    Prefab( "common/inventory/fa_steelarmor",steelarmor, assets_steel),
    Prefab( "common/inventory/fa_ironarmor", ironarmor, assets_iron)