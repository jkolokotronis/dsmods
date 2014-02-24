local KiBar = Class(function(self, inst)
    self.inst = inst
    self.max = 100
    self.current = self.max

    self.decrate = 1
    self.period = 1
    
--    self.task = self.inst:DoPeriodicTask(self.period, function() self:DoDec(self.period) end)
	self.inst:ListenForEvent("respawn", function(inst) self:OnRespawn() end)
	
end)


function KiBar:OnRespawn()
	
end

function KiBar:OnSave()
    if self.current ~= self.max then
        return {ki = self.current}
    end
end

function KiBar:OnLoad(data)
    if data.ki then
        self.current = data.ki
        self:DoDelta(0)
    end
end

function KiBar:LongUpdate(dt)
--	self:DoDec(dt, true)
end

function KiBar:Pause()
end

function KiBar:Resume()
end

function KiBar:GetDebugString()
    return string.format("%2.2f / %2.2f", self.current, self.max)
end

function KiBar:SetMax(amount)
    self.max = amount
    self.current = amount
end



function KiBar:DoDelta(delta, overtime, ignore_invincible)
    
    if self.redirect then
        self.redirect(self.inst, delta, overtime)
        return
    end

    if not ignore_invincible and self.inst.components.health.invincible == true or self.inst.is_teleporting == true then
        return
    end

    local old = self.current
    self.current = self.current + delta
    if self.current < 0 then 
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end
    
    self.inst:PushEvent("kidelta", {oldpercent = old/self.max, newpercent = self.current/self.max, overtime = overtime})
    
end

function KiBar:GetPercent(p)
    return self.current / self.max
end

function KiBar:SetPercent(p)
    local old = self.current
    self.current  = p*self.max
    self.inst:PushEvent("kidelta", {oldpercent = old/self.max, newpercent = p})

end



function KiBar:SetRate(rate)
    self.kirate = rate
end


return KiBar
