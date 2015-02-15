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

local SUMMON_TIMER=5
local KICK_TIMER=5
local SPELL_TIMER=3
local HEAL_TIMER=5
local HEAL_DELTA=100
local KICK_MAXRANGE=5
local KICK_RANGE=6
local LEIF_RANGE=15
local EXTINGUISH_RANGE=15


local DryadBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end


function DryadBrain:TryPush() 
    if(self.inst.fa_kick_counter<=0 or not self.inst.components.homeseeker) then return false end
    local pos=self.inst.components.homeseeker:GetHomePos()
    if(pos==nil) then return false end
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, KICK_MAXRANGE,nil,{"INLIMBO","FX","DECOR","prey"})
    for k,v in pairs(ents) do
        if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) and (v:HasTag("player") or v:HasTag("companion")) then
            local p1=Vector3(v.Transform:GetWorldPosition())
            local dsq = self.inst:GetDistanceSqToInst(v)
            if(dsq>(FORCEPULL_MINRANGE*FORCEPULL_MINRANGE))then
                local r=self.inst.Physics:GetRadius() + v.Physics:GetRadius() + KICK_RANGE
                local vector = -(p1-pos):GetNormalized()
                local newpos=pos+vector*r
                print("r",r,"oldpos",pos,"newpos",newpos)
                if GetWorld().Map and GetWorld().Map:GetTileAtPoint(newpos.x, newpos.y, newpos.z) ~= GROUND.IMPASSABLE then
                    local particle = SpawnPrefab("poopcloud")
                    particle.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    v.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    self.inst.fa_kick_counter=self.inst.fa_kick_counter-1
                    self.inst:FacePoint(v)
                    self.inst.sg:GoToState("stomp")

                    return true
                end
            end
        end
    end
    return false
end

function DryadBrain:TryHeal() 
    if(self.inst.fa_heal_counter<=0 or self.inst.components.health.currenthealth>0.3*self.inst.components.health.maxhealth) then return false end
    self.inst.components.health:DoDelta(HEAL_DELTA)
    self.inst.fa_heal_counter=self.inst.fa_heal_counter-1
    return true
end
function DryadBrain:TryExtinguish() 
    if(self.inst.fa_gustofwind_counter<=0) then return false end

end
function DryadBrain:TrySummon() 
    if(self.inst.components.leader.numfollowers>=3)then return false end
    if(self.inst.fa_summontreeguard_counter>0 ) then 
        local pos=Vector3(self.inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, LEIF_RANGE)
        for k,v in pairs(ents) do
            if(v:HasTag("tree") and (not v:HasTag("stump")) and (not v:HasTag("burnt")) and not v.noleif)then
                local pt=Vector3(v.Transform:GetWorldPosition())
                v:Remove()
                local tree = SpawnPrefab("leif") 
                tree.Physics:SetCollides(false)
                tree.Physics:Teleport(pt.x, pt.y, pt.z) 
                tree.Physics:SetCollides(true)
                tree.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
                self.inst.components.leader:AddFollower(tree)
                tree.sg:GoToState("spawn")
                tree:ListenForEvent("stopfollowing",function(f)
                    tree.sg:GoToState("sleep")
                end)
                self.inst.fa_summontreeguard_counter=self.inst.fa_summontreeguard_counter-1
                self.inst:FacePoint(v)
                self.inst.sg:GoToState("spell")
                return true
            end
        end
    end

    if(self.inst.fa_summonswarm_counter>0)then
        for i=1,3 do
        local pt= Vector3(self.inst.Transform:GetWorldPosition())
        local tree = SpawnPrefab("spider") 
        tree.Physics:SetCollides(false)
        tree.Physics:Teleport(pt.x, pt.y, pt.z) 
        tree.Physics:SetCollides(true)
        tree.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        self.inst.components.leader:AddFollower(tree)
--        tree.sg:GoToState("spawn")
        tree:ListenForEvent("stopfollowing",function(f)
            f.components.health:Kill()
        end)
        end
        self.inst.fa_summonswarm_counter=self.inst.fa_summonswarm_counter-1
        self.inst.sg:GoToState("spell")
        return true
    end
    return false

end
function DryadBrain:TryRegrow() 
    if(self.inst.fa_plantgrowth_counter<=0) then return false end
    local range=15
    local hit=false
    local pos = Vector3(reader.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, range)
    for k,v in pairs(ents) do
        if v.components.pickable then
            v.components.pickable:FinishGrowing()
            hit=true
        end
        if v.components.crop then
            v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*3)
            hit=true
        end        
        if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
            v.components.growable:DoGrowth()
            hit=true
        end
    end
    if(hit)then 
        self.inst.fa_plantgrowth_counter=self.inst.fa_plantgrowth_counter-1 
        self.inst.sg:GoToState("spell")
    end
    return hit
end

--[[
inst.fa_summontreeguard_counter=TREEGUARD_COUNTER
        inst.fa_calllightning_counter=LIGHTNING_COUNTER
        inst.fa_plantgrowth_counter=PLANT_COUNTER
        inst.fa_heal_counter=HEAL_COUNTER
        inst.fa_gustofwind_counter=GUST_COUNTER
        inst.fa_summonswarm_counter=SWARM_COUNTER
        inst.fa_kick_counter=KICK_COUNTER
]]

function DryadBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_root~=nil end, "RootAttack", StandAndAttack(self.inst) ),
        MinPeriod(self.inst, HEAL_TIMER, ConditionNode(function()  return self:TryHeal()  end, "heal" )),
        MinPeriod(self.inst, SPELL_TIMER, ConditionNode(function()  return self:TryExtinguish()  end,"extinguish")),
        MinPeriod(self.inst, KICK_TIMER, ConditionNode(function()  return self:TryPush()  end, "kick" )),
        MinPeriod(self.inst, SUMMON_TIMER, ConditionNode(function()  return self:TrySummon()  end, "summon" )),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME,MAX_CHASE_DIST),
        MinPeriod(self.inst, SPELL_TIMER, ConditionNode(function()  return self:TryRegrow()  end,"regrow")),
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

return DryadBrain