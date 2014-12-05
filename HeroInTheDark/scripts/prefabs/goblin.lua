
local assets=
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

    Asset("ANIM", "anim/goblin.zip")
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

        Asset( "ANIM", "anim/bluegoblin.zip" ),
        Asset("ANIM","anim/betterbarrier.zip")
}

local assets_red={
        Asset( "ANIM", "anim/fa_redgoblin.zip" ),
    
}

local prefabs =
{
    "fa_goblinskin",
"hat_goblinking",
"hat_pot",
"firewallwand",
"fa_spell_magicmissile"
}

local YELL_TIMEOUT=30
local GOBLIN_HEALTH=400
local GOBLIN_DAMAGE=30
local GOBLIN_ATTACK_PERIOD=2
local GOBLIN_RUN_SPEED=6
local GOBLIN_WALK_SPEED=3

local REDGOBLIN_HEALTH=600
local REDGOBLIN_DAMAGE=50

local BB_TIMER=15
local BB_COOLDOWN=60

local MAX_TARGET_SHARES = 5
local TARGET_DISTANCE = 25
local SHARE_TARGET_DIST = 30


    local LOOTTABLE={
        nightmarefuel = 1,
        amulet = 1,
        gears = 1,
        redgem = 1,
        bluegem = 1
    }
    local WEIGHT=5+NUM_TRINKETS
    for i=1,NUM_TRINKETS do
        LOOTTABLE["trinket_"..i]=1
    end

    


local onloadfn = function(inst, data)
    if(data)then
        inst.loadedSpawn=data.loadedSpawn
        inst.fa_bladebarrier_cooldown=data.fa_bladebarrier_cooldown
    end
end

local onsavefn = function(inst, data)
    data.loadedSpawn=inst.loadedSpawn
    data.fa_bladebarrier_cooldown=inst.fa_bladebarrier_cooldown
end
local function GetInventoryNormal(inst)
 inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        if(math.random()<=0.3)then
            local item=SpawnPrefab("hat_pot")
            inst.components.inventory:Equip(item)
        end
         inst.loadedSpawn=true
    end)
end

local function GetInventoryGuard1(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("armorwood")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("spear")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("footballhat")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end
   
local function GetInventoryGuard2(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("armormarble")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("spear")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("slurtlehat")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end

local function GetInventoryGuard3(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("armor_sanity")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("nightsword")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("slurtlehat")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end

local function GetInventoryWizard(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
        local item=SpawnPrefab("armorgrass")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("firewallwand_insta")
        inst.components.inventory:Equip(item)
  --  item.components.finiteuses:SetMaxUses(9999)
  --  item.components.finiteuses:SetUses(9999)
        item=SpawnPrefab("fa_spell_magicmissile")
        inst.components.inventory:Equip(item)
  --  item.components.finiteuses:SetMaxUses(9999)
  --  item.components.finiteuses:SetUses(9999)
         inst.loadedSpawn=true
    end)
end

local function GetInventoryKing(inst)
    inst:DoTaskInTime(0,function()
        if(inst.loadedSpawn)then
            return
        end
         local item=SpawnPrefab("hat_goblinking")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("armorruins")
        inst.components.inventory:Equip(item)
        item=SpawnPrefab("ruins_bat")
        inst.components.inventory:Equip(item)
         inst.loadedSpawn=true
    end)
end

local function RetargetFn(inst)
    local defenseTarget = inst
    local invader=nil
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
       invader = FindEntity(home, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") and not guy:HasTag("goblin")
    end)
    end
    if not invader then
        invader = FindEntity(inst, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") and not guy:HasTag("goblin")
        end)
    end
    if(invader and not inst.components.combat.target)then--invader~=inst.components.combat.target)then
        if not(inst.fa_yelltime and (GetTime()-inst.fa_yelltime)<YELL_TIMEOUT)then
            inst.fa_yelltime=GetTime()
            inst.SoundEmitter:PlaySound("fa/mobs/goblin/goblin_yell")
        end
    end
    return invader
end

local function KingRetargetFn(inst)
    local target=RetargetFn(inst)
    if(target and (target:HasTag("player") or target:HasTag("pet") or target:HasTag("companion")) and not inst.fa_bladebarrier and not (inst.fa_bladebarrier_cooldown and inst.fa_bladebarrier_cooldown>GetTime()))then
        local variables={}
        variables.tags={}
        variables.blocktags={"goblin","INLIMBO"}
        BladeBarrierSpellStartCaster(inst,BB_TIMER,variables)
        inst.fa_bladebarrier_cooldown=BB_COOLDOWN+GetTime()
        inst.fa_bbtask=inst:DoTaskInTime(BB_COOLDOWN,KingRetargetFn)
    end
    return target
end

local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
               and home:GetDistanceSqToInst(inst) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST
    end
    return inst.components.combat:CanTarget(target)     
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker and inst.components.combat:CanTarget(attacker) then
        inst.components.combat:SetTarget(attacker)
        local targetshares = MAX_TARGET_SHARES
        if inst.components.homeseeker and inst.components.homeseeker.home then
            local home = inst.components.homeseeker.home
            if home and home.components.childspawner and inst:GetDistanceSqToInst(home) <= SHARE_TARGET_DIST*SHARE_TARGET_DIST then
                targetshares = targetshares - home.components.childspawner.childreninside
                home.components.childspawner:ReleaseAllChildren(attacker)
            end
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude)
                return dude.components.homeseeker
                       and dude.components.homeseeker.home
                       and dude.components.homeseeker.home == home
            end, targetshares)
        end
    end
end

local function OnEat(inst, food)
    
    if food.components.edible and food.components.edible.foodtype == "MEAT" then
        local poo = SpawnPrefab("poop")
        poo.Transform:SetPosition(inst.Transform:GetWorldPosition())        
    end

end    

local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2, 1 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1,1, 1)
	
    inst:AddTag("pickpocketable")
	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("goblin")
    inst:AddTag("hostile")
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_evil")
	
    MakeCharacterPhysics(inst, 10, 0.5)
     
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("goblin")
        inst.AnimState:Hide("hat_hair")
         inst.AnimState:Hide("ARM_carry")
         inst.AnimState:Hide("hat")
     inst.AnimState:PlayAnimation("idle")

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst:AddComponent("talker")
--    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0,-400,0)

    inst:AddComponent("eater")
--wah screw this     inst.components.eater:SetVegetarian()
    inst.components.eater.foodprefs = { "MEAT", "VEGGIE"}
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("sleeper")
    inst.components.sleeper.sleeptestfn = function() return false end
    inst.components.sleeper.waketestfn = function() return true end

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed=GOBLIN_WALK_SPEED
    inst.components.locomotor.runspeed = GOBLIN_RUN_SPEED
    inst:SetStateGraph("SGgoblin")


    local brain = require "brains/goblinbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(GOBLIN_HEALTH)
    
    inst:AddComponent("knownlocations")
    inst:AddComponent("inventory")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(GOBLIN_DAMAGE)
    inst.components.combat:SetAttackPeriod(GOBLIN_ATTACK_PERIOD)
    inst.components.combat:SetRange(3)
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot( "monstermeat",0.5)
    inst.components.lootdropper:AddFallenLootTable(LOOTTABLE,WEIGHT,0.1)
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,0.1)

    inst:AddComponent("inspectable")
    inst:ListenForEvent("attacked", OnAttacked)

     MakeMediumFreezableCharacter(inst, "goblin")
    inst.components.freezable:SetResistance(1)
     MakeMediumBurnableCharacter(inst, "goblin")

    return inst
end

local function normal()
local inst=common()
    GetInventoryNormal(inst)
     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
    inst.components.lootdropper:AddChanceLoot( "fa_goblinskin",0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.1
    return inst
end

local function fnguards()
    local inst=common()
     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
    inst.components.lootdropper:AddChanceLoot( "fa_goblinskin",0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.1
    return inst
end

local function fnguard1()
    local inst=fnguards()
    GetInventoryGuard1(inst)
    return inst
end

local function fnguard2()
    local inst=fnguards()
    GetInventoryGuard2(inst)
    return inst
end

local function fnguard3()
    local inst=fnguards()
    GetInventoryGuard3(inst)
    return inst
end

local onhitother=function(inst,data)
    local damage=data.damage
    if(damage and damage>0 and inst:HasTag("notarget"))then
        leavestealth(inst)
    end
end

local function wizattack(inst,data)
    print("onattack?",data.weapon, data.projectile)
    --stupid thing is sending 2 things
    if(not data.projectile)then
    inst:DoTaskInTime(2,function()
    local inv=inst.components.inventory
    local current=inv:GetEquippedItem( EQUIPSLOTS.HANDS)
    local newitem=nil
    if(current and current.prefab=="firewallwand_insta")then
        newitem=inv:FindItem(function(item) return item and item.prefab=="fa_spell_magicmissile" end)
    else
        newitem=inv:FindItem(function(item) return item and item.prefab=="firewallwand_insta" end)
    end
    if(newitem)then
        if(current)then
            inv:Unequip(current)
        end
        inv:Equip(newitem)
    end
    end)
    end   
end

local function fnwiz()
    local inst=common()
    GetInventoryWizard(inst)
     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)
    inst.components.locomotor.runspeed = 7
    inst.components.combat:SetAttackPeriod(7)
    inst:ListenForEvent("onattackother", wizattack)
--    inst:ListenForEvent("onmissother", self.onattackfn)
    local brain = require "brains/goblinwizardbrain"
    inst:SetBrain(brain)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_14",0.4)
    inst.components.lootdropper:AddChanceLoot( "fa_goblinskin",0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.3
    return inst
end

local function fnking()
    local inst=common()
    inst.AnimState:SetBank("wilson")
    inst.AnimState:SetBuild("bluegoblin")
    inst.AnimState:PlayAnimation("idle")
    inst.components.lootdropper:AddChanceLoot( "fa_goblinskin",0.05)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.locomotor.walkspeed=6
    inst.components.locomotor.runspeed = 6
    inst.components.health:SetMaxHealth(1600)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.3
    GetInventoryKing(inst)
    inst.components.combat:SetRetargetFunction(1, KingRetargetFn)
    local brain = require "brains/goblinkingbrain"
    inst:SetBrain(brain)
--     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys2,FALLENLOOTTABLE.TABLE_KEYS2_WEIGHT,0.15)
    inst.components.lootdropper:SetLoot({ "goblinkinghead_item","fa_scroll_5","fa_scroll_5","fa_key_swift"})
    return inst
end

local function fnred()
local inst=common()
     inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)
    inst.components.lootdropper:AddChanceLoot("fa_scroll_1",0.05)
    inst.components.lootdropper:AddChanceLoot( "fa_redgoblinskin",0.05)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1
    inst.components.combat:SetDefaultDamage(REDGOBLIN_DAMAGE)
    inst.components.health:SetMaxHealth(REDGOBLIN_HEALTH)
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("fa_redgoblin")
    return inst
end

return Prefab( "common/goblin", normal, assets),
Prefab( "common/fa_goblin_guard_1", fnguard1, assets),
Prefab( "common/fa_goblin_guard_2", fnguard2, assets),
Prefab( "common/fa_goblin_guard_3", fnguard3, assets),
Prefab( "common/fa_goblin_wiz_1", fnwiz, assets),
Prefab( "common/fa_goblin_king_1", fnking, assets_king),
Prefab( "common/fa_redgoblin",fnred,assets_red)