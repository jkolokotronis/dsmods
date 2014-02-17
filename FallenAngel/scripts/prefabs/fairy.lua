local assets=
{
    Asset("ANIM", "anim/fairy.zip"),
    Asset("ANIM", "anim/ghost.zip"),
    Asset("ANIM", "anim/ghost_wendy_build.zip"),
    Asset("SOUND", "sound/ghost.fsb"),
}

--local INTENSITY = 2
local function onnear(inst)
 end

local function onfar(inst)
end
--[[
local function ShouldKeepTarget(inst, target)
    return false 
end]]--
    

local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker

    if attacker and attacker:HasTag("player") then
--        inst.components.health:SetVal(0)
    else
        inst.components.combat:SetTarget(attacker)
    end
end

local function auratest(inst, target)

    if target == GetPlayer() then return false end

    local leader = inst.components.follower.leader
    if target.components.combat.target and ( target.components.combat.target == inst or target.components.combat.target == leader) then return true end
    if inst.components.combat.target == target then return true end

    if leader then
        if leader == target then return false end
        if target.components.follower and target.components.follower.leader == leader then return false end
    end

    return target:HasTag("monster") --or target:HasTag("prey")
end

local function fn(Sim)
    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.Transform:SetTwoFaced()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( .8, .5 )
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    inst.entity:AddPhysics()
 
--
    local light = inst.entity:AddLight()
    light:SetFalloff(0.9)
    light:SetIntensity(0.9)
    light:SetRadius(0.7)
    light:SetColour(155/255, 225/255, 250/255)
    light:Enable(true)
    
    inst:AddTag("fairy")
    inst:AddTag("pet")
    inst:AddTag("smallcreature")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
   
    MakeCharacterPhysics(inst, 1, .25)
    inst.Physics:SetCollisionGroup(COLLISION.FLYERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    
    
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetRayTestOnBB(true);


    anim:SetBank("ghost")
    anim:SetBuild("ghost_wendy_build")
--    anim:SetBank("fairy")
--    anim:SetBuild("butterfly")
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor:EnableGroundSpeedMultiplier(false)
--  inst.components.locomotor.groundspeedmultiplier = 10
	

    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 1
    inst.components.aura.ignoreallies = true
    inst.components.aura.auratestfn = auratest

    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(1, 2)
    inst.components.playerprox:SetOnPlayerNear(onnear)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    
--    inst.components.locomotor.walkspeed = GetPlayer().components.locomotor.groundspeedmultiplier*GetPlayer().components.locomotor.walkspeed*GetPlayer().components.locomotor.fastmultiplier
--    inst.components.locomotor.runspeed = GetPlayer().components.locomotor.groundspeedmultiplier*GetPlayer().components.locomotor.walkspeed*GetPlayer().components.locomotor.fastmultiplier+4
--  inst.components.locomotor.isrunning = true
    inst.components.locomotor.walkspeed = TUNING.WILSON_RUN_SPEED
    inst.components.locomotor.runspeed = TUNING.WILSON_RUN_SPEED*2
    inst.components.locomotor:SetTriggersCreep(false)

    inst:SetStateGraph("SGghost")
--    inst:SetStateGraph("SGfairy")
    
    inst:AddComponent("inspectable")
        
    inst:AddComponent("follower")

    ---------------------       
    inst:AddTag("FX")
    inst:AddTag("companion")
    inst:AddTag("notraptrigger")
    inst:AddTag("light")
    ------------------
    inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND
    inst.components.combat.playerdamagepercent = TUNING.ABIGAIL_DMG_PLAYER_PERCENT
    inst.components.combat:SetRetargetFunction(3, Retarget)
--[[
	inst:AddComponent("combat")
	inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
	inst.components.combat.canbeattackedfn = function(self, attacker) 
		if attacker == GetPlayer() then 
			return false 
		end
		return true
	end
    ------------------]]--
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TUNING.ABIGAIL_HEALTH)
    inst.components.health:StartRegen(5,5)
    inst.components.health:SetInvincible(false)

    local brain = require "brains/abigailbrain"
    inst:SetBrain(brain)

    
    return inst
end

return Prefab( "common/fairy", fn, assets)
