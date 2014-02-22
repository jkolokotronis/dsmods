
local MakePlayerCharacter = require "prefabs/player_common"
local Combat=require "components/combat"
local SneakBuff = require "widgets/sneakbuff"

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
        Asset( "ANIM", "anim/thief.zip" ),
}
local prefabs = {
    "trap_doubleteeth",
    "trap_ice",
    "trap_fire",
    "trap_tentacle"
}

local BACKSTAB_MULTIPLIER=3
local RANGE_MULTIPLIER=1.5
local ASSASSINATION_MULTIPLIER=5
local SNEAK_HUNGER_MULT=2.0


STRINGS.TABS.SUBTERFUGE = "Subterfuge"
RECIPETABS["SUBTERFUGE"] = {str = "SUBTERFUGE", sort=999, icon = "trap_teeth.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}

STRINGS.NAMES.BOW = "Bow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "Bow"
STRINGS.RECIPE_DESC.BOW = "Bow"

STRINGS.NAMES.ARROWS = "Arrows"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROWS = "Arrows"
STRINGS.RECIPE_DESC.ARROWS = "Arrows"

STRINGS.NAMES.TRAP_DOUBLETEETH = "Double Teeth Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_DOUBLETEETH = "Double Teeth Trap"
STRINGS.RECIPE_DESC.TRAP_DOUBLETEETH = "Double Teeth Trap"

STRINGS.NAMES.TRAP_ICE = "Ice Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_ICE = "Ice Trap"
STRINGS.RECIPE_DESC.TRAP_ICE = "Ice Trap"

STRINGS.NAMES.TRAP_FIRE = "Fire Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_FIRE = "Fire Trap"
STRINGS.RECIPE_DESC.TRAP_FIRE = "Fire Trap"

STRINGS.NAMES.TRAP_TENTACLE = "Tentacle Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_TENTACLE = "Tentacle Trap"
STRINGS.RECIPE_DESC.TRAP_TENTACLE = "Tentacle Trap"

local sneakBuff

local enterstealth=function(inst)
    inst.components.hunger:SetRate(SNEAK_HUNGER_MULT*TUNING.WILSON_HUNGER_RATE)
    inst:AddTag("notarget")
end

local leavestealth=function(inst)
    inst:RemoveTag("notarget")
    inst.sneakBuff:ForceState("off")
    inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)

end

local onattacked=function(inst,data)
    local attacker=data.attacker
    local damage=data.damage
    local weapon=data.weapon
    if(damage and damage>0 and inst:HasTag("notarget"))then
        leavestealth(inst)
    end
end

local onhitother=function(inst,data)
    local damage=data.damage
    if(damage and damage>0 and inst:HasTag("notarget"))then
        leavestealth(inst)
    end
end


local fn = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=0.75
	inst.components.health:SetMaxHealth(125)
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(175)
        
    local combatmod=inst.components.combat

    function combatmod:CalcDamage (target, weapon, multiplier)
        local sneaking=inst:HasTag("notarget")
        local old=Combat.CalcDamage(self,target,weapon,multiplier)
        if(weapon and weapon.attackrange and weapon.attackrage>5)then
            return old*RANGE_MULTIPLIER
        end
        if(sneaking and not(target.components.combat and target.components.combat.target==GetPlayer()))then
            return old*ASSASSINATION_MULTIPLIER
        end
        if(target and target.components.combat and target.components.combat.target==GetPlayer())then
                return old
        else
            return old*BACKSTAB_MULTIPLIER
       end
    end

    local sg=inst.sg.sg

    sg.states["sneak"]=State{
        name = "sneak",
        tags = {"idle", "hiding"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hide")
            inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
            enterstealth(inst)
        end,
        
        onexit = function(inst)
            print("sneak exit")
--            inst:RemoveTag("notarget")
        end,
        
        events=
        {
 --          EventHandler("animover", function(inst) inst.sg:GoToState("sneak_idle") end),
        },
    }

    sg.states["sneak_idle"]=State{
        name = "sneak_idle",
        tags = {"idle", "hiding"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hide_idle", true)
            enterstealth(inst)
        end,
        
        onexit = function(inst)
            print("sneak idle exit")
--            inst:RemoveTag("notarget")
        end
        
    }

--theres gotta be a better way...

    local action_old=ACTIONS.FORCEATTACK.fn
    ACTIONS.FORCEATTACK.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.EAT.fn
    ACTIONS.EAT.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.MINE.fn
    ACTIONS.MINE.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DIG.fn
    ACTIONS.DIG.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.GIVE.fn
    ACTIONS.GIVE.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.COOK.fn
    ACTIONS.COOK.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DRY.fn
    ACTIONS.DRY.fn = function(act)
       if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.TALKTO.fn
    ACTIONS.TALKTO.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.BUILD.fn
    ACTIONS.BUILD.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.PLANT.fn
    ACTIONS.PLANT.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.HARVEST.fn
    ACTIONS.HARVEST.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DEPLOY.fn
    ACTIONS.DEPLOY.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.CATCH.fn
    ACTIONS.CATCH.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.FISH.fn
    ACTIONS.FISH.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.USEITEM.fn
    ACTIONS.USEITEM.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.READ.fn
    ACTIONS.READ.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.PICK.fn
    ACTIONS.PICK.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")and act.target.components.pickable and act.target.components.pickable.product 
            and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs") ) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local booktab=RECIPETABS.SUBTERFUGE
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("arrows", {Ingredient("twigs", 5), Ingredient("houndstooth", 1)}, booktab, {SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("bow", {Ingredient("twigs", 2), Ingredient("rope", 1),Ingredient("pigskin", 1)}, booktab,{SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("trap_doubleteeth", {Ingredient("houndstooth", 5), Ingredient("boards", 2), Ingredient("rocks", 2)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_fire", {Ingredient("gunpowder", 4),Ingredient("boards", 2), Ingredient("rocks", 2)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_ice", {Ingredient("feather_robin_winter", 2), Ingredient("boards", 2), Ingredient("rocks", 2)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_tentacle", {Ingredient("tentaclespots", 2),Ingredient("boards", 2), Ingredient("nightmarefuel", 2)}, booktab, {MAGIC = 2})
    r.image="trap_teeth.tex"

    inst.newControlsInit = function (class)
                inst.sneakBuff=SneakBuff(class.owner)
                class.rage = class:AddChild(inst.sneakBuff)
                class.rage:SetPosition(0,0,0)
                class.rage:SetOnClick(function(state) 
                     print("onclick",state) 
                        if(state and state=="on") then
--                                inst.sg:GoToState("hide")
                                inst.sg:GoToState("sneak")
                        elseif(inst:HasTag("notarget"))then
                            leavestealth(inst)
                            inst.sg:GoToState("idle")
                        end
                end)
    end

    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("onhitother", onhitother)
end



return MakePlayerCharacter("thief", prefabs, assets, fn)
