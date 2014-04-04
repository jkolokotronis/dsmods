local MakePlayerCharacter = require "prefabs/player_common"

local CooldownButton = require "widgets/cooldownbutton"
local Widget = require "widgets/widget"

local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/paladin.zip" ),
        Asset( "ANIM", "anim/fa_shieldpuff.zip" )
}
local prefabs = {
    "holysword"
}

--        SANITY_NIGHT_MID = -100/(300*20),
local LAY_ON_HANDS_HP=250
local LAY_ON_HANDS_COOLDOWN=960
local DIVINE_DEFENDER_COOLDOWN=480*4
local DIVINE_DEFENDER_DURATION=15
local TURN_UNDEAD_COOLDOWN=480
local TURN_UNDEAD_COOLDOWN_MK2=360
local TURN_UNDEAD_COOLDOWN_MK3=300
local TURN_UNDEAD_INSTA_CHANCE=0.2
local TURN_UNDEAD_RUN_CHANCE=0.7
local TURN_UNDEAD_DURATION=60
local TURN_UNDEAD_RANGE=15


local onloadfn = function(inst, data)
    inst.lohcooldowntimer=data.lohcooldowntimer
    inst.ddcooldowntimer=data.ddcooldowntimer
    inst.fa_playername=data.fa_playername
    inst.turncooldowntimer=data.turncooldowntimer
end

local onsavefn = function(inst, data)
    data.lohcooldowntimer=inst.lohCooldownButton.cooldowntimer
    data.ddcooldowntimer=inst.divinedefenderCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
    data.turncooldowntimer=inst.turnCooldownButton.cooldowntimer
end


local function onturnundead(clr)
    local pos=Vector3(clr.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TURN_UNDEAD_RANGE)
        for k,v in pairs(ents) do
            if (not v:HasTag("player") and not v:HasTag("pet") and v.components.combat and not v:IsInLimbo() and v:HasTag("undead")) then

                local rng=math.random()
                print("turn undead rng",rng)
                if(rng<TURN_UNDEAD_INSTA_CHANCE)then
                    --i need instakill but i also need to get this thing to recognize the killer... 2^31-1 or 2^63-1? if he's invuln he wont die but w/e
                    v.components.combat:GetAttacked(clr,999999)
                elseif(rng<TURN_UNDEAD_RUN_CHANCE)then

                local inst = CreateEntity()
                inst.entity:AddTransform()

                local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_turnundead"
    inst.components.spell.duration = TURN_UNDEAD_DURATION
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_turnundead = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function() end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_turnundead = nil
    end
    inst.components.spell.fn = function(inst, target, variables) end
    inst.components.spell.resumefn = function() end
    inst.components.spell.removeonfinish = true

                inst.components.spell:SetTarget(v)
                inst.components.spell:StartSpell()

                end
            end
        end
        return true
end
    

local fn = function(inst)
    
    -- choose which sounds this character will play
    inst.soundsname = "wolfgang"

    -- a minimap icon must be specified
    inst.MiniMapEntity:SetIcon( "wilson.png" )

    -- todo: Add an example special power here.
    inst.components.combat.damagemultiplier=1.5
    inst.components.health:SetMaxHealth(250)
    inst.components.sanity:SetMax(200)
    inst.components.hunger:SetMax(150)

    inst:AddComponent("xplevel")
    
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn


    inst.newControlsInit = function (cnt)

        inst.lohCooldownButton=CooldownButton(cnt.owner)
        inst.lohCooldownButton:SetText("LOH")
        inst.lohCooldownButton:SetOnClick(function()
            inst.components.health:DoDelta(LAY_ON_HANDS_HP)
            return true
        end)
        inst.lohCooldownButton:SetCooldown(LAY_ON_HANDS_COOLDOWN)
        if(inst.lohcooldowntimer and inst.lohcooldowntimer>0)then
             inst.lohCooldownButton:ForceCooldown(inst.lohcooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.lohCooldownButton)
        htbtn:SetPosition(-100,0,0)

        inst.divinedefenderCooldownButton=CooldownButton(cnt.owner)
        inst.divinedefenderCooldownButton:SetText("Defense")
        inst.divinedefenderCooldownButton:SetOnClick(function()
            inst.components.health.invincible=true

            local boom = CreateEntity()
            boom.entity:AddTransform()
            local anim=boom.entity:AddAnimState()
            boom:AddTag("NOCLICK")
            boom:AddTag("FX")
            anim:SetBank("fa_shieldpuff")
            anim:SetBuild("fa_shieldpuff")
            anim:PlayAnimation("idle",false)
            local pos1 =inst:GetPosition()
            boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
            boom:ListenForEvent("animover", function()  boom:Remove() end)

            inst:DoTaskInTime(DIVINE_DEFENDER_DURATION, function() inst.components.health.invincible=false end)
            return true
        end)
        inst.divinedefenderCooldownButton:SetCooldown(DIVINE_DEFENDER_COOLDOWN)
        if(inst.ddcooldowntimer and inst.ddcooldowntimer>0)then
             inst.divinedefenderCooldownButton:ForceCooldown(inst.ddcooldowntimer)
             inst.components.health.invincible=false
        end
        local htbtn=cnt:AddChild(inst.divinedefenderCooldownButton)
        htbtn:SetPosition(0,0,0)


        inst.turnCooldownButton=CooldownButton(class.owner)
        inst.turnCooldownButton:SetText("Turn")
        inst.turnCooldownButton:SetOnClick(function() return onturnundead(inst) end)
        local turncooldown=TURN_UNDEAD_COOLDOWN
        if(inst.components.xplevel.level>=18)then
            turncooldown=TURN_UNDEAD_COOLDOWN_MK3
        elseif(inst.components.xplevel.level>=9)then
            turncooldown=TURN_UNDEAD_COOLDOWN_MK2
        end
        inst.turnCooldownButton:SetCooldown(turncooldown)
        if(inst.turncooldowntimer and inst.turncooldowntimer>0)then
             inst.turnCooldownButton:ForceCooldown(inst.turncooldowntimer)
        end
        local htbtn=class:AddChild(inst.turnCooldownButton)
        htbtn:SetPosition(100,0,0)
        htbtn:Show()        

    end
    local prefabs1 = {
        "holysword",
    }
   
    inst.components.inventory:GuaranteeItems(prefabs1)

end

return MakePlayerCharacter("paladin", prefabs, assets, fn)
