require "behaviours/follow"
require "behaviours/wander"


local FrogHaxBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local MIN_FOLLOW = 1
local MAX_FOLLOW = 11
local MED_FOLLOW = 6
local MAX_WANDER_DIST = 10
local MAX_CHASE_TIME = 6


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

function FrogHaxBrain:OnStart()

    local root = PriorityNode(
    {
		Follow(self.inst, function() return self.inst.components.follower.leader end, 1, 2, 4, true),
		
    }, .5)
        
    self.bt = BT(self.inst, root)
         
end


return FrogHaxBrain