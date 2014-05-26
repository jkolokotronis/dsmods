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
local RecipePopup = require "widgets/recipepopup"

	local HSEP=16
	local YSEP=14
	local HW=64
	local HH=64

FASpellBookScreen = Class(Screen, function(self,caster,level)
	Screen._ctor(self, "FASpellBookScreen")
	self.caster=caster or GetPlayer()
	self:DoInit()
	self:SetLevel(level or 1)
end)

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

    self.bg = self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookbackground.xml", "fa_"..self.caster.prefab.."_bookbackground.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(1, 1, 1)
--    self.bg:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

	self.bgframe=self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookframe.xml", "fa_"..self.caster.prefab.."_bookframe.tex"))
    self.bgframe:SetPosition(-35, 84, 0)
		
    self.title = self.root:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(-180, 200, 0)

    self.quote = self.root:AddChild(Text(BODYTEXTFONT, 30))
    self.quote:SetVAlign(ANCHOR_TOP)
    self.quote:SetPosition(-180, 70, 0)
    self.quote:EnableWordWrap(true)
    self.quote:SetRegionSize(250, 200)

    self.spell = self.root:AddChild(Widget("SPELL"))
--    self.spell:SetHAlign(ANCHOR_LEFT)
--    self.spell:SetVAlign(ANCHOR_TOP)
    self.spell:SetPosition(-200, -70, 0)
--    self.spell:SetRegionSize(350, 400)

    self.spell_list= self.root:AddChild(Widget("SPELLLIST"))
--    self.spell:SetHAlign(ANCHOR_LEFT)
--    self.spell:SetVAlign(ANCHOR_TOP)
    self.spell_list:SetPosition(0, -30, 0)
 --   self.spell_list:SetRegionSize(350, 400)

    self.prevbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookprev.xml", "fa_"..self.caster.prefab.."_bookprev.tex"))--, focus, disabled))
    self.prevbutton:SetPosition(-380,-150,0)
    self.prevbutton:SetOnClick(function()
    		self:SetLevel(self.level-1 )
    	end)
    self.nextbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_booknext.xml", "fa_"..self.caster.prefab.."_booknext.tex"))
    self.nextbutton:SetPosition(280,-150,0)
    self.prevbutton:SetOnClick(function()
    	self:SetLevel(self.level+1 )
    	end)
    self.craftbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookcraft.xml", "fa_"..self.caster.prefab.."_bookcraft.tex"))
    self.craftbutton:SetPosition(130,-130,0)
    self.craftbutton:SetOnClick(function() self:CraftSpell(self.selected) end)
    self.closebutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookclose.xml", "fa_"..self.caster.prefab.."_bookclose.tex"))
    self.closebutton:SetPosition(390,300,0)
    self.closebutton:SetOnClick(function()
    	SetPause(false)
    	TheFrontEnd:PopScreen(self)
    end)


end

function FASpellBookScreen:SetLevel(level)
	self.level=level
	
	if(not self.caster.fa_spellcraft.spells[level+1])then
		self.nextbutton:Hide()
	else
		self.nextbutton:Show()
	end
	if(level==1)then
		self.prevbutton:Hide()
	else
		self.prevbutton:Show()
	end

	self.spell_list:KillAllChildren()
	local list=self.caster.fa_spellcraft.spells[level]
	for i=3,0,-1 do
		for j=0,3 do
			local spell=list[i*4+j+1]
			local button=self.spell_list:AddChild(TextButton())
			if(spell)then
				
				button:SetText(""..(i*4+j+1))
				if(self.caster.components.builder:KnowsRecipe(spell.recname))then
					button:SetOnClick(function()
						return self:OnSelectSpell(spell)
					end)
				else
--					button:Disable()
				end
			else
				button:SetText("N/A")
--				button:Disable()
			end
			button:SetPosition(j*HSEP+j*HW,i*YSEP+i*HH,0)
		end
	end

	return true
end

function FASpellBookScreen:OnSelectSpell(spell)
	self.selected=spell
	self.spell:KillAllChildren()
	local popup=self.spell:AddChild(RecipePopup(true))
	popup:SetRecipe( GetRecipe(spell.recname),self.caster)
	popup:SetPosition(-280,120,0)
	return true
end

function FASpellBookScreen:CraftSpell(spell)
	self.caster.components.builder:DoBuild(spell.recname)
	self:OnSelectSpell(spell)
end

function FASpellBookScreen:OnUpdate( dt )
	return true
end

return FASpellBookScreen