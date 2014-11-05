local FA_ScenarioUtil={}
function FA_GenerateLoot(loottable,weight,chance,loots)
        local loots=loots or {}
        local chance=math.random()
        if(loottable and chance<=chance)then
            local newloot=nil
            --pick one of...
            local rnd = math.random()*weight
            for k,v in pairs(loottable) do
                rnd = rnd - v
                if rnd <= 0 then
                    newloot=k
                    break
                end
            end
            table.insert(loots, newloot)
        end
        return loots
    
end
FA_ScenarioUtil.FA_GenerateLoot=FA_GenerateLoot

function FA_SpawnPrefabInProx(inst,prefab,count)
    local pt = Vector3(inst.Transform:GetWorldPosition())
    local theta = math.random() * 2 * PI
    local radius = 5
    local steps = 3
    local ground = GetWorld()
    local player = GetPlayer()
    
    local settarget = function(inst, player)
        if inst and inst.brain then
            inst.brain.followtarget = player
        end
    end

    -- Walk the circle trying to find a valid spawn point
    for i = 1, count do
        local offset = Vector3(radius * math.cos( theta ), 0, -radius * math.sin( theta ))
        local wander_point = pt + offset
       
        if ground.Map and ground.Map:GetTileAtPoint(wander_point.x, wander_point.y, wander_point.z) ~= GROUND.IMPASSABLE then
            local particle = SpawnPrefab("poopcloud")
            particle.Transform:SetPosition( wander_point.x, wander_point.y, wander_point.z )

            local spider = SpawnPrefab(prefab)
            spider.Transform:SetPosition( wander_point.x, wander_point.y, wander_point.z )
--            spider:DoTaskInTime(1, settarget, player)
            if(spider.components.combat)then
                spider.components.combat:SuggestTarget(player)
            end
        end
        theta = theta - (2 * PI / count)
    end
end
FA_ScenarioUtil.FA_SpawnPrefabInProx=FA_SpawnPrefabInProx

local function OnOpenChestTrap(inst, openfn, data) 
        local bail = openfn(inst, data)
        if bail then return end

        local talkabouttrap = function(inst, txt)
            inst.components.talker:Say(txt)
        end
        local player = GetPlayer()

        inst.SoundEmitter:PlaySound("dontstarve/common/chest_trap")

        local fx = SpawnPrefab("statue_transition_2")
        if fx then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx.AnimState:SetScale(1,2,1)
        end
        fx = SpawnPrefab("statue_transition")
        if fx then
            fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
            fx.AnimState:SetScale(1,1.5,1)
        end
        player:DoTaskInTime(1, talkabouttrap, GetString(player.prefab, "ANNOUNCE_TRAP_WENT_OFF"))

end
FA_ScenarioUtil.OnOpenChestTrap=OnOpenChestTrap

local function InitializeChestTrap(inst, scenariorunner, openfn)
    inst.scene_triggerfn = function(inst, data)  
        OnOpenChestTrap(inst,  openfn, data)
        scenariorunner:ClearScenario()
    end
    inst:ListenForEvent("onopen", inst.scene_triggerfn)
    inst:ListenForEvent("worked", inst.scene_triggerfn)

end
FA_ScenarioUtil.InitializeChestTrap=InitializeChestTrap

return FA_ScenarioUtil

