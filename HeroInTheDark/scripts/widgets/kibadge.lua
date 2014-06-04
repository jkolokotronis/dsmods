local Badge = require "widgets/badge"
local UIAnim = require "widgets/uianim"

local KiBadge = Class(Badge, function(self, owner)
	Badge._ctor(self, "ki", owner)
	self.owner = owner

	self.xp = 0
    self:SetScale(1,1,1)


--[[
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
]]

self.bg = self:AddChild(Image("images/xp_fill.xml", "xp_fill.tex"))
	self.bg:SetPosition(-355,0,0)
--	self.bg:SetPosition(-(150)*scale,.2,0)
	self.bg:SetHRegPoint(ANCHOR_LEFT)
	self.bg:SetScale(1,1,0)
	self.num = self:AddChild(Text(NUMBERFONT, 28))
    self.level:SetHAlign(ANCHOR_MIDDLE)
	self.num:SetPosition(6,0,0)
	self.num:SetScale(1.5,1.2,0)
--	self:StartUpdating()
end)

function KiBadge:DoDelta(old,val,max)
	self:SetValue(val,max)
end

function KiBadge:SetValue(val, max)

	local scale = 200
	self.bg:SetScale(val/max*scale,1,0)	
	self.num:SetString(tostring(math.ceil(val)).."/"..tostring(math.ceil(max)))
    self.xp = val
end

return KiBadge