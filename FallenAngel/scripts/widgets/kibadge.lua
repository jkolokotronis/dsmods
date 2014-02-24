local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local KiBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "ki", owner)

    self.anim:GetAnimState():SetBank("sanity")
    self.anim:GetAnimState():SetBuild("sanity")
    self.anim:GetAnimState():PlayAnimation("anim")
	
	self.sanityarrow = self.underNumber:AddChild(UIAnim())
	self.sanityarrow:GetAnimState():SetBank("sanity_arrow")
	self.sanityarrow:GetAnimState():SetBuild("sanity_arrow")
	self.sanityarrow:GetAnimState():PlayAnimation("neutral")
	self.sanityarrow:SetClickable(false)

	self.topperanim = self.underNumber:AddChild(UIAnim())
	self.topperanim:GetAnimState():SetBank("effigy_topper")
	self.topperanim:GetAnimState():SetBuild("effigy_topper")
	self.topperanim:GetAnimState():PlayAnimation("anim")
	self.topperanim:SetClickable(false)

--	self:StartUpdating()
end)



return KiBadge