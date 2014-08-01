local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
require "constants"

local DEFAULT_TINT={
            r=0.5,
            g=0.5,
            b=1,
            a=0.7
        }

local FA_BuffButton = Class(Widget, function(self,owner, data)

    local init=data or {}
    Widget._ctor(self, "COOLDOWNBUTTON",owner)
    self.owner=owner or GetPlayer()
    self.image = self:AddChild(Image())
    self.image:MoveToBack()

    self.text = self:AddChild(Text(DEFAULTFONT, 16))
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(100,40)
--    self.text:Hide()
    self.cooldowntext=self:AddChild(Text(DEFAULTFONT,20))
    self.cooldowntext:SetPosition(-10,10,0)

    self.cooldowntext:SetColour(255/255,0,0,1)
--    self.cooldowntext:Hide()
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
    local tint=data and  data.buttontint
    if(not tint)then
        tint=DEFAULT_TINT
    end
    self.image:SetTint(tint.r,tint.g,tint.b,tint.a)

end)

function FA_BuffButton:OnControl(control, down)

    if not self.focus then return false end
    if(control==CONTROL_ACCEPT and not down) then
        self:DoClick()
    end
    for k,v in pairs (self.children) do
        if v.focus and v:OnControl(control, down) then return true end
    end 

    return false
end



function FA_BuffButton:Enable()
	self._base.Enable(self)
    self.image:SetTexture(self.normaltex.atlas,self.normaltex.tex)
end

function FA_BuffButton:Disable()
	self._base.Disable(self)
	self.image:SetTexture(self.disabledtex.atlas,self.disabledtex.tex)
end

function FA_BuffButton:SetFont(font)
	self.text:SetFont(font)
end

function FA_BuffButton:SetOnClick( fn )
    self.OnClick = fn
end

function FA_BuffButton:GetSize()
    return self.image:GetSize()
end


function FA_BuffButton:DoClick()
    --[[
    if(self.enabled)then
    local success=true
    if self.OnClick ~= nil then
        success=self.OnClick(self.state)
    end
    --don't want to start cooldowns if ability did no effect
    if(success)then
        self:Disable()
        self.cooldowntimer=self.cooldown
        self.cooldowntimerstart=GetTime()
        self.cooldowntext:Show()
        self.cooldowntext:SetString(""..math.floor(self.cooldown))
    end
end]]
end

function FA_BuffButton:SetTextSize(sz)
	self.text:SetSize(sz)
end

function FA_BuffButton:SetText(msg)
        self.text:SetString(msg)
end


return FA_BuffButton