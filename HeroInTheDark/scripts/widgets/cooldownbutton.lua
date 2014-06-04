local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
require "constants"

local CooldownButton = Class(Widget, function(self,owner, data)

    local init=data or {}
    Widget._ctor(self, "COOLDOWNBUTTON",owner)
    self.owner=owner or GetPlayer()
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
    self.cooldowntimerstart=0
    self.cooldowntask=nil

--  sigh, hax, are widgets the only things ihat don't have longupdate
    local old_onupdate=self.owner.OnLongUpdate
    self.owner.OnLongUpdate=function(inst, dt) 
        if(old_onupdate)then
            old_onupdate(inst,dt)
        end
        if(self.cooldowntimer>0 and  self.cooldowntask)then
            self:DoDelta(dt)
        end        
    end
end)

function CooldownButton:DoDelta(dt)
    self.cooldowntimer=self.cooldowntimer-dt
    self.cooldowntimerstart=GetTime()
    if(self.cooldowntimer<=0 and  self.cooldowntask)then
        self.cooldowntask:Cancel()
        self.cooldowntask=nil
        self:Enable()
        self.cooldowntext:Hide()
        if(self.OnCountdownOver)then
            self.OnCountdownOver()
        end
    else
        self.cooldowntext:SetString(""..math.floor(self.cooldowntimer))
    end    
end

function CooldownButton:countdownfn()
--    print("time",TheSim:GetTick(),GetTime(),self.cooldowntimerstart)
    local dt=GetTime()-self.cooldowntimerstart
    self:DoDelta(dt)
end

function CooldownButton:OnControl(control, down)

    if not self.focus then return false end
    if(control==CONTROL_ACCEPT and not down) then
        self:DoClick()
    end
    for k,v in pairs (self.children) do
        if v.focus and v:OnControl(control, down) then return true end
    end 

    return false
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
        self.cooldowntimerstart=GetTime()
        self.cooldowntext:Show()
        self.cooldowntext:SetString(""..math.floor(self.cooldown))
        --why self:DoPeriodicTask not working?
        self.cooldowntask=GetPlayer():DoPeriodicTask(1, function() self:countdownfn() end)
    end
end
end

function CooldownButton:ForceCooldown(state)
    self.cooldowntimer=state
    self.cooldowntimerstart=GetTime()

    if(state>0)then
        self:Disable()
        self:Show()
        self.cooldowntext:Show()
        self.cooldowntext:SetString(""..math.floor(self.cooldown))
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