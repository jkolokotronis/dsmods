
local assets={
    Asset( "ANIM", "anim/fa_dorfkingstatue.zip" ),
}


local function pebbleonsave(inst, data)
	data.axed = inst.axed
end

local function pebbleonload(inst, data)
    if data and data.axed then
        inst.axed = data.axed
	    inst.AnimState:PlayAnimation("with_axe",true)
		inst.components.activatable.inactive = false
	end
end


local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function OnActivate(inst,doer)
	inst.SoundEmitter:PlaySound("fa/teleporter/activate")
	--inst.AnimState:PushAnimation("idle_on", true)
	
	local axe=doer.components.inventory:FindItem(function(i) return (i and i.prefab=="fa_dorfkingaxe") end)
	if(axe)then
		axe.components.inventoryitem:RemoveFromOwner(true)
		axe:Remove()
		inst.axed = true
	    inst.AnimState:PlayAnimation("with_axe",true)
	else
		inst.components.activatable.inactive=true
	end
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    inst.axed=false

    MakeObstaclePhysics(inst,1)
    anim:SetBank("fa_dorfkingstatue")
    anim:SetBuild("fa_dorfkingstatue")
    anim:PlayAnimation("idle",true)
    inst:AddComponent("inspectable")

    inst.fire1 = SpawnPrefab( "torchfire" )
    local follower = inst.fire1.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire1", 0, 0, 0.1 )
    inst.fire2 = SpawnPrefab( "torchfire" )
    local follower = inst.fire2.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire2", 0, 0, 0.1 )
    inst.fire3 = SpawnPrefab( "torchfire" )
    local follower = inst.fire3.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire3", 0, 0, 0.1 )
    inst.fire4 = SpawnPrefab( "torchfire" )
    local follower = inst.fire4.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire4", 0, 0, 0.1 )
    inst.fire5 = SpawnPrefab( "torchfire" )
    local follower = inst.fire5.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire5", 0, 0, 0.1 )
    inst.fire6 = SpawnPrefab( "torchfire" )
    local follower = inst.fire6.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fire6", 0, 0, 0.1 )

    inst.OnSave = pebbleonsave 
    inst.OnLoad = pebbleonload 

	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = false

	
    return inst
end


return Prefab( "common/fa_dorfkingstatue", fn, assets)