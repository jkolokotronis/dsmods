
local FA_Spellcaster = Class(function(self, inst)
    self.casterlevel=1
 -- i.e. necro boost for sk/necro
    self.casterleveloverride={}
-- inherent boosts? penalties? 
    self.castfailure=0
    self.inst = inst
end)

function FA_Spellcaster:GetCasterLevel(school)
	if(school and self.casterleveloverride[school]~=nil)then
		return self.casterleveloverride[school]
	else
		return self.casterlevel
    end
end

--TOTAL
function FA_Spellcaster:GetCastFailure()
	local fail=self.castfailure
	if(self.inst.components.inventory)then

    for k,v in pairs(self.inst.components.inventory) do
        if v.components.equippable and v.components.equippable.fa_castfailure then
            fail=fail+v.components.equippable.fa_castfailure 
        end
    end

	end
	return fail
end

return FA_Spellcaster