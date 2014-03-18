local CooldownButton = require "widgets/cooldownbutton"

local BB_RADIUS=8
local BB_DAMAGE=30
local DM_DAMAGE_MULT=2.0
local DM_HP_BOOST=100
local DM_MS_BOOST=1.25


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
    
    
    reader.origDamageMultiplier=reader.origDamageMultiplier or reader.components.combat.damagemultiplier
    reader.origMaxHealth=reader.origMaxHealth or reader.components.health.maxhealth
    print(reader.origMaxHealth+DM_HP_BOOST)
    reader.components.health.maxhealth=reader.origMaxHealth+DM_HP_BOOST
    reader.components.health.currenthealth=reader.components.health.currenthealth+DM_HP_BOOST
    reader.components.health:DoDelta(0)
	reader.components.health:SetMaxHealth(reader.origMaxHealth+DM_HP_BOOST)
	reader.components.locomotor.runspeed=TUNING.WILSON_RUN_SPEED*DM_MS_BOOST
    reader.components.combat.damagemultiplier=DM_DAMAGE_MULT
--    inst.components.health:SetMaxHealth(300)
    if(reader.divineMightTimer) then
        reader.divineMightTimer:Cancel()
    end
    reader.divineMightTimer=reader:DoTaskInTime(timer, function() 
        reader.divineMightTimer=nil 
        print(reader.origMaxHealth)
        reader.components.combat.damagemultiplier=reader.origDamageMultiplier
        reader.components.health.maxhealth=reader.components.health.maxhealth-DM_HP_BOOST
        reader.components.health:DoDelta(0)
		reader.components.locomotor.runspeed=TUNING.WILSON_RUN_SPEED
		end)
    return true
end

function LightSpellStart(reader,timer)
    if(timer==nil or timer<=0)then return false end
    

    --it WILL crash and burn if applied to wx
    if(not reader.Light) then
        reader.entity:AddLight()
    end

    if(reader.lightTimer) then
        reader.lightTimer:Cancel()
    end
    reader.Light:SetRadius(3)
    reader.Light:SetFalloff(0.75)
    reader.Light:SetIntensity(0.9)
    reader.Light:SetColour(235/255,121/255,12/255)

    reader.Light:Enable(true)
    
    reader.lightTimer=reader:DoTaskInTime(timer, function() 
        reader.lightTimer=nil
        reader.Light:Enable(false)
    end)
--    reader.buff_timers["light"]
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
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BB_RADIUS)
    	for k,v in pairs(ents) do
        	if (not v:HasTag("player") and not v:HasTag("pet") and v.components.combat and not v:IsInLimbo()) then

                local current = Vector3(v.Transform:GetWorldPosition() )
                local direction = (pos - current):GetNormalized()
                local angle = math.acos(direction:Dot(Vector3(1, 0, 0) ) ) / DEGREES

                local boom = CreateEntity()
                boom.entity:AddTransform()
                local anim=boom.entity:AddAnimState()
                anim:SetBank("flash_b")
                anim:SetBuild("flash_b")
                anim:SetOrientation( ANIM_ORIENTATION.OnGround )
                boom.Transform:SetRotation(angle)
                anim:PlayAnimation("idle",false)
                boom:FacePoint(pos)

                local pos1 =v:GetPosition()
                boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
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

    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetTwoFaced()
    boom.entity:AddDynamicShadow()
--    boom.DynamicShadow:SetSize( .8, .5 )
    boom.Transform:SetScale(5, 5, 1)

    anim:SetBank("betterbarrier")
    anim:SetBuild("betterbarrier")
    anim:PlayAnimation("idle",true)
--[[
    anim:SetBank("smoke_right")
    anim:SetBuild("smoke_right")
    anim:PlayAnimation("idle",true)
]]


    local pos =reader:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    reader.bladeBarrierAnim=boom


                    local follower = boom.entity:AddFollower()
                    follower:FollowSymbol( reader.GUID, "swap_object", 0.1, 0.1, -0.0001 )
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
