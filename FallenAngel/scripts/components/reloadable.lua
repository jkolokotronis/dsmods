local Reloadable = Class(function(self, inst)
    self.inst = inst
    self.ammotype = nil
end)

function Reloadable:NeedsRepairs()
	if self.inst.components.health then
		return self.inst.components.health:GetPercent() < 1
	elseif self.inst.components.workable.workleft then
		return self.inst.components.workable.workleft < self.inst.components.workable.maxwork
	end	
	return false		
end

function Reloadable:Reload(doer, item)
	local max=self.inst.components.finiteuses.total
	local current=self.inst.components.finiteuses.current
	if(max>current)then
		self.inst.components.finiteuses:SetUses(math.min(max,current+item.components.reloading.returnuses))
		if(item.components.stackable)then
			item.components.stackable:Get():Remove()
		else
			item:Remove()
		end
		return true
	end
end

return Reloadable
