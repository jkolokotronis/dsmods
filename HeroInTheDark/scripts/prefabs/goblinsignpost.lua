    
local assets =
{
	Asset("ANIM", "anim/goblinsign_1.zip"),
	Asset("ANIM", "anim/goblinsign_2.zip"),
	Asset("ANIM", "anim/goblinsign_3.zip"),
	Asset("ANIM", "anim/goblinsign_4.zip"),
	Asset("ANIM", "anim/goblinsign_5.zip"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("hit")
	inst.AnimState:PushAnimation("idle")
end


local onloadfn = function(inst, data)
	if(data and data.description)then
    inst.description=data.description
    	inst.components.inspectable.description=data.description
	end
end

local onsavefn = function(inst, data)
    data.description=inst.description
end
    
local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	   
    MakeObstaclePhysics(inst, .2)    
    
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "sign.png" )
    
--    anim:SetBank("sign_home")
    
    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper") 
    
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)
 	MakeSnowCovered(inst, .01)	


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn
   
    return inst
end

function fn1(Sim)
	local inst=fn(Sim)
    inst.AnimState:SetBank("goblinsign_1")
    inst.AnimState:SetBuild("goblinsign_1")
    inst.AnimState:PlayAnimation("idle")
	return inst
end

function fn2(Sim)
	local inst=fn(Sim)
    inst.AnimState:SetBank("goblinsign_2")
    inst.AnimState:SetBuild("goblinsign_2")
    inst.AnimState:PlayAnimation("idle")
	return inst
end
function fn3(Sim)
	local inst=fn(Sim)
    inst.AnimState:SetBank("goblinsign_3")
    inst.AnimState:SetBuild("goblinsign_3")
    inst.AnimState:PlayAnimation("idle")
	return inst
end
function fn4(Sim)
	local inst=fn(Sim)
    inst.AnimState:SetBank("goblinsign_4")
    inst.AnimState:SetBuild("goblinsign_4")
    inst.AnimState:PlayAnimation("idle")
	return inst
end
function fn5(Sim)
	local inst=fn(Sim)
    inst.AnimState:SetBank("goblinsign_5")
    inst.AnimState:SetBuild("goblinsign_5")
    inst.AnimState:PlayAnimation("idle")
	return inst
end
return Prefab( "common/objects/goblinsign_1", fn1, assets),
Prefab( "common/objects/goblinsign_2", fn2, assets),
Prefab( "common/objects/goblinsign_3", fn3, assets),
Prefab( "common/objects/goblinsign_4", fn4, assets),
Prefab( "common/objects/goblinsign_5", fn5, assets),
Prefab( "common/objects/fa_wortox_sign", fn5, assets)
--		MakePlacer( "common/homesign_placer", "sign_home", "sign_home", "idle" ) 
