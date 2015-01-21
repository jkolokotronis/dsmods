

local doSkeletonSpawn=function(inst)
    local skel=SpawnPrefab("skeletonspawn")
    skel:AddComponent("homeseeker")
    skel.components.homeseeker:SetHome(inst)
    skel.Transform:SetPosition(inst.Transform:GetWorldPosition())
    return skel
end

local startSkeletonSpawnTask=function(inst)
     local rng=math.random()*480*5
         inst:DoTaskInTime(rng, function() 
            inst:AddTag("hasSpawnedSkeleton")
            local skel=doSkeletonSpawn(inst)
            skel:ListenForEvent("death",function(skel) 
                inst:RemoveTag("hasSpawnedSkeleton") 
                startSkeletonSpawnTask(inst)
            end)
        end)
end

local spoiledSkeletonSpawn=function(inst)
    if(math.random()>0.5)then
        doSkeletonSpawn(inst)
    end
end

FA_ModUtil.AddPrefabPostInit("meat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
FA_ModUtil.AddPrefabPostInit("cookedmeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
FA_ModUtil.AddPrefabPostInit("meat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
FA_ModUtil.AddPrefabPostInit("monstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
FA_ModUtil.AddPrefabPostInit("cookedmonstermeat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
FA_ModUtil.AddPrefabPostInit("monstermeat_dried",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)
--[[
FA_ModUtil.AddPrefabPostInit("hambat",function(inst)
    if(inst.components.perishable)then
        inst.components.perishable:SetOnPerishFn(spoiledSkeletonSpawn)
    end
end)]]

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
    if(FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = false
        end
    end
    inst.components.workable:SetOnFinishCallback(mound_digcallback)
end

mound_digcallback=function(inst,worker)
    --                  who thought hardcoding stuff is great idea.... brute force override
--                onfinishcallback(inst,worker)
                
    inst.AnimState:PlayAnimation("dug")
    inst:RemoveComponent("workable")
    if(FA_DLCACCESS)then
        if(inst.components.hole)then
            inst.components.hole.canbury = true
        end
    end
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

FA_ModUtil.AddPrefabPostInit("mound",function(inst)
    inst:AddComponent( "spawner" )
    inst.components.spawner.spawnoffscreen=false
    inst.components.spawner.childname="skeletonspawn"
    inst.components.spawner.delay=SKELETONSPAWNDELAY

    local oldsave=inst.OnSave
    inst.OnSave = function(inst, data)
        if(oldsave)then
            oldsave(inst,data)
        end
        if not inst.components.workable and inst.fa_digtime then
            data.fa_digtime=inst.fa_digtime
        end
    end        
    local oldload=inst.OnLoad
    inst.OnLoad = function(inst, data)
--    print("mound onload")
        if(oldload)then
            oldload(inst,data)
        end
        if data and data.dug or not inst.components.workable then
--        print("digtime", data.fa_digtime)
            if(data.fa_digtime)then
                inst.fa_digtime=data.fa_digtime
                inst.fa_digresettask=inst:DoTaskInTime(MOUND_RESET_PERIOD-GetTime()+inst.fa_digtime,function() mound_reset(inst) end)
            else
                inst.fa_digtime=GetTime()
                inst.fa_digresettask=inst:DoTaskInTime(MOUND_RESET_PERIOD,function() mound_reset(inst) end)
            end
        end
    end    

--i dont know if it's dug or not until after load... configure is starting the process... so i have to type same thing 3 times
    inst:DoTaskInTime(0,function()
--[[
        if(inst.components.spawner and inst.components.spawner.nextspawntime)then
--            print("spawner active: ",inst.components.spawner.nextspawntime)
--        return
        end
]]
        if(inst.components.workable )then
            local onfinishcallback=inst.components.workable.onfinish
            inst.components.workable:SetOnFinishCallback(mound_digcallback)      
        else
            local nexttime=inst.components.spawner.nextspawntime or SKELETONSPAWNDELAY*math.random()
            inst.components.spawner:Configure( "skeletonspawn",SKELETONSPAWNDELAY,nexttime)
        end
    end)

end)

FA_ModUtil.AddPrefabPostInit("gravestone",function(inst)
    --[[ nah I so ain't doing this
    local old_loadpostpass=inst.OnLoadPostPass

    inst.OnLoadPostPass=function(inst,newents, data)
    --WARN i should probably return here... if they ever fix the mess they made... this will end up with double inits
        if(old_loadpostpass)then old_loadpostpass(inst,newents,data) end
        if data then
            if inst.mound and data.mounddata then
                inst.mound:LoadPostPass(data.mounddata.data, newents)
            end
        end
    end
]]
    if(inst.mound)then
--        inst:RemoveChild(inst.mound)
        inst.mound:Remove()
        inst.mound=nil
    end

    inst:DoTaskInTime(0,function()

        if(not inst.fa_mounded)then
            local mound=SpawnPrefab("mound")
            local pos=inst:GetPosition()+(TheCamera:GetDownVec()*.5)
            mound.Transform:SetPosition(pos:Get())
            inst.fa_mounded=true
        end
    end)

    local old_onsave=inst.OnSave
    inst.OnSave= function (inst, data)
        if(old_onsave) then old_onsave(inst,data) end
        if data and data.mounddata then
            --kill off manual saving
            data.mounddata=nil
        end
        data.fa_mounded=inst.fa_mounded
    end

    local old_onload=inst.OnLoad
    inst.OnLoad= function (inst, data)
        if(old_onload) then old_onload(inst,data) end
        if(data)then
            inst.fa_mounded=data.fa_mounded
        end
    end
end)


local nonEvilDapperFn=function(inst1,owner,dapperness)
            if(owner and owner:HasTag("evil"))then
                return 0
            else
                return dapperness
            end
end

local nonEvilSanityPostinit=function(inst)
    if(FA_DLCACCESS)then
        inst.components.equippable.dapperfn=function(inst1,owner)
            return nonEvilDapperFn(inst1,owner,inst.components.equippable.dapperness)
        end
    else
        inst.components.dapperness.dapperfn=function(inst1,owner)
            return nonEvilDapperFn(inst1,owner,inst.components.dapperness.dapperness)
        end
    end
end

FA_ModUtil.AddPrefabPostInit("nightsword",nonEvilSanityPostinit)
FA_ModUtil.AddPrefabPostInit("armor_sanity",nonEvilSanityPostinit)
FA_ModUtil.AddPrefabPostInit("spiderhat",nonEvilSanityPostinit)

local newFlowerPicked=function(inst,picker)

    if(picker and picker.components.sanity)then
        local delta=TUNING.SANITY_TINY
        local prefab=inst.prefab
        if(picker:HasTag("evil"))then
            if(prefab=="flower")then
                delta=-TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=TUNING.SANITY_TINY
            end
        else
            if(prefab=="flower")then
                delta=TUNING.SANITY_TINY
            elseif (prefab=="flower_evil")then
                delta=-TUNING.SANITY_TINY
            end
        end
        picker.components.sanity:DoDelta(delta)
    end
    inst:Remove()
end

FA_ModUtil.AddPrefabPostInit("flower", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
FA_ModUtil.AddPrefabPostInit("flower_evil", function(inst) inst.components.pickable.onpickedfn=newFlowerPicked end)
FA_ModUtil.AddPrefabPostInit("petals_evil", function(inst) 
    local old_oneaten=inst.components.edible.oneaten
    inst.components.edible:SetOnEatenFn(function(inst,eater)
        if(eater and eater:HasTag("evil"))then
            if eater.components.sanity then
                eater.components.sanity:DoDelta(TUNING.SANITY_SMALL)
            end
        elseif(old_oneaten)then
            old_oneaten(inst,eater)
        end
    end)
end)

FA_ModUtil.AddPrefabPostInit("gunpowder", function(inst) 
    inst:AddComponent("reloading") 
    inst.components.reloading.ammotype="gunpowder"
    inst.components.reloading.returnuses=1
end)

--this has to be the only non-fx thing that doesn't have one...
FA_ModUtil.AddPrefabPostInit("thulecite_pieces", function(inst) 
    if(not inst.SoundEmitter)then
        inst.entity:AddSoundEmitter() 
    end
end)

--staff tags so they can go into wand bags
FA_ModUtil.AddPrefabPostInit("icestaff", function(inst) inst:AddTag("staff") end)
FA_ModUtil.AddPrefabPostInit("firestaff", function(inst) inst:AddTag("staff") end)
FA_ModUtil.AddPrefabPostInit("telestaff", function(inst) inst:AddTag("staff") end)
FA_ModUtil.AddPrefabPostInit("orangestaff", function(inst) 
    inst:AddTag("staff") 
    local canblink=inst.components.blinkstaff.CanBlinkToPoint
    function inst.components.blinkstaff:CanBlinkToPoint(pt)
        local level=SaveGameIndex:GetCurrentCaveLevel()
        if(level>3)then
--            local data=Levels.cave_levels[level]
            local ground = GetWorld()
            if ground then
                local owner = self.inst.components.inventoryitem.owner
                local ownerpt=owner:GetPosition()
                local clear=ground.Pathfinder:IsClear(ownerpt.x, ownerpt.y, ownerpt.z,
                                                         pt.x, pt.y, pt.z,
                                                         {ignorewalls = false, ignorecreep = true})
                if(not clear) then return false end
            end
        end
        return canblink(self,pt)
    end
end)
FA_ModUtil.AddPrefabPostInit("greenstaff", function(inst) inst:AddTag("staff") end)
FA_ModUtil.AddPrefabPostInit("yellowstaff", function(inst) inst:AddTag("staff") end)

--DLC PATCHUP
if(FA_DLCACCESS)then

    TUNING.NIGHTSTICK_DAMAGE=(TUNING.NIGHTSTICK_DAMAGE or 0)*1.5
    FA_ModUtil.AddPrefabPostInit("nightstick",function(inst)
        inst.components.weapon.stimuli=nil
        inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.ELECTRIC
    end)
    TUNING.ARMORDRAGONFLY_FIRE_RESIST=0
    FA_ModUtil.AddPrefabPostInit("armordragonfly",function(inst)
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.85
    end)
end