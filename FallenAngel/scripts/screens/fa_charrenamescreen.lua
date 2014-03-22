require "util"
local Screen = require "widgets/screen"
local Button = require "widgets/button"
local AnimButton = require "widgets/animbutton"
local Image = require "widgets/image"
local UIAnim = require "widgets/uianim"
local NumericSpinner = require "widgets/numericspinner"
local TextEdit = require "widgets/textedit"
local Widget = require "widgets/widget"
local Text = require "widgets/text"

local VALID_CHARS = [[ abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789.,:;[]\@!#$%&()'*+-/=?^_{|}~"]]

local RENAME_TITLE_TEXT="Rename your character?"
local RENAME_BODY_TEXT="What would you like your tombstone to say?"

local FA_CharRenameScreen = Class(Screen, function(self,old)
	Screen._ctor(self, "ConsoleScreen")
	self:DoInit(old)
end)


function FA_CharRenameScreen:Run()
	local fnstr = self.console_edit:GetString()

	local player=GetPlayer()	
	if(player and fnstr and fnstr~="")then
		player.fa_playername=fnstr
	 	player:PushEvent("fa_playernamechanged",{playername=fnstr})
	else
		print("no player object to rename??")
	end
end

function FA_CharRenameScreen:Close()
	SetPause(false)
	TheFrontEnd:PopScreen()
end

function FA_CharRenameScreen:OnTextEntered()
	self:Run()
	self:Close()
end

function FA_CharRenameScreen:DoInit(old)
	SetPause(true,"console")
--darken everything behind the dialog
    self.black = self:AddChild(Image("images/global.xml", "square.tex"))
    self.black:SetVRegPoint(ANCHOR_MIDDLE)
    self.black:SetHRegPoint(ANCHOR_MIDDLE)
    self.black:SetVAnchor(ANCHOR_MIDDLE)
    self.black:SetHAnchor(ANCHOR_MIDDLE)
    self.black:SetScaleMode(SCALEMODE_FILLSCREEN)
	self.black:SetTint(0,0,0,.75)	
    
	self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetVAnchor(ANCHOR_MIDDLE)
    self.proot:SetHAnchor(ANCHOR_MIDDLE)
    self.proot:SetPosition(0,0,0)
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL)

	--throw up the background
    self.bg = self.proot:AddChild(Image("images/globalpanels.xml", "small_dialog.tex"))
    self.bg:SetVRegPoint(ANCHOR_MIDDLE)
    self.bg:SetHRegPoint(ANCHOR_MIDDLE)
	self.bg:SetScale(1.2,1.2,1.2)

--[[	
	if #buttons >2 then
		self.bg:SetScale(2,1.2,1.2)
	end
	]]

	--title	
    self.title = self.proot:AddChild(Text(TITLEFONT, 50))
    self.title:SetPosition(0, 70, 0)
    self.title:SetString(RENAME_TITLE_TEXT)

	--text
    self.text = self.proot:AddChild(Text(BODYTEXTFONT, 25))

    self.text:SetPosition(0, 5, 0)
    self.text:SetString(RENAME_BODY_TEXT)
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(500, 80)


	local label_width = 200
	local label_height = 50
	local label_offset = 450

	local space_between = 30
	local height_offset = -270

	local fontsize = 30
	
	local edit_width = 450
	local edit_bg_padding = 50
  
   
    self.edit_bg = self.proot:AddChild( Image() )
	self.edit_bg:SetTexture( "images/ui.xml", "textbox_long.tex" )
	self.edit_bg:SetPosition( 0,-90,0)
	self.edit_bg:ScaleToSize( edit_width + edit_bg_padding, label_height )

	self.console_edit = self.proot:AddChild( TextEdit( DEFAULTFONT, fontsize, "" ) )
	self.console_edit:SetPosition( 0,-90,0)
	self.console_edit:SetRegionSize( edit_width, label_height )
	self.console_edit:SetHAlign(ANCHOR_LEFT)

	self.console_edit.OnTextEntered = function() self:OnTextEntered() end
	self.console_edit:SetFocusedImage( self.edit_bg, "images/ui.xml", "textbox_long_over.tex", "textbox_long.tex" )
	self.console_edit:SetCharacterFilter( VALID_CHARS )

	self.console_edit:SetString(old or "")
	self.history_idx = nil

	self.console_edit.validrawkeys[KEY_TAB] = false
	self.console_edit.validrawkeys[KEY_UP] = false
	self.console_edit.validrawkeys[KEY_DOWN] = false
--[[
	 local spacing = 200

	self.menu = self.proot:AddChild(Menu(buttons, spacing, true))
	self.menu:SetPosition(-(spacing*(#buttons-1))/2, -70, 0) 
	self.buttons = buttons
]]	
	self.default_focus = self.console_edit

end

return FA_CharRenameScreen