
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
        Asset( "ANIM", "anim/fa_monk.zip" ),
        Asset( "ANIM", "anim/fa_ghoul.zip" ),
        Asset( "ANIM", "anim/fa_monk_level_overrides.zip" ),
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
local KIBUFF_REGEN=2
local KIBUFF_SANITY=2

local HEALTH_PER_LEVEL=3
local SANITY_PER_LEVEL=3


local onhitother=function(inst,data)
    local damage=data.damage
    local weapon=inst.components.combat:GetWeapon()
    if(damage and damage>0) and (not weapon or weapon:HasTag("unarmed"))then
        inst.components.kibar:DoDelta(KI_ATTACK_INCREASE)
    end
end

local function headoverride(inst,level)
    if(level>=20)then
        inst.AnimState:OverrideSymbol("headbase_hat", "fa_monk_level_overrides", "headbase_3")
        inst.AnimState:OverrideSymbol("headbase", "fa_monk_level_overrides", "headbase_3")
    elseif(level>=10)then
        inst.AnimState:OverrideSymbol("headbase_hat", "fa_monk_level_overrides", "headbase_2")
        inst.AnimState:OverrideSymbol("headbase", "fa_monk_level_overrides", "headbase_2")
    end
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL*(level-1)
        headoverride(inst,level)
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL
    headoverride(inst,level)
end

local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
end

local updatekiboosts=function(inst,data)
    for i=1,math.floor(data.new/10) do
        local bufftostart=inst.kibuffs[i]
        if(bufftostart and not bufftostart.active)then
            bufftostart.active=true
            bufftostart.onenter()
        end
    end
    if(data.old>data.new)then
        for i=math.floor(data.new/10)+1,math.floor(data.old/10) do
            local bufftostart=inst.kibuffs[i]
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

    inst.AnimState:SetBuild("fa_monk")

	-- todo: Add an example special power here.
    inst.components.locomotor.runspeed=BASE_MS
	inst.components.health:SetMaxHealth(150)
    --just so i dont have to run extra tests
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(150)
    inst.components.combat:SetDefaultDamage(UNARMED_DAMAGE)

    inst:AddComponent("xplevel")

    inst:AddComponent("kibar")
    inst.components.kibar.max=MAX_KI
    inst.components.kibar.current=0

    inst.kibuffs={
        [1]={
            onenter=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+KIBUFF_MS
            end,
            onexit=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-KIBUFF_MS
            end,
            active=false
        },
        [2]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false

        },
        [3]={
            onenter=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier+KIBUFF_STRIKE
            end,
            onexit=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier-KIBUFF_STRIKE
            end,
            active=false
        },
        [4]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION
            end,
            active=false
        },
        [5]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false
        },
        [6]={
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
        [7]={
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
        [8]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION+KIBUFF_GREATEREVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION-KIBUFF_GREATEREVASION
            end,
            active=false
        },
        [9]={
            onenter=function()
                if not inst.components.health.regen or not inst.components.health.regen.task then
                    inst.components.health:StartRegen(KIBUFF_REGEN, 1)
                else
                    --patching up potential collisions 
                    local amount = (inst.components.health.regen.amount/inst.components.health.regen.period)+KIBUFF_REGEN
                     inst.components.health:StartRegen(amount, 1)
                end
                inst.components.sanity.dapperness=(inst.components.sanity.dapperness or 0)+KIBUFF_SANITY
            end,
            onexit=function()
                inst.components.health.regen.amount=inst.components.health.regen.amount-KIBUFF_REGEN
                if(inst.components.health.regen.amount<=0)then
                    inst.components.health:StopRegen()
                end
                inst.components.sanity.dapperness=inst.components.sanity.dapperness-KIBUFF_SANITY
            end,
            active=false
        },
        [10]={
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
    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst.newControlsInit = function (class)

        class.ki = class:AddChild(KiBadge(class.owner))
        class.ki:SetPercent(inst.components.kibar:GetPercent(), inst.components.kibar.max)
        class.ki:SetPosition(0,0,0)

        inst:ListenForEvent("kidelta", function(inst, data)  class.ki:DoDelta(data.old,data.new,data.max) end)
    end
end

return MakePlayerCharacter("monk", prefabs, assets, fn)
