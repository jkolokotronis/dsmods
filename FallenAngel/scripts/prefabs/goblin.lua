
local assets=
{
	Asset("ANIM", "anim/orc.zip"),
    Asset("ANIM", "anim/goblin.zip"),
	Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}

local GOBLIN_HEALTH=400
local GOBLIN_DAMAGE=30
local GOBLIN_ATTACK_PERIOD=1
local GOBLIN_RUN_SPEED=6
local GOBLIN_WALK_SPEED=3

local MAX_TARGET_SHARES = 5
local TARGET_DISTANCE = 15
local SHARE_TARGET_DIST = 40


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
    if(invader and invader~=inst.components.combat.target)then
        inst.SoundEmitter:PlaySound("fa/goblin/goblin_yell")
    end
    return invader
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

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    local physics = inst.entity:AddPhysics()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
	shadow:SetSize( 2, 1 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1,1, 1)
	
	inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("goblin")
    inst:AddTag("hostile")
	
    MakeCharacterPhysics(inst, 10, 0.5)
     
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("goblin")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:Hide("hat_hair")
         inst.AnimState:Hide("ARM_carry")
         inst.AnimState:Hide("hat")
     inst.AnimState:PlayAnimation("idle")


    inst:AddComponent("eater")
--wah screw this     inst.components.eater:SetVegetarian()
    inst.components.eater.foodprefs = { "MEAT", "VEGGIE"}
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)


    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed=GOBLIN_WALK_SPEED
    inst.components.locomotor.runspeed = GOBLIN_RUN_SPEED
    inst:SetStateGraph("SGgoblin")


    local brain = require "brains/goblinbrain"
    inst:SetBrain(brain)
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(GOBLIN_HEALTH)
    
    inst:AddComponent("inventory")
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(GOBLIN_DAMAGE)
    inst.components.combat:SetAttackPeriod(GOBLIN_ATTACK_PERIOD)
    inst.components.combat:SetRange(3)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:AddChanceLoot( "monstermeat",0.5)
    inst.components.lootdropper:AddFallenLootTable(LOOTTABLE,WEIGHT,0.1)

    inst:AddComponent("inspectable")
    inst:ListenForEvent("attacked", OnAttacked)

     MakeMediumFreezableCharacter(inst, "goblin")
     MakeMediumBurnableCharacter(inst, "goblin")

    return inst
end

return Prefab( "common/goblin", fn, assets)
