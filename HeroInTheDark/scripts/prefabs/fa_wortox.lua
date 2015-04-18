
local assets = {
        Asset( "ANIM", "anim/beard.zip" ),
        Asset( "ANIM", "anim/wortox.zip" ),
-- i need to read through memfix again, I should lazy load this only on transform, but the only lazy thing here is me
        Asset( "ANIM", "anim/goblin.zip" ),
}
local prefabs = {}

local TARGET_DISTANCE=35
local NPC_RING_COST=10

local function RetargetFn(inst)

    local defenseTarget = inst
    local invader=nil
    local home = inst.components.homeseeker and inst.components.homeseeker.home
    if home and inst:GetDistanceSqToInst(home) < TUNING.MERM_DEFEND_DIST*TUNING.MERM_DEFEND_DIST then
       invader = FindEntity(home, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") 
    end)
    end
    if not invader then
        invader = FindEntity(inst, TARGET_DISTANCE, function(guy)
        return guy:HasTag("character") 
        end)
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


local function OnBlocked(owner,data) 
    local attacker = data and data.attacker
    if attacker and owner.components.combat:CanTarget(attacker) then
        owner.components.combat:SetTarget(attacker)
    end
    if(attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
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

--    inst.OnLoad = onloadfn
--    inst.OnSave = onsavefn

    inst.entity:AddPhysics()
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "wortox.png" )
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(1)
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

        inst.components.eater:SetCarnivore(true)
    inst.components.eater:SetCanEatHorrible()
        inst.components.eater.monsterimmune = true
        inst.components.eater.strongstomach = true

    

    inst:AddComponent("inventory")
--    inst:AddComponent("sanity")
    
    inst:AddComponent("lootdropper")

    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
--    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
    inst.components.locomotor.runspeed =5

    inst:AddComponent("follower")
    
    inst:AddComponent("sanityaura")
    inst.components.sanityaura.aura = -TUNING.SANITYAURA_MED

    inst:AddComponent("inspectable")
    inst:AddComponent("knownlocations")
        
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(40)
    inst.components.combat:SetAttackPeriod(1)

    inst:AddComponent("health")
    inst.components.health.fa_dodgechance=0.2
    inst.components.health:SetMaxHealth(900)
        inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
        inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-1

    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_howl_LP", "howl")
        inst:ListenForEvent("onattackother",demonattack) 

        inst:ListenForEvent("attacked",OnBlocked,inst)
        inst:ListenForEvent("blocked",OnBlocked, inst)
    
    return inst
end

local function mob()
    local inst=fn()
    inst.Transform:SetScale(1.25,1.25, 1.25)
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst:SetStateGraph("SGfa_wortox")    
    local brain = require "brains/orcbrain"
    inst:SetBrain(brain)
    return inst
end

local function king()
    local inst=fn()
    inst.Transform:SetScale(3.0,3,3)
    inst.components.locomotor.runspeed =2
    inst.components.combat:SetRetargetFunction(1, RetargetFn)
    inst.components.combat:SetKeepTargetFunction(KeepTargetFn)
    inst:SetStateGraph("SGfa_wortox")    
    local brain = require "brains/cursedpigkingbrain"
    inst.components.lootdropper:SetLoot({ "fa_ring_demon","meat","meat","meat","meat","meat","meat","meat","meat","meat","meat","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget"
        ,"goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget","goldnugget"})
    inst:SetBrain(brain)
    inst.components.health:SetMaxHealth(5000)
    inst.components.combat:SetDefaultDamage(150)
    return inst
end

local function npc()
    local inst=fn()

    inst.diamondcount=0

    inst:RemoveTag("monster")

    inst.components.lootdropper:SetLoot({ "fa_ring_demon"})

    inst.components.health:SetInvincible(true)
    inst:AddTag("notarget")

    local deathfn=function()
        inst.components.lootdropper:DropLoot()
    end

    inst:ListenForEvent("death",deathfn)

    inst:AddComponent("talker")

    inst:AddComponent("trader")

    inst.components.trader:SetAcceptTest(
        function(inst, item)
        --for some silly reason it gives just a single entry, so i have to force remove the rest
        --this is silly hack but its still better than hacking the accept logic of component's function to do what I want?
        --not convinced
        local test=item.prefab=="fa_diamondpebble" and item.components.stackable.stacksize>=10 
        if(test)then
            local extra=item.components.stackable.stacksize-9
            item.components.stackable.stacksize=extra
        end
        return test
    end)

    inst.components.trader.onaccept =function(inst, giver, item)
        inst:RemoveEventCallback("death", deathfn)
        inst.persists=false

        local curse=SpawnPrefab("fa_ring_demon")
        giver.components.inventory:GiveItem(curse)
        giver.components.inventory:Equip(curse)
        inst.AnimState:SetBuild("goblin")
        local talk=GetString(inst.prefab, "FREE_AT_LAST")
        if(talk and inst.components.talker) then inst.components.talker:Say(talk) end
        inst:DoTaskInTime(5,function()
            local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( inst.Transform:GetWorldPosition())
            inst:Remove()
        end)
    end
    inst.components.trader.onrefuse = function(inst, giver, item)
        local talk=nil
        if item.prefab=="fa_diamondpebble" and item.components.stackable.stacksize<10 then 
            talk=GetString(inst.prefab, "NOT_ENOUGH_DIAMONS")
        else
            talk=GetString(inst.prefab, "WRONG_ITEM")
        end
        if(talk and inst.components.talker) then inst.components.talker:Say(talk) end
    end

    return inst
end

return Prefab( "common/fa_cursedwortox", mob, assets),
Prefab( "common/fa_cursedpigking", king, assets),
Prefab( "common/fa_wortox_npc", npc, assets)