
local MakePlayerCharacter = require "prefabs/player_common"

local RageBuff = require "widgets/ragebuff"

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

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/barb.zip" ),
}
local prefabs = {}

local BASE_MS=1.25*TUNING.WILSON_RUN_SPEED
local RAGE_MS=1.75*TUNING.WILSON_RUN_SPEED
local RAGE_FIREDMG=0.5
local BASE_FIREDMG
local BASE_FREEZING
local DAMAGE_MULT=1.5
local EFFECTIVENESS_MULT=1.5
local RAGE_SANITY_DELTA=-5
local RAGE_HUNGER_DELTA=-10
local RAGE_PERIOD=2

local def_attack_period
local ref


local function onhpchange(inst, data)

	local current=inst.components.health.currenthealth
	local mult=0.005
	if(current<100) then
		mult=0.01
	end
	inst.components.combat.damagemultiplier=DAMAGE_MULT+mult*(inst.components.health.maxhealth-current)
	
end


local function rageProc(inst)

	inst.components.sanity:DoDelta(RAGE_SANITY_DELTA,false)
	inst.components.hunger:DoDelta(RAGE_HUNGER_DELTA,false,false)

end

local function rageStart(inst)
	
	inst.components.locomotor.runspeed=RAGE_MS
	inst.components.temperature.hurtrate=BASE_FREEZING/2.0
	inst.components.health.fire_damage_scale = RAGE_FIREDMG
	inst.components.combat.min_attack_period=def_attack_period/2.0
	inst.task = inst:DoPeriodicTask(RAGE_PERIOD, function() rageProc(inst) end)
end

local function rageEnd(inst)
	inst.components.locomotor.runspeed=BASE_MS
	inst.components.health.fire_damage_scale=BASE_FIREDMG
	inst.components.temperature.hurtrate=BASE_FREEZING
	inst.components.combat.min_attack_period=def_attack_period
	if inst.task then inst.task:Cancel() inst.task = nil end
end

local fn = function(inst)
	ref=inst
		-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	
	
	def_attack_period=inst.components.combat.min_attack_period
	BASE_FIREDMG=inst.components.health.fire_damage_scale
	BASE_FREEZING=inst.components.temperature.hurtrate
	
	
	inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetRate(2.0*TUNING.WILSON_HUNGER_RATE)
	inst.components.hunger:SetMax(250)
	inst.components.sanity:SetMax(150)
	inst.components.locomotor.runspeed=BASE_MS

	inst.StatusDisplaysInit = function (class)
        class.rage = class:AddChild(RageBuff(class.owner))
        class.rage:SetPosition(0,-100,0)
        class.rage:SetOnClick(function(state) 
        	print("onclick",state) 
        	if(state and state=="on") then
        		rageStart(inst)
        	else
        		rageEnd(inst)
        	end
        end)
    end

	
	inst:ListenForEvent("healthdelta", onhpchange)
--	inst:ListenForEvent("statusDisplaysInit",BarbStatusDisplay)

	local old_mine=ACTIONS.MINE.fn
	local old_chop=ACTIONS.CHOP.fn

	ACTIONS.MINE.fn = function(act)
		if(act.doer:HasTag("player")) then
			if act.target.components.workable and act.target.components.workable.action == ACTIONS.MINE then
    	    	local numworks = 1
    	    	if act.invobject and act.invobject.components.tool then
           			numworks = act.invobject.components.tool:GetEffectiveness(ACTIONS.MINE)
        		elseif act.doer and act.doer.components.worker then
            		numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.MINE)
        		end
        		act.target.components.workable:WorkedBy(act.doer, numworks*EFFECTIVENESS_MULT)
        		return true
        	end
		end
		return old_mine(act)
	end

	ACTIONS.CHOP.fn = function(act)
		if(act.doer:HasTag("player")) then
    		if act.target.components.workable and act.target.components.workable.action == ACTIONS.CHOP then
        		local numworks = 1
		        if act.invobject and act.invobject.components.tool then
        		    numworks = act.invobject.components.tool:GetEffectiveness(ACTIONS.CHOP)
        		elseif act.doer and act.doer.components.worker then
            		numworks = act.doer.components.worker:GetEffectiveness(ACTIONS.CHOP)
        		end
        		print("efff")
        		act.target.components.workable:WorkedBy(act.doer, numworks*EFFECTIVENESS_MULT)
        		return true
        	end
        end
        return old_chop(act)
	end
	
	local base_eater=inst.components.eater
	
	inst.components.eater.Eat=function(inst, food)
	
		if base_eater:CanEat(food) then
		local hpdelta=food.components.edible:GetHealth(base_eater.inst)
		print(inst, food.components.edible.foodtype)
			if (hpdelta>0 or not (food.components.edible.foodtype=="MEAT")) then
				base_eater.inst.components.health:DoDelta(hpdelta, nil, food.prefab)
			end

    	    base_eater.inst.components.hunger:DoDelta(food.components.edible:GetHunger(base_eater.inst))
        
        	local sanity_delta=food.components.edible:GetSanity(base_eater.inst)
        	if(sanity_delta>0 or not (food.components.edible.foodtype=="MEAT")) then
				base_eater.inst.components.sanity:DoDelta(sanity_delta)
        	end
	        base_eater.inst:PushEvent("oneat", {food = food})
    	    if base_eater.oneatfn then
        	    base_eater.oneatfn(base_eater.inst, food)
       		end
        
       		if food.components.edible then
            	food.components.edible:OnEaten(base_eater.inst)
        	end
        
        	if food.components.stackable and food.components.stackable.stacksize > 1 then
        	    food.components.stackable:Get():Remove()
       		else
            	food:Remove()
        	end
        
        	base_eater.lasteattime = GetTime()
        
       		base_eater.inst:PushEvent("oneatsomething", {food = food})
        
       		return true
    	end	
    
    end
--	StatusDisplaysInit(StatusDisplays)
--[[
	StatusDisplays.rage = StatusDisplays:AddChild(RageBuff(StatusDisplays.owner))
        StatusDisplays.rage:SetPosition(0,-100,0)
        StatusDisplays.rage:SetOnClick(function(state) 
        	print(state) 
        	if(state and state=="on") then
        		rageStart(ref)
        	else
        		rageEnd(ref)
        	end
        end)  
]]--
end


return MakePlayerCharacter("barb", prefabs, assets, fn)
