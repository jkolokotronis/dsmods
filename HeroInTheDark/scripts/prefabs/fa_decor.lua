
local fa_pillar_dwarf_assets={
    Asset( "ANIM", "anim/fa_pillar_dwarf.zip" ),
}
local fa_stool_assets={
    Asset( "ANIM", "anim/fa_stool.zip" ),
}
local fa_table_assets={
    Asset( "ANIM", "anim/fa_table.zip" ),
}
local fa_minecart_assets={
    Asset( "ANIM", "anim/fa_minecart.zip" ),
}
local fa_orcrefuse_assets={
    Asset( "ANIM", "anim/fa_orcrefuse.zip" ),
}
local fa_clothes_assets={
    Asset( "ANIM", "anim/fa_clothes.zip" ),
}
local fa_dorftorch_assets={
    Asset( "ANIM", "anim/fa_dorf_torch.zip" ),
}
local fa_fountain_assets={
    Asset("ANIM","anim/fa_fountain.zip")
}
local cageassets=
{
    Asset( "ANIM", "anim/player_cage_drop.zip" ),
    Asset( "ANIM", "anim/fa_cagechains.zip" ),
    Asset("ANIM", "anim/fa_orcfort_cage.zip"),
        Asset( "ANIM", "anim/bluegoblin.zip" ),

}
local function fn(bank,bld,animname,loop)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local build=bld or bank
    local animation=animname or "idle"
    local looping=loop or false

    anim:SetBank(bank)
    anim:SetBuild(build)
    anim:PlayAnimation(animation,looping)
    inst:AddTag("NOCLICK")

    inst.fa_rotate=function(dest)
    	anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    	local angle = inst:GetAngleToPoint(dest:GetPosition())
    	inst.Transform:SetRotation(angle)
	end
	
    return inst
end

local function fa_pillar_dwarf()
	local inst= fn("fa_pillar_dwarf")
    MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(1.3,1.3,1.3)

    inst.fire1 = SpawnPrefab( "pigtorch_flame" )
    local follower = inst.fire1.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire1", 0, 0, 0.1 )
    inst.fire1.components.firefx:SetLevel(2,true)
    inst.fire2 = SpawnPrefab( "pigtorch_flame" )
    local follower = inst.fire2.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire2", 0, 0, 0.1 )
    inst.fire2.components.firefx:SetLevel(2,true)

    return inst
end

local function fa_table()
    local inst= fn("fa_table")
    MakeObstaclePhysics(inst, 0.3)
    inst.Transform:SetScale(.75,.75,.75)
    return inst
end

local function fa_stool_blown()
    local inst= fn("fa_stool")
    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(.75,.75,.75)
    inst.AnimState:PlayAnimation("blown")
    return inst
end

local function fa_stool()
    local inst= fn("fa_stool")
    MakeInventoryPhysics(inst)
    inst.Transform:SetScale(.75,.75,.75)
    return inst
end

local function fa_clothes()
    local inst= fn("fa_clothes")
    MakeInventoryPhysics(inst)
    return inst
end

local function fa_minecart()
    local inst= fn("fa_minecart","fa_minecart","full")
    MakeObstaclePhysics(inst, 1)
    inst:RemoveTag("NOCLICK")

    inst:AddComponent("activatable")
    inst.components.activatable.OnActivate = OnActivate
    inst.components.activatable.inactive = true
    inst.components.activatable.getverb = function() return STRINGS.ACTIONS.ACTIVATE.SEARCH end
    inst.components.activatable.quickaction = false

    local function GetVerb(inst)
        return STRINGS.ACTIONS.ACTIVATE.ENTER
    end

--TODO change this if they (or I) ever fix save/load on activatable
    inst.OnSave = function(inst, data)
        data.looted=not inst.components.activatable.inactive
    end        
    inst.OnLoad = function(inst, data)
        if(data.looted)then
            inst.components.activatable.inactive=false
            inst.AnimState:PlayAnimation("empty")
        end
    end    
    
    local function OnActivate(inst,doer)
        local spawn=SpawnPrefab("fa_copperpebble")
        doer.components.inventory:GiveItem(spawn)
        inst.AnimState:PlayAnimation("empty")
    end

    return inst
end

local function fountainfn()
    local inst= fn("fa_fountain","fa_fountain","idle",true)
    MakeObstaclePhysics(inst, 0.5)
    inst:RemoveTag("NOCLICK")
    inst.playindex=1
    local anims={"idle","bad","good"}
    inst:DoPeriodicTask(10,function()
        inst.playindex=(inst.playindex+1)%3+1
        inst.AnimState:PlayAnimation(anims[inst.playindex],true)
    end)
    return inst
end

local function orcrefuse()
    local inst= fn("fa_orcrefuse")
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    MakeObstaclePhysics(inst, 0.5)
    inst:RemoveTag("NOCLICK")
    return inst
end


local function dorftorchfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()

    MakeObstaclePhysics(inst, 0.1)
    inst.Transform:SetScale(0.70, 0.70, 0.70)

--    inst:AddComponent("inspectable")


    inst.fire = SpawnPrefab( "pigtorch_flame" )
    local follower = inst.fire.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire", 0, 0, 0.1 )
    inst.fire.components.firefx:SetLevel(3,true)

    anim:SetBank("fa_dorf_torch")
    anim:SetBuild("fa_dorf_torch")
    anim:PlayAnimation("idle", true)


    inst:AddTag("structure")
   
    --MakeSnowCovered(inst, .01)
    return inst
end


local function cagefn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
         
        inst.AnimState:SetBank("wilson")
        inst.AnimState:SetBuild("bluegoblin")

        inst.AnimState:OverrideSymbol("chains", "fa_cagechains", "chains")
        inst.AnimState:OverrideSymbol("cage", "fa_orcfort_cage", "cage")
        inst.AnimState:PlayAnimation("fa_cagedrop",true)

    inst:AddComponent("inspectable")

    return inst
end


return Prefab( "common/fa_dorf_gold_pillar", fa_pillar_dwarf, fa_pillar_dwarf_assets),
Prefab( "common/fa_dorf_stool", fa_stool, fa_stool_assets),
Prefab( "common/fa_dorf_stool_blown", fa_stool_blown, fa_stool_assets),
Prefab( "common/fa_clothes", fa_clothes, fa_clothes_assets),
Prefab( "common/fa_dorf_table", fa_table, fa_table_assets),
Prefab( "common/fa_dorf_light", dorftorchfn, fa_dorftorch_assets),
Prefab( "common/fa_minecart", fa_minecart, fa_minecart_assets),
Prefab( "common/fa_playerjailcage", cagefn, cageassets),
Prefab( "common/fa_fountain", fountainfn, fa_fountain_assets),
Prefab( "common/fa_orcjailcage", cagefn, cageassets)