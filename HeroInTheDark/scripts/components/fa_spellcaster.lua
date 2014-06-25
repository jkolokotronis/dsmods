
local FA_Spellcaster = Class(function(self, inst)
    self.casterlevel=1
 -- i.e. necro boost for sk/necro
    self.casterleveloverride={}
    self.inst = inst
end)

function FA_Spellcaster:GetCasterLevel(school)
	if(school and self.casterleveloverride[school]~=nil)then
		return self.casterleveloverride[school]
	else
		return self.casterlevel
    end
end


return FA_Spellcaster