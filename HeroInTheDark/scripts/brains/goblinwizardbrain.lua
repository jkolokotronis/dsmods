require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/panic"

local SEE_PLAYER_DIST = 5
local SEE_FOOD_DIST = 10
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 10
local MAX_CHASE_DIST = 25
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8


local Goblinbrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)

local function EatFoodAction(inst)
    if(inst.components.combat.target)then return end
    local target = nil
    if inst.components.inventory and inst.components.eater then
        target = inst.components.inventory:FindItem(function(item) return inst.components.eater:CanEat(item) end)
    end
    if not target then
        target = FindEntity(inst, SEE_FOOD_DIST, function(item) return inst.components.eater:CanEat(item) end)
    end
    if target then
        local act = BufferedAction(inst, target, ACTIONS.EAT)
        act.validfn = function() return not (target.components.inventoryitem and target.components.inventoryitem.owner and target.components.inventoryitem.owner ~= inst) end
        return act
    end
end



function Goblinbrain:OnStart()
    local root = PriorityNode(
    {
         WhileNode( function() return self.inst.fa_daze~=nil end, "Daze", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_root~=nil end, "RootAttack", StandAndAttack(self.inst) ),
        WhileNode( function() return self.inst.fa_fear~=nil end, "Fear", Panic(self.inst)),
        WhileNode( function() return self.inst.components.health.takingfiredamage and not (self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE] and self.inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]>=1) end,
             "OnFire", Panic(self.inst)),
        WhileNode( function() return self.inst.components.combat.target == nil or not self.inst.components.combat:InCooldown() end, "AttackMomentarily",
            ChaseAndAttack(self.inst, MAX_CHASE_TIME, MAX_CHASE_DIST) ),
        WhileNode( function() return self.inst.components.combat.target and self.inst.components.combat:InCooldown() end, "Dodge",
            RunAway(self.inst, function() return self.inst.components.combat.target end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST) ),
        Wander(self.inst, function() 
            if(self.inst.components.homeseeker and self.inst.components.homeseeker.home)then
                return self.inst.components.homeseeker:GetHomePos()
            else
                return Vector3(self.inst.Transform:GetWorldPosition())
            end
        end

            , MAX_WANDER_DIST),
    }, .25)
    
    self.bt = BT(self.inst, root)

end

return Goblinbrain