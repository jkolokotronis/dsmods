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

	local HSEP=16
	local YSEP=14
	local HW=64
	local HH=64

--TODO write a proper factory 
FASpellBookScreen = Class(Screen, function(self,caster,level)
	Screen._ctor(self, "FASpellBookScreen")
	self.caster=caster or GetPlayer()
	self:DoInit()
	self:SetLevel(level or 1)
end)

function FASpellBookScreen:InitClass()
	if(self.caster.prefab=="druid")then
		self.bgframe:SetPosition(-35, 84, 0)
		self.spell:SetPosition(-200, -70, 0)
		self.spell_list:SetPosition(5, 205, 0)
	    self.prevbutton:SetPosition(-380,-150,0)
    	self.nextbutton:SetPosition(280,-150,0)
		self.craftbutton:SetPosition(130,-130,0)
    	self.closebutton:SetPosition(390,300,0)
    elseif(self.caster.prefab=="wizard")then
		self.bgframe:SetPosition(20, 80, 0)
		self.spell:SetPosition(-130, -70, 0)
		self.spell_list:SetPosition(78, 202, 0)
	    self.prevbutton:SetPosition(-280,-170,0)
    	self.nextbutton:SetPosition(320,-170,0)
		self.craftbutton:SetPosition(200,-120,0)
    	self.closebutton:SetPosition(450,295,0)
	elseif(self.caster.prefab=="cleric")then
		self.bgframe:SetPosition(82, 80, 0)
		self.spell:SetPosition(-60, -65, 0)
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

    self.bg = self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookbackground.xml", "fa_"..self.caster.prefab.."_bookbackground.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(1, 1, 1)
--    self.bg:SetScaleMode(SCALEMODE_FIXEDSCREEN_NONDYNAMIC)

	self.bgframe=self.root:AddChild(Image("images/fa_"..self.caster.prefab.."_bookframe.xml", "fa_"..self.caster.prefab.."_bookframe.tex"))
    
		
    self.title = self.root:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(-180, 200, 0)

    self.quote = self.root:AddChild(Text(BODYTEXTFONT, 30))
    self.quote:SetVAlign(ANCHOR_TOP)
    self.quote:SetPosition(-180, 70, 0)
    self.quote:EnableWordWrap(true)
    self.quote:SetRegionSize(250, 200)

    self.spell = self.root:AddChild(Widget("SPELL"))

    self.spell_list= self.root:AddChild(Widget("SPELLLIST"))

    self.prevbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookprev.xml", "fa_"..self.caster.prefab.."_bookprev.tex"))--, focus, disabled))
    self.prevbutton:SetOnClick(function()
    		return self:SetLevel(self.level-1 )
    	end)
    self.nextbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_booknext.xml", "fa_"..self.caster.prefab.."_booknext.tex"))
    self.nextbutton:SetOnClick(function()
    	return self:SetLevel(self.level+1 )
    	end)
    self.craftbutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookcraft.xml", "fa_"..self.caster.prefab.."_bookcraft.tex"))
    self.craftbutton:SetOnClick(function() return self:CraftSpell(self.selected) end)
    self.closebutton = self.root:AddChild(ImageButton("images/fa_"..self.caster.prefab.."_bookclose.xml", "fa_"..self.caster.prefab.."_bookclose.tex"))
    self.closebutton:SetOnClick(function()
    	SetPause(false)
    	TheFrontEnd:PopScreen(self)
    end)

    self:InitClass()
end

function FASpellBookScreen:SetLevel(level)
--	self.craftbutton:Hide()
	self.level=level
	print("level",level)
	
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
	for i=0,3,1 do
		for j=0,3 do
			local spell=list[i*4+j+1]
			if(spell)then
			local button=self.spell_list:AddChild(ImageButton(
				"images/inventoryimages/fa_scroll_"..spell.school..".xml",
				"fa_scroll_"..spell.school..".tex",
				"fa_scroll_"..spell.school..".tex",
				"fa_scroll_"..spell.school..".tex"
				))
				
--				button:SetText(""..(i*4+j+1))
				if(self.caster.components.builder:KnowsRecipe(spell.recname))then
					button:SetOnClick(function()
						return self:OnSelectSpell(spell)
					end)
				else
--					button:Disable()
				end
				button:SetPosition(j*HSEP+j*HW,-i*YSEP-i*HH,0)
			else
--				button:SetText("N/A")
--				button:Disable()
			end
		end
	end

	return true
end

function FASpellBookScreen:OnSelectSpell(spell)
	self.selected=spell
	self.spell:KillAllChildren()
	local popup=self.spell:AddChild(FA_SpellPopup(true))
--	popup:SetRecipe( GetRecipe(spell.recname),self.caster)
	popup:SetSpell(spell,self.caster)
    local can_build = self.caster.components.builder:CanBuild(spell.recname)
--	local can_build=true
	popup:SetPosition(-280,120,0)
	if(can_build)then
		self.craftbutton:Show()
	else
		self.craftbutton:Hide()
	end

	return true
end

function FASpellBookScreen:CraftSpell(spell)
	local owner=self.caster
	local recipe=GetRecipe(spell.recname)
	local old_ingredientmod=self.caster.components.builder.ingredientmod
	--technically this 'could' lead to race condition but there's very little chance for that
	--do i want additive behavior to the ammu? or any other type of 'lowering' the req?
	if(self.caster.prefab=="wizard" and self.caster.components.xplevel and self.caster.components.xplevel.level>=20) then
		self.caster.components.builder.ingredientmod=0.75*old_ingredientmod
	end
        local buffered = self.caster.components.builder:IsBuildBuffered(recipe.name)
        if buffered then
            if recipe.placer then
                self.caster.components.playercontroller:StartBuildPlacementMode(recipe, function(pt) return self.caster.components.builder:CanBuildAtPoint(pt, recipe) end)
            else
				self.caster.components.builder:DoBuild(spell.recname)
            end
        else
            if recipe.placer then
                self.caster.components.builder:BufferBuild(recipe.name)
                self.caster.components.playercontroller:StartBuildPlacementMode(recipe, function(pt) return self.caster.components.builder:CanBuildAtPoint(pt, recipe) end)
            else
                self.caster.components.builder:DoBuild(spell.recname)
            end
        end

    self.caster.components.builder.ingredientmod=old_ingredientmod

    if(recipe.placer)then
    	SetPause(false)
	  	TheFrontEnd:PopScreen(self)
	  	return
	end
	self:OnSelectSpell(spell)
end

function FASpellBookScreen:OnUpdate( dt )
	return true
end

return FASpellBookScreen