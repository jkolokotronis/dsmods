
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
        Asset( "ANIM", "anim/barbarian.zip" ),
}
local prefabs = {}

local BASE_MS=1.25*TUNING.WILSON_RUN_SPEED
local RAGE_MS_DELTA=0.5*TUNING.WILSON_RUN_SPEED
local RAGE_FIREDMG=0.75
local RAGE_FIREDMG2=0.5
local BASE_FIREDMG
local BASE_FREEZING
local DAMAGE_MULT=1.5
local EFFECTIVENESS_MULT=1.5
local RAGE_SANITY_DELTA=-5
local RAGE_HUNGER_DELTA=-10
local RAGE_PERIOD=2

local HEALTH_PER_LEVEL=5
local HUNGER_PER_LEVEL=1

local def_attack_period
local ref

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL*(level-1)
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL
    if(level==3)then
        inst.components.eater.strongstomach = true 
    elseif level==5 then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    elseif level==6 then

    elseif level==9 then
        inst.rageBuff:Show()
    elseif level==10 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==15 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==18 then

    elseif level==19 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    elseif level==20 then

    end

end

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
	if(inst.components.xplevel.level<20)then
        inst.components.locomotor.runspeed=RAGE_MS_DELTA+inst.components.locomotor.runspeed
       inst.components.temperature.hurtrate=BASE_FREEZING/1.5
       inst.components.health.fire_damage_scale = RAGE_FIREDMG
       inst.components.combat.min_attack_period=def_attack_period/1.3       
    else
	   inst.components.locomotor.runspeed=RAGE_MS_DELTA+inst.components.locomotor.runspeed
	   inst.components.temperature.hurtrate=BASE_FREEZING/2.0
	   inst.components.health.fire_damage_scale = RAGE_FIREDMG2
	   inst.components.combat.min_attack_period=def_attack_period/1.5	    
    end
        inst.task = inst:DoPeriodicTask(RAGE_PERIOD, function() rageProc(inst) end)
end

local function rageEnd(inst)
	inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-RAGE_MS_DELTA
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


        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("barbarian")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:Hide("hat_hair")

    inst:AddComponent("xplevel")


	inst.newControlsInit = function (class)
        inst.rageBuff=RageBuff(class.owner)
        class.rage = class:AddChild(inst.rageBuff)
        class.rage:SetPosition(0,0,0)
        class.rage:SetOnClick(function(state) 
        	print("onclick",state) 
        	if(state and state=="on") then
        		rageStart(inst)
        	else
        		rageEnd(inst)
        	end
        end)
         if(inst.components.xplevel.level<9)then
            inst.rageBuff:Hide()
        end
    end

	
	inst:ListenForEvent("healthdelta", onhpchange)
    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)
--	inst:ListenForEvent("statusDisplaysInit",BarbStatusDisplay)

	local old_mine=ACTIONS.MINE.fn
	local old_chop=ACTIONS.CHOP.fn

	ACTIONS.MINE.fn = function(act)
		if(act.doer:HasTag("player") and act.doer.components.xplevel and act.doer.components.xplevel.level>=6) then
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
		if(act.doer:HasTag("player") and act.doer.components.xplevel and act.doer.components.xplevel.level>=6) then
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
    local old_eat=inst.components.eater.Eat
	function base_eater:Eat ( food)
        print(self, food)
	    if(self.inst.components.xplevel.level<3 or food.components.edible.foodtype~="MEAT") then
            return old_eat(self,food)
        else

		
        if self:CanEat(food) then
		local hpdelta=food.components.edible:GetHealth(self.inst)
			if (hpdelta>0 or not (food.components.edible.foodtype=="MEAT")) then
				self.inst.components.health:DoDelta(hpdelta, nil, food.prefab)
			end

    	    self.inst.components.hunger:DoDelta(food.components.edible:GetHunger(self.inst))
        
        	local sanity_delta=food.components.edible:GetSanity(self.inst)
        	if(sanity_delta>0 or not (food.components.edible.foodtype=="MEAT")) then
				self.inst.components.sanity:DoDelta(sanity_delta)
        	end
	        self.inst:PushEvent("oneat", {food = food})
    	    if self.oneatfn then
        	    self.oneatfn(self.inst, food)
       		end
        
       		if food.components.edible then
            	food.components.edible:OnEaten(self.inst)
        	end
        
        	if food.components.stackable and food.components.stackable.stacksize > 1 then
        	    food.components.stackable:Get():Remove()
       		else
            	food:Remove()
        	end
        
        	self.lasteattime = GetTime()
        
       		self.inst:PushEvent("oneatsomething", {food = food})
        
       		return true
    	end	
        end
    end
end


return MakePlayerCharacter("barb", prefabs, assets, fn)
