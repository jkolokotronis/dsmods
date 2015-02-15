local matchers=require "fa_smelter_matcher"
local FA_Furnace = Class(function(self, inst)
    self.inst = inst
    self.cooking = false
    self.done = false
    self.time=0
    self.product = nil
    self.inst:StartUpdatingComponent(self)
end)

function FA_Furnace:SetMatcher(matcher)
    self.category=matcher
    self.matcher = matchers[matcher]
end

function FA_Furnace:OnUpdate(dt)
	if(self.cooking)then
		self.time=self.time-dt
		if(self.time<=0)then
			self:dostew()
		end
	end
end


function FA_Furnace:LongUpdate(dt)
	self:OnUpdate(dt)
end

function FA_Furnace:dostew()
	self.done = true
	self.cooking = nil

	if self.ondonecooking then
		self.ondonecooking(self.inst)
	end
	
	print("done cooking",self.product)
end

function FA_Furnace:GetTimeToCook()
	if self.cooking then
		return self.time
	end
	return 0
end

function FA_Furnace:GetIngreds()
	local ingreds={}
	for k,v in pairs (self.inst.components.container.slots) do
		local c=1
		ingreds[v.prefab]=(ingreds[v.prefab] and ingreds[v.prefab]+1) or 1
	end
	return ingreds
end

function FA_Furnace:CanCook()

	if(not self.done and not self.cooking and self.matcher)then
		return self.matcher:TryMatch(self:GetIngreds())
	else
		return false
	end
end


function FA_Furnace:StartCooking(doer)
	if not self.done and not self.cooking then
		if self.inst.components.container then
			
			local cooktime = 1

			local res=self.matcher:Match(self:GetIngreds())
			self.product=res.product
			if(doer and self.product and #self.product>0 and doer.components.fa_recipebook)then
				local first=self.product[1]
				--avoiding 'excluded' entries - theres prob a nicer way 
				if(matcher.hashtable[first])then
					doer.components.fa_recipebook:AddRecipe(self.category,first)
				end
			end
			cooktime=res.cooktime 
			self.time=cooktime
			self.done = nil
			self.cooking = true
			
			if self.onstartcooking then
				self.onstartcooking(self.inst)
			end
		
			
			
--			self.task = self.inst:DoTaskInTime(grow_time, function() self:dostew() end)

			self.inst.components.container:Close()
			self.inst.components.container:DestroyContents()
			self.inst.components.container.canbeopened = false
		end
		
	end
end

function FA_Furnace:OnSave()
    
    if self.cooking then
		local data = {}
		data.cooking = true
		data.product = self.product
		local time = GetTime()
		if self.time and self.time>0 then
			data.time = self.time
		end
		return data
    elseif self.done then
		local data = {}
		data.product = self.product
		data.done = true
		return data		
    end
end

function FA_Furnace:OnLoad(data)
    --self.produce = data.produce
    if data.cooking then
		self.product = data.product
			self.cooking = true
			self.time=data.time or 1
--			self.targettime = GetTime() + time
--			self.task = self.inst:DoTaskInTime(time, function() self:dostew() end)			
			if self.inst.components.container then		
				self.inst.components.container.canbeopened = false
			end
		if self.oncontinuecooking then
			self.oncontinuecooking(self.inst)			
		end
    elseif data.done then
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


function FA_Furnace:CollectSceneActions(doer, actions, right)
    if self.done then
        table.insert(actions, ACTIONS.FA_CRAFTPICKUP)
    elseif right and self:CanCook() then
		table.insert(actions, ACTIONS.FA_FURNACE)
    end
end


function FA_Furnace:Harvest( harvester )
	print("harvester")
	if self.done then
		if self.onharvest then
			self.onharvest(self.inst)
		end
		self.done = nil
		if self.product then
			if harvester and harvester.components.inventory then
				local loot={}
				if(type(self.product)=="table")then
					for k,v in pairs(self.product) do
						table.insert(loot, SpawnPrefab(v))
					end
				else
					table.insert(loot, SpawnPrefab(self.product))
				end
				
				for k,v in pairs(loot) do
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


return FA_Furnace
