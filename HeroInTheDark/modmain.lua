local debug=GLOBAL.debug
local require = GLOBAL.require
require "class"
require "util"
require "stategraph"
local MergeMaps=GLOBAL.MergeMaps

GLOBAL.FA_DLCACCESS=false
GLOBAL.xpcall(function()
                    GLOBAL.FA_DLCACCESS= GLOBAL.IsDLCEnabled and GLOBAL.REIGN_OF_GIANTS and GLOBAL.IsDLCEnabled(GLOBAL.REIGN_OF_GIANTS)
                end,
                function()
                    --if the calls crashed im assuming outdated code and dlc is off by default
                    print("dlc crash")
                end
            )

GLOBAL.FA_ModCompat={}
GLOBAL.FA_ModCompat.memspikefix_delay=1
--push out the env functions without namespace pollution
GLOBAL.FA_ModUtil={}
FA_ModUtil=GLOBAL.FA_ModUtil
FA_ModUtil.AddClassPostConstruct=AddClassPostConstruct
FA_ModUtil.AddPrefabPostInit=AddPrefabPostInit
FA_ModUtil.AddComponentPostInit=AddComponentPostInit
FA_ModUtil.GetModConfigData=GetModConfigData
FA_ModUtil.AddAction=AddAction
FA_ModUtil.AddStategraphActionHandler=AddStategraphActionHandler

for _, mod in ipairs( GLOBAL.ModManager.mods ) do
        if mod.modinfo.id == "RPG HUD" or mod.modinfo.name == "RPG HUD"   then
            GLOBAL.FA_ModCompat.rpghudmod=mod
--            print("hud version",mod,mod.modinfo.id,mod.modinfo.name, mod.modinfo.description)
        elseif  mod.modinfo.id == "memspikefix" or mod.modinfo.name == "memspikefix"  then
            GLOBAL.FA_ModCompat.memspikefixed=true
        elseif mod.modinfo.id=="Always On Status" or mod.modinfo.name=="Always On Status" then
            GLOBAL.FA_ModCompat.alwaysonmod=mod
        elseif  mod.modinfo.id=="upandaway" or mod.modinfo.name=="upandaway"  then
            GLOBAL.FA_ModCompat.UnA=mod
        end
    end
if(not GLOBAL.FA_ModCompat.memspikefixed and GetModConfigData("memspikefix"))then
    print("patching memory abuse")
    modimport "memspikefix.lua"
    GLOBAL.FA_ModCompat.memspikefixed=true
else
    print("bypassing memspikefix")
end

modimport "damage_entity.lua"
FA_ModUtil.MakeDamageEntity=MakeDamageEntity

local Widget = require "widgets/widget"
local XPBadge= require "widgets/xpbadge"
local TextEdit=require "widgets/textedit"
local ItemTile = require "widgets/itemtile"
local Image = require "widgets/image"
local FA_WarClock = require "widgets/fa_warclock"
local FA_BuffBar=require "widgets/fa_buffbar"
local FA_StatusBar=require "widgets/fa_statusbar"

local FA_CharRenameScreen=require "screens/fa_charrenamescreen"
local FA_SpellBookScreen=require "screens/fa_spellbookscreen"
local StatusDisplays = require "widgets/statusdisplays"
local FA_IntoxicationBadge=require "widgets/fa_intoxicationbadge"
local ImageButton = require "widgets/imagebutton"
local Levels=require("map/levels")

require "constants"
require "fa_constants"
require "widgets/text"
require "buffutil"
require "fa_mobxptable"
require "fa_strings"
require "fa_levelxptable"
require "fa_stealthdetectiontable"
require "fa_actions"
require "overrides/fa_inventory_override"
require "overrides/fa_inventorybar_override"
require "overrides/fa_combat_override"
require "overrides/fa_hounded_override"
require "overrides/fa_behavior_override"
require "overrides/fa_sanity_override"
require "fa_electricalfence"
require "fa_recipes"
require "postinits/fa_componentpostinits"

--modimport "spelleffects.lua"

--
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local STRINGS = GLOBAL.STRINGS
local ACTIONS = GLOBAL.ACTIONS
local GROUND=GLOBAL.GROUND
local Action = GLOBAL.Action
local ActionHandler=GLOBAL.ActionHandler
local GetPlayer = GLOBAL.GetPlayer
local GetClock=GLOBAL.GetClock
local GetWorld=GLOBAL.GetWorld
local GetSeasonManager=GLOBAL.GetSeasonManager
local SpawnPrefab=GLOBAL.SpawnPrefab
local TheFrontEnd=GLOBAL.TheFrontEnd

local FA_DAMAGETYPE=GLOBAL.FA_DAMAGETYPE


--it should be fixed now
--require "repairabledescriptionfix"

PrefabFiles = {
    "fa_bbq",
    "fa_fx",
    "fa_bars",
    "fa_decor",
    "fa_barrels",
    "fa_bucket",
    "fa_racks",
    "fa_lever",
    "fa_shrooms",
    "fa_dorfkingstatue",
    "fa_crafting",
    "fa_fireboulder",
    "fa_bags",
    "fa_pebbles",
    "fa_rocks",
    "fa_lavarain",
    "fa_sand",
    "fa_fissures",
    "fa_forcefields",
    "fa_fissurefx",
    "fa_fireflies",
    "fa_teleporter",
    "fa_hats",
    "fa_baseweapons",
    "fa_basearmor",
    "fa_wortox",
    "fa_stickheads",
    "fa_dungeon_walls",
    "goblinsignpost",
    "fa_lavamound",
    "fa_firehoundmound",
    "fa_animatedarmor",
    "fa_bonfire",
    "fa_dungeon_entrance",
    "fa_dungeon_exit",
    "fa_surface_portal",
    "fa_scribescrolls",
    "fa_summons",
    "fa_spell_prefabs",
    "fa_skins",
    "cheats",
    "fa_weaponupgrades",
    "poisonspider",
    "poisonspider_gland",
    "poisonspiderden",
    "poisonspiderqueen",
    "poisonspidereggsack",
    "spellprojectiles",
    "natureshealing",
    "fa_lights",
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
    "fa_menders",
    "fa_arrows",
    "fa_bow",
    "fa_keys",
    "fa_chests",
    "fa_recipebook",
    "fa_boots",
    "fa_rings",
    "fa_fireaxe",
    "fa_iceaxe",
    "fa_food",
    "fa_potions",
    "spellbooks",
    "shields",
    "armor_fire",
    "armor_frost",
    "fa_totems",
    "dagger",
    "fa_lightningsword",
    "flamingsword",
    "frostsword",
    "undeadbanesword",
    "vorpalaxe",
    "wands",
    "fa_dryad",
    "fa_dryadtree",
    "satyr",
    "unicorn",
    "fa_dorfs",
    "fa_elves",
    "fa_dorfhut",
    "fa_orchut",
    "fa_orc",
    "fa_ogre",
    "fa_troll",
    "goblin",
    "wolf",
    "goblinhut",
    "wolfmound",
	"thief",
	"barb",
	"cleric",
    "fa_druidpet",
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
    Asset( "IMAGE", "bigportraits/darkknight.tex" ),
    Asset( "ATLAS", "bigportraits/darkknight.xml" ),
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

    Asset("ATLAS", "images/inventoryimages/fa_inventoryimages.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_inventoryimages.tex"),

    Asset( "IMAGE", "minimap/fa_minimap.tex" ),
    Asset( "ATLAS", "minimap/fa_minimap.xml" ),  
    Asset( "ANIM", "anim/fa_shieldpuff.zip" ),

    Asset( "ANIM", "anim/generating_goblin_cave.zip" ),
    Asset( "ANIM", "anim/generating_mine_cave.zip" ),
    Asset( "IMAGE", "images/lava3.tex" ),
    Asset( "IMAGE", "images/lava2.tex" ),
    Asset( "IMAGE", "images/lava1.tex" ),
    Asset( "IMAGE", "images/lava.tex" ),

    Asset( "IMAGE", "images/fa_title.tex" ),
    Asset( "ATLAS", "images/fa_title.xml" ), 

    Asset( "IMAGE", "colour_cubes/lavacube.tex" ),
    Asset( "IMAGE", "colour_cubes/identity_colourcube.tex" ),
    Asset( "IMAGE", "colour_cubes/darkvision_cc.tex" ),


    Asset( "IMAGE", "images/equipslots.tex" ),
    Asset( "ATLAS", "images/equipslots.xml" ),  
    Asset( "IMAGE", "images/fa_equipbar_bg.tex" ),
    Asset( "ATLAS", "images/fa_equipbar_bg.xml" ),  


    Asset( "ANIM", "anim/fa_intoxicationbadge.zip" ),
    Asset( "ANIM", "anim/fa_player_anims.zip" ),
    Asset( "ANIM", "anim/player_cage_drop.zip" ),
    Asset( "ANIM", "anim/fa_cagechains.zip" ),
    Asset( "ANIM", "anim/fa_orcfort_cage.zip" ),
    Asset( "ANIM", "anim/fa_mug.zip" ),
--    Asset( "ANIM", "anim/icebomb.zip" ),
--    Asset( "ANIM", "anim/player_test.zip" ),
}

--[[
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("spriter_idle", true)
]]

if(not GLOBAL.FA_DLCACCESS)then
--not gonna rewrite 100 things for one prefab
    table.insert(PrefabFiles,"fa_boneshard_compat")

--[[
--is the table set before mods are loaded or on the first spawn?
GLOBAL.SetSharedLootTable( 'hound_mound',
{
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'houndstooth', 1.00},
    {'boneshard',   1.00},
    {'boneshard',   1.00},
    {'redgem',      0.01},
    {'bluegem',     0.01},
})]]
end

AddMinimapAtlas("minimap/fa_minimap.xml")
--is there really a reason to duplicate this? is there a case or a reason why would minimap be different from inv?
AddMinimapAtlas("images/inventoryimages/fa_inventoryimages.xml")
--AddMinimapAtlas("images/inventoryimages/fa_hats.xml")
--AddMinimapAtlas("images/inventoryimages/fa_basearmors.xml")
--AddMinimapAtlas("images/inventoryimages/fa_baseweapons.xml")
--AddMinimapAtlas("images/inventoryimages/fa_puppet.xml")

RemapSoundEvent( "dontstarve/characters/bard/death_voice", "dontstarve/characters/wilson/death_voice" )
RemapSoundEvent( "dontstarve/characters/bard/hurt", "fa/characters/bard/hurt" )
RemapSoundEvent( "dontstarve/characters/bard/talk_LP", "fa/characters/bard/talk_LP" )
RemapSoundEvent( "dontstarve/characters/barb/death_voice", "dontstarve/characters/wilson/death_voice")
RemapSoundEvent( "dontstarve/characters/barb/hurt", "fa/characters/barb/hurt" )
RemapSoundEvent( "dontstarve/characters/barb/talk_LP", "fa/characters/barb/talk_LP" )
RemapSoundEvent( "dontstarve/characters/paladin/death_voice", "fa/characters/paladin/death_voice")
RemapSoundEvent( "dontstarve/characters/paladin/hurt", "fa/characters/paladin/hurt" )
RemapSoundEvent( "dontstarve/characters/paladin/talk_LP", "fa/characters/paladin/talk_LP" )
RemapSoundEvent( "dontstarve/characters/wizard/death_voice", "fa/characters/wizard/death_voice")
RemapSoundEvent( "dontstarve/characters/wizard/hurt", "fa/characters/wizard/hurt" )
RemapSoundEvent( "dontstarve/characters/wizard/talk_LP", "fa/characters/wizard/talk_LP" )
RemapSoundEvent( "dontstarve/characters/dwarf/talk_LP", "fa/mobs/dwarf/talk_LP" )


local FALLENLOOTTABLE=GLOBAL.FALLENLOOTTABLE
local FALLENLOOTTABLEMERGED=GLOBAL.FALLENLOOTTABLEMERGED

           

--[[
    local SGWilson=require "stategraphs/SGwilson"
    SGWilson.states["idle"]= GLOBAL.State{
        name = "idle",
        tags = {"idle", "canrotate"},
        onenter = function(inst, pushanim)
            
            inst.components.locomotor:Stop()

            inst.AnimState:PlayAnimation("fa_cagedrop", true)

        end,        
    }
]]

-- Let the game know Wod is a male, for proper pronouns during the end-game sequence.
-- Possible genders here are MALE, FEMALE, or ROBOT
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "thief")
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "barb")
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "cleric")
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

if(GLOBAL.inventorybarpostconstruct)then
    AddClassPostConstruct("widgets/inventorybar",GLOBAL.inventorybarpostconstruct)
end

if(not GLOBAL.FA_ModCompat.rpghudmod)then

--need to re-initialize the slots and stuff the same way so it doesn't burn on hud active...
--TODO theres gotta be a better way 
local function amuletpostinit(inst)
    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.NECK
end

AddPrefabPostInit("amulet", amuletpostinit)
AddPrefabPostInit("blueamulet", amuletpostinit)
AddPrefabPostInit("purpleamulet", amuletpostinit)
AddPrefabPostInit("orangeamulet", amuletpostinit)
AddPrefabPostInit("greenamulet", amuletpostinit)
AddPrefabPostInit("yellowamulet", amuletpostinit)

local function changetopack(inst)
    inst.components.equippable.equipslot = GLOBAL.EQUIPSLOTS.PACK
end

AddPrefabPostInit("krampus_sack", changetopack)
AddPrefabPostInit("piggyback", changetopack)
AddPrefabPostInit("backpack", changetopack)
AddPrefabPostInit("icepack", changetopack)

local function resurrectableinit(inst)

    local old_findclosestres=inst.FindClosestResurrector
    function inst:FindClosestResurrector ()
        local res = nil
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return item
            end
        end

        return old_findclosestres(self)
    end

    local old_canresurrect=inst.CanResurrect
    function inst:CanResurrect()
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                return true
            end
        end

        return old_canresurrect(self)
    end

    local old_DoResurrect=inst.DoResurrect
    function inst:DoResurrect()
        self.inst:PushEvent("resurrect")
        if self.inst.components.inventory then
            local item = self.inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
            if item and item.prefab == "amulet" then
                self.inst.sg:GoToState("amulet_rebirth")
                return true
            end
        end
        
        return old_DoResurrect(self)     
    end

end

AddComponentPostInit("resurrectable", resurrectableinit)


local function newOnExit(inst)

    inst.components.hunger:SetPercent(2/3)
    inst.components.health:Respawn(TUNING.RESURRECT_HEALTH)
    
    if inst.components.sanity then
        inst.components.sanity:SetPercent(.5)
    end
    
    local item = inst.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.NECK)
    if item and item.prefab == "amulet" then
        item = inst.components.inventory:RemoveItem(item)
        if item then
            item:Remove()
            item.persists = false
        end
    end
    --SaveGameIndex:SaveCurrent()
    inst.HUD:Show()
    GLOBAL.TheCamera:SetDefault()
    inst.components.playercontroller:Enable(true)
    inst.AnimState:ClearOverrideSymbol("FX")

end

local function SGWilsonPostInit(sg)
    sg.states["amulet_rebirth"].onexit = newOnExit
end
AddStategraphPostInit("wilson", SGWilsonPostInit)

if(GetModConfigData("doubleinventoryspace")==true)then
    AddComponentPostInit("inventory", function(cmp,inst)

    end)
end

else


local function hud_inventorypostinit_fix(cmp,inst)
    --assuming postinits happen in order, i should be able to
    --it would be cleaner to just provide versions...
    if(inst.components.inventory.maxslots==55)then
        inst.components.inventory.maxslots=60
--    elseif(inst.components.inventory.maxslots==45)then
--       inst.components.inventory.maxslots=50
--    elseif(inst.components.inventory.maxslots==25 and string.find(GLOBAL.FA_ModCompat.rpghudmod.modinfo.description,"Custom UI"))then
--        inst.components.inventory.maxslots=30
    end
end
--AddComponentPostInit("inventory", hud_inventorypostinit_fix)

if(string.find(GLOBAL.FA_ModCompat.rpghudmod.modinfo.description,"Custom UI"))then
    local function StatusPostInit(self,owner)
    self.heart:SetPosition(0,50,0)
    self.heart.br:SetTint(162/255, 43/255, 37/255, 1)
    self.heart.topperanim:Hide()
    if self.heart.sanityarrow then
        self.heart.sanityarrow:SetPosition(-60,56,0)
        self.heart.sanityarrow:SetScale(.8,.8,0)
    end
    
    self.brain:SetPosition(220,50,0)
    self.brain:SetScale(.75,.75,0)
    self.brain.br:SetTint(202/255, 120/255, 34/255, 1)
    self.brain.topperanim:Hide()

    self.stomach:SetPosition(-220,50,0)
    self.stomach:SetScale(.75,.75,0)
    self.stomach.br:SetTint(85/255, 119/255, 65/255, 1)
    
    end

    AddClassPostConstruct("widgets/statusdisplays", StatusPostInit)
end

end


 local function OpenBackpack(self) 
    
    local oldSetMainCharacter = self.SetMainCharacter

    function self:SetMainCharacter(maincharacter)
        
        oldSetMainCharacter(self, maincharacter)
        
        local bp = maincharacter.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.PACK)
        
        if bp and bp.components.container then
            bp.components.container:Close()
            bp.components.container:Open(maincharacter)
        end

--nothing but equipment is registered at this point... it seems it just gives items again, 
--system does not track if a container was open
    end
    
end

AddClassPostConstruct("screens/playerhud", OpenBackpack)
--SaveGameIndex:GetCurrentCaveLevel()
--table.insert(SGWilson.actionhandlers,ActionHandler(ACTIONS.FA_CRAFTPICKUP, "dolongaction"))

local function newControlsInit(class)
    local under_root=class;
    local inst=GetPlayer()
-- TODO anything that messes up with default badges will likely break the positioning
-- IDC to write another set of x-mod-compat crap, if it bothers you fix it yourself

    class.brain:SetPosition(40,-50,0)
    class.fa_intoxication = class:AddChild(FA_IntoxicationBadge(class.owner))
    class.fa_intoxication:SetPosition(-40,-50,0)
    class.fa_intoxication:SetPercent(class.owner.components.fa_intoxication:GetPercent(), class.owner.components.fa_intoxication.max, 0)

    class.inst:ListenForEvent("fa_intoxicationdelta", function(inst, data)  
       class.fa_intoxication:SetPercent(data.newpercent, data.max)
    
    if not data.overtime then
        if data.newpercent > data.oldpercent then
            class.fa_intoxication:PulseGreen()
--            TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_up")
        elseif data.newpercent < data.oldpercent then
            class.fa_intoxication:PulseRed()
 --           TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/sanity_down")
        end
    end

    end, class.owner)

    if GetPlayer() and GetPlayer().components and GetPlayer().components.xplevel then
--       GetPlayer():ListenForEvent("healthdelta", onhpchange)
        local xpbar = under_root:AddChild(XPBadge(class.owner))
        xpbar:SetPosition(0,-28,0)
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
            --it could be just when necesary but I doubt this will incurr any serious performance issue to bother
            GetPlayer().HUD.controls.crafttabs:UpdateRecipes()
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
            inst.components.xplevel:DoDelta(GLOBAL.PROTOTYPE_XP)
        end,class.owner)

        if(GetPlayer().fa_playername==nil or GetPlayer().fa_playername=="")then
        GetPlayer():DoTaskInTime(0,function()
            GLOBAL.TheFrontEnd:PushScreen(FA_CharRenameScreen(GLOBAL.STRINGS.CHARACTER_TITLES[GetPlayer().prefab]))
            
        end)
        end
    end

--this so i can cut on copy pasting, the details can be reconfigured on per-char basis
    local xabilitybar = under_root:AddChild(Widget("abilitybar"))
        local buffbar=FA_BuffBar(xabilitybar.owner)
        buffbar:SetPosition(250,0,0)
        xabilitybar:AddChild(buffbar)
        xabilitybar.buffbar=buffbar

        inst:ListenForEvent("fa_rebuildbuffs",function(inst,data)
            buffbar:RegisterBuffs(data.buffs)
        end)
        inst:ListenForEvent("fa_addbuff",function(inst,data)
            buffbar:AddBuff(data.id,data.buff)
        end)
        inst:ListenForEvent("fa_removebuff",function(inst,data)
            buffbar:RemoveBuff(data.id)
        end)

        local statusbar=FA_StatusBar(xabilitybar.owner)
        xabilitybar:AddChild(statusbar)
        xabilitybar.statusbar=statusbar
        statusbar:SetPosition(-300,-30,0)

        inst:ListenForEvent("fa_temphpdelta",function(inst,data)
            statusbar:TempHPDelta(data.old, data.new)
        end)
        inst:ListenForEvent("fa_protectiondelta",function(inst,data)
            statusbar:ProtectionDelta(data.old,data.new,data.damagetype)
        end)

    if GetPlayer() and GetPlayer().newControlsInit then
        xabilitybar:SetPosition(0,-76,0)
        xabilitybar:SetScaleMode(GLOBAL.SCALEMODE_PROPORTIONAL)
        xabilitybar:SetMaxPropUpscale(1.25)
        xabilitybar:SetHAnchor(GLOBAL.ANCHOR_MIDDLE)
        xabilitybar:SetVAnchor(GLOBAL.ANCHOR_TOP)
        GetPlayer().newControlsInit(xabilitybar)
    end

    statusbar:RegisterBuffs()
    buffbar:RegisterBuffs(inst.components.fa_bufftimers.buff_timers)
    --[[
    GetPlayer():DoPeriodicTask(10, function()
                 GetPlayer().AnimState:PlayAnimation("test1")
            end)]]
end
--AddClassPostConstruct("screens/playerhud",newControlsInit)
AddClassPostConstruct("widgets/statusdisplays", newControlsInit)

local crafttabsPostConstruct=function(self,owner,top_root)
    if(not GetPlayer().fa_spellcraft) then return end
    local spelltab=nil
    for k,v in pairs(self.tabbyfilter) do
        if(v.filter.str=="SPELLS")then
            spelltab=v
            break
        end
    end

    if(not spelltab) then
        print("not a spellcaster?")
    else
        spelltab.selectfn = function()
           GLOBAL.TheFrontEnd:PushScreen(FA_SpellBookScreen())
        end
        --self.deselectfn = deselectfn
    end
end

if(GetModConfigData("spellbooks"))then
    AddClassPostConstruct("widgets/crafttabs",crafttabsPostConstruct)
end


local function playerhudPostContruct(self)
    
    function self:UpdateClouds(dt)
            local TheCamera = GLOBAL.TheCamera
            TheCamera.should_push_down = false
            self.clouds_on = false
            if(self.clouds)then
                self.clouds:Hide()
            end
    end
end


if(GetModConfigData("extrazoom"))then
    AddClassPostConstruct ("screens/playerhud", playerhudPostContruct)

    --resetting cave zoom levels - could do it just for mine i suppose, but the limited zoom is annoying overall
    local FollowCamera=require "cameras/followcamera"
    local cameradefault=FollowCamera.SetDefault
    function FollowCamera:SetDefault(...)
        cameradefault(self,...)

        if GetWorld() and GetWorld():IsCave() then
        self.distancetarget = 30
        self.mindist = 15
        self.maxdist = 50 
        self.mindistpitch = 30
        self.maxdistpitch = 60
        end
    end

end

if(GetModConfigData("extracontrollerrange"))then
    AddClassPostConstruct ("screens/playerhud", playerhudPostContruct)
end


local function onFishingCollect(inst,data)
    local spawnPos = GLOBAL.Vector3(inst.Transform:GetWorldPosition() )
    if(math.random()<=GLOBAL.FISHING_MERM_SPAWN_CHANCE)then
        local merm=SpawnPrefab("merm")
        merm.Transform:SetPosition(spawnPos:Get() )
    end
    if(math.random()<=GLOBAL.FISHING_SCROLL_SPAWN_CHANCE)then
        local merm=SpawnPrefab("fa_scroll_1")
        merm.Transform:SetPosition(spawnPos:Get() )
    end
end

AddClassPostConstruct("screens/loadgamescreen", function(self)
    self.MakeSaveTile = (function()
        local MakeSaveTile = self.MakeSaveTile
 
        return function(self, slotnum, ...)
            local tile = MakeSaveTile(self, slotnum, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(slotnum)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(slotnum)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
--                    tile.text:SetString(("%s-%d"):format(data.name, day))
                    tile.text:SetString(("%s"):format(data.name))
                end
            end    
 
            return tile
        end
    end)()
end)
 
AddClassPostConstruct("screens/slotdetailsscreen", function(self)
    self.BuildMenu = (function()
        local BuildMenu = self.BuildMenu
 
        return function(self, ...)
            BuildMenu(self, ...)

            local cavelevel=GLOBAL.SaveGameIndex:GetCurrentCaveLevel(self.saveslot)
            local mode = GLOBAL.SaveGameIndex:GetCurrentMode(self.saveslot)

            if(mode == "cave")then
                print("cavelevel",cavelevel)
                local data=Levels.cave_levels[cavelevel]
                --second check just to exclude other mods or default caves etc..
                if(data and GLOBAL.FA_LEVELS[data.id])then
                    local day = GLOBAL.SaveGameIndex:GetSlotDay(slotnum)
                    self.text:SetString(("%s"):format(data.name))
                end
            end    

        end
    end)()
end)

AddClassPostConstruct("components/terraformer",function(self)
local old_canterraformpoint=self.CanTerraformPoint
function self:CanTerraformPoint(pt)
    if(old_canterraformpoint(self,pt))then
        -- since it's blocking just hardcoded crap... one day I'll move this
        local ground = GetWorld()
        if ground then
            local tile = ground.Map:GetTileAtPoint(pt.x, pt.y, pt.z)
            return tile~=GROUND.FA_LAVA_ASH and tile~=GROUND.FA_LAVA_GREEN and tile~=GROUND.FA_LAVA_SHINY and tile~=FA_LAVA_TERRAIN2
        end
    else
        return false
    end
end

end)

AddPrefabPostInit("world", function(inst)

--    GLOBAL.assert( GLOBAL.GetPlayer() == nil )
    local player_prefab = GLOBAL.SaveGameIndex:GetSlotCharacter()
 
    -- Unfortunately, we can't add new postinits by now. So we have to do
    -- it the hard way...
 
    GLOBAL.TheSim:LoadPrefabs( {player_prefab} )
    local oldfn = GLOBAL.Prefabs[player_prefab].fn
    GLOBAL.Prefabs[player_prefab].fn = function()
        local inst = oldfn()

        inst:AddComponent("fa_bufftimers")
        inst:AddComponent("fa_drinker")
        inst:AddComponent("fa_intoxication")
        inst:AddComponent("fa_recipebook")
        if(inst.components.fa_spellcaster==nil)then
            inst:AddComponent("fa_spellcaster")
        end

        if(GLOBAL.FA_ModCompat.alwaysonmod)then
            print("alwayson", GLOBAL.FA_ModCompat.alwaysonmod.version)
            --cba to care about failures, if it fails oh well i did what i could
            if(not inst.components.switch)then
                GLOBAL.pcall(function()
                    inst:AddComponent("switch")
                    print("alwayson failsafe")
                end)
            end
        end
 
        local oldsavefn=inst.OnSave
        local oldloadfn=inst.OnLoad

        local onloadfn = function(inst, data)
            if(oldloadfn)then
                oldloadfn(inst,data)
            end
            inst.fa_prevcavelevel=data.fa_prevcavelevel
            print("prevcavelevel",inst.fa_prevcavelevel)
        end

        local onsavefn = function(inst, data)
            if(oldsavefn)then
                oldsavefn(inst,data)
            end
            data.fa_prevcavelevel=inst.fa_prevcavelevel
        end
        inst.OnLoad = onloadfn
        inst.OnSave = onsavefn
        inst.fa_prevcavelevel=0--should really default to current topology or so but meh
 
        return inst
    end
end)

local function UpdateWorldGenScreen(self, profile, cb, world_gen_options)
        print("level",world_gen_options.level_world)
        local data=Levels.cave_levels[world_gen_options.level_world]
        if(world_gen_options.level_type and world_gen_options.level_type=="adventure")then return end
        if(data and GLOBAL.FA_LEVELS[data.id])then
             GLOBAL.TheSim:LoadPrefabs {"MOD_"..modname}
            --TODO this crap should really be done differently
            if(data.id=="GOBLIN_CAVE" or data.id=="GOBLIN_CAVE_2" or data.id=="GOBLIN_CAVE_3" or data.id=="GOBLIN_CAVE_BOSSLEVEL")then
                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_goblin_cave")
                self.worldanim:GetAnimState():SetBuild("generating_goblin_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)

                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.GOBLIN.NOUNS)

--separate thread... cant do anything about it atm
--                self:ChangeFlavourText()
    
            elseif(data.id=="ORC_MINES" or data.id=="ORC_FORTRESS") then
--                self.bg:SetTint(GLOBAL.BGCOLOURS.RED[1],GLOBAL.BGCOLOURS.RED[2],GLOBAL.BGCOLOURS.RED[3], 1)
                self.worldanim:GetAnimState():SetBank("generating_mine_cave")
                self.worldanim:GetAnimState():SetBuild("generating_mine_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)
                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.MINES.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.MINES.NOUNS)
            elseif(data.id=="DWARF_FORTRESS") then
                self.worldanim:GetAnimState():SetBank("generating_mine_cave")
                self.worldanim:GetAnimState():SetBuild("generating_mine_cave")
                self.worldanim:GetAnimState():PlayAnimation("idle", true)
                self.verbs = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.DWARFFORTRESS.VERBS)
                self.nouns = GLOBAL.shuffleArray(GLOBAL.STRINGS.UI.WORLDGEN.DWARFFORTRESS.NOUNS)
            end
        end
       

        
end

AddClassPostConstruct("screens/worldgenscreen", UpdateWorldGenScreen)

local function UpdateMainScreen(self,...)
    if(self.shield) then self.shield:Kill() end
    self.shield = self.fixed_root:AddChild(Image())
    self.shield:SetTexture("images/fa_title.xml", "fa_title.tex")
end

AddClassPostConstruct("screens/mainscreen",UpdateMainScreen)

local function setTopologyType(inst,type)
    local oldLoadPostPass = inst.LoadPostPass
    function inst:LoadPostPass(...)
        self.topology.level_type = type
        if oldLoadPostPass then
            return oldLoadPostPass(self, ...)
        end
    end
end

local function OrcMinesPostInit(inst)
    local waves = inst.entity:AddWaveComponent()

    waves:SetRegionSize( 40, 20 )
    waves:SetRegionNumWaves( 8 )
    waves:SetWaveTexture(GLOBAL.resolvefilepath("images/lava2.tex"))--GLOBAL.resolvefilepath("images/lava.tex")
    waves:SetWaveEffect( "shaders/waves.ksh" ) -- texture.ksh
    waves:SetWaveSize( 2048, 512 )
--[[ this will collide with other overrides, turning default back to standard cc manager
    the other option is to rely on the knowledge of how level is set which is not ideal
    GLOBAL.GetWorld().components.colourcubemanager:SetOverrideColourCube(
        GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    )]]

    local SEASONS=GLOBAL.SEASONS
    if(FA_DLCACCESS)then
        GLOBAL.GetWorld().components.colourcubemanager.SEASON_CCS[SEASONS.SUMMER]["DUSK"]=GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    else
        GLOBAL.GetWorld().components.colourcubemanager.SEASON_CCS[SEASONS.SUMMER]["DUSK"]=GLOBAL.resolvefilepath "colour_cubes/lavacube.tex"
    end

--                setTopologyType(inst,"mines")        
--[[
                if(not inst.components.seasonmanager)then
                    inst:AddComponent("SeasonManager")
                end
                inst.components.seasonmanager:AlwaysDry()
                    inst.components.seasonmanager.current_season = GLOBAL.SEASONS.SUMMER
                    inst.components.seasonmanager:AlwaysSummer()

]]
                local startLavaRain=function()
                    if(not inst.fa_lavarain)then
                        inst.fa_lavarain=SpawnPrefab("fa_lavarain")
                        inst.fa_lavarain.persists=false
                    end
                    inst.fa_lavarain.entity:SetParent( GetPlayer().entity )
                    inst.fa_lavarain.particles_per_tick = 20
                    inst.fa_lavarain.splashes_per_tick = 10
                end

                local old_load=inst.OnLoad
                inst.OnLoad=function(inst,data)
                    if(old_load)then
                        old_load(inst,data)
                    end
                    if(data and data.fa_lavarain)then
                        startLavaRain()
                    end
                end
                local old_save=inst.OnSave
                inst.OnSave=function(inst,data)
                    if(old_save)then
                        old_save(inst,data)
                    end
                    if(inst.fa_lavarain)then
                        data.fa_lavarain=true
                    end
                end
                inst:ListenForEvent("startquake",function()
                    startLavaRain()
                end)
                inst:ListenForEvent("endquake",function()
                    inst.fa_lavarain:Remove()
                    inst.fa_lavarain=nil
                end)   

    
end

AddPrefabPostInit("cave", function(inst)

    local level=GLOBAL.SaveGameIndex:GetCurrentCaveLevel()
    print("in cave postinit",level)
    if(level>3)then
        inst:RemoveComponent("periodicthreat")
        local data=Levels.cave_levels[level]
        if(data and GLOBAL.FA_LEVELS[data.id])then
            if(data.id=="ORC_MINES")then
                inst.IsCave=function() return false end
                inst:AddComponent("fa_warzone")
                    AddClassPostConstruct("widgets/controls", function(self, owner)
                    self.clock:Kill()
                    self.clock=self.sidepanel:AddChild(FA_WarClock(owner))
                end)
            end
            if(data.id=="ORC_MINES" or data.id=="DWARF_FORTRESS" or data.id=="ORC_FORTRESS")then
                OrcMinesPostInit(inst)
            end

            local quakerlootoverride=GLOBAL.FA_QUAKER_LOOT_OVERRIDE[data.id]
            if(quakerlootoverride)then
--                local quaker=require("components/quaker")
                local quaker=inst.components.quaker

                function quaker:GetDebris()
                    local rng = math.random()
                    local todrop = nil
                    if rng < 0.75 then
                            todrop = quakerlootoverride.common[math.random(1, #quakerlootoverride.common)]
                    elseif rng >= 0.75 and rng < 0.95 then
                            todrop = quakerlootoverride.rare[math.random(1, #quakerlootoverride.rare)]
                    else
                            todrop = quakerlootoverride.veryrare[math.random(1, #quakerlootoverride.veryrare)]
                    end
                    return todrop
                end
            end


            local threats=GLOBAL.FA_LEVEL_THREATS[data.id]
            local threatlist = require("fa_periodicthreats")
            if(threats)then
            for k,v in pairs(threats) do
                if(not inst.components.periodicthreat)then
                    inst:AddComponent("periodicthreat")
                end
                inst.components.periodicthreat:AddThreat(v,threatlist[v])
            end
            end
        end
    end
end)


AddSimPostInit(function(inst)

    if(inst:HasTag("player"))then



    inst.AnimState:OverrideSymbol("chains", "fa_cagechains", "chains")
    inst.AnimState:OverrideSymbol("cage", "fa_orcfort_cage", "cage")

--        GLOBAL.trace_flow()
        --why the hell did they even add this...
        if(inst.components.eater.ablefoods)then
            table.insert( inst.components.eater.ablefoods, "FA_POTION" )
        end
        table.insert( inst.components.eater.foodprefs, "FA_POTION" )

        local sg=inst.sg.sg
        local old_onexit=sg.states["amulet_rebirth"].onexit
        sg.states["amulet_rebirth"].onexit=function(inst)
            old_onexit(inst)
            inst.components.health.invincible=true

            local boom = GLOBAL.CreateEntity()
            boom.entity:AddTransform()
            local anim=boom.entity:AddAnimState()
            boom:AddTag("NOCLICK")
            boom:AddTag("FX")
            boom.persists=false
            anim:SetBank("fa_shieldpuff")
            anim:SetBuild("fa_shieldpuff")
            anim:PlayAnimation("idle",false)
            local pos1 =inst:GetPosition()
            boom.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
            boom:ListenForEvent("animover", function()  boom:Remove() end)

            inst:DoTaskInTime(10, function() inst.components.health.invincible=false end)
            return true
        end

--            PlayerSanityMod(inst)

        if (inst.prefab=="darkknight" or inst.prefab=="cleric" or inst.prefab=="paladin") then
            --add shields
            local r=Recipe("fa_woodenshield", {Ingredient("boards", 5),Ingredient("rope", 5) }, RECIPETABS.WAR,  GLOBAL.TECH.SCIENCE_ONE)
            r.image="fa_woodenshield.tex"
            r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
        end
        inst:ListenForEvent("fishingcollect",onFishingCollect)

            local leader=inst.components.leader
            for k,v in pairs(leader.followers) do
                if(k.prefab=="frog")then
--why is tag being lost?
--                if k:HasTag("fa_wonderswap") then

                    print("removing frog")
                    k:Remove()
                end
            end
            


    end
end)
--\

FA_ModUtil.addT1LootPrefabPostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.tier1,FALLENLOOTTABLE.TABLE_TIER1_WEIGHT,chance)
end


FA_ModUtil.addT1T2LootPrefabPostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLE["tier1"],FALLENLOOTTABLE["tier2"]),FALLENLOOTTABLE.TABLE_TIER1_WEIGHT+FALLENLOOTTABLE.TABLE_TIER2_WEIGHT,chance)
end

FA_ModUtil.addFullLootPrefabPostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,chance)
end

FA_ModUtil.addFullStructureLootPrefabPostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.keys3),FALLENLOOTTABLE.TABLE_WEIGHT+FALLENLOOTTABLE.TABLE_KEYS3_WEIGHT,chance)
end

FA_ModUtil.addKeyTable1PostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys1,FALLENLOOTTABLE.TABLE_KEYS1_WEIGHT,chance)
end

FA_ModUtil.addKeyTable2PostInit=function(inst,chance)
    if(not inst.components.lootdropper)then
        inst:AddComponent("lootdropper")
    end
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLE.keys2,FALLENLOOTTABLE.TABLE_KEYS2_WEIGHT,chance)
end


require "postinits/fa_objectpostinits"
require "postinits/fa_mobpostinits"



--why would spells ignore longupdate? This will collide with any other postconstructs i assume, but it's not exactly something where i can stack calls
local Spell=require "components/spell"
local old_spelllongupdate=Spell.LongUpdate
if(old_spelllongupdate)then
        print("WARNING: found old spell.longupdate, bypassing override")
else
    function Spell:LongUpdate(dt)
--TODO periodic tics should fire appropriate amount of times, not just once, fix onupdate bug
        self:OnUpdate(dt)
    end
end

--[[
AddClassPostConstruct("screens/characterselectscreen", function(self)
    self:SelectCharacter "barb"
end)
]]
AddClassPostConstruct("screens/newgamescreen", function(self)
    self.character = "barb"          
    local atlas = "images/saveslot_portraits/"..self.character..".xml"
    self.portrait:SetTexture(atlas, self.character..".tex")
end)


AddModCharacter("barb")
AddModCharacter("druid")
AddModCharacter("paladin")
AddModCharacter("cleric")
AddModCharacter("darkknight")
AddModCharacter("wizard")

AddModCharacter("ranger")
AddModCharacter("thief")
AddModCharacter("monk")
AddModCharacter("necromancer")
AddModCharacter("tinkerer")
AddModCharacter("bard")
