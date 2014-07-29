local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local FA_BuffButton = require "widgets/fa_buffbutton"
require "constants"

local FA_BuffBar = Class(Widget, function(self,owner, data)
    Widget._ctor(self, "",owner)
    self.owner=owner
    self.buttonwidth=100
    self.buttonheight=40
    self.width=600
    self.height=80
    self.buttons={}

    self.root = self:AddChild(Widget("root"))
--    self.root:SetVAnchor(ANCHOR_RIGHT)
--    self.root:SetHAnchor(ANCHOR_TOP)
end)

function FA_BuffBar:Rebuild()
	if(self.cooldowntask)then
		self.cooldowntask:Cancel()
	end

	local i=0
	local xcount=math.floor(self.width/self.buttonwidth)
	for k,v in pairs(self.buttons) do
		v:SetPosition(-(i%xcount)*self.buttonwidth,-math.floor(i/xcount),0)
		i=i+1
	end
end

function FA_BuffBar:RegisterBuffs(timers)
	self.root:KillAllChildren()
    self.buttons={}
	for k,v in pairs(timers) do
		local btn=FA_BuffButton(self.owner)
        btn:SetText(v.name)
        self.buttons[k]=btn
        btn.cooldowntext:SetString(""..math.floor(v.cooldowntimer))
        self.root:AddChild(btn)
        v.btn=btn
	end
	self:Rebuild()
end

function FA_BuffBar:AddBuff(k,buff)
	local btn=nil
	if(not self.buttons[k])then
		btn=FA_BuffButton(self.owner)
		self.root:AddChild(btn)
		local xcount=math.floor(self.width/self.buttonwidth)
		local i=GetTableSize(self.buttons)
		btn:SetPosition(-(i%xcount)*self.buttonwidth,-math.floor(i/xcount),0)
	    self.buttons[k]=btn
    else
    	btn=self.buttons[k]
    end
    btn:SetText(buff.name)
    btn.cooldowntext:SetString(""..math.floor(buff.cooldowntimer))
	buff.btn=btn
end

function FA_BuffBar:RemoveBuff(name)
	local btn=self.buttons[name]
	if(btn)then
		btn:Kill()
		self.buttons[name]=nil
		self:Rebuild()
	end
end

return FA_BuffBar