local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
require "constants"

local CooldownButton = Class(Widget, function(self, data)

    local init=data or {}
    Widget._ctor(self, "COOLDOWNBUTTON")
    self.image = self:AddChild(Image())
    self.image:MoveToBack()

    self.text = self:AddChild(Text(DEFAULTFONT, 30))
--    self.text:Hide()
    self.cooldowntext=self:AddChild(Text(DEFAULTFONT,20))
    self.cooldowntext:SetPosition(-10,10,0)
    self.cooldowntext:SetColour(255/255,0,0,1)
    self.cooldowntext:Hide()
    self.cooldowntext:SetString("n/a")

    self.disabledtex=init.disabled or {}
    self.disabledtex.atlas=self.disabledtex.atlas or "images/ui.xml"
    self.disabledtex.tex=self.disabledtex.tex or "button_small_disabled.tex"
    self.normaltex=init.normaltex or {}
    self.normaltex.tex=self.normaltex.tex or "button_small.tex"
    self.normaltex.atlas=self.normaltex.atlas or "images/ui.xml"
    self.overtex=init.overtex or {}
    self.overtex.tex=self.overtex.tex or "button_small_over.tex"
    self.overtex.atlas=self.overtex.atlas or "images/ui.xml"
    self.text:SetString(init.text or "cooldown")
    if(init.fn)then
        self.OnClick=fn
    end

    self.image:SetTexture(self.normaltex.atlas,self.normaltex.tex)
    self.image:SetMouseOverTexture(self.overtex.atlas,self.overtex.tex)
    self.image:SetDisabledTexture(self.disabledtex.atlas,self.disabledtex.tex)
   
    self.cooldown=init.cooldown or 60
    self.cooldowntimer=0
    self.cooldowntask=nil
end)

function CooldownButton:countdownfn()
    self.cooldowntimer=self.cooldowntimer-1
    if(self.cooldowntimer<=0 and  self.cooldowntask)then
        self.cooldowntask:Cancel()
        self.cooldowntask=nil
        self:Enable()
        self.cooldowntext:Hide()
        if(self.OnCountdownOver)then
            self.OnCountdownOver()
        end
    else
        self.cooldowntext:SetString(""..self.cooldowntimer)
    end    
end

function CooldownButton:OnMouseButton(button, down, x, y)
	if not self.focus then return false end
    if(button==MOUSEBUTTON_LEFT and not down) then
    	self:DoClick()
    end
    for k,v in pairs (self.children) do
        if v.focus and v:OnMouseButton(button, down, x, y) then return true end
    end 

end

function CooldownButton:SetCooldown(cd)
    self.cooldown=cd
end

function CooldownButton:SetOnCountdownOver(fn)
    self.OnCountdownOver=fn
end
--[[
function CooldownButton:OnGainFocus()
	if(not self.cooldowntask) then
		self.image:SetTexture("images/ui.xml","button_small_over.tex")
	end
end

function CooldownButton:OnLoseFocus()
	if(not self.cooldowntask) then
		self.image:SetTexture("images/ui.xml","button_small.tex")
	end
end
]]

function CooldownButton:Enable()
	self._base.Enable(self)
    self.image:SetTexture(self.normaltex.atlas,self.normaltex.tex)
end

function CooldownButton:Disable()
	self._base.Disable(self)
	self.image:SetTexture(self.disabledtex.atlas,self.disabledtex.tex)
end

function CooldownButton:SetFont(font)
	self.text:SetFont(font)
end

function CooldownButton:SetOnClick( fn )
    self.OnClick = fn
end

function CooldownButton:GetSize()
    return self.image:GetSize()
end


function CooldownButton:DoClick()
    if(self.enabled)then
    local success=true
    if self.OnClick ~= nil then
        success=self.OnClick(self.state)
    end
    --don't want to start cooldowns if ability did no effect
    if(success)then
        self:Disable()
        self.cooldowntimer=self.cooldown
        self.cooldowntext:Show()
        self.cooldowntext:SetString(""..self.cooldown)
        --why self:DoPeriodicTask not working?
        self.cooldowntask=GetPlayer():DoPeriodicTask(1, function() self:countdownfn() end)
    end
end
end

function CooldownButton:ForceCooldown(state)
    self.cooldowntimer=state
    if(state>0)then
        self:Disable()
        self:Show()
        self.cooldowntext:Show()
        self.cooldowntext:SetString(""..self.cooldown)
        self.cooldowntask=GetPlayer():DoPeriodicTask(1, function() self:countdownfn() end)
    else
        self:Enable()
        if(self.cooldowntask)then
            self.cooldowntask:Cancel()
            self.cooldowntask=nil
            self.cooldowntext:Hide()
        end
    end
end
 

function CooldownButton:SetTextSize(sz)
	self.text:SetSize(sz)
end

function CooldownButton:SetText(msg)
        self.text:SetString(msg)
end

function CooldownButton:OnMouseOver()
	if self.enabled then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover")
	end
	Widget.OnMouseOver( self )
end

return CooldownButton