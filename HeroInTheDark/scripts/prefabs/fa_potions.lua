require "recipes"



local Assets =
{
    Asset("ANIM", "anim/fa_bottles.zip"),
	Asset("ANIM", "anim/frog.zip"),
	Asset("SOUND", "sound/frog.fsb"),
	Asset( "ANIM", "anim/smoke_up.zip" ),
}

local mugassets={
    Asset("ANIM", "anim/fa_mug.zip"),
}

local prefabs = {
    "blueprint",
    "fa_blooddownfx"
}

local blueprints={"tools_blueprint","magic_blueprint","town_blueprint","dress_blueprint","survival_blueprint","refine_blueprint","war_blueprint","ancient_blueprint","light_blueprint","farm_blueprint"}

local POISON_IMMUNITY_TIMER=10
local POISON_LENGTH=10
local POISON_DAMAGE=5
local POISON_PERIOD=2

local WONDER_EFFECTS={
	{
		fn=function(eater)
--		    eater.SoundEmitter:SetParameter("frogger_theme", "intensity", 1)
--			print("polymorph self")
			eater.components.locomotor:Stop()
--			eater.components.playercontroller:Enable(true)
--			eater:AddTag("notarget")
			local pos =eater:GetPosition()
--			eater:RemoveFromScene()
			local frog=SpawnPrefab("frog")
--			frog:ClearStateGraph()
			frog:StopBrain()
			frog:SetBrain(require "brains/froghaxbrain")
			frog:RestartBrain()
			frog:AddTag("notarget")
			frog:AddTag("fa_wonderswap")
			frog.components.health.invincible=true
--frog.brainfn=nil
			frog:AddComponent("follower")
			frog.components.locomotor.runspeed=2*eater.components.locomotor.runspeed
			eater.components.leader:AddFollower(frog)
			

		local boom = CreateEntity()
	    boom.entity:AddTransform()
	    local anim=boom.entity:AddAnimState()
	    boom.Transform:SetScale(1, 1, 1)
	    anim:SetBank("smoke_up")
	    anim:SetBuild("smoke_up")
	    anim:PlayAnimation("idle",false)
		
	    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    
    	boom:ListenForEvent("animover", function() 
    		frog.Transform:SetPosition(pos.x, pos.y, pos.z) 
    		frog.SoundEmitter:PlaySound("fa/music/frogger","frogger_theme")
    		boom:Remove() 
    	end)

--			frog.components.playercontroller:Enable(true)
			
			for k,v in pairs(eater.components.inventory.equipslots) do
				local item=	eater.components.inventory:Unequip(k)
				eater.components.inventory:GiveItem(item)
			end

--[[
	if eater.Physics then
        eater.Physics:SetActive(false)
    end
]]
--	eater.Physics:SetCollides(false)
    if eater.Light then
        eater.Light:Enable(false)
    end
    if eater.DynamicShadow then
        eater.DynamicShadow:Enable(false)
    end
--[[
--    if eater.AnimState then
 --       eater.AnimState:Pause()
  --  end

		eater:ListenForEvent("animover", function() 
    		eater.AnimState:Pause()
    	end)
	]]
    eater.entity:Hide()
			GetPlayer().HUD:Hide()

	eater:DoTaskInTime(60,function()
				eater:ReturnToScene()
				frog.SoundEmitter:KillSound("frogger_theme")
--				eater.components.playercontroller:Enable(true)
				frog:Remove()    		
--				eater.Physics:SetCollides(true)
				GetPlayer().HUD:Show()

				if eater.Light then
    			    eater.Light:Enable(true)
    			end
    			if eater.DynamicShadow then
        			eater.DynamicShadow:Enable(true)
    			end
    			eater.entity:Show()
--    			eater.AnimState:Resume()
			end)
		end
	},
	{
		fn=function(eater)
--		print("hounded")
		 local hounded = GetWorld().components.hounded
			if(hounded)then
				--go through full warn phase?
				local talk=GetString(eater.prefab, "FA_WONDER_HOUNDED")
				print("talk",talk)
				if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
				hounded.timetoattack=hounded.warnduration+2
			end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_POISON")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			
		    local target=eater
    		local variables={}
    		variables.strength=POISON_DAMAGE
    		variables.period=POISON_PERIOD
    		variables.buttontint={
    			r=0.5,
    			g=1,
    			b=0.5,
    			a=0.7
	    	}
    		if(target and target.components.fa_bufftimers)then
        		target.components.fa_bufftimers:AddBuff("poison","Poison","Poison",POISON_LENGTH,variables)
    		else
        		FA_BuffUtil.Poison(target,POISON_LENGTH,variables,target)
		    end
			eater.components.hunger:DoDelta(-50)

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SPEEDBOOST")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
--			print("haste")
			eater.components.locomotor.runspeed=eater.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED
			eater:DoTaskInTime(240,function() eater.components.locomotor.runspeed=eater.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED end)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SPEEDNERF")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
--		print("slow")
			eater.components.locomotor.runspeed=eater.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED/2
			eater:DoTaskInTime(240,function() eater.components.locomotor.runspeed=eater.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED/2 end)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_HPRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.health:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_HPDAMAGE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.health:DoDelta(-50)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_SLEEP")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.hunger:DoDelta(-50)
			eater.components.locomotor:Stop()
			eater.sg:GoToState("sleep")
			eater.components.health:SetInvincible(true)
			eater.components.playercontroller:Enable(false)

			GetPlayer().HUD:Hide()
			TheFrontEnd:Fade(false,1)
			eater:DoTaskInTime(1.2, function() 
		
				GetPlayer().HUD:Show()
				TheFrontEnd:Fade(true,1) 
				eater.components.health:SetInvincible(false)
				eater.components.playercontroller:Enable(true)
				GetClock():MakeNextDay()
				eater.sg:GoToState("wakeup")	
			end)

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_GOLD")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("goldnugget") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_LS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pos=Vector3(eater.Transform:GetWorldPosition())
			GetSeasonManager():DoLightningStrike(pos)			
--			local lightning = SpawnPrefab("lightning")
--            lightning.Transform:SetPosition(pos:Get())
		end
	},
	{
		fn=function(eater)
			eater.components.sanity:DoDelta(200)
			local talk=GetString(eater.prefab, "FA_WONDER_SANITYRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_INSANITY")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.sanity:SetPercent(0.05)
		end
	},
	{
		fn=function(eater)
			eater.components.hunger:DoDelta(200)
			local talk=GetString(eater.prefab, "FA_WONDER_HUNGERRESTORE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_NIGHTMAREFUEL")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("nightmarefuel") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_NAUGHTINESS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			eater.components.kramped:OnNaughtyAction(30)
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_ITEMDAMAGE")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			--yawn... can i merge them without breaking anything?
			local merged=MergeMaps(eater.components.inventory.itemslots,eater.components.inventory.equipslots)
    		for k,v in pairs(merged) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(v.components.fueled:GetPercent()/2)
        		elseif v.components.armor then
        			v.components.armor:SetPercent(v.components.armor:GetPercent()/2)
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(v.components.finiteuses:GetPercent()/2)
        		end
    		end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_ITEMREPAIR")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local merged=MergeMaps(eater.components.inventory.itemslots,eater.components.inventory.equipslots)
    		for k,v in pairs(merged) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(math.min(1,v.components.fueled:GetPercent()*2))
        		elseif v.components.armor then
        			v.components.armor:SetPercent(math.min(1,v.components.armor:GetPercent()*2))
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(math.min(1,v.components.finiteuses:GetPercent()*2))
        		end
    		end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_BLUEPRINT")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local bptodrop=blueprints[1+math.floor(math.random()*#blueprints)]
			print("bp",bptodrop)
			if(bptodrop)then
				local b=SpawnPrefab(bptodrop)
				local pt= Vector3(eater.Transform:GetWorldPosition())
				b.Transform:SetPosition(pt:Get())
			end
		end
	},
	{
		fn=function(eater)
			local talk=GetString(eater.prefab, "FA_WONDER_GEMS")
			if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
			local pt= Vector3(eater.Transform:GetWorldPosition())
			for k,v in pairs({"redgem","bluegem","purplegem"}) do
				local drop = SpawnPrefab(v) 
    		    drop.Physics:SetCollides(false)
        		drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        		drop.Physics:SetCollides(true)
        		eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
        	end
		end
	}

}

local function onfinished(inst)
    inst:Remove()
end

local function oneaten(inst,eater)

	if(eater.components.inventory)then
		eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
	end
end

local function eatwonder(inst,eater)
	if(eater and eater:HasTag("player"))then
		local index=math.floor(1+(math.random() * #WONDER_EFFECTS))
--		index=1
		local effect=WONDER_EFFECTS[index]
		if(effect)then
			effect.fn(eater)
		else
			print("no effect??")
		end
		if(eater.components.inventory)then
			eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
		end
	end
end

local function common(name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
--    inst.Transform:SetScale(3,3, 3)


    inst.AnimState:SetBank("fa_"..name)
    inst.AnimState:SetBuild("fa_bottles")
    inst.AnimState:PlayAnimation("idle")

    MakeInventoryPhysics(inst)
        
    inst:AddTag("potion")
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_"..name

	inst:AddComponent("inspectable")	
	
    inst:AddComponent("fa_drink")
    inst.components.fa_drink.healthvalue=0
    inst.components.fa_drink.hungervalue=0
    inst.components.fa_drink.sanityvalue=0
    inst.components.fa_drink.foodtype = "FA_POTION"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 40
    inst:AddComponent("tradable")

    inst.components.fa_drink.ondrink=oneaten
--    inst:ListenForEvent("oneaten",oneaten)
    
    return inst
end

local function fnr(Sim)

	local inst = common("bottle_r")
    inst.components.fa_drink.healthvalue = 150
    return inst

end

local function fny(Sim)

	local inst = common("bottle_y")
    inst.components.fa_drink.hungervalue = 150
    return inst

end

local function fng(Sim)

	local inst = common("bottle_g")
    inst.components.fa_drink.sanityvalue = 150
    return inst

end


local function fnb(Sim)

	local inst = common("bottle_b")
    inst.components.fa_drink.ondrink=eatwonder
    return inst

end


local function curepoison(inst,eater)
	if(eater and eater.fa_poison)then
        eater.fa_poison.components.spell:OnFinished()
    	local res=eater.components.health.fa_resistances[FA_DAMAGETYPE.POISON] or 0
    	if(res<1)then
    		eater.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=res+1
    		eater:DoTaskInTime(POISON_IMMUNITY_TIMER,function()
    				eater.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=eater.components.health.fa_resistances[FA_DAMAGETYPE.POISON]-1
    		end)
    	end
	end
	if(eater.components.inventory)then
		eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
	end
end

local function fncurepoison(Sim)
	local inst = common("bottle_y")
    inst.components.fa_drink.ondrink=curepoison
    return inst

end

local function fnempty()
	local inst=common("bottle_empty")
    inst:RemoveComponent("fa_drink")
    inst:DoPeriodicTask(1,function()
    	if(not inst:IsInLimbo() and GetSeasonManager():IsRaining()) then
    		local pos=inst:GetPosition()
    		local stack=inst.components.stackable.stacksize
    		inst:Remove()
    		local water=SpawnPrefab("fa_bottle_water")
    		water.components.stackable.stacksize=stack
		    water.Transform:SetPosition(pos.x, pos.y, pos.z)
    	end
    end)
	return inst
end

local function fnwater()
	local inst=common("bottle_water")
	return inst
end

local function fnoil()
	local inst=common("bottle_oil")
    inst:RemoveComponent("fa_drink")
	return inst
end

local function fnmineralwater()
	local inst=common("bottle_mineralwater")
	return inst
end

local function fnfrozenessence()
	local inst=common("bottle_frozenessence")
    inst:RemoveComponent("fa_drink")
	return inst
end

local function fnlifeessence()
	local inst=common("bottle_lifeessence")
    inst:RemoveComponent("fa_drink")
	return inst
end

local function fnlightningessence()
	local inst=common("bottle_lightningessence")
    inst:RemoveComponent("fa_drink")
	return inst
end

local function fnpoisonessence()
	local inst=common("bottle_poisonessence")
    inst:RemoveComponent("fa_drink")
	return inst
end

local function emptymug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("empty")
    inst.components.inventoryitem.imagename="fa_emptymug"
    inst:RemoveComponent("fa_drink")
    return inst
end
local function rummug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("rum")
    inst.components.fa_drink.hungervalue = 5
    inst.components.inventoryitem.imagename="fa_rummug"
	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
			if(eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_emptymug") )
			end
        end
    end
    return inst
end
local function beermug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("beer")
    inst.components.fa_drink.hungervalue = 5
    inst.components.inventoryitem.imagename="fa_beermug"
	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
			if(eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_emptymug") )
			end
        end
    end
    return inst
end
local function lightalemug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("beer")
    inst.components.fa_drink.hungervalue = 5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE
    inst.components.inventoryitem.imagename="fa_lightalemug"

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("damagemultiplier","DmgBoost","DamageMultiplier",2*60,{multiplier=0.1})
	    	end
			if(eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_emptymug") )
			end
        end
    end
    return inst
end

local function ronsalemug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("beer")
    inst.components.inventoryitem.imagename="fa_ronsalemug"
    inst.components.fa_drink.hungervalue = 5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("damagemultiplier","DmgBoost","DamageMultiplier",2*60,{multiplier=0.2})
	    	end
			if(eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_emptymug") )
			end
        end
    end
    return inst
end
local function dwarfalemug()
	local inst=common("mug")
    inst.AnimState:SetBuild("fa_mug")
    inst.AnimState:PlayAnimation("beer")
    inst.components.inventoryitem.imagename="fa_dwarfalemug"
    return inst
end
local function ftest(name)
	return function()
		local inst=common(name)
		return inst
	end
end


local function winecommon(inst,eatfn)
    inst:AddComponent("finiteuses")
    inst:RemoveComponent("stackable")
    inst.components.finiteuses:SetOnFinished( onfinished)
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-5
    inst.components.fa_drink.intoxication=10

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
            if(eatfn)then eatfn(inst) end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end

end


local function pomegranatewine()
	local inst=common("pomegranate_wine")
	winecommon(inst)

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("dapperness","Dapperness","Dapperness",2*60,{dapperness=0.5})
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function durianwine()
	local inst=common("durian_wine")
	winecommon(inst)
	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("fearreflect","FearReflect","FearReflect",2*60)
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end

	return inst
end

local function dragonwine()
	local inst=common("dragon_wine")
	winecommon(inst)
	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
			    eater.components.fa_bufftimers:AddBuff("healthregen","HealthRegen","HealthRegen",3*60)
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function melonwine()
	local inst=common("melon_wine")
	winecommon(inst)
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
			    eater.components.fa_bufftimers:AddBuff("endureelementsheat","EndureHeat","EndureElements",4*60,{summer=true})
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function redwine()
	local inst=common("red_wine")
	winecommon(inst)

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
			    eater.components.fa_bufftimers:AddBuff("healthregen","HealthRegen","HealthRegen",4*60)
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function goodberrywine()
	local inst=common("goodberry_wine")
	winecommon(inst)
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("dapperness","Dapperness","Dapperness",4*60,{dapperness=1})
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function glowingwine()
	local inst=common("glowing_wine")
	winecommon(inst)

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("friendlyworms","FriendlyWorms","FriendlyWorms",2*60)
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

local function cactuswine()
	local inst=common("cactus_wine")
	winecommon(inst)
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater:HasTag("player"))then

    		local light = SpawnPrefab("fa_darkvision_fx")
    		light.components.spell:SetTarget(eater)
	    	light.components.spell:StartSpell()

	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end


	return inst
end

local function mead()
	local inst=common("mead")
	winecommon(inst)

	inst.components.fa_drink.ondrink=function(inst,eater)
	    if(eater)then
	    	if(eater.components.fa_bufftimers)then
	            eater.components.fa_bufftimers:AddBuff("friendlybees","FriendlyBees","FriendlyBees",2*60)
	    	end
			if((not inst.components.finiteuses or inst.components.finiteuses.current <= 1) and eater.components.inventory)then
				eater.components.inventory:GiveItem( SpawnPrefab("fa_bottle_empty") )
			end
        end
    end
	return inst
end

return Prefab( "common/inventory/fa_bottle_r", fnr, Assets),
	Prefab( "common/inventory/fa_bottle_y", fny, Assets),
	Prefab( "common/inventory/fa_bottle_g", fng, Assets),
	Prefab( "common/inventory/fa_bottle_b", fnb, Assets),
	Prefab( "common/inventory/fa_bottle_empty", fnempty, Assets),
	Prefab( "common/inventory/fa_bottle_water", fnwater, Assets),
	Prefab( "common/inventory/fa_bottle_oil", fnoil, Assets),
	Prefab( "common/inventory/fa_bottle_mineralwater", fnmineralwater, Assets),
	Prefab( "common/inventory/fa_bottle_frozenessence", fnfrozenessence, Assets),
	Prefab( "common/inventory/fa_bottle_lifeessence", fnlifeessence, Assets),
	Prefab( "common/inventory/fa_bottle_lightningessence", fnlightningessence, Assets),
	Prefab( "common/inventory/fa_bottle_poisonessence", fnpoisonessence, Assets),
	Prefab( "common/inventory/fa_bottle_curepoison", fncurepoison, Assets),
	Prefab( "common/inventory/fa_emptymug", emptymug, mugassets),
	Prefab( "common/inventory/fa_rummug", rummug, mugassets),
	Prefab( "common/inventory/fa_lightalemug", lightalemug, mugassets),
	Prefab( "common/inventory/fa_ronsalemug", ronsalemug, mugassets),
	Prefab( "common/inventory/fa_dwarfalemug", dwarfalemug, mugassets),

	Prefab( "common/inventory/fa_pomegranate_wine", pomegranatewine, Assets),
	Prefab( "common/inventory/fa_durian_wine", durianwine, Assets),
	Prefab( "common/inventory/fa_dragon_wine", dragonwine, Assets),
	Prefab( "common/inventory/fa_melon_wine", melonwine, Assets),
	Prefab( "common/inventory/fa_red_wine", redwine, Assets),
	Prefab( "common/inventory/fa_goodberry_wine", goodberrywine, Assets),
	Prefab( "common/inventory/fa_glowing_wine", glowingwine, Assets),
	Prefab( "common/inventory/fa_cactus_wine", cactuswine, Assets),
	Prefab( "common/inventory/fa_mead", mead, Assets)

