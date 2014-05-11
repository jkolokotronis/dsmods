
local FAFurnace = Class(function(self, inst)
    self.inst = inst
    self.cooking = false
    self.done = false
    
    self.product = nil
    self.matcher = nil
end)

function FAFurnace:dostew(inst)
	self.task = nil
	
	if self.ondonecooking then
		self.ondonecooking(inst)
	end
	
	self.done = true
	self.cooking = nil
end

function FAFurnace:GetTimeToCook()
	if self.cooking then
		return self.targettime - GetTime()
	end
	return 0
end

function FAFurnace:GetIngreds()
	local ingreds={}
	for k,v in pairs (self.inst.components.container.slots) do
		local c=1
		ingreds[v.prefab]=(ingreds[v.prefab] and ingreds[v.prefab]+1) or 1
	end
	return ingreds
end

function FAFurnace:CanCook()

	if(self.matcher)then
		return self.matcher:TryMatch(self:GetIngreds())
	else
		return false
end


function FAFurnace:StartCooking()
	if not self.done and not self.cooking then
		if self.inst.components.container then
			
			local res=self.matcher:Match(self:GetIngreds())
			self.product=res.product
			cooktime=res.cooktime 
			self.done = nil
			self.cooking = true
			
			if self.onstartcooking then
				self.onstartcooking(self.inst)
			end
		
			
			local cooktime = 1
			
			local grow_time = cooktime
			self.targettime = GetTime() + grow_time
			self.task = self.inst:DoTaskInTime(grow_time, function() self:dostew() end)

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
		
	end
end

function FAFurnace:OnSave()
    
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

function FAFurnace:OnLoad(data)
    --self.produce = data.produce
    if data.cooking then
		self.product = data.product
		if self.oncontinuecooking then
			local time = data.time or 1
			self.product_spoilage = data.product_spoilage or 1
			self.oncontinuecooking(self.inst)
			self.cooking = true
			self.targettime = GetTime() + time
			self.task = self.inst:DoTaskInTime(time, function() self:dostew() end)
			
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


function FAFurnace:CollectSceneActions(doer, actions, right)
    if self.done then
        table.insert(actions, ACTIONS.HARVEST)
    elseif right and self:CanCook() then
		table.insert(actions, ACTIONS.COOK)
    end
end


function FAFurnace:Harvest( harvester )
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot={}
				if(type(self.product)=="table")then
					for k,v in self.product do
						table.insert(loot, SpawnPrefab(v))
					end
				else
					table.insert(loot, SpawnPrefab(self.product))
				end
				
				for k,v in loot do
					if v and v.components.perishable then
						loot.components.perishable:SetPercent( self.product_spoilage)
					end
					harvester.components.inventory:GiveItem(v, nil, Vector3(TheSim:GetScreenPos(self.inst.Transform:GetWorldPosition())))
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


return FAFurnace
