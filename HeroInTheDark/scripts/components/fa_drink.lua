local FA_Drink = Class(function(self, inst)
    self.inst = inst
    self.healthvalue = 0
    self.hungervalue = 0
    self.sanityvalue = 0
    self.intoxication=0
    self.ondrink = nil
    self.temperaturedelta = 0
    self.temperatureduration = 0
    self.destroyonuse=true

--    self.inst:AddTag("edible")
    
end)

function FA_Drink:GetSanity(eater)
	return self.sanityvalue
end

function FA_Drink:GetHunger(eater)
	return self.hungervalue
end

function FA_Drink:GetHealth(eater)
	return self.healthvalue
end

function FA_Drink:GetIntoxication(eater)
	return self.intoxication
end
function FA_Drink:SetOnDrinkFn(fn)
    self.ondrink = fn
end

function FA_Drink:OnDrink(eater)
    if self.ondrink then
        self.ondrink(self.inst, eater)
    end

    -- Food is an implicit heater/cooler if it has temperature
    if self.temperaturedelta ~= 0 and self.temperatureduration ~= 0 and eater and eater.components.temperature then
        eater.recent_temperatured_food = self.temperaturedelta
        if eater.food_temp_task then eater.food_temp_task:Cancel() end
        eater.food_temp_task = eater:DoTaskInTime(self.temperatureduration, function(eater)
        	eater.recent_temperatured_food = 0
        end)
    end

    self.inst:PushEvent("fa_ondrink", {eater = eater})
end

function FA_Drink:CollectInventoryActions(doer, actions, right)
    if doer.components.fa_drinker and doer.components.fa_drinker:CanDrink(self.inst) then
        if not self.inst.components.equippable or right then
			table.insert(actions, ACTIONS.FA_DRINK)
		end
    end
end


return FA_Drink