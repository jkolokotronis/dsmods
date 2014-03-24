local require = GLOBAL.require
require "class"
require "util"

local MergeMaps=GLOBAL.MergeMaps
local Widget = require "widgets/widget"
local XPBadge= require "widgets/xpbadge"
local TextEdit=require "widgets/textedit"
require "widgets/text"
require "stategraph"
require "constants"
require "buffutil"
require "fa_mobxptable"
require "fa_levelxptable"
require "fa_stealthdetectiontable"
local FA_CharRenameScreen=require "screens/fa_charrenamescreen"
--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local GetPlayer = GLOBAL.GetPlayer
local GetClock=GLOBAL.GetClock
local GetWorld=GLOBAL.GetWorld
local GetSeasonManager=GLOBAL.GetSeasonManager
local SpawnPrefab=GLOBAL.SpawnPrefab

local StatusDisplays = require "widgets/statusdisplays"
local ImageButton = require "widgets/imagebutton"

require "repairabledescriptionfix"

PrefabFiles = {
    "poisonspider",
    "poisonspiderden",
    "spellprojectiles",
    "natureshealing",
    "skeletonspawn",
    "boomstickprojectile",
    "fizzleboomstick",
    "fizzlearmor",
    "poopbricks",
    "treeguardian",
    "fizzlepet",
    "fizzlemanipulator",
    "rjk1100",
    "dksword",
    "holysword",
    "thieftraps",
    "arrows",
    "bow",
    "spellbooks",
    "shields",
    "armor_fire",
    "armor_frost",
    "dagger",
    "flamingsword",
    "frostsword",
    "undeadbanesword",
    "vorpalaxe",
    "wands",
    "dryad",
    "satyr",
    "unicorn",
    "orc",
    "ogre",
    "troll",
    "goblin",
    "wolf",
    "goblinhut",
    "wolfmound",
	"thief",
	"barb",
	"cleric",
    "fairy",
	"druid",
	"darkknight",
    "darkknightpet",
    "monk",
    "necromancer",
    "necropet",
    "wizard",
    "tinkerer",
    "paladin",
    "bard",
    "ranger",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/thief.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/thief.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/barb.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/barb.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/druid.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/druid.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/monk.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/monk.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/saveslot_portraits/bard.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/bard.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/thief.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/thief.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/barb.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/barb.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/cleric.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/cleric.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/druid.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/druid.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/darkknight.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/darkknight.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/monk.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/monk.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/necromancer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/necromancer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/wizard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wizard.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/tinkerer.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/tinkerer.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/paladin.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/paladin.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/ranger.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ranger.xml" ),
    Asset( "IMAGE", "images/selectscreen_portraits/bard.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/bard.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/wod_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/wod_silho.xml" ),

    Asset( "IMAGE", "bigportraits/thief.tex" ),
    Asset( "ATLAS", "bigportraits/thief.xml" ),
    Asset( "IMAGE", "bigportraits/barb.tex" ),
    Asset( "ATLAS", "bigportraits/barb.xml" ),
    Asset( "IMAGE", "bigportraits/cleric.tex" ),
    Asset( "ATLAS", "bigportraits/cleric.xml" ),
    Asset( "IMAGE", "bigportraits/druid.tex" ),
    Asset( "ATLAS", "bigportraits/druid.xml" ),
    Asset( "IMAGE", "bigportraits/monk.tex" ),
    Asset( "ATLAS", "bigportraits/monk.xml" ),
    Asset( "IMAGE", "bigportraits/necromancer.tex" ),
    Asset( "ATLAS", "bigportraits/necromancer.xml" ),
    Asset( "IMAGE", "bigportraits/wizard.tex" ),
    Asset( "ATLAS", "bigportraits/wizard.xml" ),
    Asset( "IMAGE", "bigportraits/tinkerer.tex" ),
    Asset( "ATLAS", "bigportraits/tinkerer.xml" ),
    Asset( "IMAGE", "bigportraits/paladin.tex" ),
    Asset( "ATLAS", "bigportraits/paladin.xml" ),
    Asset( "IMAGE", "bigportraits/ranger.tex" ),
    Asset( "ATLAS", "bigportraits/ranger.xml" ),
    Asset( "IMAGE", "bigportraits/bard.tex" ),
    Asset( "ATLAS", "bigportraits/bard.xml" ),

    Asset("SOUNDPACKAGE", "sound/fa.fev"),
    Asset("SOUND", "sound/fallenangel.fsb"),

    Asset( "IMAGE", "images/xp_background.tex" ),
    Asset( "ATLAS", "images/xp_background.xml" ),
    Asset( "IMAGE", "images/xp_fill.tex" ),
    Asset( "ATLAS", "images/xp_fill.xml" ),
    Asset( "IMAGE", "images/transparent.tex" ),
    Asset( "ATLAS", "images/transparent.xml" ),

    Asset( "IMAGE", "minimap/boneshield.tex" ),
    Asset( "ATLAS", "minimap/boneshield.xml" ),
    Asset( "IMAGE", "minimap/dagger.tex" ),
    Asset( "ATLAS", "minimap/dagger.xml" ),
    Asset( "IMAGE", "minimap/evilsword.tex" ),
    Asset( "ATLAS", "minimap/evilsword.xml" ),
    Asset( "IMAGE", "minimap/firearmor.tex" ),
    Asset( "ATLAS", "minimap/firearmor.xml" ),
    Asset( "IMAGE", "minimap/flamingsword.tex" ),
    Asset( "ATLAS", "minimap/flamingsword.xml" ),
    Asset( "IMAGE", "minimap/frostarmor.tex" ),
    Asset( "ATLAS", "minimap/frostarmor.xml" ),
    Asset( "IMAGE", "minimap/holysword.tex" ),
    Asset( "ATLAS", "minimap/holysword.xml" ),
    Asset( "IMAGE", "minimap/marbleshield.tex" ),
    Asset( "ATLAS", "minimap/marbleshield.xml" ),
    Asset( "IMAGE", "minimap/reflectshield.tex" ),
    Asset( "ATLAS", "minimap/reflectshield.xml" ),
    Asset( "IMAGE", "minimap/rockshield.tex" ),
    Asset( "ATLAS", "minimap/rockshield.xml" ),
    Asset( "IMAGE", "minimap/undeadbanesword.tex" ),
    Asset( "ATLAS", "minimap/undeadbanesword.xml" ),
    Asset( "IMAGE", "minimap/vorpalaxe.tex" ),
    Asset( "ATLAS", "minimap/vorpalaxe.xml" ),
    Asset( "IMAGE", "minimap/woodbow.tex" ),
    Asset( "ATLAS", "minimap/woodbow.xml" ),
    Asset( "IMAGE", "minimap/woodshield.tex" ),
    Asset( "ATLAS", "minimap/woodshield.xml" ),   
}


-- strings! Any "WOD" below would have to be replaced by the prefab name of your character.

-- The character select screen lines
-- note: these are lower-case character name
GLOBAL.STRINGS.CHARACTER_TITLES.thief = "The Sneaky"
GLOBAL.STRINGS.CHARACTER_NAMES.thief = "Pete"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.thief = "* Stabby"
GLOBAL.STRINGS.CHARACTER_QUOTES.thief = "\"Never saw me coming.\""

GLOBAL.STRINGS.CHARACTER_TITLES.barb = "The Barbarian"
GLOBAL.STRINGS.CHARACTER_NAMES.barb = "Brute strength and raw fury!"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.barb = "1.  The Lower his life the stronger his attacks\n2.  Chops / mines 50% faster, is more hungry\n3.  Can eat raw meats with no neg effects\n5.  RAGE!"
GLOBAL.STRINGS.CHARACTER_QUOTES.barb = "\"Don't ge me angry!\""

GLOBAL.STRINGS.CHARACTER_TITLES.cleric = "The Cleric"
GLOBAL.STRINGS.CHARACTER_NAMES.cleric = "cleric"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.cleric = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.cleric = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.druid = "The Druid"
GLOBAL.STRINGS.CHARACTER_NAMES.druid = "Nature's protector"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.druid = "1.  Animal companion\n2.  Druid spells\n3.  Loses sanity from destroying trees, grass and saplings\n4.  Loses sanity for killing an innocents"
GLOBAL.STRINGS.CHARACTER_QUOTES.druid = "\"When nature has work to be done, she creates a genius.\""

GLOBAL.STRINGS.CHARACTER_TITLES.darkknight = "The Shadow"
GLOBAL.STRINGS.CHARACTER_NAMES.darkknight = "darkknight"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.darkknight = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.darkknight = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.monk = "monk"
GLOBAL.STRINGS.CHARACTER_NAMES.monk = "monk"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.monk = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.monk = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.necromancer = "necromancer"
GLOBAL.STRINGS.CHARACTER_NAMES.necromancer = "necromancer"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.necromancer = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.necromancer = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.wizard = "wizard"
GLOBAL.STRINGS.CHARACTER_NAMES.wizard = "wizard"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.wizard = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.wizard = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.tinkerer = "tinkerer"
GLOBAL.STRINGS.CHARACTER_NAMES.tinkerer = "tinkerer"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.tinkerer = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.tinkerer = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.paladin = "paladin"
GLOBAL.STRINGS.CHARACTER_NAMES.paladin = "paladin"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.paladin = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.paladin = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.ranger = "ranger"
GLOBAL.STRINGS.CHARACTER_NAMES.ranger = "paladin"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.ranger = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.ranger = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.bard = "bard"
GLOBAL.STRINGS.CHARACTER_NAMES.bard = "bard"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.bard = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.bard = "\"I am a blank slate.\""
-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
GLOBAL.STRINGS.CHARACTERS.THIEF = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE.EVERGREEN = "A template description of a tree."

GLOBAL.STRINGS.NAMES.BOW = "Bow"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BOW = "Bow"
GLOBAL.STRINGS.RECIPE_DESC.BOW = "Bow"
GLOBAL.STRINGS.NAMES.ARROWS = "Arrows"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROWS = "Arrows"
GLOBAL.STRINGS.RECIPE_DESC.ARROWS = "Arrows"
GLOBAL.STRINGS.NAMES.WOODENSHIELD = "Wooden Shield"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.WOODENSHIELD = "Wooden Shield"
GLOBAL.STRINGS.RECIPE_DESC.WOODENSHIELD = "Wooden Shield"
GLOBAL.STRINGS.NAMES.ROCKSHIELD = "Rock Shield"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ROCKSHIELD = "Rock Shield"
GLOBAL.STRINGS.RECIPE_DESC.ROCKSHIELD = "Rock Shield"
GLOBAL.STRINGS.NAMES.MARBLESHIELD = "Marble Shield"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MARBLESHIELD = "Marble Shield"
GLOBAL.STRINGS.RECIPE_DESC.MARBLESHIELD = "Marble Shield"
GLOBAL.STRINGS.NAMES.BONESHIELD = "Bone Shield"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.BONESHIELD = "Bone Shield"
GLOBAL.STRINGS.RECIPE_DESC.BONESHIELD = "Bone Shield"
GLOBAL.STRINGS.NAMES.REFLECTSHIELD = "Reflection Shield"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.REFLECTSHIELD = "Reflection Shield"
GLOBAL.STRINGS.NAMES.UNDEADBANESWORD = "Sword of Lesser Undead Bane"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNDEADBANESWORD = "Sword of Lesser Undead Bane"
GLOBAL.STRINGS.NAMES.UNDEADBANESWORD2 = "Sword of Undead Bane"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNDEADBANESWORD2 = "Sword of Undead Bane"
GLOBAL.STRINGS.NAMES.UNDEADBANESWORD3 = "Sword of Greater Undead Bane"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.UNDEADBANESWORD3 = "Sword of Greater Undead Bane"
GLOBAL.STRINGS.NAMES.VORPALAXE = "Lesser Vorpal Axe"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.VORPALAXE = "Lesser Vorpal Axe"
GLOBAL.STRINGS.NAMES.VORPALAXE2 = "Vorpal Axe"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.VORPALAXE2 = "Vorpal Axe"
GLOBAL.STRINGS.NAMES.VORPALAXE3 = "Greater Vorpal Axe"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.VORPALAXE3 = "Greater Vorpal Axe"
GLOBAL.STRINGS.NAMES.FLAMINGSWORD = "Lesser Flaming Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMINGSWORD = "Lesser Flaming Sword"
GLOBAL.STRINGS.NAMES.FLAMINGSWORD2 = "Flaming Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMINGSWORD2 = "Flaming Sword"
GLOBAL.STRINGS.NAMES.FLAMINGSWORD3 = "Greater Flaming Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FLAMINGSWORD3 = "Greater Flaming Sword"
GLOBAL.STRINGS.NAMES.DAGGER = "Dagger of Lesser Slaying"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DAGGER = "Dagger of Lesser Slaying"
GLOBAL.STRINGS.NAMES.DAGGER2 = "Dagger of Slaying"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DAGGER2 = "Dagger of Slaying"
GLOBAL.STRINGS.NAMES.DAGGER3 = "Dagger of Greater Slaying"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DAGGER3 = "Dagger of Greater Slaying"
GLOBAL.STRINGS.NAMES.FROSTSWORD = "Lesser Frost Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTSWORD = "Lesser Frost Sword"
GLOBAL.STRINGS.NAMES.FROSTSWORD2 = "Frost Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTSWORD2 = "Frost Sword"
GLOBAL.STRINGS.NAMES.FROSTSWORD3 = "Greater Frost Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FROSTSWORD3 = "Greater Frost Sword"
GLOBAL.STRINGS.NAMES.ARMORFIRE = "Armor of Lesser Fire"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFIRE = "Armor of Lesser Fire"
GLOBAL.STRINGS.NAMES.ARMORFIRE2 =  "Armor of Fire"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFIRE2 = "Armor of Fire"
GLOBAL.STRINGS.NAMES.ARMORFIRE3 =  "Armor of Greater Fire"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFIRE3 = "Armor of Greater Fire"
GLOBAL.STRINGS.NAMES.ARMORFROST = "Armor of Lesser Frost"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFROST = "Armor of Lesser Frost"
GLOBAL.STRINGS.NAMES.ARMORFROST2 =  "Armor of Frost"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFROST2 = "Armor of Frost"
GLOBAL.STRINGS.NAMES.ARMORFROST3 =  "Armor of Greater Frost"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMORFROST3 = "Armor of Greater Frost"
GLOBAL.STRINGS.NAMES.DKSWORD = "Evil Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DKSWORD = "Evil Sword"
GLOBAL.STRINGS.NAMES.HOLYSWORD = "Holy Sword"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HOLYSWORD = "Holy Sword"

GLOBAL.STRINGS.NAMES.FAIRY = "Wolf"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAIRY = "Wolf"
GLOBAL.STRINGS.NAMES.FAIRY_L20 = "Wolf"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAIRY_L20 = "Wolf"
GLOBAL.STRINGS.NAMES.DARKKNIGHTPET = "Shadow Pet"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.DARKKNIGHTPET = "Shadow Pet"


GLOBAL.STRINGS.ACTIONS.RELOAD="Reload"

AddMinimapAtlas("minimap/boneshield.xml")
AddMinimapAtlas("minimap/dagger.xml")
AddMinimapAtlas("minimap/evilsword.xml")
AddMinimapAtlas("minimap/firearmor.xml")
AddMinimapAtlas("minimap/flamingsword.xml")
AddMinimapAtlas("minimap/frostarmor.xml")
AddMinimapAtlas("minimap/frostsword.xml")
AddMinimapAtlas("minimap/holysword.xml")
AddMinimapAtlas("minimap/marbleshield.xml")
AddMinimapAtlas("minimap/reflectshield.xml")
AddMinimapAtlas("minimap/rockshield.xml")
AddMinimapAtlas("minimap/undeadbanesword.xml")
AddMinimapAtlas("minimap/vorpalaxe.xml")
AddMinimapAtlas("minimap/woodbow.xml")
AddMinimapAtlas("minimap/woodshield.xml")

local EVIL_SANITY_AURA_OVERRIDE={
    robin=-TUNING.SANITYAURA_MED,
    pigman=-TUNING.SANITYAURA_MED,
    crow=-TUNING.SANITYAURA_MED,
    robin_winter=-TUNING.SANITYAURA_MED,
    beefalo=-TUNING.SANITYAURA_MED,
    babybeefalo=-TUNING.SANITYAURA_MED,
    butterfly=-TUNING.SANITYAURA_MED,
    spider_hider=0,
    spider_spitter=0,
    spider_dropper=0,
    flower_evil=TUNING.SANITYAURA_MED,
    ghost=TUNING.SANITYAURA_MED,
    hound=0,
    icehound=0,
    firehound=0,
    houndfire=0,
    nightlight=TUNING.SANITYAURA_MED,--would have to properly code this
    rabbit=-TUNING.SANITYAURA_MED,--and this
    crawlinghorror=0,
    terrorbeak=0,
    shadowtentacle=0,
    shadowwaxwell=0,
    slurper=0,
    spider=0,
    spider_warrior=0,
    tentacle=0,
    tentacle_pillar_arm=0,
    walrus=-TUNING.SANITYAURA_MED,
    little_walrus=-TUNING.SANITYAURA_MED,
    worm=0,
    penguin=-TUNING.SANITYAURA_MED,
    flower=-TUNING.SANITYAURA_MED
}

FALLENLOOTTABLE={
    tier1={ armorfire=50,
            armorfrost=50,
            dagger=50,
            flamingsword=50,
            frostsword=50,
            undeadbanesword=50,
            vorpalaxe=50
        
    },
    tier2={
            armorfire2=35,
            armorfrost2=35,
            dagger2=35,
            flamingsword2=35,
            frostsword2=35,
            undeadbanesword2=35,
            vorpalaxe2=35
        
    },
    tier3={
            armorfire3=15,
            armorfrost3=15,
            dagger3=15,
            flamingsword3=15,
            frostsword3=15,
            undeadbanesword3=15,
            vorpalaxe3=15
        
    },
    TABLE_WEIGHT=700,
    TABLE_TIER1_WEIGHT=350,
    TABLE_TIER2_WEIGHT=245,
    TABLE_TIER3_WEIGHT=105
}
FALLENLOOTTABLEMERGED=MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"],FALLENLOOTTABLE["tier3"])

local SANITY_DAY_LOSS=-100.0/(300*10)
local PROTOTYPE_XP=50
local SKELETONSPAWNDELAY=480

TUNING.ARMORGRASS = 220
TUNING.ARMORGRASS_ABSORPTION = .2
TUNING.ARMORWOOD = 450
TUNING.ARMORWOOD_ABSORPTION = .4
TUNING.ARMORMARBLE = 1050
TUNING.ARMORMARBLE_ABSORPTION = .60
TUNING.ARMORSNURTLESHELL_ABSORPTION = 0.8
TUNING.ARMORSNURTLESHELL = 1050
TUNING.ARMORMARBLE_SLOW = 0.7
TUNING.ARMORRUINS_ABSORPTION = 0.9
TUNING.ARMORRUINS = 1800
TUNING.ARMORSLURPER_ABSORPTION = 0.6
TUNING.ARMORSLURPER_SLOW_HUNGER = 0.6
TUNING.ARMORSLURPER = 300
TUNING.ARMOR_SANITY = 750
TUNING.ARMOR_SANITY_ABSORPTION = .8
TUNING.ARMOR_SANITY_DMG_AS_SANITY = 0.10

-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "cleric")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "druid")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "darkknight")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "monk")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "necromancer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wizard")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "tinkerer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "paladin")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "ranger")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "bard")

local PetBuff = require "widgets/petbuff"

local RELOAD = Action(1, true)
RELOAD.id = "RELOAD"
RELOAD.str = "Reload"
RELOAD.fn = function(act)
    if act.target and act.target.components.reloadable and act.invobject and act.invobject.components.reloading then
        return act.target.components.reloadable:Reload(act.doer, act.invobject)
    end

end
 
AddAction(RELOAD)
GLOBAL.ACTIONS.RELOAD = RELOAD


local function newControlsInit(class)
    local under_root=class;
    if GetPlayer() and GetPlayer().newControlsInit then
        local xabilitybar = under_root:AddChild(Widget("abilitybar"))
        xabilitybar:SetPosition(0,-65,0)
        xabilitybar:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
        xabilitybar:SetMaxPropUpscale(1.25)
        xabilitybar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xabilitybar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        GetPlayer().newControlsInit(xabilitybar)
    end
    if GetPlayer() and GetPlayer().newStatusDisplaysInit then
        GetPlayer().newStatusDisplaysInit(class)
    end
    if GetPlayer() and GetPlayer().components and GetPlayer().components.xplevel then
--       GetPlayer():ListenForEvent("healthdelta", onhpchange)
        local xpbar = under_root:AddChild(XPBadge(class.owner))
        xpbar:SetPosition(0,-20,0)
        xpbar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xpbar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        xpbar:SetLevel(GetPlayer().components.xplevel.level)
        xpbar:SetValue(GetPlayer().components.xplevel.currentxp,GetPlayer().components.xplevel.max)
        xpbar:SetPlayername(GetPlayer().fa_playername or GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab])
        GetPlayer():ListenForEvent("fa_playernamechanged", function(inst,data)
            xpbar:SetPlayername(data.playername)
        end,class.owner)
        GetPlayer():ListenForEvent("xpleveldelta", function(inst,data)
            xpbar:SetLevel(data.level)
            xpbar:SetValue(data.new,data.max)
        end,class.owner)

        GetPlayer():ListenForEvent("xplevelup", function(inst,data)
            inst.SoundEmitter:PlaySound("fa/levelup/levelup")
        end,class.owner)

        GetPlayer():ListenForEvent("killed", function(inst,data)
            local victim=data.victim
            local xp=GLOBAL.FA_MOBXP_TABLE[victim.prefab]
--            print("xp for",victim, xp)
            if(xp)then
                local default=xp.default
                if(xp.tagged)then
                    for k,v in pairs(xp.tagged) do
                        if(victim:HasTag(k))then
                            default=v
                            break
                        end
                    end

                end
                inst.components.xplevel:DoDelta(default)
            end
        end)
         GetPlayer():ListenForEvent("unlockrecipe", function(inst,data)
            inst.components.xplevel:DoDelta(PROTOTYPE_XP)
        end,class.owner)



        if(GetPlayer().fa_playername==nil or GetPlayer().fa_playername=="")then
        GetPlayer():DoTaskInTime(0,function()
            GLOBAL.TheFrontEnd:PushScreen(FA_CharRenameScreen(GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab]))
        end)
        end
    end
end

--AddClassPostConstruct("screens/playerhud",newControlsInit)
AddClassPostConstruct("widgets/statusdisplays", newControlsInit)

local newFlowerPicked=function(inst,picker)

    if(picker and picker.components.sanity)then
        local delta=TUNING.SANITY_TINY
        local prefab=inst.prefab
        if(picker:HasTag("evil"))then
            if(prefab=="flower")then
                delta=-TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=TUNING.SANITY_TINY
            end
        else
            if(prefab=="flower")then
                delta=TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=TUNING.SANITY_TINY
            end
        end
        picker.components.sanity:DoDelta(delta)
    end
    inst:Remove()
end

AddPrefabPostInit("flower", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
AddPrefabPostInit("flower_evil", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)

AddPrefabPostInit("gunpowder", function(inst) 
    inst:AddComponent("reloading") 
    inst.components.reloading.ammotype="gunpowder"
    inst.components.reloading.returnuses=1
end)


local doSkeletonSpawn=function(inst)
    local skel=SpawnPrefab("skeletonspawn")
    skel:AddComponent("homeseeker")
    skel.components.homeseeker:SetHome(inst)
    skel.Transform:SetPosition(inst.Transform:GetWorldPosition())
    return skel
end

local startSkeletonSpawnTask=function(inst)
     local rng=math.random()*480*5
         inst:DoTaskInTime(rng, function() 
            inst:AddTag("hasSpawnedSkeleton")
            local skel=doSkeletonSpawn(inst)
            skel:ListenForEvent("death",function(skel) 
                inst:RemoveTag("hasSpawnedSkeleton") 
                startSkeletonSpawnTask(inst)
            end)
        end)
end

local spoiledSkeletonSpawn=function(inst)
    if(math.random()>0.5)then
        doSkeletonSpawn(inst)
    end
end

AddPrefabPostInit("meat",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("cookedmeat",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("meat_dried",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("monstermeat",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("cookedmonstermeat",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("monstermeat_dried",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)
AddPrefabPostInit("hambat",function(inst)
    inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
end)

AddPrefabPostInit("merm",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("orc",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("pigman",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("pigguard",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("bunnyman",function(inst) inst:AddTag("pickpocketable") end)
AddPrefabPostInit("goblin",function(inst) inst:AddTag("pickpocketable") end)

AddPrefabPostInit("mound",function(inst)
inst:AddComponent( "spawner" )
inst.components.spawner.spawnoffscreen=false
inst.components.spawner.childname="skeletonspawn"
inst.components.spawner.delay=SKELETONSPAWNDELAY
--i dont know if it's dug or not until after load... configure is starting the process... so i have to type same thing 3 times
inst:DoTaskInTime(0,function()

    if(inst.components.spawner and inst.components.spawner.nextspawntime)then
        print("spawner active: ",inst.components.spawner.nextspawntime)
--        return
    end

    if(inst.components.workable )then
            local onfinishcallback=inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(function(inst,worker)
                onfinishcallback(inst,worker)
                inst.components.spawner:Configure( "skeletonspawn",SKELETONSPAWNDELAY,SKELETONSPAWNDELAY*math.random())
            end)      
        else
            local nexttime=inst.components.spawner.nextspawntime or SKELETONSPAWNDELAY*math.random()
            inst.components.spawner:Configure( "skeletonspawn",SKELETONSPAWNDELAY,nexttime)
        end
end)

end)


AddComponentPostInit("dapperness", function(component,inst) 
    function component:GetDapperness(owner)
         local d=self.dapperness or 0
        if self.dapperfn then
            d=self.dapperfn(self.inst,owner)
        end
        if(owner and owner:HasTag("player") and owner.prefab=="cleric" and d<0)then
          --  print("got in dapperness nerf")
            d=d*2
        end
        return d
    end
end)

--AddClassPostConstruct("dapperness",function(class) )


AddSimPostInit(function(inst)
        if inst:HasTag("player") and inst:HasTag("evil") then

                local sanitymod=inst.components.sanity
                function sanitymod:Recalc(dt)
                
                    local total_dapperness = self.dapperness or 0
                    local mitigates_rain = false
                    for k,v in pairs (self.inst.components.inventory.equipslots) do
                        if v.components.dapperness and v.prefab~="nightsword" and v.prefab~="armor_sanity" then
                            total_dapperness = total_dapperness + v.components.dapperness:GetDapperness(self.inst)
                            if v.components.dapperness.mitigates_rain then
                              mitigates_rain = true
                            end
                        end     
                    end
    
                    local dapper_delta = total_dapperness*TUNING.SANITY_DAPPERNESS
    
                    local day = GetClock():IsDay() and not GetWorld():IsCave()
                    local light_delta=0
                    if day then 
                        light_delta = SANITY_DAY_LOSS
                    end
    
                    local aura_delta = 0
                    local x,y,z = self.inst.Transform:GetWorldPosition()
                    local ents = TheSim:FindEntities(x,y,z, TUNING.SANITY_EFFECT_RANGE, nil, {"FX", "NOCLICK", "DECOR","INLIMBO"} )
                    for k,v in pairs(ents) do 

                        local override=EVIL_SANITY_AURA_OVERRIDE[v.prefab]
                        local aura_val=0
                        if(override~=nil)then
                            aura_val=override
                        elseif v.components.sanityaura and v ~= self.inst then
                            aura_val = v.components.sanityaura:GetAura(self.inst)
                        end
                        if(aura_val~=0)then
                            local distsq = self.inst:GetDistanceSqToInst(v)
                            aura_val = aura_val/math.max(1, distsq)
                            if aura_val < 0 then
                                aura_val = aura_val * self.neg_aura_mult
                            end
                            aura_delta = aura_delta + aura_val
                        end
                    end


                    local rain_delta = 0
                    if GetSeasonManager() and GetSeasonManager():IsRaining() and not mitigates_rain then
                        rain_delta = -TUNING.DAPPERNESS_MED*1.5* GetSeasonManager():GetPrecipitationRate()
                    end

                    self.rate = (dapper_delta + light_delta + aura_delta + rain_delta)  
--    print(self.rate,"light",light_delta)
    
                    if self.custom_rate_fn then
                        self.rate = self.rate + self.custom_rate_fn(self.inst)
                    end

                    self:DoDelta(self.rate*dt, true)
                end


        end
        if inst:HasTag("player") and (inst.prefab=="darkknight" or inst.prefab=="cleric" or inst.prefab=="paladin") then
            --add shields
            local r=Recipe("woodenshield", {Ingredient("log", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="woodshield.tex"
            r.atlas = "images/inventoryimages/woodshield.xml"
            local r=Recipe("rockshield", {Ingredient("rocks", 20),Ingredient("rope", 5)}, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)    
            r.image="rockshield.tex"
            r.atlas = "images/inventoryimages/rockshield.xml"
            local r=Recipe("marbleshield", {Ingredient("marble", 20),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_TWO)
            r.image="marbleshield.tex"
            r.atlas = "images/inventoryimages/marbleshield.xml"
            local r=Recipe("boneshield", {Ingredient("houndstooth", 10),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="boneshield.tex"
            r.atlas = "images/inventoryimages/boneshield.xml"
        end
end)
--\
function lootdropperPostInit(component)
    local old_generateloot=component.GenerateLoot
    function component:AddFallenLootTable(lt,weight,chance)
        self.fallenLootTable=lt
        self.fallenLootTableTotalWeight=weight
        self.fallenLootTableChance=chance
    end
    function component:GenerateLoot()
        local loots=old_generateloot(self)
        local chance=math.random()
        if(self.fallenLootTable and chance<=self.fallenLootTableChance)then
            local newloot=nil
            --pick one of...
            local rnd = math.random()*self.fallenLootTableTotalWeight
            print("rnd",rnd)
            for k,v in pairs(self.fallenLootTable) do
                rnd = rnd - v
                if rnd <= 0 then
                    newloot=k
                    break
                end
            end
            table.insert(loots, newloot)
        end
        return loots
    end
end


AddComponentPostInit("lootdropper",lootdropperPostInit)

function makestackablePrefabPostInit(inst)
    if(not inst.components.stackable)then
    inst:AddComponent("stackable")
        inst.components.stackable.maxsize = 99
    end
end

AddPrefabPostInit("rabbit", makestackablePrefabPostInit)

function addT1LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.tier1,FALLENLOOTTABLE.TABLE_TIER1_WEIGHT,chance)
end


function addT1T2LootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"]),FALLENLOOTTABLE.TABLE_TIER1_WEIGHT+FALLENLOOTTABLE.TABLE_TIER2_WEIGHT,chance)
end

function addFullLootPrefabPostInit(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,chance)
end

AddPrefabPostInit("rabbithole", function(inst) addT1LootPrefabPostInit(inst,0.05) end)

AddPrefabPostInit("merm", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("pigman", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("pigguard", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("bunnyman", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("orc", function(inst) addFullLootPrefabPostInit(inst,0.1) end)
AddPrefabPostInit("goblin", function(inst) addFullLootPrefabPostInit(inst,0.1) end)

AddPrefabPostInit("mermhouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("pighouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("rabbithouse", function(inst) addFullLootPrefabPostInit(inst,0.2) end)
AddPrefabPostInit("goblinhut", function(inst) addFullLootPrefabPostInit(inst,0.2) end)

AddPrefabPostInit("spiderden", function(inst) addT1LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden", function(inst) addT1LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("spiderden_2", function(inst) addT1T2LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden_2", function(inst) addT1T2LootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("spiderden_3", function(inst) addFullLootPrefabPostInit(inst,0.15) end)
AddPrefabPostInit("poisonspiderden_3", function(inst) addFullLootPrefabPostInit(inst,0.15) end)

--[[
AddClassPostConstruct("screens/characterselectscreen", function(screen)
    screen.charactername = screen.fixed_root:AddChild(TextEdit( GLOBAL.TITLEFONT, 60, "" ))
    screen.charactername:SetHAlign(GLOBAL.ANCHOR_MIDDLE)
    screen.charactername:SetPosition(820 , GLOBAL.RESOLUTION_Y - 400+30,0)
    screen.charactername:SetRegionSize( 500, 70 )
    local callback=screen.cb
    screen.cb=function(char)
        if(callback)then
            local chardata={character=character,customname=screen.charactername:GetString()}
            callback(chardata)
        end
    end
end)]]

AddModCharacter("barb")
AddModCharacter("druid")

AddModCharacter("thief")
AddModCharacter("cleric")
AddModCharacter("darkknight")
AddModCharacter("monk")
AddModCharacter("necromancer")
AddModCharacter("wizard")
AddModCharacter("tinkerer")
AddModCharacter("paladin")
AddModCharacter("ranger")]]
