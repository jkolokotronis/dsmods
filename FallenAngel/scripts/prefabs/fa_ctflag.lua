local assets =
{	
}

local INVASION_CHANCE=0.5
local INVASION_SIZE=8

local function getSpawnPoint(inst,radius)
    
    local theta = math.random() * 2 * PI
    local pt = inst:GetPosition()

    if type(radius) == "function" then
        radius = radius()
    end

    local offset = FindWalkableOffset(pt, theta, radius, 12, true)
    if offset then
        return pt+offset
    end
end
--TODO this needs to be more generic, but I need to solve the swapping problem first
local function startMineInvasion(inst,data)
    local tag=inst.warstate
    local hostile=GetClosestInstWithTag(tag, inst, 60)
    if(hostile)then
        local pt=getSpawnPoint(hostile,40)
        local prefab="dorf"
        if(tag=="dorf")then
            prefab="orc"
        end
        for i=1,math.random(INVASION_SIZE) do
            inst:DoTaskInTime(math.random()*10,function()
                local mob=SpawnPrefab(prefab)
                local particle = SpawnPrefab("poopcloud")
                particle.Transform:SetPosition( pt.x, pt.y,pt.z )
                mob.Transform:SetPosition( pt.x, pt.y, pt.z )
                if(mob.components.combat)then
                    spider.components.combat:SuggestTarget(hostile)
                end
            end)
        end

    end
end

local function onload(inst,data)
    if(data)then
        inst.warstate=data.warstate
        inst.centered=data.centered
    end
   
end

local function onsave(inst,data)
    data.warstate=inst.warstate
    data.centered=inst.centered
end

local function moveToCenter(inst)
    inst:DoTaskInTime(0,function()
        if(not inst.centered)then
        
            local topo = GetWorld().topology
            local pos = inst:GetPosition()
            local mynode = nil
            for i,node in ipairs(topo.nodes) do
                if TheSim:WorldPointInPoly(pos.x, pos.z, node.poly) then
                    mynode = node
                    break
                end
            end
            if(not mynode)then 
                print("ERROR: not placed in any nodes?",inst)
                return
            end

            inst.Transform:SetPosition(mynode.cent[1],0,mynode.cent[2])
            inst.centered=true
        end
    end)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
--	local anim = inst.entity:AddAnimState()

	local sound = inst.entity:AddSoundEmitter()

    
--    MakeObstaclePhysics(inst, .3)    
    
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "village.png" )
    

	inst:ListenForEvent( "warphasechange", function(world, data) 
        if(math.random()<INVASION_CHANCE)then
            startMineInvasion( inst,data ) 
        end
    end, GetWorld())
--	inst:ListenForEvent( "nighttime", function(inst, data) end, GetWorld())
	--why it wont turn on proper on reload?
    data.warstate="dorf"

    inst.OnLoad=onload
    inst.OnSave=onsave

    moveToCenter(inst)

    return inst
end



return Prefab( "common/objects/fa_wartarget", fn(), assets)
