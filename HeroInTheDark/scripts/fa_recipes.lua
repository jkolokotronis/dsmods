require "recipe"
require "tuning"

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
local r=Recipe("fa_weaponupgrade_poison", {Ingredient("poisonspidergland", 4,"images/inventoryimages/poisonspidergland.xml"), Ingredient("spidergland", 4), Ingredient("twigs",1)}, RECIPETABS.SURVIVAL,  TECH.NONE)
r.image="poisonspider_gland_salve.tex"
r.atlas = "images/inventoryimages/poisonspider_gland_salve.xml"
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
