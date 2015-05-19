local FA_Lockpick = Class(function(self, inst)
	self.inst = inst
	self.onused = nil
	self.onremoved = nil
	self.lockpick_chance={
	{[5]=0.4,[6]=0.5,[7]=0.6,[8]=0.6,[9]=0.6,[10]=0.7,[11]=0.7,[12]=0.8,[13]=0.8,[14]=0.8,[15]=0.8,[16]=0.9,[17]=0.9,[18]=0.9,[19]=0.9,[20]=0.99},
	{[10]=0.3,[11]=0.4,[12]=0.5,[13]=0.5,[14]=0.6,[15]=0.6,[16]=0.7,[17]=0.7,[18]=0.8,[19]=0.8,[20]=0.9},
	{[14]=0.3,[15]=0.4,[16]=0.5,[17]=0.6,[18]=0.7,[19]=0.7,[20]=0.8},
	{[17]=0.3,[18]=0.4,[19]=0.5,[20]=0.6},
	{[20]=0.3},
	}
end)


function FA_Lockpick:SetOnUsedFn(fn)
	self.onused = fn
end

function FA_Lockpick:SetOnRemovedFn(fn)
	self.onremoved = fn
end

function FA_Lockpick:OnUsed(lock, doer)
	if self.onused then
		self.onused(self.inst, lock, doer)
	end
end

function FA_Lockpick:OnRemoved(lock, doer)
	if self.onremoved then
		self.onremoved(self.inst, lock, doer)
	end
end

function FA_Lockpick:CollectUseActions(doer, target, actions)
	local chance=self:CanUnlock(target,doer)
	if chance and chance>0 then
		table.insert(actions, ACTIONS.UNLOCK)
	end
end

function FA_Lockpick:CanUnlock(lock,doer)
	if(inst.components.lock==nil or inst.components.lock.locklevel==nil or not inst.components.lock.islocked or inst.components.lock:IsStuck()) then return 0
	local level=(doer.components.xplevel and doer.components.xplevel.level) or 1
	local chance=self.lockpick_chance[inst.components.lock.locklevel][level]
	return chance
end

function FA_Lockpick:TryUnlock(lock,doer)
	local chance=self:CanUnlock(lock,doer)
	if(chance and math.random()<chance)then
		lock.components.lock:Unlock(nil, doer)
		self:OnUsed(lock,doer)
		return true
	else
		return false
	end

end

return FA_Lockpick