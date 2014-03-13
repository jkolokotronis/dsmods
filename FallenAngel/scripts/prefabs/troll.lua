
local assets=
{
    Asset("ANIM", "anim/PlaceholderBeast.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}

local TROLL_HEALTH=300
local TROLL_DAMAGE=100
local TROLL_ATTACK_PERIOD=1.5

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("troll")
    end)
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
    shadow:SetSize( 7, 4 )
    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(2,2, 2)
    
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("troll")
    inst:AddTag("hostile")
    
    MakeCharacterPhysics(inst, 20, 0.5)
     
--    inst:AddTag("largecreature")
    anim:SetBank("PlaceholderBeast")
    anim:SetBuild("PlaceholderBeast") 

--    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 4


    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TROLL_HEALTH)
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED
    
    
    inst:AddComponent("combat")
    inst.components.combat:SetDefaultDamage(TROLL_DAMAGE)
    inst.components.combat:SetAttackPeriod(TROLL_ATTACK_PERIOD)
    inst.components.combat:SetRange(3)
--    inst.components.combat.hiteffectsymbol = "pig_torso"
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)

    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"monstermeat",  "monstermeat"})
--    inst:AddComponent("inspectable")
    

    inst:AddComponent("eater")
--    inst.components.eater:SetOmnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    inst:ListenForEvent("attacked", OnAttacked)

    inst:SetStateGraph("SGtroll")
    local brain = require "brains/trollbrain"
    inst:SetBrain(brain)

--     MakeMediumFreezableCharacter(inst, "pig_torso")
--    MakeMediumBurnableCharacter(inst, "pig_torso")

    return inst
end

return Prefab( "common/troll", fn, assets)
