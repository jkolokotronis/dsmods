function FA_GenerateLoot(loottable,weight,chance)
        local loots={}
        local chance=math.random()
        if(self.fallenLootTable and chance<=self.fallenLootTableChance)then
            local newloot=nil
            --pick one of...
            local rnd = math.random()*self.fallenLootTableTotalWeight
            for k,v in pairs(self.fallenLootTable) do
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
end

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