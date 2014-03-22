
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
        Asset( "ANIM", "anim/cleric.zip" ),
        Asset( "ANIM", "anim/betterbarrier.zip" ),
        Asset( "ANIM", "anim/flash_b.zip" ),
}
local prefabs = {}

STRINGS.TABS.SPELLS = "Spells"

STRINGS.NAMES.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.RECIPE_DESC.SPELL_DIVINEMIGHT = "Divine Might"

STRINGS.NAMES.SPELL_CALLDIETY = "Call Diety"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_CALLDIETY = "Call Diety"
STRINGS.RECIPE_DESC.SPELL_CALLDIETY = "Call Diety"

STRINGS.NAMES.SPELL_LIGHT = "Banish Darkness"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_LIGHT = "Banish Darkness"
STRINGS.RECIPE_DESC.SPELL_LIGHT = "Banish Darkness"

STRINGS.NAMES.SPELL_HEAL = "Heal"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_HEAL = "Heal"
STRINGS.RECIPE_DESC.SPELL_HEAL = "Heal"

STRINGS.NAMES.SPELL_BLADEBARRIER = "Blade Barrier"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_BLADEBARRIER = "Blade Barrier"
STRINGS.RECIPE_DESC.SPELL_BLADEBARRIER = "Blade Barrier"

local onloadfn = function(inst, data)
    inst.lightBuffUp=data.lightBuffUp
    inst.dmBuffUp=data.dmBuffUp
    inst.bbBuffUp=data.bbBuffUp
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.lightBuffUp=inst.buff_timers["light"].cooldowntimer
    data.dmBuffUp=inst.buff_timers["divinemight"].cooldowntimer
    data.bbBuffUp=inst.buff_timers["bladebarrier"].cooldowntimer
    data.fa_playername=inst.fa_playername
end



local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=1.25
	inst.components.health:SetMaxHealth(200)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

    inst:AddComponent("reader")
    inst:AddComponent("xplevel")

    inst.buff_timers={}
--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}
    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("spell_divinemight", {Ingredient("meat", 5), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, booktab, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_brimstone.tex"
    r=Recipe("spell_calldiety", {Ingredient("redgem", 4), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, booktab,{MAGIC = 2})
    r.image="book_brimstone.tex"
    r=Recipe("spell_light", {Ingredient("fireflies", 2),Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, booktab, {MAGIC = 2})
    r.image="book_gardening.tex"
    r=Recipe("spell_heal", {Ingredient("spidergland",5),Ingredient("cutgrass", 5), Ingredient("rocks", 15)}, booktab, {MAGIC = 3})
    r.image="book_gardening.tex"
    r=Recipe("spell_bladebarrier", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, booktab, {MAGIC = 3})
    r.image="book_gardening.tex"

    inst.newControlsInit = function (class)
        local btn=InitBuffBar(inst,"light",inst.lightBuffUp,class,"light")
        btn:SetPosition(-100,0,0)
        LightSpellStart(inst,inst.lightBuffUp )
        local btn=InitBuffBar(inst,"divinemight",inst.dmBuffUp,class,"DM")
        btn:SetPosition(0,0,0)
        DivineMightSpellStart(inst,inst.dmBuffUp )
        local btn=InitBuffBar(inst,"bladebarrier",inst.bbBuffUp,class,"BB")
        btn:SetPosition(100,0,0)
        BladeBarrierSpellStart(inst,inst.bbBuffUp )
    end

end



return MakePlayerCharacter("cleric", prefabs, assets, fn)
