local CooldownButton = require "widgets/cooldownbutton"

local BB_RADIUS=8
local BB_DAMAGE=30
local DM_DAMAGE_MULT_BOOST=1.0
local DM_HP_BOOST=100
local DM_MS_BOOST=0.25*TUNING.WILSON_RUN_SPEED


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

function DivineMightSpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end
    if(reader.divineMightTimer) then
        reader.divineMightTimer:Cancel()
    end
    
    reader.components.health.maxhealth=reader.components.health.maxhealth+DM_HP_BOOST
    reader.components.health.currenthealth=reader.components.health.currenthealth+DM_HP_BOOST
    reader.components.health:DoDelta(0)
--	reader.components.health:SetMaxHealth(reader.origMaxHealth+DM_HP_BOOST)
	reader.components.locomotor.runspeed=reader.components.locomotor.runspeed+DM_MS_BOOST
    reader.components.combat.damagemultiplier=DM_DAMAGE_MULT_BOOST+reader.components.combat.damagemultiplier
    
    reader.divineMightTimer=reader:DoTaskInTime(timer, function() 
        reader.divineMightTimer=nil 
        reader.components.combat.damagemultiplier=reader.components.combat.damagemultiplier-DM_DAMAGE_MULT_BOOST
        reader.components.health.maxhealth=reader.components.health.maxhealth-DM_HP_BOOST
        reader.components.health:DoDelta(0)
		reader.components.locomotor.runspeed=reader.components.locomotor.runspeed-DM_MS_BOOST
		end)
    return true
end

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

function frozenSlowDebuff(target,timer)
    local inst = CreateEntity()
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
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
    return inst
end

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
--would it simply be easier to write a timed-aoe-dmg myself? likely..

local function apply_bb_damage(reader)
	if(reader.buff_timers["bladebarrier"].cooldowntimer<=0)then
		reader.bladeBarrierTimer:Cancel()
		reader.bladeBarrierTimer=nil
        reader.bladeBarrierAnim:Remove()
	else
		local pos=Vector3(reader.Transform:GetWorldPosition())
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BB_RADIUS,nil,{"pet","player","INLIMBO","companion"})
    	for k,v in pairs(ents) do
        	if ( v.components.combat and not (v.components.health and v.components.health:IsDead())) then

                local boom=SpawnPrefab("fa_bladebarrier_hitfx")
                local current = Vector3(v.Transform:GetWorldPosition() )
                local direction = (pos - current):GetNormalized()
                local angle = math.acos(direction:Dot(Vector3(1, 0, 0) ) ) / DEGREES
                boom.Transform:SetRotation(angle)
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                
                boom:ListenForEvent("animover", function()  boom:Remove() end)

            	v.components.combat:GetAttacked(reader, BB_DAMAGE, nil)
        	end
    	end
	end
end

function BladeBarrierSpellStart(reader,timer)
    if(timer==nil or timer<=0)then return false end
    
	if(reader.bladeBarrierTimer) then
        reader.bladeBarrierTimer:Cancel()
    end
    reader.bladeBarrierTimer=reader:DoPeriodicTask(1, function() apply_bb_damage(reader) end)

    local boom=SpawnPrefab("fa_bladebarrierfx")
    boom.entity:AddDynamicShadow()
    boom.persists=false
--    boom.DynamicShadow:SetSize( .8, .5 )
    boom.Transform:SetScale(5, 5, 1)
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol(reader.GUID, reader.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
--    boom.entity:SetParent(reader.entity)
--    boom.Transform:SetPosition(0, 0.2, 0)
    reader.bladeBarrierAnim=boom
end

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
        if ( v.components.combat and not (v.components.health and v.components.health:IsDead())) then

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
    inst.components.spell.period=2
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



function HasteSpellStart( reader,timer)
    if(timer==nil or timer<=0)then return false end
    
     if(reader.hasteTimer) then
        reader.hasteTimer:Cancel()
    else
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED
        reader.components.combat.min_attack_period=reader.components.combat.min_attack_period/1.5
    end
    reader.hasteTimer=reader:DoTaskInTime(timer, function() 
        reader.hasteTimer=nil 
        reader.components.locomotor.runspeed=reader.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED
        reader.components.combat.min_attack_period=reader.components.combat.min_attack_period*1.5
        end)
    return true
end

function InvisibilitySpellStart( reader,timer)
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

function LichSpellStart(reader,timer)

end

function UnholyStrengthSpellStart(reader,timer)

end
--spellcaster?
function LifeDrainSpellStart(reader,timer)

end

