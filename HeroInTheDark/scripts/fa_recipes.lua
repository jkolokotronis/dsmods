require "recipe"
require "tuning"
require "constants"



RECIPETABS["FA_DWARFTRADER"] = {str = "FA_DWARFTRADER", sort=999, icon = "fa_shopicon.tex", icon_atlas ="images/inventoryimages/fa_inventoryimages.xml"}
STRINGS.TABS.FA_DWARFTRADER = "Trader"

--wicker is already fixing the hardcoded crap - I see no reason to reinvent the wheel
if(not FA_ModCompat.UnA)then
	print("patching hardcoded builder tech bonuses")
	local Builder = require "components/builder"

	function Builder:KnowsRecipe(recname)
		local recipe = GetRecipe(recname)
	 
		if recipe then
			local is_intrinsic = true

			for k, v in pairs(recipe.level) do
				local bonus = self[k:lower().."_bonus"] or 0
				if bonus < v then
					is_intrinsic = false
					break
				end
			end

			if is_intrinsic then
				return true
			end
		end
	 
		return self.freebuildmode or table.contains(self.recipes, recname)
	end
end

local function AddTech(name)
	for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    	v[name]=0
	end 
	TECH.NONE[name]=0
end
local function AddPrototyper(name,tech,level)
	TECH[name]={} 
	TECH[name][tech]=level
	TUNING.PROTOTYPER_TREES[name]=deepcopy(TECH.NONE)
	TUNING.PROTOTYPER_TREES[name][tech]=level
end

--[[
TECH.FA_FOODSTAND={ FA_FOODSTAND=2}
for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v["FA_FOODSTAND"]=0
end 
TUNING.PROTOTYPER_TREES.FA_FOODSTAND=deepcopy(TECH.NONE)
TUNING.PROTOTYPER_TREES.FA_FOODSTAND["FA_FOODSTAND"]=2
TECH.NONE.FA_FOODSTAND=0
]]
AddTech("FA_FOODSTAND")
AddPrototyper("FA_FOODSTAND","FA_FOODSTAND",2)
AddTech("FA_DORFITEMSTAND")
AddPrototyper("FA_DORFITEMSTAND","FA_DORFITEMSTAND",2)
AddTech("FA_DORFPOTIONSTAND")
AddPrototyper("FA_DORFPOTIONSTAND","FA_DORFPOTIONSTAND",2)
AddTech("FA_DORFRESOURCESTAND")
AddPrototyper("FA_DORFRESOURCESTAND","FA_DORFRESOURCESTAND",2)
AddTech("FA_DORFWEAPONRECIPES")
AddPrototyper("FA_DORFWEAPONRECIPES","FA_DORFWEAPONRECIPES",2)
AddTech("FA_DORFEQUIPMENT")
AddPrototyper("FA_DORFEQUIPMENT","FA_DORFEQUIPMENT",2)
AddTech("FA_DORFARMORRECIPES")
AddPrototyper("FA_DORFARMORRECIPES","FA_DORFARMORRECIPES",2)
AddTech("FA_DORFSMELTRECIPESTAND")
AddPrototyper("FA_DORFSMELTRECIPESTAND","FA_DORFSMELTRECIPESTAND",2)
AddTech("FA_DORFOTHERRECIPESTAND")
AddPrototyper("FA_DORFOTHERRECIPESTAND","FA_DORFOTHERRECIPESTAND",2)

AddTech("FA_ELFROBERECIPESTAND")
AddPrototyper("FA_ELFROBERECIPESTAND","FA_ELFROBERECIPESTAND",2)
AddTech("FA_ELFSPELLSTAND")
AddPrototyper("FA_ELFSPELLSTAND","FA_ELFSPELLSTAND",2)
AddTech("FA_ELFWEAPONRECIPESTAND")
AddPrototyper("FA_ELFWEAPONRECIPESTAND","FA_ELFWEAPONRECIPESTAND",2)

local r=Recipe("fa_tinyscrollcase", {Ingredient("fa_goblinskin", 4,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_scroll_case.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_tinywandcase", {Ingredient("fa_goblinskin", 4,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_wand_case.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_smallscrollcase", {Ingredient("fa_orcskin", 4,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_scroll_case.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_smallwandcase", {Ingredient("fa_orcskin", 4,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_wand_case.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_bottle_curepoison", {Ingredient("poisonspidergland", 4,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("spidergland", 4), Ingredient("fa_bottle_r",1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="fa_bottle_dark_lime.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_barrel_wood", {Ingredient("fa_copperbar", 4,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("boards", 2)}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="fa_barrel_wood.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"

local r=Recipe("fa_hat_plain", {Ingredient("silk", 6),Ingredient("beefalowool", 6),Ingredient("razor", 1) }, RECIPETABS.WAR,  TECH.NONE)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_hat_lightleather", {Ingredient("pigskin", 4),Ingredient("rope", 1),Ingredient("razor", 1) }, RECIPETABS.WAR,  TECH.NONE)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_plainrobe", {Ingredient("silk", 8),Ingredient("beefalowool", 8),Ingredient("razor", 1) }, RECIPETABS.WAR,  TECH.NONE)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_lightleatherarmor", {Ingredient("pigskin", 6),Ingredient("rope", 1),Ingredient("razor", 1) }, RECIPETABS.WAR,  TECH.NONE)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_woodenstaff", {Ingredient("boards", 4),Ingredient("rope", 3)}, RECIPETABS.WAR,  TECH.NONE)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"

--[[
local r=Recipe("fa_weaponupgrade_poison", {Ingredient("poisonspidergland", 4,"images/inventoryimages/poisonspidergland.xml"), Ingredient("spidergland", 4), Ingredient("twigs",1)}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="poisonspider_gland_salve.tex"
r.atlas = "images/inventoryimages/poisonspider_gland_salve.xml"]]
local r=Recipe("fa_smeltingfurnace", {Ingredient("cutstone", 10),Ingredient("torch", 1),Ingredient("fa_lavapebble", 5,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("boards", 4)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_smeltingfurnace_placer")
r.image="fa_smeltingfurnace.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_forge", {Ingredient("fa_ironbar", 4,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_lavapebble", 5,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("hammer", 1),Ingredient("boards", 4)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_forge_placer")
r.image="fa_forge.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_alchemytable", {Ingredient("livinglog", 10),Ingredient("nightmarefuel", 5),Ingredient("fa_bottle_empty", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("boards", 5)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_alchemytable_placer")
r.image="fa_alchemytable.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_lavawall_item", {Ingredient("fa_lavabar", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.TOWN, TECH.SCIENCE_ONE)
r.image="fa_lavawall.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"

local r=Recipe("baconeggs", {Ingredient("fa_copperpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("meatballs", {Ingredient("fa_copperpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("bonestew", {Ingredient("fa_ironpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("kabobs", {Ingredient("fa_coalpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("icecream", {Ingredient("fa_silverpebble", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_ironpebble", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("meat_dried", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true,5)

local r=Recipe("fa_dorf_pickaxe", {Ingredient("bluegem", 2)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="multitool_axe_pickaxe.tex"
local r=Recipe("fa_dorf_sewing_kit", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="sewing_kit.tex"
local r=Recipe("fa_dorf_hungerbelt", {Ingredient("fa_diamondpebble", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="armorslurper.tex"
local r=Recipe("fa_dorf_lantern", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="lantern.tex"
local r=Recipe("fa_dorf_trap", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="trap_teeth.tex"
--Dwarf bed	2 red gems
local r=Recipe("fa_dorf_yellowstaff", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="yellowstaff.tex"
local r=Recipe("fa_tinydorfbag", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="fa_bag.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_smalldorfbag", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="fa_bag.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_recipebook", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER,TECH.FA_DORFITEMSTAND, nil, nil, true)
r.image="book_birds.tex"

local r=Recipe("fa_bottle_r", {Ingredient("fa_diamondpebble", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFPOTIONSTAND, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_bottle_y", {Ingredient("goldnugget", 6)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFPOTIONSTAND, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_bottle_g", {Ingredient("goldnugget", 15)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFPOTIONSTAND, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_bottle_b", {Ingredient("goldnugget", 10)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFPOTIONSTAND, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"

local r=Recipe("fa_dorfbed_player", {Ingredient("bluegem", 2)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, "fa_dorfbed_player_placer",nil,true)
r.image="tent.tex"
local r=Recipe("charcoal", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true,20)
local r=Recipe("fa_dorf_gunpowder", {Ingredient("goldnugget", 1)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true)
r.image="gunpowder.tex"
local r=Recipe("marble", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true,5)
local r=Recipe("bluegem", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true)
local r=Recipe("redgem", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true)

local r=Recipe("fa_coppersword", {Ingredient("goldnugget", 25)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_copperaxe", {Ingredient("goldnugget", 25)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_copperdagger", {Ingredient("goldnugget", 25)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_ironsword", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_ironaxe", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_irondagger", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_steelsword", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_steelaxe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_steeldagger", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_copperarmor", {Ingredient("goldnugget", 25)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_ironarmor", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_steelarmor", {Ingredient("fa_diamondpebble", 13,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_hat_copper", {Ingredient("goldnugget", 25)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_hat_iron", {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_hat_steel", {Ingredient("fa_diamondpebble", 15,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFEQUIPMENT, nil, nil, true)
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"

local r=Recipe("fa_coppersword_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_copperaxe_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_copperdagger_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironsword_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironaxe_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_irondagger_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelsword_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelaxe_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steeldagger_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_ironkama_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silverkama_recipe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelkama_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_copperkama_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goldkama_recipe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_silversword_recipe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silveraxe_recipe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silverdagger_recipe", {Ingredient("fa_diamondpebble", 7,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_flamingsword_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_fireaxe_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_frostsword_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_iceaxe_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_vorpalaxe_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_dagger_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_lightningsword_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_venomdagger1_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFWEAPONRECIPES, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_copperarmor_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironarmor_recipe", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelarmor_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_heavyleatherarmor_recipe", {Ingredient("fa_diamondpebble", 5,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_armorfrost_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_armorfire_recipe", {Ingredient("fa_diamondpebble", 25,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silverarmor_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goldarmor_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_copper_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_iron_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_steel_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_silver_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_gold_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_heavyleather_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_coppershield_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironshield_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goldshield_recipe", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silvershield_recipe", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelshield_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_boneshield_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_reflectshield_recipe", {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_copperbar_recipe", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironbar_recipe", {Ingredient("goldnugget", 10)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_pigironbar_recipe", {Ingredient("fa_diamondpebble", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelbar_recipe", {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goldbar_recipe", {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silverbar_recipe", {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_lavabar_recipe", {Ingredient("goldnugget", 10)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_coalbar_recipe", {Ingredient("goldnugget", 2)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFSMELTRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_bottle_empty_recipe", {Ingredient("goldnugget", 2)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_y_recipe", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_g_recipe", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_r_recipe", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_bottle_water_recipe", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_oil_recipe", {Ingredient("fa_diamondpebble", 5,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_mineralwater_recipe",  {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_frozenessence_recipe", {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_lifeessence_recipe",  {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_lightningessence_recipe",  {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_poisonessence_recipe",  {Ingredient("fa_diamondpebble", 10,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_bottle_curepoison_recipe",  {Ingredient("fa_diamondpebble", 5,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_wineyeast_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_distillingyeast_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_brewingyeast_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_mash_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_wort_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"


local r=Recipe("fa_barrel_molasses_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_darkrum_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_bourbon_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_goldrum_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_flavoredrum_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_hotrum_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_lightalemug_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ronsalemug_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_lightale_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_ronsale_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_drakeale_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_oriansale_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_dorfale_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_dwarfalemug_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_deathbrew_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_pomegranate_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_durian_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_dragon_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_melon_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_red_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goodberry_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_glowing_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_cactus_wine_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_mead_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_lightrum_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_clearbourbon_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_vodka_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_gin_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_tequila_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_whiskey_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_baijui_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_barrel_soju_recipe",  {Ingredient("fa_diamondpebble", 2,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFOTHERRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_abjurationrobe_recipe",{Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_lightrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_goldrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_darkrum", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_conjurationrobe_recipe",{Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_clearbourbon", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_flavoredrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_goldrum", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_divinationrobe_recipe",{Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_vodka", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_hotrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_enchantmentrobe_recipe",{Ingredient("fa_melon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_gin", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_lightale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_evocationrobe_recipe",{Ingredient("fa_red_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_tequila", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_ronsale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_illusionrobe_recipe",{Ingredient("fa_mead", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_whiskey", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_oriansale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_cactus_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_necromancyrobe_recipe",{Ingredient("fa_glowing_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_baijui", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_deathbrew", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_deathbrew", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_transmutationrobe_recipe",{Ingredient("fa_cactus_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_soju", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_dorfale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_mead", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_hat_abjuration_recipe",{Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_lightrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_goldrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_darkrum", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_conjuration_recipe",{Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_clearbourbon", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_flavoredrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_goldrum", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_divination_recipe",{Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_vodka", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_hotrum", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_enchantment_recipe",{Ingredient("fa_melon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_gin", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_lightale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_evocation_recipe",{Ingredient("fa_red_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_tequila", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_ronsale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_illusion_recipe",{Ingredient("fa_mead", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_whiskey", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_oriansale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_cactus_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_necromancy_recipe",{Ingredient("fa_glowing_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_baijui", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_deathbrew", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_deathbrew", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_transmutation_recipe",{Ingredient("fa_cactus_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_soju", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_barrel_dorfale", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_mead", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFROBERECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

local r=Recipe("fa_copperstaff_recipe",{Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFWEAPONRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_silverstaff_recipe",{Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFWEAPONRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelstaff_recipe",{Ingredient("fa_red_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_melon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFWEAPONRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironstaff_recipe",{Ingredient("fa_melon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_durian_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_pomegranate_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_red_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFWEAPONRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_goldstaff_recipe",{Ingredient("fa_dragon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml"),Ingredient("fa_melon_wine", 1,"images/inventoryimages/fa_inventoryimages.xml")},  RECIPETABS.FA_DWARFTRADER, TECH.FA_ELFWEAPONRECIPESTAND, nil, nil, true)
r.image="blueprint.tex"

--AddTech("FA_ELFSPELLSTAND")
--AddPrototyper("FA_ELFSPELLSTAND","FA_ELFSPELLSTAND",2)
--AddTech("FA_ELFWEAPONRECIPESTAND")
--AddPrototyper("FA_ELFWEAPONRECIPESTAND","FA_ELFWEAPONRECIPESTAND",2)