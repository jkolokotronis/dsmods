
local assets=
{
    Asset("ANIM", "anim/PlaceholderBeast.zip"),
    Asset("SOUND", "sound/hound.fsb"),
}

local prefabs =
{

}

local TROLL_HEALTH=3000
local TROLL_DAMAGE=100
local TROLL_ATTACK_PERIOD=1.5
local TROLL_TARGET_RANGE=10
local TROLL_REGEN_TIMER=10

local function RetargetFn(inst)
    local defenseTarget = inst
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.TROLL_TARGET_RANGE*TUNING.TROLL_TARGET_RANGE then
        defenseTarget = home
    end
    local invader = FindEntity(defenseTarget or inst, TROLL_TARGET_RANGE, function(guy)
        return guy:HasTag("character") and not guy:HasTag("troll")
    end)
    return invader
end
local function KeepTargetFn(inst, target)
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home then
        return home:GetDistanceSqToInst(target) < TUNING.TROLL_TARGET_RANGE*TUNING.TROLL_TARGET_RANGE
               and home:GetDistanceSqToInst(inst) < TUNING.TROLL_TARGET_RANGE*TUNING.TROLL_TARGET_RANGE
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
    inst:AddTag("fa_evil")
    inst:AddTag("fa_humanoid")
    inst:AddTag("fa_giant")
    
    MakeCharacterPhysics(inst, 20, 0.5)
     
--    inst:AddTag("largecreature")
    anim:SetBank("PlaceholderBeast")
    anim:SetBuild("PlaceholderBeast") 

--    inst.AnimState:PlayAnimation('idle',true)
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = 4


    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TROLL_HEALTH)
    inst.components.health:StartRegen(10, 2)

    inst.regenerating=false
    local old_dodelta=inst.components.health.DoDelta
    local healthmod=inst.components.health
    function healthmod:DoDelta (amount, overtime, cause, ignore_invincible)
        print("troll health",self.currenthealth,amount,cause)
        if(amount<0)then
            local realamount = amount - (amount * self.absorb)
            if(self.inst.regenerating)then
                if(cause ~= "fire")then
                --ignore
                    return
                else
                    return old_dodelta(self,amount,overtime,cause,ignore_invincible)
                end
            else
                local delta=self.currenthealth+realamount
                print("real damage", delta)
                if(delta<=0 and cause ~= "fire")then
                    self.inst.regenerating=true
                    print("going into regen phase")
                    self.inst.sg:GoToState("regen")
                    self.inst.regenerateTask=self.inst:DoTaskInTime(TROLL_REGEN_TIMER, function()
                        if(not self:IsDead() and self.currenthealth<TROLL_HEALTH/2)then
                            print("regeneration complete")
                            self:SetVal(TROLL_HEALTH/2,"regen")
                            self.inst.regenerating=false
                        end
                    end)
                    return old_dodelta(self,-self.currenthealth+1,overtime,cause,ignore_invincible)
                else
                    return old_dodelta(self,amount,overtime,cause,ignore_invincible)
                end
            end
        else 
            return old_dodelta(self,amount,overtime,cause,ignore_invincible)
        end
    end
    
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
    inst:AddComponent("inventory")
    inst.components.lootdropper:SetLoot({"monstermeat",  "monstermeat"})
--    inst:AddComponent("inspectable")
    

    inst:AddComponent("eater")
    inst.components.eater:SetOmnivore()
--    inst.components.eater:SetCarnivore()
    inst.components.eater:SetCanEatHorrible()
    inst.components.eater.strongstomach = true -- can eat monster meat!
    inst.components.eater:SetOnEatFn(OnEat)

    inst:AddComponent("sleeper")
    inst.components.sleeper.sleeptestfn = function() return false end
    inst.components.sleeper.waketestfn = function() return true end

    inst:ListenForEvent("attacked", OnAttacked)

    inst:SetStateGraph("SGtroll")
    local brain = require "brains/trollbrain"
    inst:SetBrain(brain)

    MakeLargeBurnableCharacter(inst, "troll",Vector3(10, 10, 1))
    MakeLargeFreezableCharacter(inst, "troll",Vector3(10, 10, 1))

    return inst
end

return Prefab( "common/fa_troll", fn, assets)
