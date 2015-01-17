local FA_Intoxication = Class(function(self, inst)
    self.inst = inst
    self.max = 100
    self.current = 0
    self.decrate = 1
    self.period = 10
    self.sanitytrans=0

    self.intox_fx={
        {
            onenter=function()
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance+0.05
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure+0.03
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier+0.1
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier+0.1
                end
            end,
            onexit=function()
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance-0.05
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure-0.03
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier-0.1
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier-0.1
                end
            end,
            active=false            
        },
        {
            onenter=function()
                self.sanitytrans=0.2
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
            end,
            onexit=function()
                self.sanitytrans=0
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
            end,
            active=false            
        }
    }
    
    self.inst:ListenForEvent("respawn", function(inst) self:OnRespawn() end)
    self.inst:ListenForEvent("healthdelta", function(inst,data) self:OnHealthDelta(data) end)
--    self.task = self.inst:DoPeriodicTask(self.period, function() self:DoDec(self.period) end)
    self.inst:StartUpdatingComponent(self)
end)

function FA_Intoxication:OnHealthDelta(data)
    if(self.sanitytrans>0)then
        local deltapercent=data.newpercent-data.oldpercent
        local delta=deltapercent*self.inst.components.health.maxhealth
        if(delta<0)then
            self.inst.components.sanity:DoDelta(delta*self.sanitytrans)
        end
    end
end

function FA_Intoxication:OnRespawn()
    self:SetPercent(0)
    end

function FA_Intoxication:OnSave()
    return {current = self.current}
end

function FA_Intoxication:OnLoad(data)
    if data.current then
        self.current = data.current
        self:DoDelta(0)
    end
end

function FA_Intoxication:OnUpdate(dt)
    if(self.current>0)then
        self:DoDelta(-self.decrate*dt/self.period)
    end
end

function FA_Intoxication:LongUpdate(dt)
    self:OnUpdate(dt, true)
end

function FA_Intoxication:GetDebugString()
    return string.format("%2.2f / %2.2f", self.current, self.max)
end

function FA_Intoxication:SetMax(amount)
    self.max = amount
end

function FA_Intoxication:DoDelta(delta)
    
    local old = self.current
    self.current = self.current + delta
    if self.current < 0 then 
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end
    self.inst:PushEvent("fa_intoxicationdelta", {oldpercent = old/self.max, newpercent = self.current/self.max,max=self.max})
    
end

function FA_Intoxication:GetPercent(p)
    return self.current / self.max
end

function FA_Intoxication:SetPercent(p)
    local old = self.current
    self.current  = p*self.max
    self.inst:PushEvent("fa_intoxicationdelta", {oldpercent = old/self.max, newpercent = p})
end

function FA_Intoxication:SetRate(rate)
    self.decrate = rate
end

function FA_Intoxication:GetRate()
    return self.decrate
end
return FA_Intoxication
