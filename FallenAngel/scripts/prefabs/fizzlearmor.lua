local assets=
{
	Asset("ANIM", "anim/armor_wood.zip"),
}
local REFLECT_DAMAGE=60

local function OnBlocked(owner,data) 
    owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour") 
    if(data and data.attacker and data.attacker.components.combat)then
        print("reflecting to",data.attacker)
        data.attacker.components.combat:GetAttacked(owner, REFLECT_DAMAGE, nil)
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_wood", "swap_body")
    inst:ListenForEvent("attacked", OnBlocked, owner)
    inst:ListenForEvent("blocked", OnBlocked, owner)
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
    inst:RemoveEventCallback("blocked", OnBlocked, owner)
    inst:ListenForEvent("attacked", OnBlocked, owner)
end

local function fn(Sim)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("armor_wood")
    inst.AnimState:SetBuild("armor_wood")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddTag("wood")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/logarmour"
    inst.components.inventoryitem.imagename="logarmour"

    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL
    
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(TUNING.ARMORWOOD, TUNING.ARMORWOOD_ABSORPTION)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

return Prefab( "common/inventory/fizzlearmor", fn, assets) 
