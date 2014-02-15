local Widget = require "widgets/widget"
local Text = require "widgets/text"
require "constants"

--[[
MOUSEBUTTON_LEFT = 1000
MOUSEBUTTON_RIGHT = 1001
MOUSEBUTTON_MIDDLE = 1002
MOUSEBUTTON_SCROLLUP = 1003
MOUSEBUTTON_SCROLLDOWN = 1004
]]--

local ToggleBuff = Class(Widget, function(self, data)
    Widget._ctor(self, "TOGGLE")
    self.image = self:AddChild(Image())

    self.image:MoveToBack()

    self.text = self:AddChild(Text(DEFAULTFONT, 30))
--    self.text:Hide()
    
    self.state = data.state or "off"
	self.states = data.states or {"on", "off", "optional"}
	
	if data ~= nil then
		local is_good = true
		for i,state in ipairs(self.states) do
			if data[state] == nil then
				is_good = false
				break
			end
		end
		
		if is_good then
			self:SetImages(data)
		end
		if data.disabled ~= nil then
			self:SetDisabledImage(data.disabled)
		end
	end
    self.image:SetTexture(self.normaltex[self.state].atlas,self.normaltex[self.state].tex)
    self.image:SetMouseOverTexture(self.normaltex["on"].atlas,self.normaltex["on"].tex)
    self.image:SetDisabledTexture(self.disabledtex.atlas,self.disabledtex.tex)
   



end)

function ToggleBuff:OnMouseButton(button, down, x, y)
	if not self.focus then return false end
    print("onmousedown",button,down,x,y)
    if(button==MOUSEBUTTON_LEFT and not down) then
    	self:DoToggle()
    end
    for k,v in pairs (self.children) do
        if v.focus and v:OnMouseButton(button, down, x, y) then return true end
    end 

end


function ToggleBuff:OnGainFocus()
	if(self.state=="off") then
		self.image:SetTexture(self.normaltex["on"].atlas,self.normaltex["on"].tex)
	end
end

function ToggleBuff:OnLoseFocus()
	if(self.state=="off") then
		self.image:SetTexture(self.normaltex["off"].atlas,self.normaltex["off"].tex)
	end
end

function ToggleBuff:Enable()
	self._base.Enable(self)
    self.image:SetTexture(self.normaltex[self.state].atlas,self.normaltex[self.state].tex)
end

function ToggleBuff:Disable()
	self._base.Disable(self)
	self.image:SetTexture(self.disabledtex.atlas,self.disabledtex.tex)
end

function ToggleBuff:SetFont(font)
	self.text:SetFont(font)
end

function ToggleBuff:SetOnClick( fn )
    self.OnChanged = fn
end

function ToggleBuff:GetSize()
    return self.image:GetSize()
end

function ToggleBuff:SetImages(tex)
    self.normaltex = tex    
    self.image:SetTexture(self.normaltex[self.state].atlas,self.normaltex[self.state].tex)
end

function ToggleBuff:SetMouseOverImage(tex)
    self.mouseovertex = tex
end

function ToggleBuff:DoToggle(setval)
	if setval ~= nil then
    	self.state = setval
    else
    	if(self.state and self.state=="off") then
    		self.state="on"
    	else
    		self.state="off"
    	end
    end
    
    if self.OnChanged ~= nil then
    	self.OnChanged(self.state)
    end
    
    --print("Toggle:",self.state)
    self.image:SetTexture(self.normaltex[self.state].atlas,self.normaltex[self.state].tex)
end
 
function ToggleBuff:SetDisabledImage(tex)
    self.disabledtex = tex
end

function ToggleBuff:SetTextSize(sz)
	self.text:SetSize(sz)
end

function ToggleBuff:SetText(msg)
    if msg then
        self.text:SetString(msg)
        self.text:Show()
    else
        self.text:Hide()
    end
end

function ToggleBuff:OnMouseOver()
	if self.enabled then
		TheFrontEnd:GetSound():PlaySound("dontstarve/HUD/click_mouseover")
	end
	Widget.OnMouseOver( self )
end

return ToggleBuff