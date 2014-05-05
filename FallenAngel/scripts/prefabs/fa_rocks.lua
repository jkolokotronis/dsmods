local rock1_assets =
{
	Asset("ANIM", "anim/fa_lavarock.zip"),
	Asset("ANIM", "anim/fa_lavarock2.zip"),
	Asset("ANIM", "anim/fa_lavarock3.zip"),
}

local rock2_assets =
{
	Asset("ANIM", "anim/rock2.zip"),
}

local rock_flintless_assets =
{
	Asset("ANIM", "anim/rock_flintless.zip"),
}

local prefabs =
{
    "rocks",
    "nitre",
    "fa_lavapebble",
    "goldnugget",
}    

SetSharedLootTable( 'fa_lavarock',
{
    {'rocks',  1.00},
    {'fa_lavapebble',  1.00},
    {'fa_lavapebble',  1.00},
    {'fa_lavapebble',  1.00},
    {'goldnugget',  1.00},
    {'fa_lavapebble',  0.25},
    {'goldnugget',  0.60},
})


local function baserock_fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
	MakeObstaclePhysics(inst, 1.)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "rock.png" )

	inst:AddComponent("lootdropper") 
	
	inst:AddComponent("workable")
	inst.components.workable:SetWorkAction(ACTIONS.MINE)
	inst.components.workable:SetWorkLeft(TUNING.ROCKS_MINE)
	
	inst.components.workable:SetOnWorkCallback(
		function(inst, worker, workleft)
			local pt = Point(inst.Transform:GetWorldPosition())
			if workleft <= 0 then
				inst.SoundEmitter:PlaySound("dontstarve/wilson/rock_break")
				inst.components.lootdropper:DropLoot(pt)
				inst:Remove()
			else
				
				
				if workleft < TUNING.ROCKS_MINE*(1/3) then
					inst.AnimState:PlayAnimation("low")
				elseif workleft < TUNING.ROCKS_MINE*(2/3) then
					inst.AnimState:PlayAnimation("med")
				else
					inst.AnimState:PlayAnimation("full")
				end
			end
		end)     

    local color = 0.5 + math.random() * 0.5
    anim:SetMultColour(color, color, color, 1)    

	inst:AddComponent("inspectable")
	inst.components.inspectable.nameoverride = "ROCK"
	MakeSnowCovered(inst, .01)        
	return inst
end
local lavatypes={
	"fa_lavarock",
	"fa_lavarock2",
	"fa_lavarock3"
}

local function rock1_fn(Sim)
	local inst = baserock_fn(Sim)
	inst.AnimState:SetBank("fa_lavarock")
	inst.AnimState:SetBuild(lavatypes[math.random(#lavatypes)])
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
	inst.AnimState:PlayAnimation("full")

    inst.entity:AddLight()
	inst.Light:SetRadius(.8)
    inst.Light:SetFalloff(.5)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(150/255,15/255,15/255)
	inst.Light:Enable(true)
	inst.components.lootdropper:SetChanceLootTable('fa_lavarock')

	return inst
end


local lavapebble_assets=
{
	Asset("ANIM", "anim/fa_lavapebble.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_lavapebble.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_lavapebble.tex"),
}

local lavapebble_names = {"f1","f2","f3"}

local function lavapebbleonsave(inst, data)
	data.anim = inst.animname
end

local function lavapebbleonload(inst, data)
    if data and data.anim then
        inst.animname = data.anim
	    inst.AnimState:PlayAnimation(inst.animname)
	end
end

local function lavapebblefn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("fa_lavapebble")
    inst.AnimState:SetBuild("fa_lavapebble")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    inst.animname = lavapebble_names[math.random(#lavapebble_names)]
    inst.AnimState:PlayAnimation(inst.animname)

    inst:AddComponent("edible")
    inst.components.edible.foodtype = "ELEMENTAL"
    inst.components.edible.hungervalue = 1
    inst:AddComponent("tradable")
    
    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_lavapebble"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_lavapebble.xml"

	inst:AddComponent("repairer")
	inst.components.repairer.repairmaterial = "lava"
	inst.components.repairer.healthrepairvalue = TUNING.REPAIR_ROCKS_HEALTH

    inst.OnSave = lavapebbleonsave 
    inst.OnLoad = lavapebbleonload 
    return inst
end

return Prefab( "common/inventory/fa_lavapebble", lavapebblefn, lavapebble_assets),
		Prefab("mines/objects/rocks/fa_lavarock", rock1_fn, rock1_assets, prefabs)
		

