

local FAWarzone = Class(function(self, inst)
	self.inst = inst
	self.task = nil
	self.phases={
		{	
			name="peace",
			length=12,
			onenter=function()

			end,
			onexit=function()

			end,
		}
		{
			name="war",
			length=6,
			onenter=function()

			end,
			onexit=function()

			end,
		}
	}
	self.phase=1

	self.totalsegs = 16
	self.segtime = 30

	self.calmColour = Point(0, 0, 0)
	self.warnColour = Point(0, 0, 0)

	self.currentColour = self.calmColour

	self.lerpToColour = self.calmColour
	self.lerpFromColour = self.calmColour

    self.lerptimeleft = 0
    self.totallerptime = 0
    self.override_timeLeftInEra = nil

    self.inst:StartUpdatingComponent(self)
end)

function FAWarzone:GetDaySegs()
	--eventually they may/will be different, for now...
	return self.phases
end

function FAWarzone:GetTimeLeftInEra()
	return self.timeLeftInEra
end

function FAWarzone:OnSave()
	return {
	phase = self.phase,
	timeLeftInEra = self.timeLeftInEra
	}
end

function FAWarzone:OnLoad(data)
	if(data and data.phase)then
		inst.phase=data.phase
	end

--	self.inst:PushEvent("phasechange", {oldphase = self.phase, newphase = self.phase})

	self.timeLeftInEra=data.timeLeftInEra or 0

end


function FAWarzone:GetDebugString()
    return string.format("%s: %2.2f ", self.phase, self:GetTimeLeftInEra())
end


function FAWarzone:GetPhase()
	return self.phase
end

function FAWarzone:GetNextPhase()
	return self.phase % #self.phases +1
end

function FAWarzone:NextPhase()
	local oldphase = self.phase
	self.phase=self:GetNextPhase()
	self.phases[oldphase].onexit()
	self.phases[self.phase].onenter()
	self.timeLeftInEra=self.phases[self.phases].length*self.segtime

	self.inst:PushEvent("warphasechange", {oldphase = self.phases[oldphase], newphase = self.phases[self.phase]})
end

function FAWarzone:OnUpdate(dt)
	self.timeLeftInEra = self.timeLeftInEra - dt

	if self.override_timeLeftInEra ~= nil then
		self.timeLeftInEra = self.override_timeLeftInEra
	end
	if self.timeLeftInEra <= 0 then
		local time_left_over = -self.timeLeftInEra
		self:NextPhase()

		if time_left_over > 0 then
			self:OnUpdate(time_left_over)
			return
		end
	end

--[[ not sure if/what i want to do with graphics... or should it be done here at all
    if self.lerptimeleft > 0 then
        local percent = 1 - (self.lerptimeleft / self.totallerptime)
        local r = percent*self.lerpToColour.x + (1 - percent)*self.lerpFromColour.x
        local g = percent*self.lerpToColour.y + (1 - percent)*self.lerpFromColour.y
        local b = percent*self.lerpToColour.z + (1 - percent)*self.lerpFromColour.z
        self.currentColour = Point(r,g,b)
        self.lerptimeleft = self.lerptimeleft - dt
    end
    if GetWorld():IsCave() and self.inst.topology.level_number == 2 then
        TheSim:SetAmbientColour(self.currentColour.x, self.currentColour.y, self.currentColour.z )
    end
]]
--	self.inst:PushEvent("nightmareclocktick", {phase = self.phase, normalizedtime = self:GetNormTime()})

end


function NightmareClock:LerpAmbientColour(src, dest, time)
	self.lerptimeleft = time
	self.totallerptime = time

    if time == 0 then
		self.currentColour = dest
    else
		self.lerpFromColour = src
		self.lerpToColour = dest
	end

    if not self.currentColour then
		self.currentColour = src
    end
	--This will probably clash with the clock
    if GetWorld():IsCave() and self.inst.topology and self.inst.topology.level_number == 2 then
        TheSim:SetAmbientColour(self.currentColour.x, self.currentColour.y, self.currentColour.z )
    end
end

function NightmareClock:LerpFactor()
	if self.totallerptime == 0 then
		return 1
	else
		return math.min( 1.0, 1.0 - self.lerptimeleft / self.totallerptime )
	end
end

function NightmareClock:LongUpdate(dt)
	self:OnUpdate(dt)
--[[
	self.lerptimeleft = 0
	if self:IsCalm() then
		self.currentColour = self.calmColour
	elseif self:IsWarn() then
		self.currentColour = self.warnColour
	elseif self:IsNightmare() then
		self.currentColour = self.nightmareColour
	else
		self.currentColour = self.dawnColour
	end

    if GetWorld():IsCave() and self.inst.topology.level_number == 2 then
        TheSim:SetAmbientColour(self.currentColour.x, self.currentColour.y, self.currentColour.z )
    end]]
end

return NightmareClock