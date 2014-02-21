local ToggleBuff=require "widgets/togglebuff"

local PetBuff = Class(ToggleBuff, function(self, data)
	local init=data or {}
	init.states={"on", "off"}
	init.disabled=init.disabled or {}
	init.disabled.atlas=init.disabled.atlas or "images/ui.xml"
	init.disabled.tex=init.disabled.tex or "button_small_disabled.tex"
	init["on"]=init["on"] or {}
	init["on"].atlas=init["on"].atlas or "images/ui.xml"
	init["on"].tex=init["on"].tex or "button_small_over.tex"
	init["off"]=init["off"] or {}
	init["off"].atlas=init["off"].atlas or "images/ui.xml"
	init["off"].tex=init["off"].tex or "button_small.tex"
	init.name=init.name or "Pet"
	ToggleBuff._ctor(self, init)
	self.text:SetString("Pet")
end)

function PetBuff:OnPetDies()
	self:ForceState("off")
end

return PetBuff