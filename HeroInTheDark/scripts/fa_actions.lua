local SGWilson=require "stategraphs/SGwilson"
require "actions"

local DIG_SAND_CHANCE=0.35
local MINE_DIAMOND_CHANCE=0.05

local FA_FURNACE=Action(1)
FA_FURNACE.id="FA_FURNACE"

FA_FURNACE.fn = function(act)
--print("test?")
    if act.target.components.fa_furnace then
        act.target.components.fa_furnace:StartCooking()
        return true
    end
end

FA_FURNACE.strfn = function(act)

    if act.target.components.fa_furnace.getverb then
        local what=act.target.components.fa_furnace.getverb(act.target, act.doer)
--        print(what)
        return what
    else
        return nil
    end
end

ACTIONS.FA_FURNACE=FA_FURNACE
SGWilson.actionhandlers[ACTIONS.FA_FURNACE]=ActionHandler(ACTIONS.FA_FURNACE, "doshortaction")
--FA_ModUtil.AddAction(FA_FURNACE)

local FA_CRAFTPICKUP=Action(1)
FA_CRAFTPICKUP.id="FA_CRAFTPICKUP"

FA_CRAFTPICKUP.fn = function(act)
--print("test?")
    if act.target.components.fa_furnace then
       return act.target.components.fa_furnace:Harvest(act.doer)
    end
end

FA_CRAFTPICKUP.strfn = function(act)
        return STRINGS.ACTIONS.FA_CRAFTPICKUP
end

ACTIONS.FA_CRAFTPICKUP=FA_CRAFTPICKUP
SGWilson.actionhandlers[ACTIONS.FA_CRAFTPICKUP]=ActionHandler(ACTIONS.FA_CRAFTPICKUP, "dolongaction")
--FA_ModUtil.AddAction(FA_CRAFTPICKUP)


local FA_LOCKPICK=Action(1)
FA_LOCKPICK.id="FA_CRAFTPICKUP"

FA_LOCKPICK.fn = function(act)
    if act.target.components.lock then
        if act.target.components.lock:IsLocked() then
            local key=act.invobject
            local test=key.components.fa_lockpick:TryUnlock(act.target,act.doer)
            --this could go in tryunlock, but how safe is it to destroy object from a member component of said object?
            if(test)then
                if key.components.stackable and key.components.stackable.stacksize > 1 then
                    key = key.components.stackable:Get()

                else
                    key.components.inventoryitem:RemoveFromOwner()
                end
            key:Remove()
            return test
            end
        end
        return false
    end
end

FA_LOCKPICK.strfn = function(act)
        return STRINGS.ACTIONS.FA_LOCKPICK
end

ACTIONS.FA_LOCKPICK=FA_LOCKPICK
SGWilson.actionhandlers[ACTIONS.FA_LOCKPICK]=ActionHandler(ACTIONS.FA_LOCKPICK, "dolongaction")

local FA_DRINK=Action()
FA_DRINK.id="FA_DRINK"

FA_DRINK.fn = function(act)
local obj = act.target or act.invobject
print("drink",act.doer,obj)
    if act.doer.components.fa_drinker then
       return act.doer.components.fa_drinker:Drink(obj)
    end
end

ACTIONS.FA_DRINK=FA_DRINK

SGWilson.actionhandlers[ACTIONS.FA_DRINK]=ActionHandler(ACTIONS.FA_DRINK, "fa_drink")
SGWilson.states["fa_drink"]= State{
        name = "fa_drink",
        tags ={"busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("horn")
            inst.AnimState:OverrideSymbol("horn01", "fa_mug", "drink_override")
            --inst.AnimState:Hide("ARM_carry") 
            inst.AnimState:Show("ARM_normal")
            if inst.components.inventory.activeitem then-- and inst.components.inventory.activeitem.components.instrument then
                print("act",inst.components.inventory.activeitem)
                inst.components.inventory:ReturnActiveItem()
            end
            
            inst.components.hunger:Pause()
        end,
        
        onexit = function(inst)
            if inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
                inst.AnimState:Show("ARM_carry") 
                inst.AnimState:Hide("ARM_normal")
            inst.components.hunger:Resume()
            end
        end,
        
        timeline=
        {
            TimeEvent(21*FRAMES, function(inst)
         --       inst.SoundEmitter:PlaySound("dontstarve/common/horn_beefalo")
                inst:PerformBufferedAction()
            end),
        },
        
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

    }    

SGWilson.states["fa_spellfailed"]=State{
        name = "fa_spellfailed",
        tags = {"busy", "fa_spellfailed"},
        onenter = function(inst)
            inst.components.playercontroller:Enable(false)
            if inst.components.locomotor then
                inst.components.locomotor:StopMoving()
            end
            inst.AnimState:PlayAnimation("idle")
            inst.SoundEmitter:PlaySound("dontstarve/common/freezecreature")
            if(not inst.fa_fizzle_fx)then
                local fx=SpawnPrefab("fa_spinningstarsfx")
                fx.persists=false
                local follower = fx.entity:AddFollower()
                follower:FollowSymbol( inst.GUID, inst.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
                inst.fa_fizzle_fx=fx
            end
        end,
        
        onexit = function(inst)
            if(inst.fa_fizzle_fx)then
                inst.fa_fizzle_fx:Remove()
                inst.fa_fizzle_fx=nil
            end
            inst.components.playercontroller:Enable(true)
        end,

         timeline=
        {
            TimeEvent(5, function(inst)
                if inst.sg.sg.states.hit then
                    inst.sg:GoToState("hit")
                else
                    inst.sg:GoToState("idle")
                end
            end),
        },
    }


SGWilson.states["fa_whirlwind"]=State{
        name = "fa_whirlwind",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.components.combat:StartAttack()
            inst.AnimState:PlayAnimation("fa_whirlwind")
            inst.components.playercontroller:Enable(false)
        end,

        onexit=function(inst)
            inst.components.playercontroller:Enable(true)
        end,
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        timeline=
        {
            TimeEvent(4*FRAMES, function(inst) 
                local pos=Vector3(inst.Transform:GetWorldPosition())
                local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 10,nil,{"INLIMBO","FX","DECOR","player","companion"})
                for k,v in pairs(ents) do
                    if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) 
                        and not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))then
                            inst.components.combat:DoAttack(v, nil, nil, nil, 5)
                    end
                end
            end),
            TimeEvent(18*FRAMES, function(inst) 
                local pos=Vector3(inst.Transform:GetWorldPosition())
                local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 10,nil,{"INLIMBO","FX","DECOR","player","companion"})
                for k,v in pairs(ents) do
                    if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) 
                        and not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))then
                            inst.components.combat:DoAttack(v, nil, nil, nil, 5)
                    end
                end
                inst.sg:RemoveStateTag("abouttoattack") 
            end),
            TimeEvent(24*FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
                inst.sg:RemoveStateTag("busy")
            end),            
        },
    }


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



local harveststrfn_old=ACTIONS.HARVEST.strfn 
ACTIONS.HARVEST.strfn = function(act)
    if act.target.components.harvestable and act.target.components.harvestable.getverb then
        return act.target.components.harvestable.getverb(act.target, act.doer)
    else
        return harveststrfn_old(act)
    end
end

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
        sand.Transform:SetPosition(pos:Get() )
    end

    return ret
end

local pickup_old=ACTIONS.PICKUP.fn
ACTIONS.PICKUP.fn = function(act)
    if act.doer.components.inventory and act.target and (act.target:HasTag("cursed") or act.target:HasTag("unidentified")   ) and act.target.components.inventoryitem and not act.target:IsInLimbo() then    
        act.doer:PushEvent("onpickup", {item = act.target})
        act.doer.components.inventory:GiveItem(act.target, nil, Vector3(TheSim:GetScreenPos(act.target.Transform:GetWorldPosition())))
        return true 
    else
        return pickup_old(act)
    end
end