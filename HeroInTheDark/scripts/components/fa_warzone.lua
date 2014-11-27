
local MINE_SPAWNS={
        {
            age=1,
            count=1,
            prefab="fa_redgoblin"
        },
        {
            age=3,
            count=1,
            prefab="fa_orc"
        },
        {
            age=7,
            count=2,
            prefab="fa_orc"
        },
        {
            age=10,
            count=3,
            prefab="fa_orc"
        },
        {
            age=15,
            count=5,
            prefab="fa_orc"
        },
        {
            age=20,
            count=10,
            prefab="fa_orc"
        },
        {
            age=25,
            count=15,
            prefab="fa_orc"
        },
        {
            age=30,
            count=20,
            prefab="fa_orc"
        },
        {
            age=35,
            count=25,
            prefab="fa_orc"
        }
    }

local FA_Warzone = Class(function(self, inst)
	self.inst = inst
	self.task = nil
	self.phases={
		{	
			name="peace",
			length=12,
			onenter=function()
				self:StopSpawner()
			end,
			onexit=function()

			end,
		},
		{
			name="war",
			length=4,
			onenter=function()
				self:SetSpawner()
			end,
			onexit=function()
				self.age=self.age+1
			end,
		}
	}
	self.phase=1
	self.age=1

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

    self.spawnlist=MINE_SPAWNS
    self.currentspawns=nil

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
	currentspawns=self.currentspawns,
	age=self.age,
	timeLeftInEra = self.timeLeftInEra
	}
end

function FA_Warzone:OnLoad(data)
	if(data and data.phase)then
		self.phase=data.phase
		self.phases[self.phase].onenter()
--		self.inst:PushEvent("warphasechange",  {oldphase = nil, newphase = self.phases[self.phase]})
	end


	self.currentspawns=data.currentspawns
	self.age=data.age or 1 
	self.timeLeftInEra=data.timeLeftInEra or 0
end


function FA_Warzone:GetDebugString()
    return string.format("%s: %2.2f ", self.phase, self:GetTimeLeftInEra())
end

function FA_Warzone:GetPhaseById(i)
	return self.phases[i]
end

function FA_Warzone:GetPhase()
	return self.phase
end

function FA_Warzone:NextPhase(phase,left)
	local oldphase = self.phase
	self.phase=phase
	self.phases[oldphase].onexit()
	self.phases[self.phase].onenter()
	if(left)then
		self.timeLeftInEra=left
	else
		self.timeLeftInEra=self.phases[self.phase].length*self.segtime
	end
	self.inst:PushEvent("warphasechange", {oldphase = self.phases[oldphase], newphase = self.phases[self.phase]})

end

function FA_Warzone:SetSpawner()
	local worldage=self.inst.components.age:GetAge() / TUNING.TOTAL_DAY_TIME --TODO I think the age thing is broken, ill have to rewrite it proper self.age
	self.currentspawns=nil
	local newspawner=nil
	for k,v in ipairs(self.spawnlist) do
		if(v.age<=worldage)then newspawner=v
		else break
		end
	end
	if(newspawner)then
		self.currentspawns=deepcopy(newspawner)
		self.currentspawns.period=self.phases[self.phase].length*self.segtime/self.currentspawns.count
		self.currentspawns.count=math.ceil(self.timeLeftInEra/self.currentspawns.period)--ceil because 1 will always be lost otherwise, as timeleft has to be a few ms below max
		self.currentspawns.countdown=0
--		self.currentspawns.endcountdown=count*self.currentspawns.period
	end
end

function FA_Warzone:StopSpawner()
	self.currentspawns=nil
end

local function SpawnMob(prefab)
	local player=GetPlayer()
	local pt = Vector3(player.Transform:GetWorldPosition())
    local theta = math.random() * 2 * PI
    local radius = 15

	local offset = FindWalkableOffset(pt, theta, radius, 12, true)
	if offset then
		local wander_point=pt+offset
		local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( wander_point.x, wander_point.y, wander_point.z )

            local spider = SpawnPrefab(prefab)
            spider.Transform:SetPosition( wander_point.x, wander_point.y, wander_point.z )
--            spider:DoTaskInTime(1, settarget, player)
            if(spider.components.combat)then
                spider.components.combat:SuggestTarget(player)
            end
		return pt+offset
	end
end

function FA_Warzone:OnUpdate(dt,longupdate)
	self.timeLeftInEra = self.timeLeftInEra - dt
	local time_left_over = -self.timeLeftInEra
	local phase=self.phase
	local phasechange=0
	while(self.timeLeftInEra<=0)do
		phasechange=phasechange+1
		phase=phase % #self.phases +1
		self.timeLeftInEra=self.phases[phase].length*self.segtime-time_left_over
		time_left_over = -self.timeLeftInEra
	end
	if(phasechange>0)then
		self:NextPhase(phase,-time_left_over)
	elseif not(longupdate) and self.currentspawns and self.currentspawns.count>0 then
		self.currentspawns.countdown=self.currentspawns.countdown-dt
		if(self.currentspawns.countdown<=0)then
			self.currentspawns.countdown=self.currentspawns.period
			self.currentspawns.count=self.currentspawns.count-1
			SpawnMob(self.currentspawns.prefab)
		end
	end

--[[ recursion + pushevents just cries for trouble
	if self.timeLeftInEra <= 0 then
		local time_left_over = -self.timeLeftInEra
		self:NextPhase()

		if time_left_over > 0 then
			self:OnUpdate(time_left_over,true)
			return
		end
	end

 not sure if/what i want to do with graphics... or should it be done here at all
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
	self:OnUpdate(dt,true)
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