local SGWilson=require "stategraphs/SGwilson"
require "actions"

local DIG_SAND_CHANCE=0.1
local MINE_DIAMOND_CHANCE=0.05

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


local FA_MEND=Action(1, true)
FA_MEND.id="FA_MEND"
FA_MEND.str="Mend"
FA_MEND.fn=function(act)
print("actionfn")
    if(act.target and act.invobject and act.invobject.components.fa_mender)then
        return act.invobject.components.fa_mender:DoMending(act.target, act.doer)
    end
end
FA_ModUtil.AddAction(FA_MEND) 



local action_old=ACTIONS.MURDER.fn

ACTIONS.MURDER.fn = function(act)

    local murdered = act.invobject or act.target
    if murdered and murdered.components.health then
                
        local obj=murdered.components.inventoryitem:RemoveFromOwner(false)

        if murdered.components.health.murdersound then
            act.doer.SoundEmitter:PlaySound(murdered.components.health.murdersound)
        end

        local stacksize = 1
        if murdered.components.stackable then
            stacksize = murdered.components.stackable.stacksize
        end

        if murdered.components.lootdropper then
--            for i = 1, stacksize do
                local loots = murdered.components.lootdropper:GenerateLoot()
                for k, v in pairs(loots) do
                    local loot = SpawnPrefab(v)
                    act.doer.components.inventory:GiveItem(loot)
                end      
--            end
        end

        act.doer:PushEvent("killed", {victim = obj})
        obj:Remove()

        return true
    end
end

local dig_old=ACTIONS.DIG.fn
ACTIONS.DIG.fn = function(act)
	if(act.target and act.target:IsValid() and math.random()<DIG_SAND_CHANCE)then
	    local spawnPos =Vector3(act.target.Transform:GetWorldPosition() )
	    local sand=SpawnPrefab("fa_sand")
        sand.Transform:SetPosition(spawnPos:Get() )
	end
	return dig_old(act)
end

local mine_old=ACTIONS.MINE.fn
ACTIONS.MINE.fn = function(act)
	--have to do this before cause callback can destroy the object leading to invalid references
	local pos
	if(act.target and act.target:IsValid())then
		pos=Vector3(act.target.Transform:GetWorldPosition() )
	end
	local ret=mine_old(act)
    if pos and ((act.target and act.target.components.workable and act.target.components.workable.workleft<=0) or not act.target:IsValid()) and math.random()<MINE_DIAMOND_CHANCE then
	    local sand=SpawnPrefab("fa_diamondpebble")
        sand.Transform:SetPosition(spawnPos:Get() )
    end

    return ret
end