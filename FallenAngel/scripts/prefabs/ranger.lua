
local MakePlayerCharacter = require "prefabs/player_common"


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
        Asset( "ANIM", "anim/ranger.zip" ),
}
local prefabs = {}


STRINGS.NAMES.NATURESHEALING = "Nature's Healing Medicine"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NATURESHEALING = "Nature's Healing Medicine"
STRINGS.RECIPE_DESC.NATURESHEALING = "Nature's Healing Medicine"

local DAMAGE_MULT=1
local FLURRY_COOLDOWN=480
local FORAGE_COOLDOWN=480
local MURDER_SANITY_DELTA=-1
local EXTERMINATE_SANITY_DELTA=5

local forage_table={
    "carrot",
    "cave_banana",
    "corn",
    "pumpkin",
    "eggplant",
    "durian",
    "pomegranate",
    "dragonfruit",
    "berries",
    "mandrake"
}


local function onmurder(inst,data)
    local victim=data.victim
    if(victim:HasTag("animal") or victim:HasTag("bird"))then
        inst.components.sanity:DoDelta(MURDER_SANITY_DELTA)
    else
        if(victim:HasTag("monster") or victim:HasTag("undead"))then
             inst.components.sanity:DoDelta(EXTERMINATE_SANITY_DELTA)
        end
    end
end

local onforage=function()
    local roll=forage_table[math.random(1, #forage_table)]
    local item=SpawnPrefab(roll)
    local spawn_point= Vector3(GetPlayer().Transform:GetWorldPosition())
    item.Physics:Teleport(spawn_point.x,35,spawn_point.z)
    return true
end

local onflurry=function()

end


local onloadfn = function(inst, data)
    inst.foragecooldowntimer=data.foragecooldowntimer
    inst.flurrycooldowntimer=data.flurrycooldowntimer
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.foragecooldowntimer=inst.forageCooldownButton.cooldowntimer
    data.flurrycooldowntimer=inst.flurryCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
end

local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
    inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(190)
	inst.components.sanity:SetMax(150)
	inst.components.hunger:SetMax(200)

    inst:AddComponent("xplevel")
    inst:ListenForEvent("killed", onmurder)
   
    local r=Recipe("arrows", {Ingredient("twigs", 5), Ingredient("houndstooth", 1)},  RECIPETABS.WAR,  {SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("bow", {Ingredient("twigs", 2), Ingredient("rope", 1),Ingredient("pigskin", 1)}, RECIPETABS.WAR,{SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("natureshealing", {Ingredient("berries", 2), Ingredient("honey", 1),Ingredient("papyrus", 2)},  RECIPETABS.SURVIVAL,{SCIENCE = 1})
    r.image="book_brimstone.tex"

    inst.newControlsInit = function (class)

        inst.forageCooldownButton=CooldownButton(cnt.owner)
        inst.forageCooldownButton:SetText("Forage")
        inst.forageCooldownButton:SetOnClick(onforage)
        inst.forageCooldownButton:SetCooldown(FORAGE_COOLDOWN)
        if(inst.foragecooldowntimer and inst.foragecooldowntimer>0)then
             inst.forageCooldownButton:ForceCooldown(inst.foragecooldowntimer)
        end
        local foragebtn=cnt:AddChild(inst.forageCooldownButton)
        foragebtn:SetPosition(-100,0,0)

        inst.flurryCooldownButton=CooldownButton(cnt.owner)
        inst.flurryCooldownButton:SetText("Flurry")
        inst.flurryCooldownButton:SetCooldown(FLURRY_COOLDOWN)
        inst.flurryCooldownButton:SetOnClick(onflurry)
        if(inst.flurrycooldowntimer and inst.flurrycooldowntimer>0)then
             inst.flurryCooldownButton:ForceCooldown(inst.flurrycooldowntimer)
        end
        local flurrybtn=cnt:AddChild(inst.flurryCooldownButton)
        flurrybtn:SetPosition(100,0,0)
    end

end

return MakePlayerCharacter("ranger", prefabs, assets, fn)
