
local MakePlayerCharacter = require "prefabs/player_common"

local CooldownButton = require "widgets/cooldownbutton"
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
        Asset( "ANIM", "anim/barbarian_rage.zip" ),
        Asset( "ANIM", "anim/barbarian_rage2.zip" ),
}
local prefabs = {}

--local BASE_MS=1.25*TUNING.WILSON_RUN_SPEED
local BASE_MS=1*TUNING.WILSON_RUN_SPEED
local RAGE_MS_DELTA=0.5*TUNING.WILSON_RUN_SPEED
local RAGE_FIREDMG=0.75
local RAGE_FIREDMG2=0.5
local BASE_FIREDMG
local BASE_FREEZING
local DAMAGE_MULT=1.0
local EFFECTIVENESS_MULT=1.5
local RAGE_SANITY_DELTA=-5
local RAGE_HUNGER_DELTA=-10
local RAGE_PERIOD=2

local RAGE_RESIST=0.25
local RAGE_RESIST20=0.5

local HEALTH_PER_LEVEL=5
local HUNGER_PER_LEVEL=1

local def_attack_period
local ref


local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
    inst.whirlwindcooldowntimer=data.whirlwindcooldowntimer
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
    data.whirlwindcooldowntimer=inst.whirlwindCooldownButton.cooldowntimer
end


local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL*(level-1)
        if(level>=2)then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
        end
        if(level>=3)then
        inst.components.eater.strongstomach = true 
        end
        if level>=5 then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
        end
        if level>=7 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
        end
        if level>=10 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=11 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
        end
        if level>=14 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1        
        end
        if level>=15 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=17 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
        end
        if level>=19 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
        end
        inst.components.health:DoDelta(0)
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL
    if(level==2)then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
    elseif(level==3)then
        inst.components.eater.strongstomach = true 
    elseif level==5 then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    elseif level==7 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
    elseif level==9 then
        inst.rageBuff:Show()
    elseif level==10 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==11 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
    elseif level==12 then
        inst.whirlwindCooldownButton:Show()
    elseif level==14 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1        
    elseif level==15 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==17 then
        inst.components.combat.fa_basedamagemultiplier=inst.components.combat.fa_basedamagemultiplier+0.1
    elseif level==18 then
    
    elseif level==19 then
         inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    elseif level==20 then

    end
    --force refresh of ui/combat mult recalc
    inst.components.health:DoDelta(0)
end

local function onhpchange(inst, data)

	local current=inst.components.health.currenthealth
	local mult=0.005
	if(current<100) then
		mult=0.01
	end
	inst.components.combat.damagemultiplier=inst.components.combat.fa_basedamagemultiplier+mult*(inst.components.health.maxhealth-current)
	
end


local function rageProc(inst)

	inst.components.sanity:DoDelta(RAGE_SANITY_DELTA,false)
	inst.components.hunger:DoDelta(RAGE_HUNGER_DELTA,false,false)

end

local function doresistdelta(inst,delta)

    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]+delta
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+delta
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]+delta
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]+delta
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]+delta
end

local function rageStart(inst)
    local resist=RAGE_RESIST
    inst.components.health.fa_stunresistance=inst.components.health.fa_stunresistance+1
	if(inst.components.xplevel.level<20)then
        inst.components.locomotor.runspeed=RAGE_MS_DELTA+inst.components.locomotor.runspeed
       inst.components.combat.min_attack_period=def_attack_period/1.3    
        inst.AnimState:SetBuild("barbarian_rage")   
    else
        resist=RAGE_RESIST20
	   inst.components.locomotor.runspeed=RAGE_MS_DELTA+inst.components.locomotor.runspeed
	   inst.components.combat.min_attack_period=def_attack_period/1.5	   
        inst.AnimState:SetBuild("barbarian_rage2") 
    end
    inst.fa_rage_resistboost=resist
    doresistdelta(inst,resist)
        inst.task = inst:DoPeriodicTask(RAGE_PERIOD, function() rageProc(inst) end)
end

local function rageEnd(inst)
    inst.components.health.fa_stunresistance=inst.components.health.fa_stunresistance-1
    doresistdelta(inst,-inst.fa_rage_resistboost)
    inst.fa_rage_resistboost=nil
	inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-RAGE_MS_DELTA
	inst.components.health.fire_damage_scale=BASE_FIREDMG
	inst.components.temperature.hurtrate=BASE_FREEZING
	inst.components.combat.min_attack_period=def_attack_period
    inst.AnimState:SetBuild("barb")
	if inst.task then inst.task:Cancel() inst.task = nil end
end

local fn = function(inst)
	ref=inst
		-- choose which sounds this character will play
	inst.soundsname = "barb"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "barb.tex" )

	-- todo: Add an example special power here.
	
	
	def_attack_period=inst.components.combat.min_attack_period
--	BASE_FIREDMG=inst.components.health.fire_damage_scale
--	BASE_FREEZING=inst.components.temperature.hurtrate
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0
	
	inst.components.combat.damagemultiplier=DAMAGE_MULT
    inst.components.combat.fa_basedamagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetRate(2.0*TUNING.WILSON_HUNGER_RATE)
	inst.components.hunger:SetMax(250)
	inst.components.sanity:SetMax(150)
	inst.components.locomotor.runspeed=BASE_MS

--[[
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("barbarian")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:Hide("hat_hair")
]]
    inst:AddComponent("xplevel")


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

	inst.newControlsInit = function (class)
        inst.rageBuff=RageBuff(class.owner)
        class.rage = class:AddChild(inst.rageBuff)
        class.rage:SetPosition(-250,0,0)
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

        inst.whirlwindCooldownButton=CooldownButton(class.owner)
        inst.whirlwindCooldownButton:SetText("Wrlwind")
        inst.whirlwindCooldownButton:SetOnClick(function() 
            inst.sg:GoToState("fa_whirlwind")
            return true
        end)
        inst.whirlwindCooldownButton:SetCooldown(120)
        if(inst.whirlwindcooldowntimer and inst.whirlwindcooldowntimer>0)then
             inst.whirlwindCooldownButton:ForceCooldown(inst.whirlwindcooldowntimer)
        end
        local htbtn=class:AddChild(inst.whirlwindCooldownButton)
        htbtn:SetPosition(-250,-40,0)
        if(inst.components.xplevel.level<12)then
            inst.whirlwindCooldownButton:Hide()
        end

    end

	
	inst:ListenForEvent("healthdelta", onhpchange)
    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)

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
