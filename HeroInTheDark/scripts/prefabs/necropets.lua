require "prefabutil"
local brain = require "brains/fizzlepetbrain"
local Container=require"components/container"


local assets =
{

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
    
    Asset("ANIM", "anim/chester.zip"),
    Asset("ANIM", "anim/ui_chest_3x2.zip"),
    Asset("SOUND", "sound/chester.fsb"),
    Asset("ANIM", "anim/wx78.zip"),
    Asset("SOUND", "sound/wx78.fsb")    
}

local prefabs =
{
    "chester_eyebone",
    "die_fx"
}


local items =
{

    AXE = "swap_axe",
    PICK = "swap_pickaxe",
    SWORD = "swap_nightmaresword"
}

local PET_DAMAGE=50
local PET_HEALTH=500


local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function EquipItem(inst, item)
    if item then
        inst.AnimState:OverrideSymbol("swap_object", item, item)
        inst.AnimState:Show("ARM_carry") 
        inst.AnimState:Hide("ARM_normal")
    end
end


local function fn()
    --print("chester - create_chester")

    local inst = CreateEntity()
    
    inst:AddTag("companion")
 --   inst:AddTag("character")
    inst:AddTag("scarytoprey")
--    inst:AddTag("chester")
    inst:AddTag("notraptrigger")
    inst:AddTag("companion")


    inst.OnLoad=onloadfn
    inst.OnSave=onsavefn

    inst.entity:AddTransform()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "wilton.png" )

    --print("   AnimState")
    local anim=inst.entity:AddAnimState()


        anim:SetBank("wilson")
        anim:SetBuild("wilton")
        anim:PlayAnimation("idle")
        
        anim:Hide("ARM_carry")
        anim:Hide("hat")
        anim:Hide("hat_hair")
        anim:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
        anim:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
        anim:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")

    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
    MakeCharacterPhysics(inst, 75, .5)
    
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.Transform:SetFourFaced()

    inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "torso"
--    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
    inst.components.combat:SetDefaultDamage(PET_DAMAGE)
    inst.components.combat:SetAttackPeriod(0.75)
    inst.components.combat:SetRetargetFunction(0.1, Retarget)
    --inst:ListenForEvent("attacked", OnAttacked)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst:AddTag("noauradamage")

    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 7

    inst:AddComponent("follower")
        inst:AddComponent("inventory")
--        inst.components.inventory.starting_inventory = starting_inventory
        inst.components.inventory.dropondeath = true

    inst:AddComponent("lootdropper")
--    inst.components.lootdropper:SetLoot({"gears",  "gears","gears",  "gears","gears",  "gears","purplegem"})

    inst:SetStateGraph("SGfizzlepet")
    inst.sg:GoToState("idle")

    inst.items=items
    inst.equipfn=EquipItem
    
    inst:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
    end)

    inst:SetBrain(brain)    

    --print("   brain")


    --print("chester - create_chester END")
    return inst
end

local function skeletonfn(Sim)

end

local function zombiefn(Sim)

end

local function abominationfn(Sim)

end

local function spectrefn(Sim)

end

return Prefab( "common/necroskeleton", skeletonfn, assets, prefabs),
    Prefab("common/necrozombie",zombiefn, assets, prefabs),
    Prefab("necroabomination",abominationfn, assets, prefabs),
    Prefab("necrospectre",spectrefn, assets, prefabs)
