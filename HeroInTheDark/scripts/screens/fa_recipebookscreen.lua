local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local TextButton = require "widgets/textbutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local NumericSpinner = require "widgets/numericspinner"
local IngredientUI = require "widgets/ingredientui"
local FA_SpellPopup = require "widgets/fa_spellpopup"
local matchers=require "fa_smelter_matcher"
	local HSEP=16
	local YSEP=14
	local HW=64
	local HH=64
	local PAGE_COUNT=5

FASpellBookScreen = Class(Screen, function(self,inst,category,page)
	Screen._ctor(self, "FARecipeBookScreen")
	self.inst=inst or GetPlayer()
	self:DoInit()

    self.category=category or "food" 
    self.page=page or 1
    self:SetCategory(self.category)
    self:SetPage(self.page)
--	self:SetLevel(self.level,self.page)
end)

function FARecipeBookScreen:InitClass()
	if(self.caster.prefab=="druid")then
		self.bgframe:SetPosition(-35, 84, 0)
		self.spell:SetPosition(-200, -70, 0)
		self.leveltext:SetPosition(150,276,0)
		self.spell_list:SetPosition(5, 205, 0)
	    self.prevbutton:SetPosition(-380,-150,0)
    	self.nextbutton:SetPosition(280,-150,0)
		self.craftbutton:SetPosition(130,-130,0)
    	self.closebutton:SetPosition(390,300,0)
    elseif(self.caster.prefab=="wizard")then
		self.bgframe:SetPosition(20, 80, 0)
		self.spell:SetPosition(-130, -70, 0)
		self.leveltext:SetPosition(210,274,0)
		self.spell_list:SetPosition(78, 202, 0)
	    self.prevbutton:SetPosition(-280,-170,0)
    	self.nextbutton:SetPosition(320,-170,0)
		self.craftbutton:SetPosition(200,-120,0)
    	self.closebutton:SetPosition(450,295,0)
	elseif(self.caster.prefab=="cleric")then
		self.bgframe:SetPosition(82, 80, 0)
		self.spell:SetPosition(-60, -65, 0)
		self.leveltext:SetPosition(280,274,0)
		self.spell_list:SetPosition(135, 205, 0)
	    self.prevbutton:SetPosition(-175,-167,0)
    	self.nextbutton:SetPosition(325,-167,0)
		self.craftbutton:SetPosition(250,-110,0)
    	self.closebutton:SetPosition(450,295,0)
	end
end

function FASpellBookScreen:DoInit()
	SetPause(true,"fa_spellcraft")

    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,.75)	
    
	self.root = self:AddChild(Widget("ROOT"))
    self.root:SetVAnchor(ANCHOR_MIDDLE)
    self.root:SetHAnchor(ANCHOR_MIDDLE)
    self.root:SetPosition(0,0,0)
    self.root:SetScaleMode(SCALEMODE_NONE)

    self.bg = self.root:AddChild(Image("images/notebookparts/background.xml", "background.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(1, 1, 1)
--    self.bg:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

--	self.bgframe=self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookframe.xml", "fa_"..self.caster.prefab.."_bookframe.tex"))
    
		--[[
    self.title = self.root:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(-180, 200, 0)

    self.quote = self.root:AddChild(Text(BODYTEXTFONT, 30))
    self.quote:SetVAlign(ANCHOR_TOP)
    self.quote:SetPosition(-180, 70, 0)
    self.quote:EnableWordWrap(true)
    self.quote:SetRegionSize(250, 200)
]]
--    self.leveltext=self.root:AddChild(Text(UIFONT, 32))

    self.recipe = self.root:AddChild(Widget("RECIPE"))
--    self.recipe:SetPosition(130, 640, 0)

    self.recipe_list= self.root:AddChild(Widget("RECIPELIST"))

    self.prevbutton = self.root:AddChild(ImageButton("images/notebookparts/left.xml", "left.tex"))--, focus, disabled))
    self.prevbutton:SetOnClick(function()
    		if(self.page>1)then
	    		return self:SetCategory(self.category,self.page-1 )
	    	else
	    		return self:SetCategory(self.category-1,1)
	    	end
    	end)
    self.nextbutton = self.root:AddChild(ImageButton("images/notebookparts/right.xml", "right.tex"))
    self.nextbutton:SetOnClick(function()
    	if(self.currentcount and self.currentcount>self.page*PAGE_COUNT)then
    		return self:SetCategory(self.category,self.page+1)
    	else
	    	return self:SetCategory(self.category+1,1 )
	    end
    	end)
    self.closebutton = self.root:AddChild(ImageButton("images/notebookparts/Exit-button.xml", "Exit-button.tex"))
    self.closebutton:SetOnClick(function()
    	SetPause(false)
    	TheFrontEnd:PopScreen(self)
    end)

end

function FASpellBookScreen:SetCategory(category,page)
	self.leveltext:SetString("Level "..level)
	self.craftbutton:Hide()
	self.category=category
	self.page=page
--	print("level",level,"page",page)

	self.recipe_list:KillAllChildren()
	local list={}
	for i=1,#self.inst.fa_recipebook.recipes[category].recipes do
		local sp=self.inst.fa_recipebook.recipes[category][i]
		table.insert(list,sp)
	end
	self.currentcount=#list

	for i=0,4 do
		local r=list[(page-1)*PAGE_COUNT+i] 
		if(r)then
			local button=self.spell_list:AddChild(ImageButton(
				"images/inventoryimages/fa_inventoryimages.xml",
				r..".tex",
				r..".tex",
				r..".tex"
				))
			button:SetOnClick(function()
						return self:OnSelectRecipe(r)
					end)
			button:SetPosition(150,-i*YSEP-i*HH,0)
		end
	end

	if(self.currentcount>page*PAGE_COUNT)then
		self.nextbutton:Show()		
	else
		self.nextbutton:Hide()
	end
	if(page==1)then
		self.prevbutton:Hide()
	else
		self.prevbutton:Show()
	end

	return true
end

function FASpellBookScreen:OnSelectRecipe(r)
	self.selected=r
	self.recipe:KillAllChildren()
	local data=self.inst.components.fa_recipebook.recipes[self.category].matcher.hashtable[r]
	local product=data.product
	local cooktime=data.cooktime
	local ingreds={}
	for k,v in ipairs(data.test) do
		local ingred=self.recipe:AddChild(Widget())
		local t={}
		local ing=nil
		if(type(v.ingred)=="function")then
            ing = ingred:AddChild(Text(SMALLNUMBERFONT, 24))
            ing:SetString(matchers.FN_DESCRIPTION[v.ingred])
        end
		else
		    ing = ingred:AddChild(Image("images/inventoryimages/fa_inventoryimages", v.ingred))
		end
		local count=ingred:AddChild(Text(SMALLNUMBERFONT,24))
		count:SetString("X "..v.count)
	end

	return true
end


function FASpellBookScreen:OnUpdate( dt )
	return true
end

return FASpellBookScreen