
local batdevil_assets={
    Asset("ANIM", "anim/fa_batdevil.zip"),
}
local hellbat_assets={
    Asset("ANIM", "anim/fa_hellbat.zip"),
}
local hellhound_assets={
    Asset("ANIM", "anim/fa_hellhound.zip"),
}
local hellworm_assets={
    Asset("ANIM", "anim/fa_hellworm.zip"),
}


local function OnEat(inst, food)
    
    if food.components.edible and food.components.edible.foodtype == "MEAT" then
        local poo = SpawnPrefab("spoiled_food")
        poo.Transform:SetPosition(inst.Transform:GetWorldPosition())        
    end

end    


local function RetargetFn(inst)
    local invader = FindEntity(inst, TUNING.MERM_TARGET_DIST, function(guy)
        return guy:HasTag("character") and not guy:HasTag("fa_demon")
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

local function fn(name)

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()

    local sound = inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    inst.Transform:SetFourFaced()

    inst.entity:AddPhysics()
    inst:AddTag("fa_demon")
    inst:AddTag("scarytoprey")
    inst:AddTag("monster")
    inst:AddTag("hostile")
    inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")
    inst:AddComponent("health")

    inst:AddComponent("sanityaura")
    return inst
end

local function batdevil(Sim)
	local inst=fn()
    shadow:SetSize( 2.5, 1.5 )
--    inst.Transform:SetTwoFaced()
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
--    light:Enable(true)


    anim:SetBank("wilson")
    anim:SetBuild("fa_batdevil")
    anim:PlayAnimation("idle")
    
    anim:Hide("ARM_carry")
    anim:Hide("hat")
    anim:Hide("hat_hair")

    MakeCharacterPhysics(inst, 20, .5)
 
inst:AddComponent("eater")
    inst.components.eater:SetCarnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true 
    inst.components.eater:SetOnEatFn(OnEat)

    
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,0.05)

    inst:AddComponent("inventory")

    inst:AddComponent("locomotor") 
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED

    inst:AddComponent("follower")
    
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("knownlocations")
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(TUNING.HOUND_DAMAGE)
    inst.components.combat:SetAttackPeriod(2)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
--    inst.components.combat:SetKeepTargetFunction(KeepTarget)

    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.DEATH]=1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=-0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.HOLY]=-0.4
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=-0.1
    inst.components.inventory.dropondeath = true

    inst:SetStateGraph("SGskeletonspawn")

    local brain = require "brains/skeletonspawnbrain"
    inst:SetBrain(brain)

    inst:ListenForEvent("attacked", OnAttacked)
    
    return inst
end

return     Prefab("common/fa_batdevil", fa_batdevil, batdevil_assets)