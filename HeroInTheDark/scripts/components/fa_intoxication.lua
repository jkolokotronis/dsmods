local FA_Intoxication = Class(function(self, inst)
    self.inst = inst
    self.max = 100
    self.current = 0
    self.decrate = 1
    self.period = 10
    self.sanitytrans=0

    self.intox_fx={
    --10
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
    --20
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
        },
    --30
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance+0.05
                self.old_duskmultiplier=self.inst.components.sanity.duskmultiplier
                self.inst.components.sanity.duskmultiplier=0
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure+0.15
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier+0.1
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier+0.1
                end
                self.ignoresspoilage=self.inst.components.eater.ignoresspoilage
                self.inst.components.eater.ignoresspoilage=true
            end,
            onexit=function()
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure-0.15
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier-0.1
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier-0.1
                end
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance-0.05
                self.inst.components.sanity.duskmultiplier=self.old_duskmultiplier
                self.inst.components.eater.ignoresspoilage=elf.ignoresspoilage
            end,
            active=false            
        },
    --40
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
                self.inst.components.health.absorb=self.inst.components.health.absorb-0.05
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
                self.inst.components.health.absorb=self.inst.components.health.absorb+0.05
            end,
            active=false            
        },
    --50
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
                self.neg_aura_mult=self.inst.components.sanity.neg_aura_mult
                self.inst.components.sanity.neg_aura_mult=0
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure+0.18
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier+0.2
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier+0.2
                end
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
                self.inst.components.sanity.neg_aura_mult=self.neg_aura_mult
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure-0.15
                end
                self.inst.components.combat.damagemultiplier=self.inst.components.combat.damagemultiplier-0.1
                --TODO I really need to solve this in a better way
                if(self.inst.components.combat.fa_basedamagemultiplier)then                       
                    self.inst.components.combat.fa_basedamagemultiplier=self.inst.components.combat.fa_basedamagemultiplier-0.1
                end
            end,
            active=false            
        },
    --60
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
                self.monsterimmune=self.inst.components.eater.monsterimmune
                self.inst.components.eater.monsterimmune=true
                self.strongstomach=self.inst.components.eater.strongstomach
                self.inst.components.eater.strongstomach=true
                self.night_drain_mult=self.inst.components.sanity.night_drain_mult
                self.inst.components.sanity.night_drain_mult=0
                self.sanitytrans= self.sanitytrans+0.2
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
                self.inst.components.eater.monsterimmune=self.monsterimmune
                self.inst.components.eater.strongstomach=elf.strongstomach
                self.inst.components.sanity.night_drain_mult=self.night_drain_mult
                 self.sanitytrans= self.sanitytrans-0.2
            end,
            active=false            
        },
    --70
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.05
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance+0.2
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.05
                self.inst.components.health.fa_dodgechance=self.inst.components.health.fa_dodgechance-0.2
            end,
            active=false            
        },
    --80
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.1
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure+1
                end
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.1
                if(self.inst.components.fa_spellcaster)then
                   self.inst.components.fa_spellcaster.castfailure=self.inst.components.fa_spellcaster.castfailure-1
                end
            end,
            active=false            
        },
    --90
        {
            onenter=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate+0.1
                self.inst.components.health.absorb=self.inst.components.health.absorb-0.2
            end,
            onexit=function()
                self.inst.components.hunger.hungerrate=self.inst.components.hunger.hungerrate-0.1
                self.inst.components.health.absorb=self.inst.components.health.absorb+0.2
            end,
            active=false            
        },
    --100
        {
            onenter=function()
                local talk=GetString( self.inst.prefab, "FA_WONDER_SLEEP")
                if(talk and eater.components.talker) then eater.components.talker:Say(talk) end
                eater.components.locomotor:Stop()
                eater.sg:GoToState("sleep")
                eater.components.health:SetInvincible(true)
                eater.components.playercontroller:Enable(false)

                GetPlayer().HUD:Hide()
                TheFrontEnd:Fade(false,1)
                eater:DoTaskInTime(1.2, function() 
                    GetPlayer().HUD:Show()
                    TheFrontEnd:Fade(true,1) 
                    eater.components.health:SetInvincible(false)
                    eater.components.playercontroller:Enable(true)
                    GetClock():MakeNextDay()
                    eater.sg:GoToState("wakeup")    
                    self:SetPercent(0)
                end)
            end,
            onexit=function()
            end,
            active=false            
        }
    }
    
    self.inst:ListenForEvent("respawn", function(inst) self:OnRespawn() end)
    self.inst:ListenForEvent("healthdelta", function(inst,data) self:OnHealthDelta(data) end)
    self.inst:ListenForEvent("oneatsomething", function(inst,data) self:OnEatSomething(data) end)
    self.inst:ListenForEvent("onattackother",function(inst,data) self:OnAttack(data) end )
--    self.task = self.inst:DoPeriodicTask(self.period, function() self:DoDec(self.period) end)
    self.inst:StartUpdatingComponent(self)
end)

function FA_Intoxication:OnAttack(data)
    local held_weapon=self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
    local rng=math.random()
    if(held_weapon and ((self.current>=90 and rng<=0.6) or (self.current>=70 and rng<=0.3) or (self.current>=50 and rng<0.15)))then

    inst.components.inventory:Unequip(EQUIPSLOTS.HANDS, true) 
    inst.components.inventory:DropItem(held_weapon)
    if held_weapon.Physics then

        local x, y, z = held_weapon:GetPosition():Get()
        y = .3
        held_weapon.Physics:Teleport(x,y,z)

        local hp = target:GetPosition()
        local pt = inst:GetPosition()
        local vel = (hp - pt):GetNormalized()     
        local speed = 3 + (math.random() * 2)
        local angle = -math.atan2(vel.z, vel.x) + (math.random() * 20 - 10) * DEGREES
        held_weapon.Physics:SetVel(math.cos(angle) * speed, 10, math.sin(angle) * speed)
        self.inst.components.talker:Say(GetString(held_weapon.prefab, "ANNOUNCE_TOOL_SLIP"))
    end

    end
end

function FA_Intoxication:OnEatSomething( data )
    local food=data.food
    if(self.current>=30 and food.components.edible.foodtype == "HORRIBLE")then
        self.inst.components.hunger:DoDelta(40)
    elseif(self.current>=60 and (food.prefab=="monstermeat" or food.prefab=="cookedmonstermeat" or food.prefab=="monstermeat_dried"))then
        self.inst.components.hunger:DoDelta(20)
    elseif(self.current>=60 and food.components.edible.ismeat)then
        self.inst.components.hunger:DoDelta(food.edible.hungervalue/2.0)
    elseif(self.current>=80 and food.prefab=="spoiled_food")then
        self.inst.components.hunger:DoDelta(5)
    elseif(self.current>=80 and food.prefab=="plantmeat")then
        self.inst.components.hunger:DoDelta(TUNING.CALORIES_MED)
    end
end

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
        self:DoDelta(self.current)
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


function FA_Intoxication:UpdateToxEffects(oldv,newv)

    for i=1,math.floor(newv/10) do
        local bufftostart=self.intox_fx[i]
        if(bufftostart and not bufftostart.active)then
            bufftostart.active=true
            bufftostart.onenter()
        end
    end
    if(oldv>newv)then
        for i=math.floor(newv/10)+1,math.floor(oldv/10) do
            local bufftostart=self.intox_fx[i]
            if(bufftostart and bufftostart.active)then
                bufftostart.active=false
                bufftostart.onexit()
            end
        end
    end

end

function FA_Intoxication:DoDelta(delta)
    
    local old = self.current
    self.current = self.current + delta
    if self.current < 0 then 
        self.current = 0
    elseif self.current > self.max then
        self.current = self.max
    end
    self:UpdateToxEffects(old,self.current)
    self.inst:PushEvent("fa_intoxicationdelta", {oldpercent = old/self.max, newpercent = self.current/self.max,max=self.max})
    
end

function FA_Intoxication:GetPercent(p)
    return self.current / self.max
end

function FA_Intoxication:SetPercent(p)
    local old = self.current
    self.current  = p*self.max
    self:UpdateToxEffects(old,self.current)
    self.inst:PushEvent("fa_intoxicationdelta", {oldpercent = old/self.max, newpercent = p})
end

function FA_Intoxication:SetRate(rate)
    self.decrate = rate
end

function FA_Intoxication:GetRate()
    return self.decrate
end
return FA_Intoxication
