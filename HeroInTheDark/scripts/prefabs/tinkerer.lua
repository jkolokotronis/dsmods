
local MakePlayerCharacter = require "prefabs/player_common"
local Combat=require "components/combat"


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
        Asset( "ANIM", "anim/tinkerer.zip" ),
}
local prefabs = {
    "rjk1100",
    "fizzlemanipulator",
    "fizzlepet",
    "fizzleboomstick",
    "fizzlearmor"
}

local DAMAGE_MULT=0.5
local BASE_MS=1.25*TUNING.WILSON_RUN_SPEED
local CLOCKWORK_MULT=6.0

STRINGS.TABS.TINKERING = "Tinkering"

STRINGS.NAMES.FIZZLEMANIPULATOR = "Ecological manipulator of power"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIZZLEMANIPULATOR = "Who knew poop could be so much fun"
STRINGS.RECIPE_DESC.FIZZLEMANIPULATOR = "Who knew poop could be so much fun"

STRINGS.NAMES.RJK1100 = "RJK-1100 prototype rabbit station"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RJK1100 = "Fizzlegear's Class RJK-1100 prototype rabbit station"
STRINGS.RECIPE_DESC.RJK1100 = "Fizzlegear's Class RJK-1100 prototype rabbit station"

STRINGS.NAMES.RJK1100 = "Fizzlegear's Class RJK-1100 prototype rabbit station"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.RJK1100 = "Fizzlegear's Class RJK-1100 prototype rabbit station"
STRINGS.RECIPE_DESC.RJK1100 = "Fizzlegear's Class RJK-1100 prototype rabbit station"

STRINGS.NAMES.FIZZLEPET = "Fizzlegear's Wonderous Automation Model XXI"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIZZLEPET = "It's Alive! Kinda..."

STRINGS.NAMES.FIZZLEPET_BOX = "Fizzlegear's Wonderous Automation Model XXI"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIZZLEPET_BOX = "It's Alive! Kinda..."
STRINGS.RECIPE_DESC.FIZZLEPET_BOX = "It's Alive! Kinda..."

STRINGS.NAMES.FIZZLEBOOMSTICK = "Fizzlegear's patented golden boomstick version 1.0"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIZZLEBOOMSTICK = "Fizzlegear's patented golden boomstick version 1.0"
STRINGS.RECIPE_DESC.FIZZLEBOOMSTICK = "Fizzlegear's patented golden boomstick version 1.0"

STRINGS.NAMES.FIZZLEARMOR = "Fizzlegear's electroshock whiskers disguise, tag number 121"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FIZZLEARMOR = "Fizzlegear's electroshock whiskers disguise, tag number 121"
STRINGS.RECIPE_DESC.FIZZLEARMOR = "Fizzlegear's electroshock whiskers disguise, tag number 121"


local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
end

local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "tinkerer.tex" )

	-- todo: Add an example special power here.

    inst.components.locomotor.runspeed=BASE_MS
    inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(125)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(150)

    inst:AddComponent("xplevel")

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    local combatmod=inst.components.combat

    function combatmod:CalcDamage (target, weapon, multiplier)

        local old=Combat.CalcDamage(self,target,weapon,multiplier)
        if(target and target:HasTag("chess"))then
                return old*CLOCKWORK_MULT
        else
            return old
        end
    end

    
    inst.newControlsInit = function (class)
        if(class.buffbar)then
            class.buffbar.width=800
        end
    end


    
RECIPETABS["TINKERING"] = {str = "TINKERING", sort=999, icon = "trap_teeth.tex", icon_atlas = "images/inventoryimages.xml"}
    local booktab=RECIPETABS.TINKERING
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("fizzlemanipulator", {Ingredient("gears", 5), Ingredient("boards", 4),Ingredient("rocks", 4)}, booktab,{SCIENCE = 1},"fizzlemanipulator_placer")
    r.image="book_brimstone.tex"
    r=Recipe("rjk1100", {Ingredient("houndstooth", 5), Ingredient("boards", 2), Ingredient("rocks", 2)}, booktab, {SCIENCE = 2},"rjk1100_placer")
    r.image="trap_teeth.tex"
    r=Recipe("fizzlepet_box", {Ingredient("gears", 15),Ingredient("rope", 5), Ingredient("purplegem", 1), Ingredient("redgem", 1), Ingredient("bluegem", 1)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("fizzleboomstick", {Ingredient("gunpowder", 1),Ingredient("goldnugget", 5), Ingredient("gears", 4)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("fizzlearmor", {Ingredient("gears", 5),Ingredient("goldnugget", 5), Ingredient("beardhair", 5)}, booktab, {SCIENCE = 2})
    r.image="trap_teeth.tex"

end

return MakePlayerCharacter("tinkerer", prefabs, assets, fn)
