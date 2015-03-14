local CooldownButton = require "widgets/cooldownbutton"

local BB_RADIUS=9
local BB_DAMAGE=30
local BB_PERIOD=2
local DM_DAMAGE_MULT_BOOST=1.0
local IC_DAMAGE_MULT_BOOST=0.2
local DM_HP_BOOST=100
local DM_MS_BOOST=0.25*TUNING.WILSON_RUN_SPEED
local IA_MS_BOOST=1*TUNING.WILSON_RUN_SPEED
local IG_HP_BOOST=150
local IG_DODGE_BOOST=0.25

local HASTE_SPEED_BOOST=TUNING.WILSON_RUN_SPEED
local HASTE_DODGE_BOOST=0.25
local HASTE_ATTACK_BOOST=0.5

FA_BuffUtil={}

function InitBuffBar(inst,buff,timer,class,name)
        inst.buff_timers[buff]=CooldownButton(class.owner)
        inst.buff_timers[buff]:SetText(name)
        --override clicks to never work
        inst.buff_timers[buff]:SetOnClick(function() return false end)
        inst.buff_timers[buff]:SetOnCountdownOver(function() inst.buff_timers[buff]:Hide() end)
        if(timer and timer>0)then
             inst.buff_timers[buff]:ForceCooldown(timer)
        else
            inst.buff_timers[buff]:Hide()
        end
        local btn=class:AddChild(inst.buff_timers[buff])
        return btn
end

local ig_start=function(inst, target, variables)
    local target=inst.components.spell.target
    if target and target.components.health then
        target.components.health.fa_temphp=IG_HP_BOOST
        target.components.health.fa_dodgechance=IG_DODGE_BOOST+target.components.health.fa_dodgechance
    end
end

local function FA_InspireGreatnessSpellStart( reader,timer)

    if(timer==nil or timer<=0)then return false end

    if reader.fa_inspiregreatness then
        reader.fa_inspiregreatness.components.spell.lifetime = 0
        reader.components.health.fa_temphp=IG_HP_BOOST
--        reader.fa_inspiregreatness.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_inspiregreatness"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_inspiregreatness = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = ig_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.health:DoDelta(0)
        reader.components.health.fa_dodgechance=IG_DODGE_BOOST-reader.components.health.fa_dodgechance
        inst.components.spell.target.fa_inspiregreatness = nil
    end

        inst.components.spell.resumefn = ig_start
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.InspireGreatness=FA_InspireGreatnessSpellStart

local ia_start=function(inst, target, variables)
    local target=inst.components.spell.target
    if target then
        target.components.locomotor.runspeed=target.components.locomotor.runspeed+IA_MS_BOOST
    end
end

local function FA_InspireAgilitySpellStart( reader,timer)

    if(timer==nil or timer<=0)then return false end

    if reader.fa_inspireagility then
        reader.fa_inspireagility.components.spell.lifetime = 0
--        reader.fa_inspireagility.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_inspireagility"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_inspireagility = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = ia_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed+IA_MS_BOOST
        inst.components.spell.target.fa_inspireagility = nil
    end

        inst.components.spell.resumefn = ia_start
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
end

FA_BuffUtil.InspireAgility=FA_InspireGreatnessSpellStart

local ic_start=function(inst)
    local target=inst.components.spell.target

    if target then
        target.components.combat.damagemultiplier=IC_DAMAGE_MULT_BOOST+target.components.combat.damagemultiplier
    end
end

local function FA_InspireCourageSpellStart( reader,timer)

    if(timer==nil or timer<=0)then return false end

    if reader.fa_inspirecourage then
        reader.fa_inspirecourage.components.spell.lifetime = 0
--        reader.fa_inspirecourage.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_inspirecourage"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_inspirecourage = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = ic_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.combat.damagemultiplier=reader.components.combat.damagemultiplier-IC_DAMAGE_MULT_BOOST
        inst.components.spell.target.fa_inspirecourage = nil
    end

        inst.components.spell.resumefn = ic_start
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
end

FA_BuffUtil.InspireCourage=FA_InspireCourageSpellStart

local dm_start=function(inst)
    local target=inst.components.spell.target
    if target then
        target.components.health.maxhealth=target.components.health.maxhealth+DM_HP_BOOST
        target.components.health.currenthealth=target.components.health.currenthealth+DM_HP_BOOST
        target.components.health:DoDelta(0)
        target.components.locomotor.runspeed=target.components.locomotor.runspeed+DM_MS_BOOST
        target.components.combat.damagemultiplier=DM_DAMAGE_MULT_BOOST+target.components.combat.damagemultiplier
    end
end

local function DivineMightSpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_divinemight then
        reader.fa_divinemight.components.spell.lifetime = 0
        reader.components.health.currenthealth=math.min(reader.components.health.currenthealth+DM_HP_BOOST,reader.components.health.maxhealth)
--        reader.fa_divinemight.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_divinemight"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_divinemight = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = dm_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.combat.damagemultiplier=reader.components.combat.damagemultiplier-DM_DAMAGE_MULT_BOOST
        reader.components.health.maxhealth=reader.components.health.maxhealth-DM_HP_BOOST
        reader.components.health:DoDelta(0)
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed-DM_MS_BOOST
        inst.components.spell.target.fa_divinemight = nil
    end

        inst.components.spell.resumefn = dm_start
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.DivineMight=DivineMightSpellStart


local resiststart=function(inst)
    local target=inst.components.spell.target
    if target then
        target.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=(target.components.health.fa_resistances[FA_DAMAGETYPE.FIRE] or 0)+0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=(target.components.health.fa_resistances[FA_DAMAGETYPE.COLD] or 0)+0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=(target.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC] or 0)+0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=(target.components.health.fa_resistances[FA_DAMAGETYPE.ACID] or 0) +0.3
    end
end

local function ResistanceSpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_resistance then
        reader.fa_resistance.components.spell.lifetime = 0
--        reader.fa_resistance.components.spell:ResumeSpell()
        return true
    else


    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_resistance"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_resistance = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = resiststart
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        local target=inst.components.spell.target
        target.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=(target.components.health.fa_resistances[FA_DAMAGETYPE.FIRE] or 0)-0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=(target.components.health.fa_resistances[FA_DAMAGETYPE.COLD] or 0)+0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=(target.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC] or 0)-0.3
        target.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=(target.components.health.fa_resistances[FA_DAMAGETYPE.ACID] or 0) -0.3
        inst.components.spell.target.fa_resistance = nil
    end

        inst.components.spell.resumefn = resiststart
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.Resistance=ResistanceSpellStart

local endurestart=function(inst)
    local target=inst.components.spell.target
    local variables=inst.components.spell.variables
    if target then
        if(variables and variables.summer)then
            target.components.temperature.inherentsummerinsulation = (target.components.temperature.inherentsummerinsulation or 0)+120
        else
            target.components.temperature.inherentinsulation = target.components.temperature.inherentinsulation +120
        end
    end
end

local function EndureElementsSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_endureelements then
        reader.fa_endureelements.components.spell:OnFinish()
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_endureelements"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_endureelements = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = endurestart
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        if(variables and variables.summer)then
            reader.components.temperature.inherentsummerinsulation = (reader.components.temperature.inherentsummerinsulation or 0)-120
        else
            reader.components.temperature.inherentinsulation = reader.components.temperature.inherentinsulation -120
        end
        inst.components.spell.target.fa_endureelements = nil
    end

        inst.components.spell.resumefn = endurestart
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.EndureElements=EndureElementsSpellStart


local drstart=function(inst)
    local target=inst.components.spell.target
    local variables=inst.components.spell.variables
    local damagetype=variables.damagetype
    local drdelta=variables.drdelta
    if target then
        target.components.health.fa_damagereduction[damagetype]=(target.components.health.fa_damagereduction[damagetype] or 0)+drdelta
    end
end

local function DamageReductionSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_damagereduction then
        reader.fa_damagereduction.components.spell:OnFinish()
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_damagereduction"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_damagereduction = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = drstart
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        local target=inst.components.spell.target
        local damagetype=variables.damagetype
        local drdelta=variables.drdelta
        target.components.health.fa_damagereduction[damagetype]=(target.components.health.fa_damagereduction[damagetype] or 0)-drdelta
        inst.components.spell.target.fa_damagereduction = nil
    end

        inst.components.spell.resumefn = drstart
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.DamageReduction=DamageReductionSpellStart

local function damagetransformlistener(inst,data)
        local deltapercent=data.newpercent-data.oldpercent
        local delta=deltapercent*inst.components.health.maxhealth
        if(delta<0)then
            inst.components.sanity:DoDelta(-delta*1)
        end
end

local dmgxformstart=function(inst)
    local target=inst.components.spell.target
    local variables=inst.components.spell.variables
    if target then
        target:ListenForEvent("healthdelta", damagetransformlistener)
    end
end

local function DamageSanityTransformSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_damagetransform then
        reader.fa_damagetransform.components.spell.lifetime = 0
        reader.fa_damagetransform.components.spell:ResumeSpell()
        return
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_damagetransform"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_damagetransform = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = dmgxformstart
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        local target=inst.components.spell.target
        reader:RemoveEventCallback("healthdelta", damagetransformlistener)
        inst.components.spell.target.fa_damagetransform = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.DamageSanityTransform=DamageSanityTransformSpellStart


local function DamageMultiplierSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_damagemultiplier then
        reader.fa_damagemultiplier.components.spell:OnFinish()
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_damagemultiplier"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    local multiplier=(variables and variables.multiplier) or 0.1
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_damagemultiplier = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        reader.components.combat.damagemultiplier=reader.components.combat.damagemultiplier+multiplier
        if(reader.components.combat.fa_basedamagemultiplier)then                       
           reader.components.combat.fa_basedamagemultiplier=reader.components.combat.fa_basedamagemultiplier+multiplier
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
         reader.components.combat.damagemultiplier=reader.components.combat.damagemultiplier-multiplier
        if(reader.components.combat.fa_basedamagemultiplier)then                       
           reader.components.combat.fa_basedamagemultiplier=reader.components.combat.fa_basedamagemultiplier-multiplier
        end
        inst.components.spell.target.fa_damagemultiplier = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.DamageMultiplier=DamageMultiplierSpellStart



local function DappernessSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_dapperness then
        reader.fa_dapperness.components.spell:OnFinish()
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_dapperness"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    local dapperness=(variables and variables.dapperness) or 0.5
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_dapperness = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        reader.components.sanity.dapperness=(reader.components.sanity.dapperness or 0)+dapperness
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.sanity.dapperness=(reader.components.sanity.dapperness or 0)-dapperness
        inst.components.spell.target.fa_dapperness = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.Dapperness=DappernessSpellStart

local function HealthRegenSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_healthregen then
        reader.fa_healthregen.components.spell:OnFinish()
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_healthregen"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_healthregen = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        if(reader.components.health.regen.task~=nil)then
            reader.components.health:StartRegen(1, 1)
        else
            reader.components.health.regen.amount=reader.components.health.regen.amount+1*reader.components.health.regen.period
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        if(reader.components.health.regen.task~=nil)then
            reader.components.health.regen.amount=reader.components.health.regen.amount-1*reader.components.health.regen.period
            if(reader.components.health.regen.amount<=0)then
                reader.components.health:StopRegen()
            end
        end
        inst.components.spell.target.fa_healthregen = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.HealthRegen=HealthRegenSpellStart

local fearreflectevent=function(owner,data) 
    if(data and data.attacker and math.random()<=0.5)then
        local target=data.attacker
        --the whole spell crap should really be in single place... in next lifetime
        if(target.fa_fear)then target.fa_fear.components.spell:OnFinish() end
        
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_fear"
        inst.components.spell.duration = 15
        inst.components.spell.ontargetfn = function(inst,target)
            target.fa_fear = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_fear = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
        
    end
end

local function FearReflectSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_fearreflect then
        reader.fa_fearreflect.components.spell.lifetime = 0
        reader.fa_fearreflect.components.spell:ResumeSpell()
        return
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_fearreflect"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    local dapperness=(variables and variables.dapperness) or 0.5
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_fearreflect = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        reader:ListenForEvent("attacked",fearreflectevent)
        reader:ListenForEvent("blocked",fearreflectevent)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader:RemoveEventCallback("blocked", fearreflectevent)
        reader:RemoveEventCallback("attacked", fearreflectevent)
        inst.components.spell.target.fa_fearreflect = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.FearReflect=FearReflectSpellStart

local function FriendlyBeesSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_friendlybees then
        reader.fa_friendlybees.components.spell.lifetime = 0
        reader.fa_friendlybees.components.spell:ResumeSpell()
        return
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_friendlybees"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    local dapperness=(variables and variables.dapperness) or 0.5
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_friendlybees = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        if(reader:HasTag("insect"))then
            inst.fa_ignoreinsect=true
        else
            reader:AddTag("insect")
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        if(not inst.fa_ignoreinsect)then
            reader:RemoveTag("insect")
        end
        inst.components.spell.target.fa_friendlybees = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.FriendlyBees=FriendlyBeesSpellStart

local function FriendlyWormsSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_friendlyworms then
        reader.fa_friendlyworms.components.spell.lifetime = 0
        reader.fa_friendlyworms.components.spell:ResumeSpell()
        return
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_friendlyworms"
    inst.components.spell.duration = timer
    inst.components.spell.variables=variables
    local dapperness=(variables and variables.dapperness) or 0.5
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_friendlyworms = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)

    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end

        inst.components.spell.target.fa_friendlyworms = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.FriendlyWorms=FriendlyWormsSpellStart


local lightfn=function(inst, target, variables)
    if target then
        inst.Transform:SetPosition(target:GetPosition():Get())
    end
end

local function light_start(inst)
    local spell = inst.components.spell
    inst.Light:Enable(true)

end
local function create_light(timer)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddLight()

    inst.Light:SetRadius(6)
    inst.Light:SetFalloff(0.5)
    inst.Light:SetIntensity(0.8)
    inst.Light:SetColour(155/255,155/255,255/255)

    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_banishdarkness"
--    inst.components.spell:SetVariables(light_variables)
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_banishdarkness = inst
        target:AddTag(inst.components.spell.spellname)
        target.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    end
    inst.components.spell.onstartfn = light_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_banishdarkness = nil
        inst.components.spell.target.AnimState:ClearBloomEffectHandle()
    end
    inst.components.spell.fn = lightfn
    --the load/save on spells... can be done through char's own control but 
    --I can either let old entity die and recast, or use the provided resumes, supposedly
    inst.components.spell.resumefn = light_start
    inst.components.spell.removeonfinish = true

    return inst

end

local function createfrozenSlowDebuff(target,timer)
    local inst = CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_frozenslow"
--    inst.components.spell:SetVariables(light_variables)
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_frozenslow = inst
        target:AddTag(inst.components.spell.spellname)
        if(target.components.combat)then
            print("slowing down")
            target.components.combat.min_attack_period=target.components.combat.min_attack_period*2
        end
        if(target.components.locomotor)then
            print("snare")
            target.components.locomotor.runspeed=target.components.locomotor.runspeed/2
        end
    end
    inst.components.spell.onstartfn = function(inst)    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_frozenslow = nil
        if(target.components.combat)then
            print("speeding up")
            target.components.combat.min_attack_period=target.components.combat.min_attack_period/2
        end
        if(target.components.locomotor)then
            print("unsnare")
            target.components.locomotor.runspeed=target.components.locomotor.runspeed*2
        end
    end
--    inst.components.spell.fn = lightfn
    inst.components.spell.resumefn = function(inst,timeleft)   end 
    inst.components.spell.removeonfinish = true
    return inst
end

local function frozenSlowDebuff(target,timer)
    if(timer==nil or timer<=0)then return false end
    if(target.fa_frozenslow)then
        target.fa_frozenslow.components.spell.lifetime = 0
        target.fa_frozenslow.components.spell:ResumeSpell()
    else
        local inst=createfrozenSlowDebuff(target,timer)
        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end
    return true

end
FA_BuffUtil.FrozenSlowDebuff=frozenSlowDebuff

function LightSpellStart(reader,timer)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_banishdarkness then
        reader.fa_banishdarkness.components.spell.lifetime = 0
        reader.fa_banishdarkness.components.spell:ResumeSpell()
    else
        local light = create_light(timer)
        light.components.spell:SetTarget(reader)
        if not light.components.spell.target then
            light:Remove()
        end
        light.components.spell:StartSpell()
    end

    return true
end

FA_BuffUtil.Light=LightSpellStart


local function casterbbdamage(inst, target)
    local tags={}
    local blocktags={}
    local variables=inst.components.spell.variables
    if(variables and variables.tags)then
        tags=variables.tags
    end
    if(variables and variables.blocktags)then
        blocktags=variables.blocktags
    end
    local pos=Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BB_RADIUS,tags,blocktags)
    for k,v in pairs(ents) do
        if ( v.components.combat and not (v.components.health and v.components.health:IsDead())
            and not (v.components.follower and v.components.follower.leader and v.components.follower.leader==target)
            ) then

                local current = Vector3(v.Transform:GetWorldPosition() )
                local direction = (pos - current):GetNormalized()
                local angle = math.acos(direction:Dot(Vector3(1, 0, 0) ) ) / DEGREES
                local boom=SpawnPrefab("fa_bladebarrier_hitfx")
                boom.Transform:SetRotation(angle)
                boom:FacePoint(pos)
                local pos1 =v:GetPosition()
                boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
                boom:ListenForEvent("animover", function()  boom:Remove() end)

                v.components.combat:GetAttacked(target, BB_DAMAGE, nil)
        end
    end
end

function BladeBarrierSpellStartCaster(reader,timer,variables)
    if(timer==nil or timer<=0)then return false end
    local inst = CreateEntity()
    inst.persists=false
    local caster = reader
    local trans = inst.entity:AddTransform()
    inst.Transform:SetTwoFaced()
    inst.entity:AddDynamicShadow()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local anim=inst.entity:AddAnimState()
    inst.Transform:SetScale(5, 5, 1)
    anim:SetBank("betterbarrier")
    anim:SetBuild("betterbarrier")
    anim:PlayAnimation("idle",true)
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_bladebarrier"
    inst.components.spell.duration = timer
    if(variables)then
        inst.components.spell:SetVariables(variables)
    end
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_bladebarrier = inst
        target:AddTag(inst.components.spell.spellname)
        local pos =target:GetPosition()
        inst.Transform:SetPosition(pos.x, pos.y, pos.z)
--        target.bladeBarrierAnim=boom
        local follower = inst.entity:AddFollower()
        follower:FollowSymbol( target.GUID, "swap_object", 0.1, 0.1, -0.0001 )
    end

    inst.components.spell.onstartfn = function(inst)
    end
    inst.components.spell.fn = casterbbdamage
    inst.components.spell.period=BB_PERIOD
--    inst.components.spell.resumefn = light_resume
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_bladebarrier = nil
--        inst.components.spell.target.fa_bbanim:Remove()
    end
    inst.components.spell.removeonfinish = true
    inst.components.spell:SetTarget(reader)
    inst.components.spell:StartSpell()
--    inst.fa_icestorm_caster=caster
end

local function BladeBarrierSpellStartPlayer(reader,timer)
    local variables={}
    variables.blocktags={"player","INLIMBO","companion"}
    return BladeBarrierSpellStartCaster(reader,timer,variables)
end

FA_BuffUtil.BladeBarrier=BladeBarrierSpellStartPlayer

local longstrider_start=function(inst, target, variables)
    local target=inst.components.spell.target
    if target then
        target.components.locomotor.runspeed=target.components.locomotor.runspeed+IA_MS_BOOST
    end
end

local function FA_ProtEvilSpellStart(reader,timer)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_protevil then
        reader.fa_protevil.components.spell.lifetime = 0
--        reader.fa_inspireagility.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_protevil"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_protevil = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_protevil = nil
    end

        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
end

FA_BuffUtil.ProtEvil=FA_ProtEvilSpellStart

local function FA_LongstriderSpellStart( reader,timer)

    if(timer==nil or timer<=0)then return false end

    if reader.fa_longstrider then
        reader.fa_longstrider.components.spell.lifetime = 0
--        reader.fa_inspireagility.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_longstrider"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_longstrider = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = longstrider_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed-IA_MS_BOOST
        inst.components.spell.target.fa_longstrider = nil
    end

        inst.components.spell.resumefn = longstrider_start
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        if not inst.components.spell.target then
            inst:Remove()
        end
        inst.components.spell:StartSpell()
    end
end

FA_BuffUtil.Longstrider=FA_LongstriderSpellStart


local haste_start=function(inst)
    local target=inst.components.spell.target
    if target then
        target.components.locomotor.runspeed=target.components.locomotor.runspeed+HASTE_SPEED_BOOST
        target.components.combat.min_attack_period=target.components.combat.min_attack_period/(1+HASTE_ATTACK_BOOST)
        target.components.health.fa_dodgechance=IG_DODGE_BOOST+target.components.health.fa_dodgechance
    end
end

local function HasteSpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end
    
    if reader.fa_haste then
        reader.fa_haste.components.spell.lifetime = 0
        reader.fa_haste.components.spell:ResumeSpell()
        return true
    else

    local inst=CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_haste"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_haste = inst
        target:AddTag(inst.components.spell.spellname)
    end

    inst.components.spell.onstartfn = haste_start
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed-HASTE_SPEED_BOOST
        reader.components.combat.min_attack_period=reader.components.combat.min_attack_period*(1+HASTE_ATTACK_BOOST)
        reader.components.health.fa_dodgechance=IG_DODGE_BOOST-reader.components.health.fa_dodgechance
        inst.components.spell.target.fa_haste = nil
    end

    inst.components.spell.resumefn = function() end
    inst.components.spell.removeonfinish = true

    inst.components.spell:SetTarget(reader)
    inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.Haste=HasteSpellStart

local function InvisibilitySpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end
    
    if(reader.invisibilityTimer) then
        reader.invisibilityTimer:Cancel()
    end
    reader:AddTag("notarget")
    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("smoke_up")
    anim:SetBuild("smoke_up")
    anim:PlayAnimation("idle",false)

    local pos =reader:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    
    boom:ListenForEvent("animover", function() boom:Remove() end)

    reader.invisibilityTimer=reader:DoTaskInTime(timer, function() 
        reader.invisibilityTimer=nil 
        if(reader:HasTag("notarget"))then
            reader:RemoveTag("notarget")
        end
    end)
    return true
end

FA_BuffUtil.Invisibility=InvisibilitySpellStart


local function dopoison(inst,target)
    local variables=inst.components.spell.variables
    local strength=variables.strength
    if(target and not target.components.health:IsDead())then
        --bypassing armor - but this also bypasses potential retarget
--        target.components.health:DoDelta(-POISON_DAMAGE)
            target.components.combat:GetAttacked(inst.caster, strength, nil,nil,FA_DAMAGETYPE.POISON)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end

--variables can't have references
local function PoisonSpellStart(target,timer,variables,attacker)

    local strength=variables.strength
    local period=variables.period
  
  if(target and target.components.health and target.components.combat and not target.components.health:IsDead())then

    if target.fa_poison then
        if(target.fa_poison.strength and target.fa_poison.strength==strength)then
            print("resetting poison timer")
            target.fa_poison.components.spell.lifetime = 0
        --        reader.fa_inspiregreatness.components.spell:ResumeSpell()
            return true
        elseif(target.fa_poison.strength and target.fa_poison.strength>strength)then
            print("don't overwrite stronger poison")
            return false
        else
            target.fa_poison.components.spell:OnFinish() 
        end
    end

      local inst = CreateEntity()
      inst.persists=false
      local caster=attacker
      local trans = inst.entity:AddTransform()

    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_poison"
    inst.strength=strength
    inst.components.spell.variables=variables
    inst.components.spell.duration = timer
    inst.components.spell.fn = dopoison
    inst.components.spell.period=period
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=caster
        target.fa_poison = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_poison = nil
    end
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
  end
  return true
end

FA_BuffUtil.Poison=PoisonSpellStart


local deathbrewevent=function(owner,data) 
    if(owner and owner:IsValid() and not owner.components.health:IsDead())then
        owner.components.health:DoDelta(1)
    end
end

local deathkillevent=function(inst,data)
    if(math.random()<0.2)then
        local poop=SpawnPrefab("nightmarefuel")
        local spawn_point= Vector3(inst.Transform:GetWorldPosition())
        poop.Physics:Teleport(spawn_point.x,spawn_point.y,spawn_point.z)
    end
end

local function DeathBrewSpellStart( reader,timer,variables)
    if(timer==nil or timer<=0)then return false end

    if reader.fa_deathbrew then
        reader.fa_deathbrew.components.spell.lifetime = 0
        reader.fa_deathbrew.components.spell:ResumeSpell()
        return
    else

    local inst=CreateEntity()
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_deathbrew"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_deathbrew = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function(inst)
        reader:ListenForEvent("onhitother",deathbrewevent)
        reader:ListenForEvent("killed", deathkillevent)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        reader:RemoveEventCallback("onhitother", deathbrewevent)
        reader:RemoveEventCallback("killed", deathkillevent)
        inst.components.spell.target.fa_deathbrew = nil
    end

        inst.components.spell.resumefn = function(inst,timeleft)   end 
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(reader)
        inst.components.spell:StartSpell()
    end
    
    return true
end

FA_BuffUtil.DeathBrew=DeathBrewSpellStart



function LichSpellStart(reader,timer)

end

function UnholyStrengthSpellStart(reader,timer)

end
--spellcaster?
function LifeDrainSpellStart(reader,timer)

end

return FA_BuffUtil