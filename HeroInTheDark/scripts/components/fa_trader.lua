local cooking = require("cooking")


local FaTrader = Class(function(self, inst)
    self.inst = inst
    self.cooking = false
    self.done = false
    
    self.product = nil
    self.matcher = nil
end)

local function dostew(inst)
	inst.components.stewer.task = nil
	
	if inst.components.stewer.ondonecooking then
		inst.components.stewer.ondonecooking(inst)
	end
	
	inst.components.stewer.done = true
	inst.components.stewer.cooking = nil
end

function Stewer:GetTimeToCook()
	if self.cooking then
		return self.targettime - GetTime()
	end
	return 0
end


function Stewer:CanCook()
	--[[
	local num = 0
	for k,v in pairs (self.inst.components.container.slots) do
		num = num + 1 
	end
	return num == 4]]
	return true
end


function Stewer:StartCooking()
	if not self.done and not self.cooking then
		if self.inst.components.container then
		
			self.done = nil
			self.cooking = true
			
			if self.onstartcooking then
				self.onstartcooking(self.inst)
			end
		
			
			local cooktime = 1
			self.product, cooktime = cooking.CalculateRecipe(self.inst.prefab, ings)
			
			local grow_time = TUNING.BASE_COOK_TIME * cooktime
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, dostew, "stew")

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
		
	end
end

function Stewer:OnSave()
    
    if self.cooking then
		local data = {}
		data.cooking = true
		data.product = self.product
		data.product_spoilage = self.product_spoilage
		local time = GetTime()
		if self.targettime and self.targettime > time then
			data.time = self.targettime - time
		end
		return data
    elseif self.done then
		local data = {}
		data.product = self.product
		data.product_spoilage = self.product_spoilage
		data.done = true
		return data		
    end
end

function Stewer:OnLoad(data)
    --self.produce = data.produce
    if data.cooking then
		self.product = data.product
		if self.oncontinuecooking then
			local time = data.time or 1
			self.product_spoilage = data.product_spoilage or 1
			self.oncontinuecooking(self.inst)
			self.cooking = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, dostew, "stew")
			
			if self.inst.components.container then		
				self.inst.components.container.canbeopened = false
			end
			
		end
    elseif data.done then
		self.product_spoilage = data.product_spoilage or 1
		self.done = true
		self.product = data.product
		if self.oncontinuedone then
			self.oncontinuedone(self.inst)
		end
		if self.inst.components.container then		
			self.inst.components.container.canbeopened = false
		end
		
    end
end


function Stewer:CollectSceneActions(doer, actions, right)
    if self.done then
        table.insert(actions, ACTIONS.HARVEST)
    elseif right and self:CanCook() then
		table.insert(actions, ACTIONS.COOK)
    end
end


function Stewer:Harvest( harvester )
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot = SpawnPrefab(self.product)
				
				
				if loot then
				
					if loot and loot.components.perishable then
					loot.components.perishable:SetPercent( self.product_spoilage)
					end
					harvester.components.inventory:GiveItem(loot, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
				end
			end
			self.product = nil
		end
		
		if self.inst.components.container then		
			self.inst.components.container.canbeopened = true
		end
		
		return true
	end
end


return Stewer
