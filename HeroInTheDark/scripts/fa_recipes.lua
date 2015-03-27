require "recipe"
require "tuning"
require "constants"



RECIPETABS["FA_DWARFTRADER"] = {str = "FA_DWARFTRADER", sort=999, icon = "fa_dorf.tex", icon_atlas ="minimap/fa_minimap.xml"}
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
r.image="fa_bottle_light_green.tex"
r.atlas = "images/inventoryimages/fa_inventoryimages.xml"
local r=Recipe("fa_barrel_wood", {Ingredient("fa_copperbar", 4,"images/inventoryimages/fa_inventoryimages.xml"), Ingredient("boards", 2)}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="fa_barrel_wood.tex"
--r.atlas = "images/inventoryimages/fa_barrel_wood.xml"


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

local r=Recipe("multitool_axe_pickaxe", {Ingredient("bluegem", 2)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
local r=Recipe("sewing_kit", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
local r=Recipe("armorslurper", {Ingredient("fa_diamondpebble", 1,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
local r=Recipe("sewing_kit", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
local r=Recipe("fa_dorf_lantern", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
local r=Recipe("trap_teeth", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
--Dwarf bed	2 red gems
local r=Recipe("yellowstaff", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFITEMSTAND, nil, nil, true)
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
local r=Recipe("thulecite", {Ingredient("goldnugget", 5)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFRESOURCESTAND, nil, nil, true)
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

local r=Recipe("fa_copperarmor_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_ironarmor_recipe", {Ingredient("fa_diamondpebble", 4,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_steelarmor_recipe", {Ingredient("fa_diamondpebble", 8,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_copper_recipe", {Ingredient("goldnugget", 20)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_iron_recipe", {Ingredient("fa_diamondpebble", 3,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
r.image="blueprint.tex"
local r=Recipe("fa_hat_steel_recipe", {Ingredient("fa_diamondpebble", 6,"images/inventoryimages/fa_inventoryimages.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_DORFARMORRECIPES, nil, nil, true)
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