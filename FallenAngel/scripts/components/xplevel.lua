require "mobxptable"
require "levelxptable"

local XPLevel = Class(function(self, inst)
    self.level=1
    self.inst = inst
    self.max = LEVELXP_TABLE[1].max
    self.currentxp = 0
	
end)

local LEVEL_CAP=20

function XPLevel:OnRespawn()
	end

function XPLevel:OnSave()
--    if self.currentxp ~= self.max then
        return {level = self.level,currentxp=self.currentxp}
--    end
end

function XPLevel:OnLoad(data)
    self.level=data.level or self.level
    self.currentxp=data.currentxp or self.currentxp  
    self.max=LEVELXP_TABLE[self.level].max
    self:DoDelta(0)
    self.inst:PushEvent("xplevel_loaded")
end

function XPLevel:LongUpdate(dt)
--	self:DoDec(dt, true)
end

function XPLevel:SetMax(amount)
    self.max = amount
end

function XPLevel:DoDelta(delta)

    local old = self.currentxp
    local oldlevel = self.level
    if(self.level~=LEVEL_CAP)then

        self.currentxp = self.currentxp + delta
        if self.currentxp >= self.max then
            self.level=self.level+1
            if(self.level~=LEVEL_CAP)then
                self.currentxp=self.currentxp-self.max
                self.max=LEVELXP_TABLE[self.level].max
            else
                self.currentxp=0
            end
            self.inst:PushEvent("xplevelup",{level=self.level})
        end
    else

    end
        self.inst:PushEvent("xpleveldelta", {old= old, new = self.currentxp,max=self.max,level=self.level})
end

function XPLevel:GetPercent(p)
    return self.currentxp / self.max
end

return XPLevel
