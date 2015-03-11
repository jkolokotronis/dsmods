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


local DorfBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


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