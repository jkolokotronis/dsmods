

-- why I'm not using eater interface?  
-- assumptions, unnecesary checks, logic that should not apply at all, different stategraph calls, maintaining compatibility... too much hassle 

local FA_Drinker = Class(function(self, inst)
    self.inst = inst
    self.oneatfn = nil
    self.lasteattime = nil
end)

function FA_Drinker:TimeSinceLastEating()
	if self.lasteattime then
		return GetTime() - self.lasteattime
	end
end

function FA_Drinker:OnSave()
    if self.lasteattime then
        return {time_since_eat = self:TimeSinceLastEating()}
    end
end

function FA_Drinker:OnLoad(data)
    if data.time_since_eat then
        self.lasteattime = GetTime() - data.time_since_eat
    end
end

function FA_Drinker:SetOnDrinkFn(fn)
    self.ondrinkfn = fn
end

function FA_Drinker:SetCanDrinkTestFn(fn)
    self.candrinktest = fn
end

function FA_Drinker:Drink( food )
    print("test",food)
    if self:CanDrink(food) then
		
        if self.inst.components.health then
				self.inst.components.health:DoDelta(food.components.fa_drink:GetHealth(self.inst), nil, food.prefab)
        end

        if self.inst.components.hunger then
            self.inst.components.hunger:DoDelta(food.components.fa_drink:GetHunger(self.inst))
        end
        
        if self.inst.components.sanity then
			self.inst.components.sanity:DoDelta(food.components.fa_drink:GetSanity(self.inst))
        end

        if(self.inst.components.fa_intoxication)then
            self.inst.components.fa_intoxication:DoDelta(food.components.fa_drink:GetIntoxication(self.inst))
        end
        
        --not sure i care about having 2 of them but meh
        self.inst:PushEvent("fa_ondrink", {food = food})
        if self.ondrinkfn then
            self.ondrinkfn(self.inst, food)
        end
        
        if food.components.fa_drink then
            food.components.fa_drink:OnDrink(self.inst)
        end
        
        if food.components.stackable and food.components.stackable.stacksize > 1 and not self.eatwholestack then
            food.components.stackable:Get():Remove()
        elseif food.components.finiteuses then
            food.components.finiteuses:Use(1)
        elseif food.components.fa_drink.destroyonuse then
            food:Remove()
        end


        self.lasteattime = GetTime()
        
        self.inst:PushEvent("fa_ondrinksomething", {food = food})
        
        return true
    end
end

function FA_Drinker:CanDrink(inst)
    if inst and inst.components.fa_drink then
		if self.candrinktest then
			return self.candrinktest(self.inst, inst)
		end
        return true
    end
end

return FA_Drinker