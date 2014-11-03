require "recipe"
require "tuning"
require "constants"



RECIPETABS["FA_DWARFTRADER"] = {str = "FA_DWARFTRADER", sort=999, icon = "fa_dorf.tex", icon_atlas ="minimap/fa_dorf.xml"}
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


TECH.FA_FOODSTAND={ FA_FOODSTAND=2}
for k,v in pairs(TUNING.PROTOTYPER_TREES) do
    v["FA_FOODSTAND"]=0
end 
TUNING.PROTOTYPER_TREES.FA_FOODSTAND=deepcopy(TECH.NONE)
TUNING.PROTOTYPER_TREES.FA_FOODSTAND["FA_FOODSTAND"]=2
TECH.NONE.FA_FOODSTAND=0

local r=Recipe("fa_tinyscrollcase", {Ingredient("fa_goblinskin", 4,"images/inventoryimages/fa_goblinskin.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_scroll_case.tex"
r.atlas = "images/inventoryimages/fa_scroll_case.xml"
local r=Recipe("fa_tinywandcase", {Ingredient("fa_goblinskin", 4,"images/inventoryimages/fa_goblinskin.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_wand_case.tex"
r.atlas = "images/inventoryimages/fa_wand_case.xml"
local r=Recipe("fa_smallscrollcase", {Ingredient("fa_orcskin", 4,"images/inventoryimages/fa_orcskin.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_scroll_case.tex"
r.atlas = "images/inventoryimages/fa_scroll_case.xml"
local r=Recipe("fa_smallwandcase", {Ingredient("fa_orcskin", 4,"images/inventoryimages/fa_orcskin.xml"),Ingredient("pigskin", 4),Ingredient("twigs", 10)}, RECIPETABS.SURVIVAL,  TECH.MAGIC_TWO)    
r.image="fa_wand_case.tex"
r.atlas = "images/inventoryimages/fa_wand_case.xml"
local r=Recipe("fa_bottle_curepoison", {Ingredient("poisonspidergland", 4,"images/inventoryimages/poisonspidergland.xml"), Ingredient("spidergland", 4), Ingredient("fa_bottle_r",1,"images/inventoryimages/fa_bottles.xml")}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="fa_bottle_light_green.tex"
r.atlas = "images/inventoryimages/fa_bottles.xml"
--[[
local r=Recipe("fa_weaponupgrade_poison", {Ingredient("poisonspidergland", 4,"images/inventoryimages/poisonspidergland.xml"), Ingredient("spidergland", 4), Ingredient("twigs",1)}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="poisonspider_gland_salve.tex"
r.atlas = "images/inventoryimages/poisonspider_gland_salve.xml"]]
local r=Recipe("fa_smeltingfurnace", {Ingredient("cutstone", 10),Ingredient("torch", 1),Ingredient("fa_lavapebble", 5,"images/inventoryimages/fa_pebbles.xml"),Ingredient("boards", 4)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_smeltingfurnace_placer")
r.image="fa_smeltingfurnace.tex"
r.atlas = "images/inventoryimages/fa_smeltingfurnace.xml"
local r=Recipe("fa_forge", {Ingredient("fa_ironbar", 4,"images/inventoryimages/fa_orebars.xml"),Ingredient("fa_lavapebble", 5,"images/inventoryimages/fa_pebbles.xml"),Ingredient("hammer", 1),Ingredient("boards", 4)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_forge_placer")
r.image="fa_forge.tex"
r.atlas = "images/inventoryimages/fa_forge.xml"
local r=Recipe("fa_alchemytable", {Ingredient("livinglog", 10),Ingredient("nightmarefuel", 5),Ingredient("fa_bottle_empty", 1,"images/inventoryimages/fa_bottles.xml"),Ingredient("boards", 5)}, RECIPETABS.SCIENCE, TECH.NONE, "fa_alchemytable_placer")
r.image="fa_alchemytable.tex"
r.atlas = "images/inventoryimages/fa_alchemytable.xml"
local r=Recipe("fa_lavawall_item", {Ingredient("fa_lavabar", 4,"images/inventoryimages/fa_orebars.xml")}, RECIPETABS.TOWN, TECH.SCIENCE_ONE)
r.image="fa_lavawall.tex"
r.atlas = "images/inventoryimages/fa_lavawall.xml"

local r=Recipe("baconeggs", {Ingredient("fa_copperpebble", 4,"images/inventoryimages/fa_pebbles.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("meatballs", {Ingredient("fa_copperpebble", 3,"images/inventoryimages/fa_pebbles.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("bonestew", {Ingredient("fa_ironpebble", 4,"images/inventoryimages/fa_pebbles.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("kabobs", {Ingredient("fa_coalpebble", 2,"images/inventoryimages/fa_pebbles.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("icecream", {Ingredient("fa_silverpebble", 1,"images/inventoryimages/fa_pebbles.xml"),Ingredient("fa_ironpebble", 1,"images/inventoryimages/fa_pebbles.xml")}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)
local r=Recipe("meat_dried", {Ingredient("goldnugget", 1)}, RECIPETABS.FA_DWARFTRADER, TECH.FA_FOODSTAND, nil, nil, true)