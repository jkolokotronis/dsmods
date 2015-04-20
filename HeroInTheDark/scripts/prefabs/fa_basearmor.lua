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
local assets_adamantine=
{
    Asset("ANIM", "anim/fa_adamantinearmor.zip"),
}
local assets_fa_abjurationrobe=
{
    Asset("ANIM", "anim/fa_abjurationrobe.zip"),
}
local assets_fa_conjurationrobe=
{
    Asset("ANIM", "anim/fa_conjurationrobe.zip"),
}
local assets_fa_divinationrobe=
{
    Asset("ANIM", "anim/fa_divinationrobe.zip"),
}
local assets_fa_enchantmentrobe=
{
    Asset("ANIM", "anim/fa_enchantmentrobe.zip"),
}
local assets_fa_evocationrobe=
{
    Asset("ANIM", "anim/fa_evocationrobe.zip"),
}
local assets_fa_illusionrobee=
{
    Asset("ANIM", "anim/fa_illusionrobe.zip"),
}
local assets_fa_necromancyrobe=
{
    Asset("ANIM", "anim/fa_necromancyrobe.zip"),
}
local assets_fa_transmutationrobe=
{
    Asset("ANIM", "anim/fa_transmutationrobe.zip"),
}
local assets_fa_heavyleatherarmor=
{
    Asset("ANIM", "anim/fa_heavyleatherarmor.zip"),
}
local assets_fa_lightleatherarmor=
{
    Asset("ANIM", "anim/fa_lightleatherarmor.zip"),
}
local assets_fa_plainrobe=
{
    Asset("ANIM", "anim/fa_plainrobe.zip"),
}


local ARMOR_ABSORPTION_T1=0.70
local ARMOR_ABSORPTION_T2=0.80
local ARMOR_ABSORPTION_T3=0.95
local ARMOR_DURABILITY_T1=1800
local ARMOR_DURABILITY_T2=2800
local ARMOR_DURABILITY_T3=4000
local ARMOR_DURABILITY_SILVER=2500
local ARMOR_ABSORPTION_SILVER=0.85
local ARMOR_DURABILITY_GOLD=2000
local ARMOR_ABSORPTION_GOLD=0.7
local ARMOR_DURABILITY_SILVER=2500
local ARMOR_ABSORPTION_SILVER=0.85
local ARMOR_DURABILITY_ADAMANT=8500
local ARMOR_ABSORPTION_ADAMANT=0.95
local ARMOR_DURABILITY_LEATHER=1200
local ARMOR_ABSORPTION_LEATHER=0.65
local ARMOR_DURABILITY_HEAVYLEATHER=1500
local ARMOR_ABSORPTION_HEAVYLEATHER=0.75

local ARMOR_GOLD_DAPPERNESS=5.0/60
local ARMOR_GOLD_FUELLEVEL=1200
local DIV_ROBE_DAPPERNESS=5.0/60

local ARMOR_ROBE_DURA=1000
local ARMOR_ROBE_ABSO=0.6
local ARMOR_ROBE_ABJ_ABSO=0.65
local ROBE_CL_BONUS=2


    local function generic_perish(inst)
        inst:Remove()
    end


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
     inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
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
local function adamantinearmor()
    local inst =fn("fa_adamantinearmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_ADAMANT, ARMOR_ABSORPTION_ADAMANT)
    return inst
end
local function ironarmor()
    local inst =fn("fa_ironarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T2, ARMOR_ABSORPTION_T2)
    return inst
end
local function silverarmor()
    local inst =fn("fa_silverarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_SILVER, ARMOR_ABSORPTION_SILVER)
    return inst
end
local function goldarmor()
    local inst =fn("fa_goldarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_GOLD, ARMOR_ABSORPTION_GOLD)


        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = ARMOR_GOLD_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = ARMOR_GOLD_DAPPERNESS
        end


        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "USAGE"
        inst.components.fueled:InitializeFuelLevel(ARMOR_GOLD_FUELLEVEL)
        inst.components.fueled:SetDepletedFn( generic_perish )


        inst:ListenForEvent("rainstop", function() inst.components.fueled.rate=1 end, GetWorld()) 
        inst:ListenForEvent("rainstart", function() inst.components.fueled.rate=2 end, GetWorld()) 

    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_goldarmor", "swap_body")
        inst.components.fueled:StartConsuming()        
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        inst.components.fueled:StopConsuming()        
        onunequip(inst,owner)
    end)

    return inst
end

local function fa_heavyleatherarmor()
    local inst =fn("fa_heavyleatherarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_HEAVYLEATHER, ARMOR_ABSORPTION_HEAVYLEATHER)
    return inst
end

local function fa_lightleatherarmor()
    local inst =fn("fa_lightleatherarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_LEATHER, ARMOR_ABSORPTION_LEATHER)
    return inst
end

local function fa_plainrobe()
    local inst =fn("fa_plainrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    return inst
end
local function fa_abjurationrobe()
    local inst =fn("fa_abjurationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABJ_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ABJURATION]=ROBE_CL_BONUS
    return inst
end

local function fa_conjurationrobe()
    local inst =fn("fa_conjurationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.CONJURATION]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.POISON]=0.2
    return inst
end

local function fa_divinationrobe()
    local inst =fn("fa_divinationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.DIVINATION]=ROBE_CL_BONUS
        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = DIV_ROBE_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = DIV_ROBE_DAPPERNESS
        end
    return inst
end

local function fa_enchantmentrobe()
    local inst =fn("fa_enchantmentrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ENCHANTMENT]=ROBE_CL_BONUS
    return inst
end

local function fa_evocationrobe()
    local inst =fn("fa_evocationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.EVOCATION]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.3
    return inst
end

local function fa_illusionrobe()
    local inst =fn("fa_illusionrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ILLUSION]=ROBE_CL_BONUS
    return inst
end

local function fa_necromancyrobe()
    local inst =fn("fa_necromancyrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.NECROMANCY]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.DEATH]=0.2
    return inst
end

local function fa_transmutationrobe()
    local inst =fn("fa_transmutationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.TRANSMUTATION]=ROBE_CL_BONUS
    return inst
end

return
    Prefab( "common/inventory/fa_copperarmor",copperarmor, assets_copper),
    Prefab( "common/inventory/fa_steelarmor",steelarmor, assets_steel),
    Prefab( "common/inventory/fa_adamantinearmor",adamantinearmor, assets_adamantine),
    Prefab( "common/inventory/fa_ironarmor", ironarmor, assets_iron),
    Prefab( "common/inventory/fa_silverarmor", silverarmor, assets_silver),
    Prefab( "common/inventory/fa_goldarmor", goldarmor, assets_gold),
    Prefab( "common/inventory/fa_plainrobe", fa_plainrobe, assets_fa_plainrobe),
    Prefab( "common/inventory/fa_lightleatherarmor", fa_lightleatherarmor, assets_fa_lightleatherarmor),
    Prefab( "common/inventory/fa_heavyleatherarmor", fa_heavyleatherarmor, assets_fa_heavyleatherarmor),
    Prefab( "common/inventory/fa_abjurationrobe", fa_abjurationrobe, assets_fa_abjurationrobe),
    Prefab( "common/inventory/fa_conjurationrobe", fa_conjurationrobe, assets_fa_conjurationrobe),
    Prefab( "common/inventory/fa_divinationrobe", fa_divinationrobe, assets_fa_divinationrobe),
    Prefab( "common/inventory/fa_enchantmentrobe", fa_enchantmentrobe, assets_fa_enchantmentrobe),
    Prefab( "common/inventory/fa_evocationrobe", fa_evocationrobe, assets_fa_evocationrobe),
    Prefab( "common/inventory/fa_illusionrobe", fa_illusionrobe, assets_fa_illusionrobee),
    Prefab( "common/inventory/fa_necromancyrobe", fa_necromancyrobe, assets_fa_necromancyrobe),
    Prefab( "common/inventory/fa_transmutationrobe", fa_transmutationrobe, assets_fa_transmutationrobe)