require "behaviours/follow"
require "behaviours/wander"
require "behaviours/faceentity"
require "behaviours/panic"


local MIN_FOLLOW_DIST = 0
local MAX_FOLLOW_DIST = 12
local TARGET_FOLLOW_DIST = 6

local MAX_WANDER_DIST = 15


local function GetFaceTargetFn(inst)
    return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
    return inst.components.follower.leader == target
end

local function GetPos(inst)
    if(inst.components.follower and inst.components.follower.leader)then
        return Vector3(inst.components.follower.leader.Transform:GetWorldPosition())
    elseif(inst.components.homeseeker and inst.components.homeseeker.home)then
                return inst.components.homeseeker:GetHomePos()
            elseif(inst.components.knownlocations and inst.components.knownlocations:GetLocation("home"))then
                return inst.components.knownlocations:GetLocation("home")
            else
                return Vector3(inst.Transform:GetWorldPosition())
            end
        end


local WandererBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


function WandererBrain:OnStart()
    local root = 
    PriorityNode({
        Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST),
        Wander(self.inst, GetPos,MAX_WANDER_DIST),
        
    }, .25)
    self.bt = BT(self.inst, root)
end

return WandererBrain