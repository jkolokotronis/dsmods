local assets =
{
	Asset("ANIM", "anim/gravestones.zip"),
}

local prefabs = 
{
	"ghost",
	"amulet",
	"redgem",
	"gears",
	"bluegem",
	"nightmarefuel",
}

for k= 1,NUM_TRINKETS do
    table.insert(prefabs, "trinket_"..tostring(k) )
end


local mound_digcallback
-- could use new dlc code but that wouldnt work in non dlc version
local mound_reset=function(inst)
    print("in mound reset")
    if(inst.components.spawner)then
        inst.components.spawner:CancelSpawning()
    end
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
    inst.AnimState:PlayAnimation("gravedirt")
    inst.fa_digtime=nil
    inst.components.workable:SetOnFinishCallback(mound_digcallback)
end

mound_digcallback=function(inst,worker)
    inst.AnimState:PlayAnimation("dug")
    inst:RemoveComponent("workable")
    if worker then
        if worker.components.sanity then
           if(worker:HasTag("evil"))then
---------------------
            else
                worker.components.sanity:DoDelta(-TUNING.SANITY_SMALL)
            end
        end     
        local roll=math.random()
        if roll < GHOST_MOUND_SPAWN_CHANCE then
                local ghost = SpawnPrefab("ghost")
                local pos = Point(inst.Transform:GetWorldPosition())
                pos.x = pos.x -.3
                pos.z = pos.z -.3
                if ghost then
                    ghost.Transform:SetPosition(pos.x, pos.y, pos.z)
                end
        elseif worker.components.inventory then
                local item = nil
                if math.random() < GHOST_MOUND_ITEM_CHANCE then
                    local loots = 
                    {
                        nightmarefuel = 1,
                        amulet = 1,
                        gears = 1,
                        redgem = 5,
                        bluegem = 5,
                    }
                    item = weighted_random_choice(loots)
                else
                    item = "trinket_"..tostring(math.random(NUM_TRINKETS))
                end

                if item then
                    inst.components.lootdropper:SpawnLootPrefab(item)
                end
                if(math.random()<GHOST_MOUND_SCROLL_CHANCE)then
                    inst.components.lootdropper:SpawnLootPrefab("fa_scroll_12")
                end
        end
    end
                inst.fa_digtime=GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(MOUND_RESET_PERIOD,function() print("should reset mound") mound_reset(inst) end)
                inst.components.spawner:Configure( "skeletonspawn",SKELETONSPAWNDELAY,SKELETONSPAWNDELAY*math.random())
end
  
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    
    anim:SetBank("gravestone")
    anim:SetBuild("gravestones")
    anim:PlayAnimation("gravedirt")

    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = function(inst)
        if not inst.components.workable then        	
            return "DUG"
        end
    end
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.DIG)
    inst.components.workable:SetWorkLeft(1)
	inst:AddComponent("lootdropper")
        
    inst.components.workable:SetOnFinishCallback(mound_digcallback)      

       inst:AddComponent( "spawner" )
    inst.components.spawner.spawnoffscreen=false
--    inst.components.spawner.childname="skeletonspawn"
    inst.components.spawner.childfn=function(inst)
    	local rng=math.random()
    	if(rng<0.33)then
    		return "fa_drybones"
    	elseif(rng<0.66)then
    		return "fa_dartdrybones"
    	else
    		return "fa_skull"
    	end
	end
    inst.components.spawner.delay=SKELETONSPAWNDELAY

    
    inst.OnSave = function(inst, data)
        if not inst.components.workable then
            data.dug = true
        end
        if not inst.components.workable and inst.fa_digtime then
            data.fa_digtime=inst.fa_digtime
        end
    end        
    
    inst.OnLoad = function(inst, data)
        if data and data.dug or not inst.components.workable then
            inst:RemoveComponent("workable")
            inst.AnimState:PlayAnimation("dug")
            if(data.fa_digtime)then
                inst.fa_digtime=data.fa_digtime
                inst.fa_digresettask=inst:DoTaskInTime(MOUND_RESET_PERIOD-GetTime()+inst.fa_digtime,mound_reset)
            else
                inst.fa_digtime=GLOBAL.GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(MOUND_RESET_PERIOD, mound_reset)
            end

            local nexttime=inst.components.spawner.nextspawntime or GLOBAL.SKELETONSPAWNDELAY*math.random()
            inst.components.spawner:Configure( "skeletonspawn",GLOBAL.SKELETONSPAWNDELAY,nexttime)
	    end
    end           
    
    
    return inst
end


return Prefab( "common/fa_lavamound", fn, assets, prefabs ) 
