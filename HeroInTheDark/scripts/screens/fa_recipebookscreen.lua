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
local matchers=require "fa_smelter_matcher"
local FA_SpellPopup = require "widgets/fa_spellpopup"
	local HSEP=16
	local YSEP=15
	local HW=64
	local HH=64
	local PAGE_COUNT=5


FARecipeBookScreen = Class(Screen, function(self,caster,category,page)
	Screen._ctor(self, "FARecipeBookScreen")
	self.caster=caster or GetPlayer()
	self:DoInit()

    self.category=category or "KegMatcher" 
    self.page=page or 1
    self:SetCategory(self.category,self.page)
end)


function FARecipeBookScreen:DoInit()
	SetPause(true,"fa_recipecraft")

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

    self.sketch = self.root:AddChild(Image("images/notebookparts/notebookparts.xml", "Foodpot-sketch.tex"))
    self.sketch:SetVRegPoint(ANCHOR_MIDDLE)
    self.sketch:SetHRegPoint(ANCHOR_MIDDLE)
    self.sketch:SetPosition(240,-190,0)

--	self.bgframe=self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookframe.xml", "fa_"..self.caster.prefab.."_bookframe.tex"))
    

    self.recipe = self.root:AddChild(Widget("RECIPE"))
	self.recipe:SetPosition(150,180,0)

    self.recipe_list= self.root:AddChild(Widget("RECIPELIST"))
	self.recipe_list:SetPosition(-340,280,0)


	self.foodbutton=self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml","food_drinks-tab.tex", "food_drinks-tab-Kopie.tex"))
	self.foodbutton:SetPosition(117-453,3+300,0)
    self.foodbutton:SetOnClick(function()
    	self:SetCategory("KegMatcher",1, "Foodpot-sketch.tex")
    	end)
	self.forgebutton=self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml","forge-tab.tex", "forge-tab-Kopie.tex"))
	self.forgebutton:SetPosition(265-458,14+280,0)
    self.forgebutton:SetOnClick(function()
    	self:SetCategory("ForgeMatcher",1,"Forge-sketch.tex")
    	end)
	self.smelterbutton=self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml","smelter-tab.tex", "smelter-tab-Kopie.tex"))
	self.smelterbutton:SetPosition(414-466,14+270,0)
    self.smelterbutton:SetOnClick(function()
    	self:SetCategory("SmelterMatcher",1,"Smelter-sketch.tex")
    	end)
	self.alchemybutton=self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml","alchemy-tab.tex", "alchemy-tab-Kopie.tex"))
	self.alchemybutton:SetPosition(573-446,0+302,0)
    self.alchemybutton:SetOnClick(function()
    	self:SetCategory("AlchemyMatcher",1,"Alchemy-table-sketch.tex")
    	end)
	self.otherbutton=self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml","other-tab.tex", "other-tab-Kopie.tex"))
	self.otherbutton:SetPosition(747-460,18+280,0)
    self.otherbutton:SetOnClick(function()
    	self:SetCategory("DistillerMatcher",1,"Other-sketch.tex")
    	end)


    self.prevbutton = self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml", "left.tex"))--, focus, disabled))
	self.prevbutton:SetPosition(-300,-195,0)
    self.prevbutton:SetOnClick(function()
    		if(self.page>1)then
	    		return self:SetCategory(self.category,self.page-1 )
	    	else
	    		return self:SetCategory(self.category-1,1)
	    	end
    	end)
    self.nextbutton = self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml", "right.tex"))
	self.nextbutton:SetPosition(-100,-195,0)
    self.nextbutton:SetOnClick(function()
    	if(self.currentcount and self.currentcount>self.page*PAGE_COUNT)then
    		return self:SetCategory(self.category,self.page+1)
    	else
	    	return self:SetCategory(self.category+1,1 )
	    end
    	end)

    self.closebutton = self.root:AddChild(ImageButton("images/notebookparts/notebookparts.xml", "Exit-button.tex"))
	self.closebutton:SetPosition(938-487,26+234,0)
    self.closebutton:SetOnClick(function()
    	SetPause(false)
    	TheFrontEnd:PopScreen(self)
    end)

--    self:InitClass()
end

function FARecipeBookScreen:SetCategory(category,page,tex)
	self.category=category
	self.page=page
	if(tex~=nil)then
		self.sketch:SetTexture("images/notebookparts/notebookparts.xml", tex)
	end
	print("category",category,"page",page)

	self.recipe_list:KillAllChildren()
	self.recipe:KillAllChildren()
	local list={}
	for i=1,#self.caster.components.fa_recipebook.recipes[category].recipes do
		local sp=self.caster.components.fa_recipebook.recipes[category].recipes[i]
		print("sp",i,sp)
		table.insert(list,sp)
	end
	self.currentcount=#list
	print("count",#list)

	for i=1,5 do
		local r=list[(page-1)*PAGE_COUNT+i] 
		print(r)
		if(r)then
			local button=self.recipe_list:AddChild(ImageButton(
				"images/inventoryimages/fa_inventoryimages.xml",
				r..".tex",
				r..".tex",
				r..".tex"
				))
			button:SetOnClick(function()
						return self:OnSelectRecipe(r)
					end)
			button:SetPosition(0,-i*YSEP-i*HH,0)
			local text= self.recipe_list:AddChild(Text(BODYTEXTFONT, 28))
--    		self.quote:SetVAlign(ANCHOR_TOP)
    		text:SetPosition(100,-i*YSEP-i*HH,0)
		    text:EnableWordWrap(true)
    		text:SetRegionSize(250, 80)
--    		print("r:",r,"string",STRINGS.NAMES[string.upper(r)])
    		text:SetString(STRINGS.NAMES[string.upper(r)])
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

function FARecipeBookScreen:OnSelectRecipe(r)
	self.selected=r
	self.recipe:KillAllChildren()
	local data=self.caster.components.fa_recipebook.recipes[self.category].matcher.hashtable[r]
	local product=data.product
	local cooktime=data.cooktime
	local ingreds={}
	local i=0
	for k,v in ipairs(data.test) do
		local ingred=self.recipe:AddChild(Widget("ing"))
		local t={}
		local ing=nil
		if(type(v.ingred)=="function")then
            ing = ingred:AddChild(Text(SMALLNUMBERFONT, 28))
            ing:SetString(matchers.FN_DESCRIPTION[v.ingred])
		else
			print("ingred",v.ingred)
			-- ui data does not belong to matcher level... screw oop principles
			local atlas=v.atlas or "images/inventoryimages/fa_inventoryimages.xml"
		    ing = ingred:AddChild(Image(atlas, v.ingred..".tex"))
		end
		local count=ingred:AddChild(Text(SMALLNUMBERFONT,28))
		count:SetString(v.count.." X ")
  		count:SetPosition(0,-i*YSEP-i*HH,0)
   		ing:SetPosition(80,-i*YSEP-i*HH,0)
   		i=i+1
	end

	return true
end


function FARecipeBookScreen:OnUpdate( dt )
	return true
end

return FARecipeBookScreen









