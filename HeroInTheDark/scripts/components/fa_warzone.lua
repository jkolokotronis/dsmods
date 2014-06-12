

local FA_Warzone = Class(function(self, inst)
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
		},
		{
			name="war",
			length=4,
			onenter=function()

			end,
			onexit=function()

			end,
		}
	}
	self.phase=1

	self.totalsegs = 16
	self.segtime = 30

	self.timeLeftInEra=self.phases[self.phase].length*self.segtime

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

function FA_Warzone:GetDaySegs()
	--eventually they may/will be different, for now...
	return self.phases
end

function FA_Warzone:GetTimeLeftInEra()
	return self.timeLeftInEra
end

function FA_Warzone:OnSave()
	return {
	phase = self.phase,
	timeLeftInEra = self.timeLeftInEra
	}
end

function FA_Warzone:OnLoad(data)
	if(data and data.phase)then
		self.phase=data.phase
	end

--	self.inst:PushEvent("phasechange", {oldphase = self.phase, newphase = self.phase})

	self.timeLeftInEra=data.timeLeftInEra or 0

end


function FA_Warzone:GetDebugString()
    return string.format("%s: %2.2f ", self.phase, self:GetTimeLeftInEra())
end


function FA_Warzone:GetPhase()
	return self.phase
end

function FA_Warzone:GetNextPhase()
	return self.phase % #self.phases +1
end

function FA_Warzone:NextPhase()
	local oldphase = self.phase
	self.phase=self:GetNextPhase()
	self.phases[oldphase].onexit()
	self.phases[self.phase].onenter()
	self.timeLeftInEra=self.phases[self.phase].length*self.segtime

	self.inst:PushEvent("warphasechange", {oldphase = self.phases[oldphase], newphase = self.phases[self.phase]})
end

function FA_Warzone:OnUpdate(dt)
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


function FA_Warzone:LerpAmbientColour(src, dest, time)
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

function FA_Warzone:LerpFactor()
	if self.totallerptime == 0 then
		return 1
	else
		return math.min( 1.0, 1.0 - self.lerptimeleft / self.totallerptime )
	end
end

function FA_Warzone:LongUpdate(dt)
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

return FA_Warzone