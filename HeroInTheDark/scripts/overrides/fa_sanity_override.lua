local easing = require("easing")
local EVIL_SANITY_AURA_OVERRIDE={
    robin=-TUNING.SANITYAURA_MED,
    pigman=-TUNING.SANITYAURA_MED,
    crow=-TUNING.SANITYAURA_MED,
    robin_winter=-TUNING.SANITYAURA_MED,
    beefalo=-TUNING.SANITYAURA_MED,
    babybeefalo=-TUNING.SANITYAURA_MED,
    butterfly=-TUNING.SANITYAURA_MED,
    spider_hider=0,
    spider_spitter=0,
    spider_dropper=0,
    spider=0,
    poisonspider=0,
    flower_evil=TUNING.SANITYAURA_MED,
    ghost=TUNING.SANITYAURA_MED,
    skeletonspawn=TUNING.SANITYAURA_MED,
    fa_drybones=TUNING.SANITYAURA_MED,
    fa_dartdrybones=TUNING.SANITYAURA_MED,
    fa_skull=TUNING.SANITYAURA_MED,
    mound=TUNING.SANITYAURA_MED,
    hound=0,
    icehound=0,
    firehound=0,
    houndfire=0,
    nightlight=TUNING.SANITYAURA_MED,--would have to properly code this
    rabbit=-TUNING.SANITYAURA_MED,--and this
    crawlinghorror=0,
    terrorbeak=0,
    shadowtentacle=0,
    shadowwaxwell=0,
    shadowhand=0,
    slurper=0,
    spiderqueen=-TUNING.SANITYAURA_MED,
    spider_warrior=0,
    tentacle=0,
    tentacle_pillar_arm=0,
    walrus=-TUNING.SANITYAURA_MED,
    little_walrus=-TUNING.SANITYAURA_MED,
    worm=0,
    penguin=-TUNING.SANITYAURA_MED,
    flower=-TUNING.SANITYAURA_MED
}


local sanitymod=require "components/sanity"
local sanity_onupdate=sanitymod.OnUpdate

function sanitymod:OnUpdate(dt)
    sanity_onupdate(self,dt)

    --recalc the % taking drunkedness into account if there
    if(self.inst.components.fa_intoxication and self.inst.components.fa_intoxication.current>=40)then
        --whatever am i supposed to do with this?
        local adjusted=math.max(self:GetPercent()-(self.inst.components.fa_intoxication.current)/150.0,0)    
--        local speed = easing.outQuad( 1 - adjusted, 0, .2, 1) 
        --self.fxtime = self.fxtime + dt*speed    
--        PostProcessor:SetEffectTime(self.fxtime+dt*speed)

        local distortion_value = easing.outQuad( adjusted, 0, 1, 1) 
        PostProcessor:SetDistortionFactor(distortion_value)
        PostProcessor:SetDistortionRadii( 0.5, 0.685 )

    end
end


function sanitymod:Recalc(dt)
    local total_dapperness = self.dapperness or 0
    local mitigates_rain = false
    
                    for k,v in pairs (self.inst.components.inventory.equipslots) do
                        --might as well fix the compat PROPERLY while here eh
                        local dapperness=nil
                        if(v.components.equippable and v.components.equippable.GetDapperness) then
                            dapperness= v.components.equippable:GetDapperness(self.inst)
                        end
                        if(not dapperness and v.components.dapperness)then
                            dapperness=v.components.dapperness:GetDapperness(self.inst)
                            if v.components.dapperness.mitigates_rain then
                              mitigates_rain = true
                            end
                        end
                        if dapperness then
                            total_dapperness = total_dapperness + dapperness 
                        end     
                    end

    -- WTB PROPER ? operator
    if(self.dapperness_mult==nil)then
        total_dapperness = total_dapperness * self.dapperness_mult 
    end

    local moisture_delta=0
    if(self.GetMoistureDelta)then
        moisture_delta=self:GetMoistureDelta()
    end

    local dapper_delta = total_dapperness*TUNING.SANITY_DAPPERNESS
    
    local light_delta = 0
    local lightval = self.inst.LightWatcher:GetLightValue()
    
    local day = GetClock():IsDay() and not GetWorld():IsCave()
    
    if day then 
        if(self.inst:HasTag("evil"))then
            light_delta= SANITY_DAY_LOSS
        else
            light_delta = TUNING.SANITY_DAY_GAIN
        end
    else    
        if not self.inst:HasTag("evil")then

            local highval = TUNING.SANITY_HIGH_LIGHT
            local lowval = TUNING.SANITY_LOW_LIGHT

            if lightval > highval then
                light_delta =  TUNING.SANITY_NIGHT_LIGHT
            elseif lightval < lowval then
                light_delta = TUNING.SANITY_NIGHT_DARK
            else
                light_delta = TUNING.SANITY_NIGHT_MID
            end

            light_delta = light_delta*self.night_drain_mult
        --should this go instead or in front of night drain? 
            if(GetClock():IsDusk())then
                light_delta=light_delta*self.duskmultiplier
            end

        end

    end
    
    local aura_delta = 0
    local x,y,z = self.inst.Transform:GetWorldPosition()
    local ents = TheSim:FindEntities(x,y,z, TUNING.SANITY_EFFECT_RANGE, nil, {"FX", "NOCLICK", "DECOR","INLIMBO"} )
    for k,v in pairs(ents) do 
        local aura_val=nil
        if(self.inst:HasTag("evil"))then
            aura_val=EVIL_SANITY_AURA_OVERRIDE[v.prefab]
        end
        
        if aura_val==nil and v.components.sanityaura and v ~= self.inst then
            local distsq = self.inst:GetDistanceSqToInst(v)
            aura_val = v.components.sanityaura:GetAura(self.inst)/math.max(1, distsq)
        end

        if(aura_val)then
            if aura_val < 0 then
                aura_val = aura_val * self.neg_aura_mult
            end
            aura_delta = aura_delta + aura_val
        end
    end

    local rain_delta = 0
    if(not FA_DLCACCESS)then
        if GetSeasonManager() and GetSeasonManager():IsRaining() and not mitigates_rain then
            rain_delta = -TUNING.DAPPERNESS_MED*1.5* GetSeasonManager():GetPrecipitationRate()
        end
    end

    self.rate = (dapper_delta + moisture_delta + light_delta + aura_delta ) 
    
    if self.custom_rate_fn then
        self.rate = self.rate + self.custom_rate_fn(self.inst)
    end

    --print (string.format("dapper: %2.2f light: %2.2f TOTAL: %2.2f", dapper_delta, light_delta, self.rate*dt))
    self:DoDelta(self.rate*dt, true)
end
