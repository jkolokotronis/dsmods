-- TODO decompile/repack this mess into single files, no reason to split shit like this
local rock_assets =
{
	Asset("ANIM", "anim/fa_lavarock.zip"),
	Asset("ANIM", "anim/fa_lavarock2.zip"),
	Asset("ANIM", "anim/fa_lavarock3.zip"),
	Asset("ANIM", "anim/fa_ironrock.zip"),
	Asset("ANIM", "anim/fa_limestonerock.zip"),
	Asset("ANIM", "anim/fa_coalrock.zip"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "fa_lavapebble",
    "fa_ironpebble",
    "fa_coalpebble",
    "fa_limestonepebble",
    "fa_adamantinepebble",
    "fa_copperpebble",
    "goldnugget",
    "flint",
}    

local IRON_MINE=12
local LIME_MINE=6
local COAL_MINE=8
local COPPER_MINE=10
local ADAMANTINE_MINE=22
local LAVA_MINE=8

SetSharedLootTable( 'fa_lavarock',
{
    {'rocks',  1.00},
    {'fa_lavapebble',  1.00},
    {'fa_lavapebble',  1.00},
    {'fa_lavapebble',  1.00},
    {'fa_lavapebble',  0.50},
    {'flint',  1.0},
})

SetSharedLootTable( 'fa_ironrock',
{
    {'rocks',  1.00},
    {'fa_ironpebble',  1.00},
    {'fa_ironpebble',  0.80},
    {'fa_ironpebble',  0.40},
})

SetSharedLootTable( 'fa_coalrock',
{
    {'fa_coalpebble',  1.00},
    {'fa_coalpebble',  1.00},
    {'fa_coalpebble',  1.00},
    {'fa_coalpebble',  0.80},
    {'fa_coalpebble',  0.40},
})

SetSharedLootTable( 'fa_limestonerock',
{
    {'rocks',  1.00},
    {'fa_limestonepebble',  1.00},
    {'fa_limestonepebble',  1.00},
    {'fa_limestonepebble',  0.80},
})

SetSharedLootTable( 'fa_adamantinerock',
{
    {'fa_adamantinepebble',  1.00},
    {'fa_adamantinepebble',  1.00},
    {'fa_adamantinepebble',  .50},
    {'fa_adamantinepebble',  0.20},
    {'fa_adamantinepebble',  0.20},
    {'fa_adamantinepebble',  0.2},
})

SetSharedLootTable( 'fa_copperrock',
{
    {'fa_copperpebble',  1.00},
    {'fa_copperpebble',  0.80},
    {'fa_copperpebble',  0.8},
    {'fa_silverpebble',  0.20},
    {'fa_silverpebble',  0.20},
})

	local function resolveanimtoplay(percent,stages)
		local anim_to_play = ""..stages
		for i=1,stages-1 do
			if(percent<=(i/stages))then
				anim_to_play=""..i
				break
			end
		end
		return anim_to_play
	end

local lavatypes={
	"fa_lavarock",
	"fa_lavarock2",
	"fa_lavarock3"
}


local function rockonsave(inst, data)
	data.anim = inst.animname
end

local function rockonload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
		inst.AnimState:SetBank(inst.animname)
	    inst.AnimState:SetBuild(inst.animname)
	    --are comps loaded yet?
	    if(inst.components.workable and inst.components.workable.workleft>0)then
	    	inst.AnimState:PlayAnimation(resolveanimtoplay(inst.components.workable.workleft/inst.components.workable.maxwork,inst.stages))
	    end
	end
end

local function baserock_fn(name,animnames,minehits)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	inst.animname="fa_"..name.."rock"
	if(animnames)then
	    if(type(animnames) == "table" )then
	    	inst.animname = animnames[math.random(#animnames)]
    	else
    		inst.animname=animnames
    	end
    end
    inst.stages=3
-- I'm just gonna force one that I renamed here
--	inst.AnimState:SetBank("fa_"..name.."rock")
	inst.AnimState:SetBank(inst.animname)
	inst.AnimState:SetBuild(inst.animname)
	inst.AnimState:PlayAnimation("anim")

	MakeObstaclePhysics(inst, 1.)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "rock.png" )

	inst:AddComponent("lootdropper") 
	inst.components.lootdropper:SetChanceLootTable('fa_'..name..'rock')
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable.savestate=true
	inst.components.workable:SetWorkLeft(minehits or TUNING.ROCKS_MINE)
	inst.components.workable:SetMaxWork(minehits or TUNING.ROCKS_MINE)
	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)
			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				inst:Remove()
			else
				inst.AnimState:PlayAnimation(resolveanimtoplay(workleft/inst.components.workable.maxwork,inst.stages))
			end
		end)     

    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)    

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	MakeSnowCovered(inst, .01)        

    inst.OnSave = rockonsave 
    inst.OnLoad = rockonload 

	return inst
end

local function rock1_fn(Sim)
	local inst = baserock_fn("lava",lavatypes,LAVA_MINE)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    inst.entity:AddLight()
	inst.Light:SetRadius(.8)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(150/255,15/255,15/255)
	inst.Light:Enable(true)

	return inst
end

local function ironrock()
	return baserock_fn("iron",nil,IRON_MINE)
end
local function coalrock()
	local inst=baserock_fn("coal",nil,COAL_MINE)
	inst.stages=4
	return inst
end
local function limestonerock()
	local inst=baserock_fn("limestone",nil,LIME_MINE)
	inst.stages=5
	return inst
end
local function adamantinerock()
	return baserock_fn("adamantine",nil,ADAMANTINE_MINE)
end
local function copperrock()
	return baserock_fn("copper",nil,COPPER_MINE)
end

local pebble_assets=
{
	Asset("ANIM", "anim/fa_lavapebble.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_lavapebble.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_lavapebble.tex"),
}

local lavapebble_names = {"f1","f2","f3"}

local function pebbleonsave(inst, data)
	data.anim = inst.animname
end

local function pebbleonload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function pebblefn(name,animnames)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.animname="idle"

    if(animnames)then
	    if(type(animnames) == "table" )then
	    	inst.animname = animnames[math.random(#animnames)]
    	else
    		inst.animname=animnames
    	end
    end
	inst.AnimState:PlayAnimation(inst.animname)

	inst:AddTag("ore")
--    inst.AnimState:SetBank("fa_"..name.."pebble")
	 inst.AnimState:SetBank("fa_lavapebble")
    inst.AnimState:SetBuild("fa_"..name.."pebble")

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_"..name.."pebble"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_"..name.."pebble.xml"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = name
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH

    inst.OnSave = pebbleonsave 
    inst.OnLoad = pebbleonload 

	return inst
end

local function lavapebblefn(Sim)
	local inst=pebblefn("lava",lavapebble_names)
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    return inst
end

local function ironpebblefn(Sim)
	return pebblefn("iron",lavapebble_names)
end

local function coalpebblefn(Sim)
	local inst= pebblefn("coal",lavapebble_names)
	MakeSmallBurnable(inst, TUNING.LARGE_BURNTIME*2)
    MakeSmallPropagator(inst)
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.LARGE_FUEL*2
    return inst
end

local function limestonepebblefn(Sim)
	return pebblefn("limestone",lavapebble_names)
end

local function adamantinepebblefn(Sim)
	return pebblefn("adamantine",lavapebble_names)
end

local function copperpebblefn(Sim)
	return pebblefn("copper",lavapebble_names)
end

local function silverpebblefn(Sim)
	return pebblefn("silver",lavapebble_names)
end

return Prefab( "common/inventory/fa_lavapebble", lavapebblefn, pebble_assets),
Prefab( "common/inventory/fa_ironpebble", ironpebblefn, pebble_assets),
Prefab( "common/inventory/fa_coalpebble", coalpebblefn, pebble_assets),
Prefab( "common/inventory/fa_limestonepebble", limestonepebblefn, pebble_assets),
Prefab( "common/inventory/fa_adamantinepebble", adamantinepebblefn, pebble_assets),
Prefab( "common/inventory/fa_copperpebble", copperpebblefn, pebble_assets),
Prefab( "common/inventory/fa_silverpebble", silverpebblefn, pebble_assets),
		Prefab("mines/objects/rocks/fa_lavarock", rock1_fn, rock_assets, prefabs),
		Prefab("mines/objects/rocks/fa_ironrock", ironrock, rock_assets, prefabs),
		Prefab("mines/objects/rocks/fa_coalrock", coalrock, rock_assets, prefabs),
		Prefab("mines/objects/rocks/fa_limestonerock", limestonerock, rock_assets, prefabs),
		Prefab("mines/objects/rocks/fa_adamantinerock", adamantinerock, rock_assets, prefabs),
		Prefab("mines/objects/rocks/fa_copperrock", copperrock, rock_assets, prefabs)
		

