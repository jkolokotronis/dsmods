require "behaviours/wander"
require "behaviours/runaway"
require "behaviours/doaction"
require "behaviours/faceentity"
require "behaviours/chaseandattack"
require "behaviours/panic"

local SEE_PLAYER_DIST = 30
local MAX_WANDER_DIST = 15
local MAX_CHASE_TIME = 15
local MAX_CHASE_DIST = 40
local RUN_AWAY_DIST = 5
local STOP_RUN_AWAY_DIST = 8
local AOERANGE=10
local AOE_PERIOD=30
local AOEDAMAGE=50
local FORCEPULL_PERIOD=15
local FORCEPULL_MINRANGE=15
local FORCEPULL_MAXRANGE=40

local CursedPigKingBrain = Class(Brain, function(self, inst)
    Brain._ctor(self, inst)
end)


local function GetFaceTargetFn(inst)
    return GetClosestInstWithTag("player", inst, SEE_PLAYER_DIST)
end

local function KeepFaceTargetFn(inst, target)
    return inst:GetDistanceSqToInst(target) <= SEE_PLAYER_DIST*SEE_PLAYER_DIST
end

function CursedPigKingBrain:TryAOE() 
    local pos=Vector3(self.inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, AOERANGE,nil,{"INLIMBO","FX","DECOR","prey"})
    local hitcount=0
    for k,v in pairs(ents) do
        if not(v==self.inst) and v.components.combat and not (v.components.health and v.components.health:IsDead()) then
            hitcount=hitcount+1
            v.components.combat:GetAttacked(self.inst, AOEDAMAGE, nil,nil,FA_DAMAGETYPE.FIRE)

                local hitfx =SpawnPrefab("fa_firestormhitfx")
                hitfx.persists=false
                hitfx.Transform:SetPosition(v.Transform:GetWorldPosition())
                hitfx:ListenForEvent("animover", function() 
                        hitfx.AnimState:ClearBloomEffectHandle()
                        hitfx:Remove() 
                        end)
                
        end
    end

    if(hitcount>0)then
        local ringfx =SpawnPrefab("fa_firestormfx")
        ringfx.persists=false
        ringfx.Transform:SetPosition(pos.x, pos.y, pos.z)
        ringfx:ListenForEvent("animover", function() 
            ringfx.AnimState:ClearBloomEffectHandle()
            ringfx:Remove() 
        end)
        return true
    else
        return false
    end
end

function CursedPigKingBrain:TryPull() 
    local pos=Vector3(self.inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FORCEPULL_MAXRANGE,nil,{"INLIMBO","FX","DECOR","prey"})
    for k,v in pairs(ents) do
        if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) and (v:HasTag("player") or v:HasTag("companion")) then
            local p1=Vector3(v.Transform:GetWorldPosition())
            local dsq = self.inst:GetDistanceSqToInst(v)
            if(dsq>(FORCEPULL_MINRANGE*FORCEPULL_MINRANGE))then
                local r=self.inst.Physics:GetRadius() + v.Physics:GetRadius() + 1
                local vector = (p1-pos):GetNormalized()
                local newpos=pos+vector*r
                print("r",r,"oldpos",pos,"newpos",newpos)
                if GetWorld().Map and GetWorld().Map:GetTileAtPoint(newpos.x, newpos.y, newpos.z) ~= GROUND.IMPASSABLE then
                    local particle = SpawnPrefab("poopcloud")
                    particle.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    v.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    return true
                end
            end
        end
    end
    return false
end

function CursedPigKingBrain:OnStart()
    local root = PriorityNode(
    {
        WhileNode( function() return self.inst.fa_stun~=nil end, "Stun", StandStill(self.inst)),
        WhileNode( function() return self.inst.fa_root~=nil end, "RootAttack", StandAndAttack(self.inst) ),
        MinPeriod(self.inst, AOE_PERIOD, ConditionNode(function()  return self:TryAOE()  end, "aoespam" )),
        MinPeriod(self.inst, FORCEPULL_PERIOD, ConditionNode(function()  return self:TryPull()  end, "force pull" )),
        ChaseAndAttack(self.inst, MAX_CHASE_TIME,MAX_CHASE_DIST),
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

return CursedPigKingBrain