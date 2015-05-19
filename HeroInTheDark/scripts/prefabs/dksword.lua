local assets=
{
    Asset("ANIM", "anim/fa_evilsword.zip"),
    
}
local assets2=
{
    Asset("ANIM", "anim/fa_evilsword2.zip"),
    
}
local assetsstone=
{
    Asset("ANIM", "anim/fa_darksword_stone.zip"),
    
}
local assets3=
{
    Asset("ANIM", "anim/fa_evilsword3.zip"),
    
}
local DK_SWORD_LEECH=5
local DK_SWORD_DAMAGE=40
local DK_SWORD_DAMAGE_2=50
local DK_SWORD_DAMAGE_3=70

local function onattack(inst, attacker, target)
    if(attacker and attacker.components.health)then
        attacker.components.health:DoDelta(DK_SWORD_LEECH)
    end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end


local function fn(name)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
  
    inst:AddTag("irreplaceable")
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon(name )

    
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

--    inst.AnimState:SetMultColour(1, 1, 1, 0.6)
    
    inst:AddTag("shadow")
    inst:AddTag("sharp")
    inst:AddTag("sword")
    
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE)
    inst.components.weapon:SetOnAttack(onattack)
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=name
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
    
    local function onequip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", name, "swap_weapon")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function base()
    local inst=fn("fa_evilsword")
    return inst
end

local function up2()
    local inst=fn("fa_evilsword2")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE_2)
    return inst
end

local function up3()
    local inst=fn("fa_evilsword3")
    inst.components.weapon:SetDamage(DK_SWORD_DAMAGE_3)
    return inst
end

local function fa_darksword_stone()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.empty=false

    MakeObstaclePhysics(inst,0.5)
    anim:SetBank("fa_darksword_stone")
    anim:SetBuild("fa_darksword_stone")
    anim:PlayAnimation("sword")
    inst:AddComponent("inspectable")

    local function onsave(inst, data)
        data.empty = inst.empty
    end

    local function onload(inst, data)
        if data and data.empty then
            inst.empty = data.empty
            inst.AnimState:PlayAnimation("empty",true)
            inst.components.activatable.inactive = false
        end
    end
    inst.OnSave = onsave 
    inst.OnLoad = onload 

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = function(inst,doer)
    
        local axe=doer.components.inventory:FindItem(function(i) return (i and i.prefab=="fa_evilsword2") end)
        if(axe)then
            axe.components.inventoryitem:RemoveFromOwner(true)
            axe:Remove()
            inst.empty = true
            inst.AnimState:PlayAnimation("empty",true)
            local upgrade=SpawnPrefab("fa_evilsword3")
            doer.components.inventory:GiveItem(upgrade)
        else
            inst.components.activatable.inactive=true
        end

    end
    
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = function() return STRINGS.ACTIONS.ACTIVATE.PULL end
    inst.components.activatable.quickaction = false

    return inst
end

return Prefab( "common/inventory/dksword", base, assets),
Prefab( "common/inventory/fa_evilsword2", up2, assets2),
Prefab( "common/inventory/fa_evilsword3", up3, assets3),
Prefab( "common/inventory/fa_darksword_stone", fa_darksword_stone, assetsstone)


