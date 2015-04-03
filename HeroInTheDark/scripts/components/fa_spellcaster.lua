
local FA_Spellcaster = Class(function(self, inst)
    self.casterlevel=1
 -- i.e. necro boost for sk/necro
    self.casterleveloverride={}
-- inherent boosts? penalties? 
    self.castfailure=0
    self.inst = inst
end)

function FA_Spellcaster:GetCasterLevel(school)
    local cl=self.casterlevel
	if(school and self.casterleveloverride[school]~=nil)then
		cl= self.casterleveloverride[school]
    end
    for k,v in pairs(self.inst.components.inventory.equipslots) do
        if v.components.equippable and v.components.equippable.fa_casterlevel then
            if(type(v.components.equippable.fa_casterlevel)=="number")then
                cl=cl+v.components.equippable.fa_casterlevel
            elseif(type(v.components.equippable.fa_casterlevel)=="table" and school~=nil and v.components.equippable.fa_casterlevel[school])then
                cl=cl+v.components.equippable.fa_casterlevel[school]
            end
        end
    end

    return cl
end

function FA_Spellcaster:GetCastFailure()
	local fail=self.castfailure
	if(self.inst.components.inventory)then

    for k,v in pairs(self.inst.components.inventory.equipslots) do
        if v.components.equippable and v.components.equippable.fa_castfailure then
            fail=fail+v.components.equippable.fa_castfailure 
        end
    end

	end
	return fail
end

return FA_Spellcaster