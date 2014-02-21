local require = GLOBAL.require
require "class"

local Widget = require "widgets/widget"
require "widgets/text"
require "stategraph"
require "constants"
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


local StatusDisplays = require "widgets/statusdisplays"
local ImageButton = require "widgets/imagebutton"

--local xx=require "prefabs/spells"

PrefabFiles = {

    "spellbooks",
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
    "thieftraps"
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
-- You can also add any kind of custom dialogue that you would like. Don't forget to make
-- categores that don't exist yet using = {}
-- note: these are UPPER-CASE charcacter name
GLOBAL.STRINGS.CHARACTERS.THIEF = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE = {}
GLOBAL.STRINGS.CHARACTERS.THIEF.DESCRIBE.EVERGREEN = "A template description of a tree."

STRINGS.NAMES.ARROW = "Arrow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW="Arrow"
STRINGS.NAMES.BOW = "Bow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARROW="Bow"
STRINGS.NAMES.FIRETRAP = "FIRETRAP"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIRETRAP="FIRETRAP"
STRINGS.NAMES.SPIKETRAP = "SPIKETRAP"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPIKETRAP="SPIKETRAP"
STRINGS.NAMES.ICETRAP = "ICETRAP"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ICETRAP="ICETRAP"
STRINGS.NAMES.TENTACLETRAP = "TENTACLETRAP"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TENTACLETRAP="TENTACLETRAP"
STRINGS.NAMES.TELEPORTTRAP = "TELEPORTTRAP"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TELEPORTTRAP="TELEPORTTRAP"


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
local SANITY_DAY_LOSS=-100.0/(300*10)

-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "cleric")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "druid")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "darkknight")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "monk")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "necromancer")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "wizard")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "tinkerer")

local PetBuff = require "widgets/petbuff"
local function newControlsInit(class)

    if GetPlayer() and GetPlayer().newControlsInit then
        local xabilitybar = class.top_root:AddChild(Widget("abilitybar"))
        xabilitybar:SetScale(1,1,1)
        xabilitybar:SetPosition(0,-30,0)
        GetPlayer().newControlsInit(xabilitybar)
    end
end

AddClassPostConstruct("widgets/controls", newControlsInit)

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

AddSimPostInit(function(inst)
        if inst:HasTag("player") and inst:HasTag("evil") then

                local sanitymod=inst.components.sanity
                function sanitymod:Recalc(dt)
                
                    local total_dapperness = self.dapperness or 0
                    local mitigates_rain = false
                    for k,v in pairs (self.inst.components.inventory.equipslots) do
                        if v.components.dapperness then
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
end)
--\

AddModCharacter("thief")
AddModCharacter("barb")
AddModCharacter("cleric")
AddModCharacter("druid")
AddModCharacter("darkknight")
AddModCharacter("monk")
AddModCharacter("necromancer")
AddModCharacter("wizard")
AddModCharacter("tinkerer")

