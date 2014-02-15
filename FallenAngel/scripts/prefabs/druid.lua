
local MakePlayerCharacter = require "prefabs/player_common"


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
        Asset( "ANIM", "anim/druid.zip" ),
}
local prefabs = {}


local CHOP_SANITY_DELTA=-5
local DIG_SANITY_DELTA=-5
local PICK_SANITY_DELTA=-2
local PLANT_SANITY_DELTA=10
local MURDER_SANITY_DELTA=-5

local ref

local function onmurder(inst,data)
    local victim=data.victim
    print(victim)
    if(victim:HasTag("animal") or victim:HasTag("bird"))then
        inst.components.sanity:DoDelta(MURDER_SANITY_DELTA)
    end
end

local fn = function(inst)
	
        local ref=inst

        local old_dig=ACTIONS.DIG.fn
        local old_plant=ACTIONS.PLANT.fn
        local old_pick=ACTIONS.PICK.fn
        local old_deploy=ACTIONS.DEPLOY.fn
        local old_chop=ACTIONS.CHOP.fn

        ACTIONS.CHOP.fn = function(act)
                local wkb=act.target.components.workable
                old_chop(act)
                print(wkb.workleft)
                if wkb and wkb.action == ACTIONS.CHOP and wkb.workleft <= 0 then
                        print("chop chop")
                        inst.components.sanity:DoDelta(CHOP_SANITY_DELTA)
                end

                return true
        end

        ACTIONS.DIG.fn = function(act)
                local ret=old_dig(act)
                if ret and act.doer:HasTag("player") and act.target.components.workable and act.target.components.workable.action == ACTIONS.DIG then
                print("dig",act.target)
                        if(act.target.components.pickable) then
                                if(act.target.components.pickable.product and(act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs"))then
                                        inst.components.sanity:DoDelta(DIG_SANITY_DELTA)
                                end
                        end
                end
                return ret
        end


        ACTIONS.PLANT.fn = function(act)
                local ret=old_plant(act)
                print("plant",act.target)
                if(ret and act.doer:HasTag("player") and act.target.components.pickable) then
                        print(act.target.components.pickable)
                        if(act.target.components.pickable.product and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs")) then
                                inst.components.sanity:DoDelta(PLANT_SANITY_DELTA)
                        end
                end
                return ret
        end

        
        ACTIONS.PICK.fn = function(act)
                print("pick",act.target)
                local ret=old_pick(act)
                if(ret and act.doer:HasTag("player") and act.target.components.pickable) then
                        print(act.target.components.pickable)
                        if(act.target.components.pickable.product and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs")) then
                                inst.components.sanity:DoDelta(PICK_SANITY_DELTA)
                        end
                end
                return ret
        end

        ACTIONS.DEPLOY.fn = function(act)
                local ret=old_deploy(act)
                if(ret and act.doer:HasTag("player")) then
                        if(act.invobject and (act.invobject.name=="Grass Tuft" or act.invobject.name=="Sapling")) then
                                inst.components.sanity:DoDelta(PLANT_SANITY_DELTA)
                        end
                       -- print("deploy",act.invobject)
                end
                return ret
        end
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	
	inst.components.health:SetMaxHealth(175)
	inst.components.sanity:SetMax(250)
	inst.components.hunger:SetMax(150)

    inst:ListenForEvent("killed", onmurder)

end



return MakePlayerCharacter("druid", prefabs, assets, fn)
