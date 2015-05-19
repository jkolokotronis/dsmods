
local assets_ironsword={
    Asset("ANIM", "anim/fa_ironsword.zip"),    
}
local assets_silversword={
    Asset("ANIM", "anim/fa_silversword.zip"),
}
local assets_steelsword={
    Asset("ANIM", "anim/fa_steelsword.zip"), 
}
local assets_adamantinesword={
    Asset("ANIM", "anim/fa_adamantinesword.zip"), 
}
local assets_coppersword={
    Asset("ANIM", "anim/fa_coppersword.zip"),
}

local assets_ironaxe={
    Asset("ANIM", "anim/fa_ironaxe.zip"),    
}
local assets_silveraxe={
    Asset("ANIM", "anim/fa_silveraxe.zip"),
}
local assets_steelaxe={
    Asset("ANIM", "anim/fa_steelaxe.zip"), 
}
local assets_adamantineaxe={
    Asset("ANIM", "anim/fa_adamantineaxe.zip"), 
}
local assets_copperaxe={
    Asset("ANIM", "anim/fa_copperaxe.zip"),
}
local assets_dorfkingaxe={
    Asset("ANIM", "anim/fa_dorfkingaxe.zip"),
}
local assets_orckingaxe={
    Asset("ANIM", "anim/fa_orckinghammer.zip"),
}

local assets_ironkama={
    Asset("ANIM", "anim/fa_ironkama.zip"),    
}
local assets_silverkama={
    Asset("ANIM", "anim/fa_silverkama.zip"),
}
local assets_steelkama={
    Asset("ANIM", "anim/fa_steelkama.zip"), 
}
local assets_adamantinekama={
    Asset("ANIM", "anim/fa_adamantinekama.zip"), 
}
local assets_copperkama={
    Asset("ANIM", "anim/fa_copperkama.zip"),
}
local assets_woodenkama={
    Asset("ANIM", "anim/fa_woodenkama.zip"),
}
local assets_goldkama={
    Asset("ANIM", "anim/fa_goldkama.zip"),
}

local assets_ironstaff={
    Asset("ANIM", "anim/fa_ironstaff.zip"),    
}
local assets_silverstaff={
    Asset("ANIM", "anim/fa_silverstaff.zip"),
}
local assets_steelstaff={
    Asset("ANIM", "anim/fa_steelstaff.zip"), 
}
local assets_adamantinestaff={
    Asset("ANIM", "anim/fa_adamantinestaff.zip"), 
}
local assets_copperstaff={
    Asset("ANIM", "anim/fa_copperstaff.zip"),
}
local assets_woodenstaff={
    Asset("ANIM", "anim/fa_woodenstaff.zip"),
}
local assets_goldstaff={
    Asset("ANIM", "anim/fa_goldstaff.zip"),
}

local AXE_DAMAGE_T1=55
local AXE_DAMAGE_T2=75
local AXE_DAMAGE_T3=90
local AXE_USES_T1=115
local AXE_USES_T2=225
local AXE_USES_T3=350
local SWORD_DAMAGE_T1=50
local SWORD_DAMAGE_T2=70
local SWORD_DAMAGE_T3=85
local SWORD_USES_T1=115
local SWORD_USES_T2=225
local SWORD_USES_T3=350

local ADAMANTINE_SWORD_DAMAGE=120
local ADAMANTINE_SWORD_USES=1000
local ADAMANTINE_AXE_DAMAGE=135
local ADAMANTINE_AXE_USES=1000

local WOOD_KAMA_DAMAGE=30
local WOOD_KAMA_USES=120
local COPPER_KAMA_DAMAGE=40
local COPPER_KAMA_USES=150
local COPPER_KAMA_KI=1
local SILVER_KAMA_DAMAGE=50
local SILVER_KAMA_USES=200
local SILVER_KAMA_KI=1
local GOLD_KAMA_DAMAGE=35
local GOLD_KAMA_USES=200
local IRON_KAMA_DAMAGE=60
local IRON_KAMA_USES=250
local IRON_KAMA_KI=2
local STEEL_KAMA_DAMAGE=70
local STEEL_KAMA_USES=375
local STEEL_KAMA_KI=3
local ADAMANTINE_KAMA_DAMAGE=90
local ADAMANTINE_KAMA_USES=1000
local ADAMANTINE_KAMA_KI=5


local WOODEN_STAFF_DAMAGE=30
local WOODEN_STAFF_USES=120
local COPPER_STAFF_DAMAGE=35
local COPPER_STAFF_USES=150
local SILVER_STAFF_DAMAGE=35
local SILVER_STAFF_USES=200
local GOLDEN_STAFF_DAMAGE=35
local GOLDEN_STAFF_USES=200
local GOLDEN_STAFF_DAPPERNESS=3.0/60
local IRON_STAFF_DAMAGE=40
local IRON_STAFF_USES=250
local STEEL_STAFF_DAMAGE=45
local STEEL_STAFF_USES=375
local ADAMANTINE_STAFF_DAMAGE=60
local ADAMANTINE_STAFF_USES=1000

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end


local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal") 
end

local function common(name)

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst:AddTag("sharp")
    inst:AddComponent("weapon")
    inst:AddComponent("inspectable")
    
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( name..".tex" )

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=name
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnUnequip( onunequip )
    inst.components.equippable:SetOnEquip(function(inst,owner)
    	owner.AnimState:OverrideSymbol("swap_object", name, "swap_weapon")
    	owner.AnimState:Show("ARM_carry") 
	    owner.AnimState:Hide("ARM_normal") 
    end)
    return inst
end

local function coppersword()
    local inst=common("fa_coppersword")
    inst:AddTag("sword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T1)
    inst.components.finiteuses:SetUses(SWORD_USES_T1)
    return inst
end
local function ironsword()
    local inst=common("fa_ironsword")
    inst:AddTag("sword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T2)
    inst.components.finiteuses:SetUses(SWORD_USES_T2)
    return inst
end
local function silversword()
    local inst=common("fa_silversword")
    inst:AddTag("sword")

    inst:AddTag("fa_silver")
    inst.components.weapon:SetDamage(SWORD_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T2)
    inst.components.finiteuses:SetUses(SWORD_USES_T2)
    return inst
end
local function steelsword()
    local inst=common("fa_steelsword")
    inst:AddTag("sword")

    inst.components.weapon:SetDamage(SWORD_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T3)
    inst.components.finiteuses:SetUses(SWORD_USES_T3)
    return inst
end
local function adamantinesword()
    local inst=common("fa_adamantinesword")
    inst:AddTag("sword")

    inst.components.weapon:SetDamage(ADAMANTINE_SWORD_DAMAGE)
    inst.components.finiteuses:SetMaxUses(ADAMANTINE_AXE_USES)
    inst.components.finiteuses:SetUses(ADAMANTINE_AXE_USES)
    return inst
end
local function copperaxe()
    local inst=common("fa_copperaxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T1)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T1)
    inst.components.finiteuses:SetUses(AXE_USES_T1)
    return inst
end
local function steelaxe()
    local inst=common("fa_steelaxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T3)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T3)
    inst.components.finiteuses:SetUses(AXE_USES_T3)
    return inst
end
local function adamantineaxe()
    local inst=common("fa_adamantineaxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(ADAMANTINE_AXE_DAMAGE)
    inst.components.finiteuses:SetMaxUses(ADAMANTINE_AXE_USES)
    inst.components.finiteuses:SetUses(ADAMANTINE_AXE_USES)
    return inst
end
local function ironaxe()
    local inst=common("fa_ironaxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end
local function silveraxe()
    local inst=common("fa_silveraxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end
local function dorfkingaxe()
    local inst=common("fa_dorfkingaxe")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end
local function orckingaxe()
    local inst=common("fa_orckinghammer")
    inst:AddTag("axe")

    inst.components.weapon:SetDamage(AXE_DAMAGE_T2)
    inst.components.finiteuses:SetMaxUses(AXE_USES_T2)
    inst.components.finiteuses:SetUses(AXE_USES_T2)
    return inst
end
local function magesword()
    local inst=common("fa_coppersword")
    inst:AddTag("sword")
    inst.components.weapon:SetDamage(inst.components.weapon.damage*2)
    inst:AddComponent("characterspecific")
    inst.components.characterspecific:SetOwner("wizard")
    inst.components.weapon:SetDamage(SWORD_DAMAGE_T1*2)
    inst.components.finiteuses:SetMaxUses(SWORD_USES_T1*0.75)
    inst.components.finiteuses:SetUses(SWORD_USES_T1*0.75)
    return inst
end

local function fa_ironkama()
    local inst=common("fa_ironkama")
    inst.components.weapon:SetDamage(IRON_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(IRON_KAMA_USES)
    inst.components.finiteuses:SetUses(IRON_KAMA_USES)
    inst.fa_kiboost=IRON_KAMA_KI
    inst:AddTag("unarmed")
    return inst
end
local function fa_silverkama()
    local inst=common("fa_silverkama")
    inst.components.weapon:SetDamage(SILVER_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(SILVER_KAMA_USES)
    inst.components.finiteuses:SetUses(SILVER_KAMA_USES)
    inst.fa_kiboost=SILVER_KAMA_KI
    inst:AddTag("unarmed")
    return inst
end
local function fa_steelkama()
    local inst=common("fa_steelkama")
    inst.components.weapon:SetDamage(STEEL_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(STEEL_KAMA_USES)
    inst.components.finiteuses:SetUses(STEEL_KAMA_USES)
    inst.fa_kiboost=STEEL_KAMA_KI
    inst:AddTag("unarmed")
    return inst
end
local function fa_adamantinekama()
    local inst=common("fa_adamantinekama")
    inst.components.weapon:SetDamage(ADAMANTINE_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(ADAMANTINE_KAMA_USES)
    inst.components.finiteuses:SetUses(ADAMANTINE_KAMA_USES)
    inst.fa_kiboost=ADAMANTINE_KAMA_KI
    inst:AddTag("unarmed")
    return inst
end
local function fa_copperkama()
    local inst=common("fa_copperkama")
    inst.components.weapon:SetDamage(COPPER_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(COPPER_KAMA_USES)
    inst.components.finiteuses:SetUses(COPPER_KAMA_USES)
    inst.fa_kiboost=COPPER_KAMA_KI
    inst:AddTag("unarmed")
    return inst
end
local function fa_woodenkama()
    local inst=common("fa_woodenkama")
    inst.components.weapon:SetDamage(WOOD_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(WOOD_KAMA_USES)
    inst.components.finiteuses:SetUses(WOOD_KAMA_USES)
    inst:AddTag("unarmed")
    return inst
end
local function fa_goldkama()
    local inst=common("fa_goldkama")
    inst.components.weapon:SetDamage(GOLD_KAMA_DAMAGE)
    inst.components.finiteuses:SetMaxUses(GOLD_KAMA_USES)
    inst.components.finiteuses:SetUses(GOLD_KAMA_USES)
    inst:AddTag("unarmed")

    local function onattack(inst, attacker, target)
        if(attacker and attacker.components.sanity)then
            attacker.components.sanity:DoDelta(1)
        end
    end
    inst.components.weapon:SetOnAttack(onattack)
    
    return inst
end

local function fa_ironstaff()
    local inst=common("fa_ironstaff")
    inst.components.weapon:SetDamage(IRON_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(IRON_STAFF_USES)
    inst.components.finiteuses:SetUses(IRON_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
local function fa_silverstaff()
    local inst=common("fa_silverstaff")
    inst.components.weapon:SetDamage(SILVER_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(SILVER_STAFF_USES)
    inst.components.finiteuses:SetUses(SILVER_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")

    local function onattack(inst, attacker, target)
        if(attacker and target and target:HasTag("undead")) then
          target.components.combat:GetAttacked(attacker, inst.components.weapon.damage*0.5, nil)
        end
    end
    inst.components.weapon:SetOnAttack(onattack)

    return inst
end
local function fa_steelstaff()
    local inst=common("fa_steelstaff")
    inst.components.weapon:SetDamage(STEEL_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(STEEL_STAFF_USES)
    inst.components.finiteuses:SetUses(STEEL_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
local function fa_adamantinestaff()
    local inst=common("fa_adamantinestaff")
    inst.components.weapon:SetDamage(ADAMANTINE_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(ADAMANTINE_STAFF_USES)
    inst.components.finiteuses:SetUses(ADAMANTINE_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
local function fa_copperstaff()
    local inst=common("fa_copperstaff")
    inst.components.weapon:SetDamage(COPPER_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(COPPER_STAFF_USES)
    inst.components.finiteuses:SetUses(COPPER_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
local function fa_woodenstaff()
    local inst=common("fa_woodenstaff")
    inst.components.weapon:SetDamage(WOODEN_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(WOODEN_STAFF_USES)
    inst.components.finiteuses:SetUses(WOODEN_STAFF_USES)
    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
local function fa_goldstaff()
    local inst=common("fa_goldstaff")
    inst.components.weapon:SetDamage(GOLDEN_STAFF_DAMAGE)
    inst.components.finiteuses:SetMaxUses(GOLDEN_STAFF_USES)
    inst.components.finiteuses:SetUses(GOLDEN_STAFF_USES)

        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = GOLDEN_STAFF_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = GOLDEN_STAFF_DAPPERNESS
        end

    inst:AddTag("unarmed")
    inst:AddTag("staff")
    return inst
end
return
    Prefab( "common/inventory/fa_coppersword",coppersword, assets_coppersword),
    Prefab( "common/inventory/fa_steelsword",steelsword, assets_steelsword),
    Prefab( "common/inventory/fa_adamantinesword",adamantinesword, assets_adamantinesword),
    Prefab( "common/inventory/fa_ironsword", ironsword, assets_ironsword),
    Prefab( "common/inventory/fa_silversword", silversword, assets_silversword),
    Prefab( "common/inventory/fa_copperaxe",copperaxe, assets_copperaxe),
    Prefab( "common/inventory/fa_steelaxe",steelaxe, assets_steelaxe),
    Prefab( "common/inventory/fa_adamantineaxe",adamantineaxe, assets_adamantineaxe),
    Prefab( "common/inventory/fa_ironaxe", ironaxe, assets_ironaxe),
    Prefab( "common/inventory/fa_silveraxe", silveraxe, assets_silveraxe),
    Prefab( "common/inventory/fa_dorfkingaxe", dorfkingaxe, assets_dorfkingaxe),
    Prefab( "common/inventory/fa_orckinghammer", orckingaxe, assets_orckingaxe),
    Prefab( "common/inventory/fa_magesword", magesword, assets_coppersword),
    Prefab( "common/inventory/fa_ironkama", fa_ironkama, assets_ironkama),
    Prefab( "common/inventory/fa_silverkama", fa_silverkama, assets_silverkama),
    Prefab( "common/inventory/fa_steelkama",fa_steelkama, assets_steelkama),
    Prefab( "common/inventory/fa_adamantinekama",fa_adamantinekama, assets_adamantinekama),
    Prefab( "common/inventory/fa_copperkama",fa_copperkama, assets_copperkama),
    Prefab( "common/inventory/fa_woodenkama",fa_woodenkama, assets_woodenkama),
    Prefab( "common/inventory/fa_goldkama",fa_goldkama, assets_goldkama),
    Prefab( "common/inventory/fa_ironstaff", fa_ironstaff, assets_ironstaff),
    Prefab( "common/inventory/fa_silverstaff", fa_silverstaff, assets_silverstaff),
    Prefab( "common/inventory/fa_steelstaff",fa_steelstaff, assets_steelstaff),
    Prefab( "common/inventory/fa_adamantinestaff",fa_adamantinestaff, assets_adamantinestaff),
    Prefab( "common/inventory/fa_copperstaff",fa_copperstaff, assets_copperstaff),
    Prefab( "common/inventory/fa_woodenstaff",fa_woodenstaff, assets_woodenstaff),
    Prefab( "common/inventory/fa_goldstaff",fa_goldstaff, assets_goldstaff)
