local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local NumericSpinner = require "widgets/numericspinner"
local IngredientUI = require "widgets/ingredientui"
local IngredientUI = require "widgets/recipepopup"


FASpellBookScreen = Class(Screen, function(self,caster,level)
	Screen._ctor(self, "FASpellBookScreen")
	self.caster=caster
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
    self.root:SetScaleMode(SCALEMODE_PROPORTIONAL)

    self.bg = self.root:AddChild(Image("images/fa"..castername.."_bookbackground.xml", "fa_"..castername.."_bookbackground.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(1, 1, 1)
		
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
    self.spell:SetRegionSize(350, 400)

    self.spell_list= self.root:AddChild(Widget("SPELLLIST"))
--    self.spell:SetHAlign(ANCHOR_LEFT)
--    self.spell:SetVAlign(ANCHOR_TOP)
    self.spell_list:SetPosition(100, -70, 0)
    self.spell_list:SetRegionSize(350, 400)

    self.prevbutton = self.root:AddChild(ImageButton(atlas, normal, focus, disabled))
    self.prevbutton:SetPosition(100,300,0)
    self.nextbutton = self.root:AddChild(ImageButton(atlas, normal, focus, disabled))
    self.nextbutton:SetPosition(100,300,0)
    self.craftbutton = self.root:AddChild(ImageButton(atlas, normal, focus, disabled))
    self.craftbutton:SetPosition(100,300,0)
    self.closebutton = self.root:AddChild(ImageButton(atlas, normal, focus, disabled))
    self.closebutton:SetPosition(100,300,0)
    self.closebutton:SetOnClick(function()
    	TheFrontEnd:PopScreen(self)
    end)


end

function FASpellBookScreen:SetLevel(level)
	HSEP=5
	YSEP=5
	HW=64
	HH=64

	self.spell_list:KillAllChildren()
	local list=self.caster.fa_spellcraft.spells[level]
	for i=0,3 do
		for j=0,3 do
			local spell=list[i*4+j+1]
			local button=self.spell_list:AddChild(TextButton())
			if(spell)then
				
				button:SetText(""..(i*4+j+1))
				if(self.caster.components.builder:KnownRecipe(spell.recname))then
					button:SetOnClick(function()
						return self:OnSelectSpell(spell)
					end)
				else
					button:Disable()
				end
			else
				button:SetText("N/A")
				button:Disable()
			end
			button:SetPosition((1+j)*HSEP+j*HW,(1+i)*YSEP+i*HH,0)
		end
	end

	return true
end

function FASpellBookScreen:OnSelectSpell(spell)
	self.spell:KillAllChildren()
	local popup=self.spell:AddChild(RecipePopup(true))
	popup:SetRecipe( GetRecipe(spell.recname),self.caster)
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