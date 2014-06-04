
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

local BASE_MS=1.0*TUNING.WILSON_RUN_SPEED
local UNARMED_DAMAGE=TUNING.UNARMED_DAMAGE*4
local MAX_KI=100
local KI_ATTACK_INCREASE=2

local KIBUFF_MS=0.5*TUNING.WILSON_RUN_SPEED
local KIBUFF_EVASION=0.3
local KIBUFF_GREATEREVASION=0.6
local KIBUFF_STRIKE=3
local KIBUFF_IMPROVEDSTRIKE=5
local KIBUFF_ABSORB=50


local onhitother=function(inst,data)
    local damage=data.damage
    local weapon=inst.components.combat:GetWeapon()
    if(damage and damage>0) and (not weapon or weapon:HasTag("unarmed"))then
        inst.components.kibar:DoDelta(KI_ATTACK_INCREASE)
    end
end


local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
end

local updatekiboosts=function(inst,data)
    for i=1,math.floor(data.new/10) do
        local bufftostart=inst.kibuffs[i*10]
        if(bufftostart and not bufftostart.active)then
            bufftostart.active=true
            bufftostart.onenter()
        end
    end
    if(data.old>data.new)then
        for i=math.floor(data.new/10)+1,math.floor(data.old/10) do
            local bufftostart=inst.kibuffs[i*10]
            if(bufftostart and bufftostart.active)then
                bufftostart.active=false
                bufftostart.onexit()
            end
        end
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

    inst.kibuffs={
        [10]={
            onenter=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+KIBUFF_MS
            end,
            onexit=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-KIBUFF_MS
            end,
            active=false
        },
        [20]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false

        },
        [30]={
            onenter=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier+KIBUFF_STRIKE
            end,
            onexit=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier-KIBUFF_STRIKE
            end,
            active=false
        },
        [40]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION
            end,
            active=false
        },
        [50]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false
        },
        [60]={
            onenter=function()
                inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
                inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+0.5
            end,
            onexit=function()
                inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0
                inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-0.5
            end,
            active=false
        },
        [70]={
        --it is possible this will lead to heal effects - if there are additional effects on this layer... will have to come back here later
            onenter=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier+KIBUFF_IMPROVEDSTRIKE-KIBUFF_STRIKE
            inst.fa_damagetype=FA_DAMAGETYPE.HOLY
            end,
            onexit=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier-KIBUFF_IMPROVEDSTRIKE+KIBUFF_STRIKE
            inst.fa_damagetype=nil
            end,
            active=false
        },
        [80]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION+KIBUFF_GREATEREVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION-KIBUFF_GREATEREVASION
            end,
            active=false
        },
        [90]={
            onenter=function()
                if not inst.components.health.regen.task then
                    inst.components.health:StartRegen(1, 1)
                else
                    --patching up potential collisions 
                    local amount = (inst.components.health.regen.amount/inst.components.health.regen.period)+1
                     inst.components.health:StartRegen(amount, 1)
                end
                inst.components.sanity.dapperness=inst.components.sanity.dapperness+1
            end,
            onexit=function()
                inst.components.health.regen.amount=inst.components.health.regen.amount-1
--                inst.components.health:StopRegen()
                inst.components.sanity.dapperness=inst.components.sanity.dapperness-1
            end,
            active=false
        },
        [100]={
            onenter=function()
                inst.components.health.absorb= inst.components.health.absorb+KIBUFF_ABSORB
            end,
            onexit=function()
                inst.components.health.absorb= inst.components.health.absorb-KIBUFF_ABSORB
            end,
            active=false
        },
    }

    inst:ListenForEvent("onhitother", onhitother)
    inst:ListenForEvent("kidelta", updatekiboosts)


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst.newControlsInit = function (class)

        class.ki = class:AddChild(KiBadge(class.owner))
        class.ki:SetPercent(class.owner.components.kibar:GetPercent(), class.owner.components.kibar.max)
        class.ki:SetPosition(0,0,0)

        inst:ListenForEvent("kidelta", function(inst, data)  class.ki:DoDelta(data.old,data.new,data.max) end)
    end
end

return MakePlayerCharacter("monk", prefabs, assets, fn)
