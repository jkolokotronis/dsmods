local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
require "constants"

local DEFAULT_TINT={
            r=1,
            g=1,
            b=1,
            a=1
        }

local FA_StatusButton = Class(Widget, function(self,owner, data)

    local init=data or {}
    Widget._ctor(self, "COOLDOWNBUTTON",owner)
    self.owner=owner or GetPlayer()
    self.image = self:AddChild(Image())
    self.image:MoveToBack()

    self.text = self:AddChild(Text(DEFAULTFONT, 12))
    self.text:EnableWordWrap(true)
    self.text:SetRegionSize(32,32)
    self.text:SetColour(1,1,1,1)
--    self.text:Hide()
    self.cooldowntext=self:AddChild(Text(DEFAULTFONT,12))
    self.cooldowntext:SetPosition(-10,10,0)

    self.cooldowntext:SetColour(255/255,0,0,1)
    self.cooldowntext:Hide()
    self.cooldowntext:SetString("n/a")

    self.disabledtex=init.disabled or {}
    self.disabledtex.atlas=self.disabledtex.atlas or "images/inventoryimages/fa_inventoryimages.xml"
    self.disabledtex.tex=self.disabledtex.tex or "fa_white.tex"
    self.normaltex=init.normaltex or {}
    self.normaltex.tex=self.normaltex.tex or "fa_white.tex"
    self.normaltex.atlas=self.normaltex.atlas or "images/inventoryimages/fa_inventoryimages.xml"
    self.overtex=init.overtex or {}
    self.overtex.tex=self.overtex.tex or "fa_white.tex"
    self.overtex.atlas=self.overtex.atlas or "images/inventoryimages/fa_inventoryimages.xml"
    self.text:SetString(init.text or "")
    if(init.fn)then
        self.OnClick=fn
    end

    self.image:SetTexture(self.normaltex.atlas,self.normaltex.tex)
    self.image:SetMouseOverTexture(self.overtex.atlas,self.overtex.tex)
    self.image:SetDisabledTexture(self.disabledtex.atlas,self.disabledtex.tex)
    local tint=data.buttontint
    if(not tint)then
        tint=DEFAULT_TINT
    end
    self.image:SetTint(tint.r,tint.g,tint.b,tint.a)
    self.image:SetScale(0.5,0.5,0)

end)

function FA_StatusButton:OnControl(control, down)

    if not self.focus then return false end
    if(control==CONTROL_ACCEPT and not down) then
        self:DoClick()
    end
    for k,v in pairs (self.children) do
        if v.focus and v:OnControl(control, down) then return true end
    end 

    return false
end



function FA_StatusButton:Enable()
	self._base.Enable(self)
    self.image:SetTexture(self.normaltex.atlas,self.normaltex.tex)
end

function FA_StatusButton:Disable()
	self._base.Disable(self)
	self.image:SetTexture(self.disabledtex.atlas,self.disabledtex.tex)
end

function FA_StatusButton:SetFont(font)
	self.text:SetFont(font)
end

function FA_StatusButton:SetOnClick( fn )
    self.OnClick = fn
end

function FA_StatusButton:GetSize()
    return self.image:GetSize()
end


function FA_StatusButton:DoClick()
end

function FA_StatusButton:SetTextSize(sz)
	self.text:SetSize(sz)
end

function FA_StatusButton:SetText(msg)
        self.text:SetString(msg)
end


return FA_StatusButton