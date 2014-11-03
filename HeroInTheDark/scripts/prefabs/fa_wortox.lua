
local assets = {

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
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),
        Asset( "ANIM", "anim/wortox.zip" ),
}
local prefabs = {}

local function OnBlocked(owner,data) 
    if(data and data.attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
        if(math.random()<=0.2)then
            print("reflecting to",data.attacker)
            data.attacker.components.combat:GetAttacked(owner, 20, nil,nil,FA_DAMAGETYPE.FIRE)
            data.attacker.components.burnable:Ignite()
        end
    end
end

local function demonattack(attacker,data)
    local target=data.target
    target.components.combat:GetAttacked(attacker, 20, nil,nil,FA_DAMAGETYPE.FIRE)
    if(target.components.health:IsInvincible() == false and math.random()<=0.2)then
        if(target.components.burnable and not target.components.fueled)then
            target.components.burnable:Ignite()
        end
    end
end


local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 2.5, 1.5 )
--    inst.Transform:SetTwoFaced()
    inst.Transform:SetFourFaced()

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst.entity:AddPhysics()
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)


    anim:SetBank("wilson")
    anim:SetBuild("wortox")
    anim:PlayAnimation("idle")
    
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")

    MakeCharacterPhysics(inst, 20, .5)
 
inst:AddComponent("eater")

        owner.components.eater:SetCarnivore(true)
    inst.components.eater:SetCanEatHorrible()
        owner.components.eater.monsterimmune = true
        owner.components.eater.strongstomach = true

    

    inst:AddComponent("inventory")
--    inst:AddComponent("sanity")
    
--    inst.components.inventory.starting_inventory = inventoryrng



    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
--    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED

    inst:AddComponent("follower")
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(40)
    inst.components.combat:SetAttackPeriod(1)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(900)
        owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+1
        owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]-1

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
    inst:SetStateGraph("SGskeletonspawn")
        inst:ListenForEvent("onhitother",demonattack) 

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
        inst:ListenForEvent("attacked",OnBlocked,owner)
        inst:ListenForEvent("blocked",OnBlocked, owner)
    
    return inst
end

return Prefab( "common/fa_cursedwortox", spawn, assets),
Prefab( "common/fa_cursedpigking", spawn, assets),
Prefab( "common/fa_wortox_npc", spawn, assets)