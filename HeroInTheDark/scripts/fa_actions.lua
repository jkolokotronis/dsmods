local SGWilson=require "stategraphs/SGwilson"
require "actions"

local FA_FURNACE=Action(1)
FA_FURNACE.id="FA_FURNACE"

FA_FURNACE.fn = function(act)
print("test?")
    if act.target.components.fa_furnace then
        act.target.components.fa_furnace:StartCooking()
        return true
    end
end

FA_FURNACE.strfn = function(act)
    if act.target.components.fa_furnace.getverb then
        return act.target.components.fa_furnace.getverb(act.target, act.doer)
    else
        return STRINGS.ACTIONS.FA_FURNACE.GENERIC
    end
end

ACTIONS.FA_FURNACE=FA_FURNACE
SGWilson.actionhandlers[ACTIONS.FA_FURNACE]=ActionHandler(ACTIONS.FA_FURNACE, "doshortaction")
--FA_ModUtil.AddAction(FA_FURNACE)

local FA_CRAFTPICKUP=Action(1)
FA_CRAFTPICKUP.id="FA_CRAFTPICKUP"

FA_CRAFTPICKUP.fn = function(act)
print("test?")
    if act.target.components.fa_furnace then
       return act.target.components.fa_furnace:Harvest(act.doer)
    end
end

FA_CRAFTPICKUP.strfn = function(act)
        return STRINGS.ACTIONS.FA_CRAFTPICKUP
end


ACTIONS.FA_CRAFTPICKUP=FA_CRAFTPICKUP
--FA_ModUtil.AddAction(FA_CRAFTPICKUP)


local RELOAD = Action(1, true)
RELOAD.id = "RELOAD"
RELOAD.str = "Reload"
RELOAD.fn = function(act)
    if act.target and act.target.components.reloadable and act.invobject and act.invobject.components.reloading then
        return act.target.components.reloadable:Reload(act.doer, act.invobject)
    end

end
ACTIONS.RELOAD = RELOAD
--FA_ModUtil.AddAction(RELOAD)

SGWilson.actionhandlers[ACTIONS.FA_CRAFTPICKUP]=ActionHandler(ACTIONS.FA_CRAFTPICKUP, "dolongaction")
