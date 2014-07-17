--as of now it's just firing on everything
--I'll care about flexibility after armor/weapons pass
local FA_Mender = Class(function(self, inst)
    self.inst = inst
    self.meding_percent = 1.0
    self.repair_type=nil
--[[
	0001 sewing mess
	0010 armor
	0100 finiteuses 
]]
    self.mask=7
end)


function FA_Mender:DoMending(target, doer)
print("in domending")
	local used=false
    if target.components.fueled and target.components.fueled.fueltype == "USAGE" and target.components.fueled:GetPercent() < 1 then	
		target.components.fueled:SetPercent(math.min(1,target.components.fueled:GetPercent()+self.meding_percent))
    	used=true
	elseif (target.components.armor and target.components.armor:GetPercent()<1)then
		target.components.armor:SetPercent(math.min(1,target.components.armor:GetPercent()+self.meding_percent))
    	used=true
	elseif (target.components.finiteuses and target.components.finiteuses:GetPercent()<1) then
		target.components.finiteuses:SetPercent(math.min(1,target.components.finiteuses:GetPercent()+self.meding_percent))
    	used=true
	end

	if(used)then
		if self.inst.components.finiteuses then
			self.inst.components.finiteuses:Use(1)
		end
		
		if self.onmended then
			self.onmended(self.inst, target, doer)
		end
	end
	return used	
end

function FA_Mender:CollectUseActions(doer, target, actions, right)

	--default sewing nonsense
    if 	not target:HasTag("scroll") and not target:HasTag("wand") and not target:HasTag("book") and not target.components.fa_mender and
    	((not target:HasTag("no_sewing") and target.components.fueled and target.components.fueled.fueltype == "USAGE" and target.components.fueled:GetPercent() < 1) or
    	(target.components.armor and target.components.armor:GetPercent()<1) or
    	(target.components.finiteuses and target.components.finiteuses:GetPercent()<1) ) then
        table.insert(actions, ACTIONS.FA_MEND)
    end
end

return FA_Mender
