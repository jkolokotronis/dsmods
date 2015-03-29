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

        Asset("ANIM","anim/fa_dorf.zip")
}

local assets_king={
    
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

        Asset("ANIM","anim/fa_dorf_king.zip")
}

local prefabs =
{
}

local DWARF_HEALTH=300
local DWARF_DAMAGE=50
local DWARF_ATTACK_PERIOD=2
local DWARF_RUN_SPEED=6
local DWARF_WALK_SPEED=3

local GUARD_HEALTH=300
local GUARD_DAMAGE=50
local GUARD_ATTACK_PERIOD=2
local GUARD_RUN_SPEED=6
local GUARD_WALK_SPEED=3

local KING_GUARD_HEALTH=300
local KING_GUARD_DAMAGE=50
local KING_GUARD_ATTACK_PERIOD=2
local KING_GUARD_RUN_SPEED=6
local KING_GUARD_WALK_SPEED=3


local TRADER_HEALTH=150
local TRADER_DAMAGE=50

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function ontalk(inst, script)
	inst.SoundEmitter:PlaySound("dontstarve/pig/grunt")
end


local function CalcSanityAura(inst, observer)
	if inst.components.werebeast
       and inst.components.werebeast:IsInWereState() then
		return -TUNING.SANITYAURA_LARGE
	end
	
	if inst.components.follower and inst.components.follower.leader == observer then
		return TUNING.SANITYAURA_SMALL
	end
	
	return 0
end

local INV_TABLE={
    {"armorfire","fa_fireaxe","fa_hat_copper"},
    {"armormarble","fa_copperaxe","fa_hat_copper"},
    {"armormarble","fa_ironaxe","fa_hat_iron"},
    {"armormarble","fa_steelaxe","fa_hat_steel"}
}

local function getinventory(inst)
        inst:DoTaskInTime(0,function()
            if(inst.loadedSpawn) then return end
            local items=INV_TABLE[math.random(#INV_TABLE)]
            for k,v in ipairs(items) do
                local item=SpawnPrefab(v)
                if(item)then
                    inst.components.inventory:Equip(item)
                end
            end
            inst.loadedSpawn=true
        end)
end

local function getguardinventory(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_steelarmor")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_fireaxe")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_hat_steel")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end

local function getkingguardinventory(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_goldarmor")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_silveraxe")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_hat_gold")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
local function getkinginventory(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("fa_adamantinearmor")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("fa_adamantinesword")
        inst.components.inventory:Equip(item)
        --implicit
--        item=SpawnPrefab("fa_hat_dorfking")
--        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end

local onload = function(inst, data)
     if(data)then
        inst.loadedSpawn=data.loadedSpawn
    end
end

local onsave = function(inst, data)
    data.loadedSpawn=inst.loadedSpawn
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    if(not attacker) then return end
    inst.components.combat:SetTarget(attacker)

        if not (attacker:HasTag("dorf") ) then
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("dorf")  end, MAX_TARGET_SHARES)
        end
end

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
        function(guy)
            if not guy.LightWatcher or guy.LightWatcher:IsInLight() then
                return guy:HasTag("monster") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) and not 
                (inst.components.follower.leader ~= nil and guy:HasTag("abigail"))
            end
        end)
end

local function NormalKeepTargetFn(inst, target)
    --give up on dead guys, or guys in the dark, or werepigs
    return inst.components.combat:CanTarget(target)
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable
                   and ent.components.burnable:IsBurning()
        end, {"campfire"})
        return DefaultSleepTest(inst) and fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return DefaultSleepTest(inst)
    end
end


local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    inst.soundsname="dwarf"
	shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()

    inst.Transform:SetScale(0.65,0.65, 0.65)

    inst.entity:AddLightWatcher()
    
    inst:AddComponent("talker")
    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0,-400,0)

    MakeCharacterPhysics(inst, 50, .5)
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = DWARF_RUN_SPEED
    inst.components.locomotor.walkspeed = DWARF_WALK_SPEED

    inst:AddTag("character")
    inst:AddTag("dorf")
    inst:AddTag("scarytoprey")
    inst:AddTag("fa_good")
    inst:AddTag("fa_humanoid")

    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("fa_dorf")
    inst.AnimState:Hide("hat_hair")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:PlayAnimation("idle")    

    ------------------------------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(DWARF_DAMAGE)
    inst.components.combat:SetAttackPeriod(DWARF_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)   
 
    inst:AddComponent("trader")
    inst.components.trader.test=function(inst, item)
        if(item and item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.RING)then
            return true
        elseif(item and item.components.fa_drink)then
            return true
        end
        return false
    end
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.RING then
            local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.RING)
            if current then
                inst.components.inventory:DropItem(current)
            end
            inst.components.inventory:Equip(item)
        end
        if item.components.fa_drink then
                giver.components.leader:AddFollower(inst)
                if(item.prefab=="fa_barrel_dorfale" or item.prefab=="fa_dwarfalemug")then
                inst.components.follower:AddLoyaltyTime(2^30)
                else
                inst.components.follower:AddLoyaltyTime(4*60)
                end
        end
    end

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.DORFNAMES
    inst.components.named:PickNewName()
    
    inst:AddComponent("follower")
    inst.components.follower.maxfollowtime = 2^30 --if its 0 addloyaltytime ends up breaking mobs immediately
    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(DWARF_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.3

    ------------------------------------------

    inst:AddComponent("inventory")
    inst.components.inventory.dropondeath=false
    
    ------------------------------------------

    inst:AddComponent("lootdropper")    
    inst.components.lootdropper:SetLoot({ "goldnugget", "meat"})

    ------------------------------------------

    inst:AddComponent("knownlocations")
    
    ------------------------------------------

    MakeMediumBurnableCharacter(inst,"torso")
    MakeMediumFreezableCharacter(inst)
    
    ------------------------------------------


    inst:AddComponent("inspectable")
    
    local brain = require "brains/dorfbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGdorf")
    

    inst.OnSave = onsave
    inst.OnLoad = onload    
    inst:ListenForEvent("attacked", OnAttacked)    
--    inst:ListenForEvent("newcombattarget", OnNewTarget)
    
    return inst
end

local function normal()
    local inst = common()
    getinventory(inst)
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,0.1)
    return inst
end

local function guard()
    local inst = common()
    getguardinventory(inst)
    inst.components.inventory.dropondeath=true
    return inst
end

local function kingguard()
    local inst = common()
    getkingguardinventory(inst)
    inst.components.inventory.dropondeath=true
    return inst
end

local function trader()
    local inst = common()
    inst.components.health:SetMaxHealth(TRADER_HEALTH)
    inst.components.combat:SetDefaultDamage(TRADER_DAMAGE)
    inst.components.lootdropper:SetLoot({ "goldnugget",  "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget", "goldnugget","meat","fa_dorf_crown"})

    inst:AddComponent("homeseeker")
--    skel.components.homeseeker:SetHome(inst)
    return inst
end


local function kingfn()
    local inst = common()
    inst.AnimState:SetBuild("fa_dorf_king")
    inst.components.inventory.dropondeath=true
    --TODO what the heck is special key?
    inst.components.lootdropper:SetLoot({ "goldnugget", "meat","fa_hat_dorfking"})
    getkinginventory(inst)
    return inst
end

return Prefab( "common/characters/fa_dorf", normal, assets, prefabs),
 Prefab( "common/characters/fa_dorf_merchant", trader, assets, prefabs),
Prefab( "common/characters/fa_dorf_king", kingfn, assets_king, prefabs),
Prefab( "common/characters/fa_dorf_king_guard", kingguard, assets, prefabs),
Prefab( "common/characters/fa_dorf_guard", guard, assets, prefabs)
