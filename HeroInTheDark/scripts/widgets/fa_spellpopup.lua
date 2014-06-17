require "class"

local TileBG = require "widgets/tilebg"
local InventorySlot = require "widgets/invslot"
local Image = require "widgets/image"
local ImageButton = require "widgets/imagebutton"
local Widget = require "widgets/widget"
local TabGroup = require "widgets/tabgroup"
local UIAnim = require "widgets/uianim"
local Text = require "widgets/text"
local IngredientUI = require "widgets/ingredientui"

require "widgets/widgetutil"

local TEASER_SCALE_TEXT = 1
local TEASER_SCALE_BTN = 1.5

local FA_SpellPopup = Class(Widget, function(self, horizontal)
    Widget._ctor(self, "Recipe Popup")
    
    local hud_atlas = resolvefilepath( "images/hud.xml" )

    self.bg = self:AddChild(Image())
    local img = horizontal and "craftingsubmenu_fullvertical.tex" or "craftingsubmenu_fullhorizontal.tex"
    
    if horizontal then
		self.bg:SetPosition(240,40,0)
    else
		self.bg:SetPosition(210,16,0)
    end
--    self.bg:SetTexture(hud_atlas, img)
    
    --
    
    self.contents = self:AddChild(Widget(""))
    self.contents:SetPosition(-75,0,0)
    
    if JapaneseOnPS4() then
        self.name = self.contents:AddChild(Text(UIFONT, 42 * 0.8))
    else
        self.name = self.contents:AddChild(Text(UIFONT, 42))
	end
    self.name:SetPosition(320, 142, 0)
    if JapaneseOnPS4() then
        self.name:SetRegionSize(64*3+20,90)
        self.name:EnableWordWrap(true)
    end

    if JapaneseOnPS4() then
        self.desc = self.contents:AddChild(Text(BODYTEXTFONT, 33 * 0.8))
        self.desc:SetPosition(320, -10, 0)
        self.desc:SetRegionSize(64*3+30,90)
	else
        self.desc = self.contents:AddChild(Text(BODYTEXTFONT, 33))
        self.desc:SetPosition(320, -5, 0)
        self.desc:SetRegionSize(64*3+30,70)	
    end
    self.desc:EnableWordWrap(true)
    
    self.ing = {}
--[[    
    self.button = self.contents:AddChild(ImageButton(UI_ATLAS, "button.tex", "button_over.tex", "button_disabled.tex"))
    self.button:SetScale(.7,.7,.7)
    self.button:SetOnClick(function() if not DoRecipeClick(self.owner, self.recipe) then self.owner.HUD.controls.crafttabs:Close() end end)
    ]]
    
    self.recipecost = self.contents:AddChild(Text(NUMBERFONT, 40))
    self.recipecost:SetHAlign(ANCHOR_LEFT)
    self.recipecost:SetRegionSize(80,50)
    self.recipecost:SetPosition(420,-115,0)--(375, -115, 0)
    self.recipecost:SetColour(255/255, 234/255,0/255, 1)

    self.amulet = self.contents:AddChild(Image( resolvefilepath("images/inventoryimages.xml"), "greenamulet.tex"))
    self.amulet:SetPosition(415, -105, 0)
    self.amulet:SetTooltip(STRINGS.GREENAMULET_TOOLTIP)
    
    self.teaser = self.contents:AddChild(Text(BODYTEXTFONT, 28))
    self.teaser:SetPosition(325, -100, 0)
    self.teaser:SetRegionSize(64*3+20,100)
    self.teaser:EnableWordWrap(true)
    self.teaser:Hide()
    
end)



function FA_SpellPopup:Refresh()
	
    local recipe = self.recipe
	local owner = self.owner
	
	if not owner then
		return false
	end
	
    local knows = owner.components.builder:KnowsRecipe(self.spell.recname)
    local buffered = owner.components.builder:IsBuildBuffered(self.spell.recname)
    local can_build = owner.components.builder:CanBuild(self.spell.recname) or buffered
    local tech_level = owner.components.builder.accessible_tech_trees

    local equippedBody = owner.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
--this should be amu but do i care about it?
    local showamulet = equippedBody and equippedBody.prefab == "greenamulet"
    
	if not showamulet then
        self.amulet:Hide()
    else
        self.amulet:Show()
    end

    self.name:SetString(STRINGS.NAMES[string.upper(self.spell.recname)])
    self.desc:SetString(STRINGS.RECIPE_DESC[string.upper(self.spell.recname)])
    
    for k,v in pairs(self.ing) do
        v:Kill()
    end
    self.ing = {}

    local center = 330
    local num = GetTableSize(recipe.ingredients)
    local w = 64
    local div = 10
    
    local offset = center
    
    local i=0
    local y=0
    for k,v in pairs(recipe.ingredients) do
        if(i%3==0)then
            offset=center-(w/2+div)*(math.max(3,num-i)-1)
            y=y+80
        end
        local has, num_found = owner.components.inventory:Has(v.type, RoundUp(v.amount * owner.components.builder.ingredientmod))
        
        local ing = self.contents:AddChild(IngredientUI(v.atlas, v.type..".tex", v.amount, num_found, has, STRINGS.NAMES[string.upper(v.type)], owner))
        ing:SetPosition(Vector3(offset, y, 0))
        offset = offset + (w+ div)
        self.ing[k] = ing
        i=i+1
    end

    self.teaser:SetString(self.spell.school or "")
    self.teaser:Show()
end


function FA_SpellPopup:SetSpell(spell, owner)
    self.recipe = GetRecipe(spell.recname)
    self.spell=spell
    self.owner = owner
    self:Refresh()
end


return FA_SpellPopup
