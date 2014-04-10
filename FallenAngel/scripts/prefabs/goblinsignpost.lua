    
local assets =
{
	Asset("ANIM", "anim/sign_home.zip"),
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
    
    anim:SetBank("sign_home")
    anim:SetBuild("sign_home")
    anim:PlayAnimation("idle")
    
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

return Prefab( "common/objects/goblinsign_1", fn, assets),
Prefab( "common/objects/goblinsign_2", fn, assets),
Prefab( "common/objects/goblinsign_3", fn, assets)
--		MakePlacer( "common/homesign_placer", "sign_home", "sign_home", "idle" ) 
