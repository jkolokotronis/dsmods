
local MakePlayerCharacter = require "prefabs/player_common"
local CooldownButton = require "widgets/cooldownbutton"


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
        Asset( "ANIM", "anim/goblin.zip" ),
        Asset( "ANIM", "anim/wizard.zip" ),
        Asset( "ANIM", "anim/smoke_up.zip" ),
}
local prefabs = {}

local DAMAGE_MULT=0.5


STRINGS.TABS.SPELLS = "Spells"
STRINGS.NAMES.MAGICMISSILEWAND = "Wand of Magic Missile"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MAGICMISSILEWAND = "Wand of Magic Missile"
STRINGS.RECIPE_DESC.MAGICMISSILEWAND = "Wand of Magic Missile"

STRINGS.NAMES.ACIDARROWWAND = "Wand of Acid Arrow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACIDARROWWAND = "Wand of Acid Arrow"
STRINGS.RECIPE_DESC.ACIDARROWWAND ="Wand of Acid Arrow"

STRINGS.NAMES.FIREBALLWAND = "Wand of Fireball"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREBALLWAND = "Wand of Fireball"
STRINGS.RECIPE_DESC.FIREBALLWAND =  "Wand of Fireball"

STRINGS.NAMES.ICESTORMWAND = "Wand of IceStorm"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICESTORMWAND = "Wand of IceStorm"
STRINGS.RECIPE_DESC.ICESTORMWAND =  "Wand of IceStorm"

STRINGS.NAMES.FIREWALLWAND = "Wand of FireWall"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIREWALLWAND = "Wand of FireWall"
STRINGS.RECIPE_DESC.FIREWALLWAND =  "Wand of FireWall"

STRINGS.NAMES.SUNBURSTWAND = "Wand of Sunburst"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUNBURSTWAND ="Wand of Sunburst"
STRINGS.RECIPE_DESC.SUNBURSTWAND ="Wand of Sunburst"

STRINGS.NAMES.SPELL_INVISIBILITY = "Invisibility"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_INVISIBILITY =  "Invisibility"
STRINGS.RECIPE_DESC.SPELL_INVISIBILITY = "Invisibility"

STRINGS.NAMES.SPELL_HASTE = "Haste"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_HASTE =  "Haste"
STRINGS.RECIPE_DESC.SPELL_HASTE = "Haste"

STRINGS.NAMES.SPELL_SUMMONFEAST = "Summon feast"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_SUMMONFEAST =  "Summon feast"
STRINGS.RECIPE_DESC.SPELL_SUMMONFEAST =  "Summon feast"

STRINGS.NAMES.PRISMATICWAND = "Prismatic Wall"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.PRISMATICWAND =  "Prismatic Wall"
STRINGS.RECIPE_DESC.PRISMATICWAND = "Prismatic Wall"


STRINGS.NAMES.TRAP_CIRCLEOFDEATH = "Circle of Death"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_CIRCLEOFDEATH = "Circle of Death"
STRINGS.RECIPE_DESC.TRAP_CIRCLEOFDEATH = "Circle of Death"


local leavestealth=function(inst)
    inst:RemoveTag("notarget")
    inst.buff_timers["invisibility"]:Hide()
    inst.buff_timers["invisibility"].cooldowntimer=0 
end

local onloadfn = function(inst, data)
    inst.invisBuffUp=data.invisBuffUp
    inst.hasteBuffUp=data.hasteBuffUp
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.invisBuffUp=inst.buff_timers["invisibility"].cooldowntimer
    data.hasteBuffUp=inst.buff_timers["haste"].cooldowntimer
    data.fa_playername=inst.fa_playername
end


local onattacked=function(inst,data)
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
    inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(125)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

--[[self.rain = SpawnPrefab( "rain" )
        self.rain.entity:SetParent( GetPlayer().entity )
        self.rain.particles_per_tick = 0
        self.rain.splashes_per_tick = 0]]
    
    inst:AddComponent("xplevel")
    inst:AddComponent("reader")


        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("goblin")
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:Hide("hat_hair")
         inst.AnimState:Hide("ARM_carry")
         inst.AnimState:Hide("hat")

    inst.buff_timers={}
--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn


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


RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}
    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("magicmissilewand", {Ingredient("meat", 1), Ingredient("cutgrass", 1), Ingredient("rocks", 1)}, booktab, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="icestaff.tex"
    r=Recipe("acidarrowwand", {Ingredient("redgem",1), Ingredient("cutgrass", 1), Ingredient("rocks", 1)}, booktab,{MAGIC = 2})
    r.image="greenstaff.tex"
    r=Recipe("fireballwand", {Ingredient("meat", 2),Ingredient("cutgrass", 1), Ingredient("rocks", 1)}, booktab, {MAGIC = 2})
    r.image="firestaff.tex"
    r=Recipe("icestormwand", {Ingredient("spidergland",1),Ingredient("cutgrass",1), Ingredient("rocks", 1)}, booktab, {MAGIC = 3})
    r.image="icestaff.tex"
    r=Recipe("firewallwand", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, booktab, {MAGIC = 3})
    r.image="firestaff.tex"
    r=Recipe("sunburstwand", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, booktab, {MAGIC = 3})
    r.image="firestaff.tex"
    r=Recipe("prismaticwand", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, booktab, {MAGIC = 3})
    r.image="firestaff.tex"


    r=Recipe("spell_invisibility", {Ingredient("redgem", 4), Ingredient("cutgrass",1), Ingredient("rocks", 1)}, booktab,{MAGIC = 2})
    r.image="book_brimstone.tex"
    r=Recipe("spell_haste", {Ingredient("meat", 2),Ingredient("cutgrass", 1), Ingredient("rocks", 1)}, booktab, {MAGIC = 2})
    r.image="book_gardening.tex"
    r=Recipe("spell_summonfeast",{Ingredient("redgem", 1), Ingredient("cutgrass", 10), Ingredient("meat", 1)}, RECIPETABS.SPELLS,{MAGIC = 2})
    r.image="book_gardening.tex"

     r=Recipe("trap_circleofdeath", {Ingredient("tentaclespots", 2),Ingredient("boards", 2), Ingredient("nightmarefuel", 2)}, booktab, {MAGIC = 2})
    r.image="trap_teeth.tex"
    

    inst.newControlsInit = function (class)
        local btn=InitBuffBar(inst,"invisibility",inst.invisBuffUp,class,"Invis")
        btn:SetPosition(-100,0,0)
        InvisibilitySpellStart(inst,inst.bbBuffUp )
        local btn=InitBuffBar(inst,"haste",inst.hasteBuffUp,class,"Haste")
        btn:SetPosition(0,0,0)
        HasteSpellStart(inst,inst.hasteBuffUp )
    end


    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("onhitother", onhitother)

end




return MakePlayerCharacter("wizard", prefabs, assets, fn)
