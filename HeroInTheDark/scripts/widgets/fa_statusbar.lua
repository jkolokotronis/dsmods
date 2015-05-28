local Widget = require "widgets/widget"
local Text = require "widgets/text"
local Image = require "widgets/image"
local FA_StatusButton = require "widgets/fa_statusbutton"
require "constants"

local FA_StatusBar = Class(Widget, function(self,owner, data)
    Widget._ctor(self, "",owner)
    self.owner=owner
    self.buttonwidth=32
    self.buttonheight=32
    self.width=260
    self.height=80
    self.buttons={}
    --shouldnt owner point to it?
    self.player=GetPlayer()

    self.root = self:AddChild(Widget("root"))
--    self.root:SetVAnchor(ANCHOR_RIGHT)
--    self.root:SetHAnchor(ANCHOR_TOP)
end)

function FA_StatusBar:Rebuild()
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

function FA_StatusBar:RegisterBuffs()
	self.root:KillAllChildren()
    self.buttons={}
    if(self.player.components.health.fa_temphp and self.player.components.health.fa_temphp>0)then
    	local data={
    		buttontint={r=1,g=1,b=1,a=1},
    		normaltex={tex="fa_heart.tex"},
    		text=""..math.floor(self.player.components.health.fa_temphp)
	    }
		local btn=FA_StatusButton(self.owner,data)
		self.root:AddChild(btn)
        self.buttons["temphp"]=btn
    end

    for k,v in pairs(self.player.components.health.fa_protection) do
    	if(v>0)then
	    	local t=FA_DAMAGE_INDICATORS[k]
    		local data={
    			buttontint={r=t[1],g=t[2],b=t[3],a=t[4]},
    			normaltex={tex="fa_white.tex"},
    			text=""..math.floor(v)
	    	}
	    	local btn=FA_StatusButton(self.owner,data)
			self.root:AddChild(btn)
	        self.buttons["prot_"..k]=btn
	    end
    end

    for k,v in pairs(self.player.components.health.fa_resistances) do
--------- if phys dr is not being shown in vanilla, should resists be shown here, with or without it?
    end

	self:Rebuild()
end

function FA_StatusBar:TempHPDelta(old,new)
	local btn=self.buttons["temphp"]
	if(new==0)then
		if(btn)then
			self.buttons["temphp"]=nil
			btn:Kill()
			self:Rebuild()
		end
	else
		if(not btn)then
			local data={
    		buttontint={r=1,g=1,b=1,a=1},
    		normaltex={tex="fa_heart.tex"}
		    }
			btn=FA_StatusButton(self.owner,data)
			self.root:AddChild(btn)
    	    self.buttons["temphp"]=btn
    	    self:Rebuild()
		end
		btn:SetText(""..math.floor(new))
	end
end

function FA_StatusBar:ProtectionDelta(old,new,damagetype)
	local btn=self.buttons["prot_"..damagetype]
	if(new==0)then
		if(btn)then
			self.buttons["prot_"..damagetype]=nil
			btn:Kill()
			self:Rebuild()
		end
	else
		if(not btn)then
			local t=FA_DAMAGE_INDICATORS[damagetype]
    		local data={
    			buttontint={r=t[1],g=t[2],b=t[3],a=t[4]},
    			normaltex={tex="fa_white.tex"},
    			text=""..math.floor(new)
	    	}
			btn=FA_StatusButton(self.owner,data)
			self.root:AddChild(btn)
    	    self.buttons["prot_"..damagetype]=btn
    	    self:Rebuild()
		end
		btn:SetText(""..math.floor(new))
	end
end


return FA_StatusBar