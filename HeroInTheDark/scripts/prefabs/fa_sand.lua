local assets=
{
	Asset("ANIM", "anim/fa_sand.zip"),
}


local function BlowAway(inst)
    inst.blowawaytask = nil
    inst.persists = false
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("inspectable")
	inst.SoundEmitter:PlaySound("dontstarve/common/dust_blowaway")
	inst.AnimState:PlayAnimation("disappear")
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function StopBlowAway(inst)
	if inst.blowawaytask then
		inst.blowawaytask:Cancel()
		inst.blowawaytask = nil
	end
end
		
local function PrepareBlowAway(inst)
	StopBlowAway(inst)
	inst.blowawaytask = inst:DoTaskInTime(25+math.random()*10, BlowAway)
end


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("fa_sand")
    inst.AnimState:SetBuild("fa_sand")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    ---------------------       

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:SetOnPutInInventoryFn(StopBlowAway)
    inst.components.inventoryitem.imagename="fa_sand"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

   
	inst:ListenForEvent("ondropped",  PrepareBlowAway)
	PrepareBlowAway(inst)


    return inst
end

return Prefab( "common/inventory/fa_sand", fn, assets) 

