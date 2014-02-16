local require = GLOBAL.require
require "class"
require "widgets/text"
--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local Action = GLOBAL.Action
local GetPlayer = GLOBAL.GetPlayer


local StatusDisplays = require "widgets/statusdisplays"

--local xx=require "prefabs/spells"

PrefabFiles = {

    "spellbooks",
	"thief",
	"barb",
	"cleric",
    "fairy",
	"druid",
	"darkknight",
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
    Asset( "IMAGE", "bigportraits/darkknight.tex" ),
    Asset( "ATLAS", "bigportraits/darkknight.xml" ),

    Asset("ANIM", "anim/fairy.zip"),

}


-- strings! Any "WOD" below would have to be replaced by the prefab name of your character.

-- The character select screen lines
-- note: these are lower-case character name
GLOBAL.STRINGS.CHARACTER_TITLES.thief = "The Sneaky"
GLOBAL.STRINGS.CHARACTER_NAMES.thief = "Pete"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.thief = "* Stabby"
GLOBAL.STRINGS.CHARACTER_QUOTES.thief = "\"Never saw me coming.\""

GLOBAL.STRINGS.CHARACTER_TITLES.barb = "The Barangrian"
GLOBAL.STRINGS.CHARACTER_NAMES.barb = "Lars"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.barb = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.barb = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.cleric = "The Cleric"
GLOBAL.STRINGS.CHARACTER_NAMES.cleric = "cleric"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.cleric = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.cleric = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.druid = "The Druid"
GLOBAL.STRINGS.CHARACTER_NAMES.druid = "druid"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.druid = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.druid = "\"I am a blank slate.\""

GLOBAL.STRINGS.CHARACTER_TITLES.darkknight = "The Shadow"
GLOBAL.STRINGS.CHARACTER_NAMES.darkknight = "darkknight"
GLOBAL.STRINGS.CHARACTER_DESCRIPTIONS.darkknight = "* An example of how to create a mod character."
GLOBAL.STRINGS.CHARACTER_QUOTES.darkknight = "\"I am a blank slate.\""

-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
GLOBAL.STRINGS.CHARACTERS.THIEF = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE.EVERGREEN = "A template description of a tree."

-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "cleric")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "druid")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "darkknight")

local function StatusDisplaysInit(class)
    if GetPlayer() and GetPlayer().StatusDisplaysInit then
        GetPlayer().StatusDisplaysInit(class)
    end
end

AddClassPostConstruct("widgets/statusdisplays", StatusDisplaysInit)



function LinkPostInit(inst)

end

AddSimPostInit(function(inst)
        if inst.prefab == "druid" then
--                LinkPostInit(inst)
        end
end)
--
AddModCharacter("thief")
AddModCharacter("barb")
AddModCharacter("cleric")
AddModCharacter("druid")
AddModCharacter("darkknight")

