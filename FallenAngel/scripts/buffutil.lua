local BB_RADIUS=10
local BB_DAMAGE=30
local DM_DAMAGE_MULT=2.0
local DM_HP_BOOST=100
local DM_MS_BOOST=1.25

--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}
function DivineMightSpellStart(inst, reader,timer)
    
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
        reader.components.health.maxhealth=reader.origMaxHealth
        reader.components.health:DoDelta(0)
		reader.components.locomotor.runspeed=TUNING.WILSON_RUN_SPEED
		end)
    return true
end

function LightSpellStart(inst, reader,timer)

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
		local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 20)
    	for k,v in pairs(ents) do
        	if (not v:HasTag("player") and not v:HasTag("pet") and v.components.combat and not v:IsInLimbo()) then
            	v.components.combat:GetAttacked(reader, BB_DAMAGE, nil)
        	end
    	end
	end
end

function BladeBarrierSpellStart(inst,reader,timer)
	if(reader.bladeBarrierTimer) then
        reader.bladeBarrierTimer:Cancel()
    end
    reader.bladeBarrierTimer=reader:DoPeriodicTask(2, function() apply_bb_damage(reader) end)

    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetTwoFaced()
    boom.entity:AddDynamicShadow()
--    boom.DynamicShadow:SetSize( .8, .5 )
    boom.Transform:SetScale(4, 4, 1)

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

--    boom:AddComponent("follower")
--    reader.components.leader:AddFollower(boom)

--    local r,g,b,a = anim:GetMultColour()
--    anim:SetMultColour(r,g,b,1)
--[[
    boom:DoPeriodicTask(0.2, function() 
        local pos =reader:GetPosition()
        boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    end )
]]
        
end