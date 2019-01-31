
local MakePlayerCharacter = require "prefabs/player_common"
local CooldownButton = require "widgets/cooldownbutton"
require "fa_constants"

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
        Asset( "ANIM", "anim/wortox.zip" ),
        Asset( "ANIM", "anim/wizard.zip" ),
        Asset( "ANIM", "anim/smoke_up.zip" ),

        
    Asset( "IMAGE", "images/fa_wizard_bookcraft.tex" ),
    Asset( "IMAGE", "images/fa_wizard_booknext.tex" ),
    Asset( "IMAGE", "images/fa_wizard_bookprev.tex" ),
    Asset( "IMAGE", "images/fa_wizard_bookclose.tex" ),
    Asset( "ATLAS", "images/fa_wizard_bookcraft.xml" ),
    Asset( "ATLAS", "images/fa_wizard_booknext.xml" ),
    Asset( "ATLAS", "images/fa_wizard_bookprev.xml" ),
    Asset( "ATLAS", "images/fa_wizard_bookclose.xml" ),
    Asset( "IMAGE", "images/fa_wizard_bookbackground.tex" ),
    Asset( "IMAGE", "images/fa_wizard_bookframe.tex" ),
    Asset( "ATLAS", "images/fa_wizard_bookbackground.xml" ),
    Asset( "ATLAS", "images/fa_wizard_bookframe.xml" ),
    Asset( "ATLAS", "images/fa_wizard_bookbackground.xml" ),
}

local start_inv = 
{
    "fa_spell_magicmissile", 
    "fa_scroll_1",
    "fa_scroll_1",
    "fa_scroll_1",
}

local prefabs = {
    "fa_scroll_free",
    "fa_scroll_1",
    "fa_spell_magicmissile"
}

local DAMAGE_MULT=0.5
local ARMOR_SPEED_MULT=0.3
local SANITY_PER_LEVEL=6


STRINGS.TABS.SPELLS = "Spells"



local leavestealth=function(inst)
    inst:RemoveTag("notarget")
    inst.components.fa_bufftimers:ForceRemove("invisibility")
--    inst.buff_timers["invisibility"]:Hide()
--    inst.buff_timers["invisibility"].cooldowntimer=0 
end

local onloadfn = function(inst, data)
    if(data)then
        inst.loadedSpawn=data.loadedSpawn
    end
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
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


local function enableL1spells()
    GetPlayer().fa_spellcraft.spells[1]={
--[[        {
            recname="fa_spell_resistance",
            school="abjuration",
        },]]
        {
            recname="fa_spell_acidsplash",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_dazehuman",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_dancinglight",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_light",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_frostray",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_disruptundead",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_mending",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_summonmonster1",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_protevil",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_shield",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_magearmor",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_charmperson",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_sleep",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_magicmissile",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_fear",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_rayofenfeeblement",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_expretreat",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_enlargehumanoid",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_reducehumanoid",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_resistance",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_endureelementsheat",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_endureelementscold",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_magesword",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
    }


--    local r=Recipe("fa_spell_resistance", {Ingredient("pigskin", 2), Ingredient("beefalowool", 6), Ingredient("cutgrass", 8)}, RECIPETABS.SPELLS,TECH.NONE)
--    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_acidsplash", {Ingredient("stinger",10), Ingredient("spoiled_food", 5), Ingredient("twigs", 10)},RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="greenstaff.tex"
    local r=Recipe("fa_spell_dazehuman", {Ingredient("meat",2), Ingredient("twigs", 10), Ingredient("goldnugget", 4)},RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="greenstaff.tex"
    local r=Recipe("fa_spell_dancinglight", {Ingredient("spidergland",2), Ingredient("fireflies", 4)},RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
   local  r=Recipe("fa_spell_light", {Ingredient("fireflies", 1),Ingredient("lightbulb", 4), Ingredient("papyrus", 4)}, RECIPETABS.SPELLS, TECH.FA_SPELL)
    r.image="book_gardening.tex" 
    local r=Recipe("fa_spell_frostray", {Ingredient("ice",5), Ingredient("twigs", 10), Ingredient("bluegem", 1)},RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="icestaff.tex"
    local r=Recipe("fa_spell_disruptundead", {Ingredient("boneshard", 4),Ingredient("ash", 10), Ingredient("nightmarefuel", 4)}, RECIPETABS.SPELLS, TECH.FA_SPELL)
    r.image="book_gardening.tex" 
    local r=Recipe("fa_spell_mending", {Ingredient("sewing_kit", 1), Ingredient("nightmarefuel", 6), Ingredient("honey", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster1", {Ingredient("papyrus", 4), Ingredient("silk", 2), Ingredient("spidergland", 2)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_shield", {Ingredient("ash", 10), Ingredient("rocks", 10), Ingredient("nightmarefuel", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_magearmor", {Ingredient("armorgrass", 1), Ingredient("armorwood", 1), Ingredient("nightmarefuel", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_charmperson", {Ingredient("meat", 4), Ingredient("twigs", 10), Ingredient("goldnugget", 8)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_sleep", {Ingredient("blowdart_sleep", 1), Ingredient("twigs", 10), Ingredient("poop", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
   local  r=Recipe("fa_spell_magicmissile", {Ingredient("charcoal", 10), Ingredient("twigs", 10), Ingredient("nightmarefuel", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="icestaff.tex"
    local r=Recipe("fa_spell_fear", {Ingredient("nightmarefuel", 6), Ingredient("twigs", 6), Ingredient("petals_evil", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_rayofenfeeblement", {Ingredient("nightmarefuel", 6), Ingredient("twigs", 6), Ingredient("monstermeat", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_enlargehumanoid", {Ingredient("meat", 4), Ingredient("smallmeat", 4), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_reducehumanoid", {Ingredient("meat", 4), Ingredient("smallmeat", 4), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_expretreat", {Ingredient("rabbit", 2), Ingredient("papyrus", 4), Ingredient("batwing", 1)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_protevil", {Ingredient("houndstooth", 2), Ingredient("goldnugget", 6), Ingredient("healingsalve", 2)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_resistance", {Ingredient("fa_lavapebble", 2,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("ice", 2), Ingredient("fa_bottle_water", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_endureelementsheat", {Ingredient("fa_lavapebble", 4,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("nightmarefuel", 4), Ingredient("redgem", 1)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_endureelementscold", {Ingredient("ice", 4), Ingredient("nightmarefuel", 2), Ingredient("bluegem", 1)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_magesword", {Ingredient("fa_coppersword", 1,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("nightmarefuel", 2)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="fa_coppersword.tex"
    r.atlas="images/inventoryimages/fa_inventoryimages.xml"
end

local function enableL2spells()
    GetPlayer().fa_spellcraft.spells[2]={
        {
            recname="fa_spell_acidarrow",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_summonmonster2",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_summonswarm",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_web",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_gustofwind",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_mirrorimage",
            school=FA_SPELL_SCHOOLS.ILLUSION,
        },
        {
            recname="fa_spell_commandundead",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_falselife",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_darkvision",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_knock",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
    }

    local r=Recipe("fa_spell_acidarrow", {Ingredient("stinger",20), Ingredient("spoiled_food", 5), Ingredient("twigs", 20)},RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="greenstaff.tex"
    local r=Recipe("fa_spell_summonmonster2",  {Ingredient("fish", 4), Ingredient("froglegs", 4), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonswarm", {Ingredient("spidergland", 5), Ingredient("silk", 5), Ingredient("monstermeat", 5)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_web", {Ingredient("twigs", 10), Ingredient("silk", 8), Ingredient("spidergland", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_gustofwind", {Ingredient("feather_crow", 4), Ingredient("feather_robin", 4), Ingredient("feather_robin_winter", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_mirrorimage", {Ingredient("meat", 4), Ingredient("beardhair", 4), Ingredient("monstermeat", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
   local  r=Recipe("fa_spell_commandundead", {Ingredient("boneshard", 6), Ingredient("nightmarefuel", 6), Ingredient("petals_evil", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_falselife", {Ingredient("nightmarefuel", 4), Ingredient("mosquitosack", 2), Ingredient("spidergland", 2)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_darkvision", {Ingredient("lightbulb", 12), Ingredient("fireflies", 2), Ingredient("papyrus", 4)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
   local  r=Recipe("fa_spell_knock", {Ingredient("nightmarefuel", 2), Ingredient("hammer", 1), Ingredient("fa_copperbar", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="icestaff.tex"
end

local function enableL3spells()
    GetPlayer().fa_spellcraft.spells[3]={
        {
            recname="fa_spell_summonmonster3",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        --[[
        {
            recname="fa_spell_deepslumber",
            school="enchantment",
        },]]
        {
            recname="fa_spell_holdperson",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        --[[
        {
            recname="fa_spell_rage",
            school="enchantment",
        },--]]
        {
            recname="fa_spell_daylight",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_fireball",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_tinyhut",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_haltundeadmass",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_haste",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_slow",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
    }


    local r=Recipe("fa_spell_summonmonster3", {Ingredient("pigskin", 2), Ingredient("poop", 6), Ingredient("papyrus", 5)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
--    local r=Recipe("fa_spell_deepslumber", {Ingredient("blowdart_sleep", 2), Ingredient("twigs", 15), Ingredient("poop", 8)}, RECIPETABS.SPELLS,TECH.NONE)
--    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_holdperson", {Ingredient("meat", 2), Ingredient("silk", 6), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
--    local r=Recipe("fa_spell_rage", {Ingredient("meat", 4), Ingredient("monstermeat", 6), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.NONE)
--    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_daylight", {Ingredient("lightbulb", 12), Ingredient("boneshard", 2), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_fireball", {Ingredient("charcoal", 10), Ingredient("ash", 10), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="firestaff.tex"
    local r=Recipe("fa_spell_tinyhut", {Ingredient("log", 20), Ingredient("bedroll_furry", 1), Ingredient("twigs", 20)}, RECIPETABS.SPELLS,TECH.FA_SPELL,"fa_spell_tinyhut_placer")
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_haltundeadmass", {Ingredient("nightmarefuel", 8), Ingredient("boneshard", 4), Ingredient("petals_evil", 8)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_haste", {Ingredient("rabbit", 2), Ingredient("batwing", 3), Ingredient("papyrus", 8)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_slow", {Ingredient("silk", 5), Ingredient("honey", 10), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
end

local function enableL4spells()
    GetPlayer().fa_spellcraft.spells[4]={
        {
            recname="fa_spell_stoneskin",--wasnt this conjuration?
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_secureshelter",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_summonmonster4",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_charmmonster",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_firewall",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_shadowconjuration",
            school=FA_SPELL_SCHOOLS.ILLUSION,
        },
        {
            recname="fa_spell_animatedead",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
    }

    local r=Recipe("fa_spell_stoneskin", {Ingredient("rocks", 20), Ingredient("flint", 10), Ingredient("papyrus", 8)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_secureshelter", {Ingredient("log", 40), Ingredient("bedroll_furry", 1), Ingredient("twigs", 40)}, RECIPETABS.SPELLS,TECH.FA_SPELL,"fa_spell_secureshelter_placer")
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster4", {Ingredient("bluegem", 1), Ingredient("houndstooth", 4), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_charmmonster", {Ingredient("monstermeat", 6), Ingredient("goldnugget", 8), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_firewall", {Ingredient("redgem", 4), Ingredient("rocks", 10), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="firestaff.tex"
    local r=Recipe("fa_spell_shadowconjuration", {Ingredient("nightmarefuel", 10), Ingredient("petals_evil", 10), Ingredient("papyrus", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_animatedead", {Ingredient("nightmarefuel", 10), Ingredient("boneshard", 5), Ingredient("papyrus", 10)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
end

local function enableL5spells()
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="fa_spell_magehound",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
--[[        {
            recname="fa_spell_wallofstone",
            school="conjuration",
        },]]
        {
            recname="fa_spell_dominateperson",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_holdmonster",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
    }

    local r=Recipe("fa_spell_magehound", {Ingredient("beardhair", 4), Ingredient("monstermeat", 8), Ingredient("papyrus", 8)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
--    local r=Recipe("fa_spell_wallofstone", {Ingredient("rocks", 20), Ingredient("twigs", 10), Ingredient("flint", 10)}, RECIPETABS.SPELLS,TECH.NONE)
--    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_dominateperson", {Ingredient("meat", 8), Ingredient("twigs", 15), Ingredient("goldnugget", 16)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_holdmonster", {Ingredient("monstermeat", 6), Ingredient("silk", 8), Ingredient("honey", 12)}, RECIPETABS.SPELLS,TECH.FA_SPELL)
    r.image="book_gardening.tex"
end

local function enableL6spells() end
local function enableL7spells() end
local function enableL8spells() end
local function enableL9spells() end



local function onxploaded(inst)
    local level=inst.components.xplevel.level
    inst.components.fa_spellcaster.casterlevel=level
    if(level>=3)then
        enableL2spells()
    end
    if(level>=5)then
        enableL3spells()
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_5")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_5")
    end
    if(level>=7)then
        enableL4spells()
    end
    if(level>=9)then
        enableL5spells()
    end
    if(level>=10)then
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_10")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_10")
    end
    if(level>=11)then
        enableL6spells()
    end
    if(level>=14)then
        enableL7spells()
    end
    if(level>=17)then
        enableL8spells()
    end
    if(level>=19)then
        enableL9spells()
    end
    if(level==20)then
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_20")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_20")
    end
    if(level>1)then
        inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL*(level-1)
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.fa_spellcaster.casterlevel=level

    inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL

    if(level==3)then
        enableL2spells()
    elseif(level==5)then
        enableL3spells()
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_5")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_5")
    elseif(level==7)then
        enableL4spells()
    elseif(level==9)then
        enableL5spells()
    elseif(level==10)then
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_10")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_10")
    elseif(level==11)then
        enableL6spells()
    elseif(level==14)then
        enableL7spells()
    elseif(level==17)then
        enableL8spells()
    elseif(level==19)then
        enableL9spells()
    elseif(level==20)then
        inst.AnimState:OverrideSymbol("headbase", "wizard", "headbase_20")
        inst.AnimState:OverrideSymbol("headbase_hat", "wizard", "headbase_hat_20")
    end

    --effectively, this is same as [1,currentlevel]
    local scroll=SpawnPrefab("fa_scroll_free")
    scroll.lowbound=1
    scroll.highbound=9
    scroll.setRecipe(scroll.lowbound,scroll.highbound,inst)
    inst.components.inventory:GiveItem(scroll, nil, TheInput:GetScreenPosition())
end


local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wizard"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wizard.tex" )

	-- todo: Add an example special power here.
    inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(125)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

--[[self.rain = SpawnPrefab( "rain" )
        self.rain.entity:SetParent( GetPlayer().entity )
        self.rain.particles_per_tick = 0
        self.rain.splashes_per_tick = 0]]
    
    inst:AddTag("fa_spellcaster")
    inst:AddComponent("xplevel")
    inst:AddComponent("reader")
    inst:AddComponent("fa_spellcaster")


    inst.fa_spellcraft={}
    inst.fa_spellcraft.spells={}
    

    inst.buff_timers={}
--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn


    inst:ListenForEvent("xplevelup", onlevelup)
    inst:ListenForEvent("xplevel_loaded",onxploaded)

    local old_speedmult=inst.components.locomotor.GetSpeedMultiplier
    function inst.components.locomotor:GetSpeedMultiplier()
        local res=old_speedmult(self)
        local body=self.inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
        if(body and body.components.armor and not (body:HasTag("fa_boundarmor") or body:HasTag("fa_robe")))then
            res=res*ARMOR_SPEED_MULT
        end
        return res
    end

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


    RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex",crafting_station = false}--, icon_atlas = "images/inventoryimages/herotab.xml"}
    enableL1spells()

    inst.newControlsInit = function (class)
        if(class.buffbar)then
            class.buffbar.width=800
        end
    end


    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("onhitother", onhitother)

end




return MakePlayerCharacter("wizard", prefabs, assets, fn,start_inv)
