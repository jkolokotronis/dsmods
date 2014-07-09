local FA_BuffUtil=require "buffutil"


local FA_BuffTimers = Class(function(self, inst)
    self.buff_timers={}
    self.inst = inst
    self.inst:StartUpdatingComponent(self)
	
end)

local LEVEL_CAP=20

function FA_BuffTimers:OnRespawn()
	end

function FA_BuffTimers:GetTimers()
    return self.buff_timers
end

function FA_BuffTimers:OnSave()
    local saveents={}
    for k,v in pairs(self.buff_timers) do 
        if(v.cooldowntimer>0)then
            saveents[k]={}
            saveents[k].cooldowntimer=v.cooldowntimer
            saveents[k].fname=v.fname
            saveents[k].name=v.name
        end
    end
    return {saveents=saveents}
end

function FA_BuffTimers:LoadPostPass(newents, data)
    for k,v in pairs(self.buff_timers) do
        if(v.fname)then
            FA_BuffUtil[v.fname](self.inst,v.cooldowntimer)
        end
    end 
end

function FA_BuffTimers:OnLoad(data)
    --main reason to reload like this is to allow the 'default' crap from init/postinit to be preserved on old saves
    if(data and data.saveents)then
        for k,v in pairs(data.saveents) do
            self.buff_timers[k]=v
            --is it safe to call the f here? 
            --hmph pointless... it wont be there in time to trigger updates
--            self.inst:PushEvent("fa_startbuff",{name=v.name,timer=v.cooldowntimer})
        end
    end
end

function FA_BuffTimers:AddBuff(id,name,fn,timer)
    self.buff_timers[id]={}
    self.buff_timers[id].name=name
    self.buff_timers[id].fname=fn
    self.buff_timers[id].cooldowntimer=timer
    FA_BuffUtil[fn](self.inst,timer)
    self.inst:PushEvent("fa_addbuff",{id=id,buff=self.buff_timers[id]})
end

function FA_BuffTimers:LongUpdate(dt)
	self:DoDelta(dt, true)
    self.inst:PushEvent("fa_rebuildbuffs",{buffs=self.buff_timers})
end

function FA_BuffTimers:ForceRemove(id)
    local buff=self.buff_timers[id]
    if(buff)then
        self.buff_timers[id]=nil
        self.inst:PushEvent("fa_removebuff",{id=id})
    end
end

--ideally... the controls go just from here, but sending 1000 events/second is far from worth the clear separation, plus lack of mutexes would cause way too many race conditions
function FA_BuffTimers:OnUpdate(delta)

    for k,v in pairs(self.buff_timers) do
        v.cooldowntimer=v.cooldowntimer-delta
--        print(k,v.cooldowntimer,v.btn)
        if(v.cooldowntimer<=0)then
            self.buff_timers[k]=nil
            self.inst:PushEvent("fa_removebuff",{id=k})
        elseif(v.btn)then
            v.btn.cooldowntext:SetString(""..math.floor(v.cooldowntimer))
        end
    end
end

return FA_BuffTimers
