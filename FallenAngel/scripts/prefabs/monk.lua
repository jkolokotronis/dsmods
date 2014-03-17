
local MakePlayerCharacter = require "prefabs/player_common"
local KiBadge=require "widgets/kibadge"
local KiBar=require "components/kibar"


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
        Asset( "ANIM", "anim/monk.zip" ),
}
local prefabs = {}

local BASE_MS=1.5*TUNING.WILSON_RUN_SPEED
local UNARMED_DAMAGE=TUNING.UNARMED_DAMAGE*4
local MAX_KI=200
local KI_ATTACK_INCREASE=5


local kidelta=function(status,data)
    status.ki:SetPercent(data.newpercent, status.owner.components.kibar.max)
    
    if not data.overtime then
        if data.newpercent > data.oldpercent then
            status.ki:PulseGreen()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_up")
        elseif data.newpercent < data.oldpercent then
            status.ki:PulseRed()
            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_down")
        end
    end
    
end

local onhitother=function(inst,data)
    local damage=data.damage
    local weapon=inst.components.combat:GetWeapon()
    if(damage and damage>0 and (not weapon or weapon:HasTag("unarmed")))then
        inst.components.kibar:DoDelta(KI_ATTACK_INCREASE)
    end
end

local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
    inst.components.locomotor.runspeed=BASE_MS
	inst.components.health:SetMaxHealth(150)
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(150)
    inst.components.combat:SetDefaultDamage(UNARMED_DAMAGE)

    inst:AddComponent("xplevel")

    inst:AddComponent("kibar")
    inst.components.kibar.max=MAX_KI
    inst.components.kibar.current=0

    inst:ListenForEvent("onhitother", onhitother)


    inst.newStatusDisplaysInit= function(class)

        class.brain:SetPosition(-40,-40,0)

        class.ki = class:AddChild(KiBadge(class.owner))
        class.ki:SetPercent(class.owner.components.kibar:GetPercent(), class.owner.components.kibar.max)
        class.ki:SetPosition(40,-40,0)

        class.inst:ListenForEvent("kidelta", function(inst, data)  kidelta(class,data) end, class.owner)
    end
end

return MakePlayerCharacter("monk", prefabs, assets, fn)
