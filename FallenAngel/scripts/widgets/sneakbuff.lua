local ToggleBuff=require "widgets/togglebuff"

local SneakBuff = Class(ToggleBuff, function(self, data)
	local init={}
	init.states={"on", "off"}
	init.disabled={}
	init.disabled.atlas="images/ui.xml"
	init.disabled.tex="button_small_disabled.tex"
	init["on"]={}
	init["on"].atlas="images/ui.xml"
	init["on"].tex="button_small_over.tex"
	init["off"]={}
	init["off"].atlas="images/ui.xml"
	init["off"].tex="button_small.tex"
	ToggleBuff._ctor(self, init)
	self.text:SetString("Sneak")
end)



return SneakBuff