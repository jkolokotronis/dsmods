require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"

local SEE_PLAYER_DIST = 15
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 15
local MAX_CHASE_DIST = 40
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local MIN_FOLLOW_DIST = 2
local MAX_FOLLOW_DIST = 9
local TARGET_FOLLOW_DIST = 5


local KEEP_WORKING_DIST = 20
local SEE_WORK_DIST = 25
local DorfBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function HasStateTags(inst, tags)
    for k,v in pairs(tags) do
        if inst.sg:HasStateTag(v) then
            return true
        end
    end
end

local function KeepWorkingAction(inst, actiontags)
    return inst.components.follower.leader and inst.components.follower.leader:GetDistanceSqToInst(inst) <= KEEP_WORKING_DIST*KEEP_WORKING_DIST and 
    HasStateTags(inst.components.follower.leader, actiontags)
end

local function StartWorkingCondition(inst, actiontags)
    return inst.components.follower.leader and HasStateTags(inst.components.follower.leader, actiontags) and not HasStateTags(inst, actiontags)
end

local function FindObjectToWorkAction(inst, action)
    if inst.sg:HasStateTag("working") then
        return 
    end
    local target = FindEntity(inst.components.follower.leader, SEE_WORK_DIST, function(item) return item.components.workable and item.components.workable.action == action end)
    if target then
        --print(GetTime(), target)
        return BufferedAction(inst, target, action)
    end
end

local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end


function DorfBrain:OnStart()
    local root = PriorityNode(
    {
         WhileNode( function() return self.inst.fa_daze~=nil end, "Daze", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_root~=nil end, "RootAttack", StandAndAttack(self.inst) ),
        WhileNode( function() return self.inst.fa_fear~=nil end, "Fear", Panic(self.inst)),
        WhileNode( function() return self.inst.components.health.takingfiredamage and not (self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE] and self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]>=1) end,
         "OnFire", Panic(self.inst)),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME,MAX_CHASE_DIST),

        WhileNode(function() return StartWorkingCondition(self.inst, {"mining", "premine"}) and 
        KeepWorkingAction(self.inst, {"mining", "premine"}) end, "keep mining",                   
            DoAction(self.inst, function() return FindObjectToWorkAction(self.inst, ACTIONS.MINE) end)),
        Follow(self.inst, function() return self.inst.components.follower.leader end, MIN_FOLLOW_DIST, TARGET_FOLLOW_DIST, MAX_FOLLOW_DIST, true),
        Wander(self.inst, function() 
            if(self.inst.components.homeseeker and self.inst.components.homeseeker.home)then
                return self.inst.components.homeseeker:GetHomePos()
            elseif(self.inst.components.knownlocations and self.inst.components.knownlocations:GetLocation("home"))then
                return self.inst.components.knownlocations:GetLocation("home")
            else
                return Vector3(self.inst.Transform:GetWorldPosition())
            end
        end

            , MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)

end

return DorfBrain