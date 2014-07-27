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
