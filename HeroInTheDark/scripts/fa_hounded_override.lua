
local Hounded=require("components/hounded")

Hounded.prefabspec={}

Hounded.attack_delays["rare"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end
Hounded.attack_delays["occasional"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end
Hounded.attack_delays["frequent"]=function() return TUNING.TOTAL_DAY_TIME * 9 + math.random() * TUNING.TOTAL_DAY_TIME * 3 end

Hounded.attack_levels=
{
    intro={warnduration= function() return 120 end, numhounds = function() return 2 end},
    light={warnduration= function() return 60 end, numhounds = function() return 2 + math.random(2) end},
    med={warnduration= function() return 60 end, numhounds = function() return 3 + math.random(3) end},
    heavy={warnduration= function() return 60 end, numhounds = function() return 4 + math.random(3) end},
    crazy={warnduration= function() return 60 end, numhounds = function() 

        return 4 + math.random(4) + math.max(math.floor(GetClock().numcycles/50),4)

    end},
}


local old_planhoundattack=Hounded.PlanNextHoundAttack
function Hounded:PlanNextHoundAttack()
    local ret=old_planhoundattack(self)
    local day = GetClock().numcycles
    --+1 gob for every 10 days past 100? +1 orc for every 10 days past 150? then mix in random stuff... whatever
    self.prefabspec={}
    local gob=0
    local hound=self.houndstorelease
    local orc=0
    if(day>100)then
        gob=math.min(math.floor((day-100)/10),self.houndstorelease-2)
        hound=self.houndstorelease-gob
        if(day>150)then
            orc=math.min(math.floor((day-200)/10),gob-2)
            gob=gob-orc
        end


    end

        self.prefabspec["goblin"]=gob
        self.prefabspec["hound"]=hound
        self.prefabspec["fa_orc"]=orc
end

local old_houndedsave=Hounded.OnSave
function Hounded:OnSave()
    local ret=old_houndedsave(self)
    if(ret)then
        print("prefabspec",self.prefabspec and self.prefabspec["hound"])
        if(self.prefabspec)then
            ret["prefabspec"]=self.prefabspec
        end
    end
    return ret
end

local old_houndedload=Hounded.OnLoad
function Hounded:OnLoad(data)
    old_houndedload(self,data)
    if(data and data.prefabspec)then
        self.prefabspec=data.prefabspec
    end
    print("prefabspec",self.prefabspec and self.prefabspec["hound"])
end


--TODO this needs to be fixed in a more flexibile way, but klei hacks and laziness got the best of me
function Hounded:ReleaseHound(dt)
    local pt = GLOBAL.Vector3(GetPlayer().Transform:GetWorldPosition())
        
    local spawn_pt = self:GetSpawnPoint(pt)
    
    if spawn_pt then
        self.houndstorelease = self.houndstorelease - 1
    print("self.attacksizefn",self.attacksizefn)
    print("houndstorelease",self.houndstorelease)

            local prefab = "hound"
            local day = GetClock().numcycles
            local special_hound_chance = self:GetSpecialHoundChance()

            if(FA_DLCACCESS)then
                if GetSeasonManager() and GetSeasonManager():IsSummer() then
                    special_hound_chance = special_hound_chance * 1.5
                end
            end

            for k,v in pairs(self.prefabspec) do
                --WTB continue
                if(v>0)then
                    if(k=="hound")then

                        if math.random() < special_hound_chance then
                        if GetSeasonManager():IsWinter() or (FA_DLCACCESS and GetSeasonManager():IsSpring()) then
                            prefab = "icehound"
                        else
                            prefab = "firehound"
                        end
                    end
                    else
                        prefab=k
                    end

                    self.prefabspec[k]=v-1
        

                    break
                end
            end

                    local hound = SpawnPrefab(prefab)
                    if hound then
                        hound.Physics:Teleport(spawn_pt:Get())
                        hound:FacePoint(pt)
                        hound.components.combat:SuggestTarget(GetPlayer())
                    end

    end
    
end    