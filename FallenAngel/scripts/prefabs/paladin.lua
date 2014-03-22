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
}
local prefabs = {
    "holysword"
}

--        SANITY_NIGHT_MID = -100/(300*20),
local LAY_ON_HANDS_HP=250
local LAY_ON_HANDS_COOLDOWN=960
local DIVINE_DEFENDER_COOLDOWN=480*4
local DIVINE_DEFENDER_DURATION=15


local onloadfn = function(inst, data)
    inst.lohcooldowntimer=data.lohcooldowntimer
    inst.ddcooldowntimer=data.ddcooldowntimer
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.lohcooldowntimer=inst.lohCooldownButton.cooldowntimer
    data.ddcooldowntimer=inst.divinedefenderCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
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

    end
    local prefabs1 = {
        "holysword",
    }
   
    inst.components.inventory:GuaranteeItems(prefabs1)

end

return MakePlayerCharacter("paladin", prefabs, assets, fn)
