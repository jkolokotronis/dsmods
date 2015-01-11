local assets =
{
	Asset("ANIM", "anim/fa_orebars.zip"),	
}

local prefabs =
{

}

local function barfn(name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

    inst:AddTag("fa_bar")
--    inst.AnimState:SetBank("fa_"..name.."pebble")
	inst.AnimState:SetBank("fa_"..name.."bar")
    inst.AnimState:SetBuild("fa_orebars")
	inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_"..name.."bar"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = name
	inst.components.repairer.healthrepairvalue = 4*TUNING.REPAIR_ROCKS_HEALTH

	return inst
end

local function lavabarfn(Sim)
	local inst=  barfn("lava")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "lava"
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH
    return inst
end

local function ironbarfn(Sim)
	return barfn("iron")
end

local function pigironbarfn(Sim)
	return barfn("pigiron")
end

local function coalbarfn(Sim)
	local inst= barfn("coal")
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME*4)
    MakeSmallPropagator(inst)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL*4
    return inst
end

local function limebarfn(Sim)
	return barfn("limestone")
end

local function adamantinebarfn(Sim)
	return barfn("adamantine")
end

local function copperbarfn(Sim)
	return barfn("copper")
end

local function silverbarfn(Sim)
	return barfn("silver")
end

local function steelbarfn(Sim)
	return barfn("steel")
end

local function goldbarfn(Sim)
	return barfn("gold")
end 
return Prefab( "common/inventory/fa_ironbar", ironbarfn, assets,prefabs),
Prefab( "common/inventory/fa_pigironbar", pigironbarfn, assets,prefabs),
Prefab( "common/inventory/fa_coalbar", coalbarfn, assets,prefabs),
Prefab( "common/inventory/fa_adamantinebar", adamantinebarfn, assets,prefabs),
Prefab( "common/inventory/fa_copperbar", copperbarfn, assets,prefabs),
Prefab( "common/inventory/fa_steelbar", steelbarfn, assets,prefabs),
Prefab( "common/inventory/fa_silverbar", silverbarfn, assets,prefabs),
Prefab( "common/inventory/fa_goldbar", goldbarfn, assets,prefabs),
Prefab( "common/inventory/fa_lavabar", lavabarfn, assets,prefabs)