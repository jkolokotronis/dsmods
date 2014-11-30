local redshroomassets=
{
	Asset("ANIM", "anim/fa_redshroom.zip"),
}
local pinkshroomassets=
{
	Asset("ANIM", "anim/fa_pinkshroom.zip"),
}
local greenshroomassets=
{
	Asset("ANIM", "anim/fa_greenshroom.zip"),
}
local redshroomcapassets=
{
	Asset("ANIM", "anim/fa_redshroomcap.zip"),

    Asset( "IMAGE", "images/inventoryimages/fa_redshroomcap.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_redshroomcap.xml" ),
}
local pinkshroomcapassets=
{
	Asset("ANIM", "anim/fa_pinkshroomcap.zip"),

    Asset( "IMAGE", "images/inventoryimages/fa_pinkshroomcap.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_pinkshroomcap.xml" ),
}
local greenshroomcapassets=
{
	Asset("ANIM", "anim/fa_greenshroomcap.zip"),
    
    Asset( "IMAGE", "images/inventoryimages/fa_greenshroomcap.tex" ),
    Asset( "ATLAS", "images/inventoryimages/fa_greenshroomcap.xml" ),
}

local function onregenfn(inst)
	inst.AnimState:PlayAnimation("idle", true)
        inst.Light:Enable(true)
end

local function makeemptyfn(inst)
	inst.AnimState:PlayAnimation("picked")
        inst.Light:Enable(false)
end

local function onpickedfn(inst)
	--inst.SoundEmitter:PlaySound("dontstarve/wilson/pickup_reeds") 
	inst.AnimState:PushAnimation("picked")
        inst.Light:Enable(false)
	
end

    local function GetStatus(inst)
        if inst.components.pickable and inst.components.pickable.canbepicked and inst.components.pickable.caninteractwith then
            return "GENERIC"
        else 
            return "PICKED"
        end
    end
local function shroomfn(name)
    	local inst = CreateEntity()
        inst.entity:AddSoundEmitter()
    	inst.entity:AddTransform()


    local light = inst.entity:AddLight()
    light:SetFalloff(1)
    light:SetIntensity(0.4)
    light:SetRadius(2)
    light:SetColour(255/255, 150/255, 150/255)
    light:Enable(true)
    
    	
    	inst.entity:AddAnimState()
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")
        inst.AnimState:SetRayTestOnBB(true)
        inst:AddComponent("inspectable")
        inst.components.inspectable.getstatus = GetStatus

        inst:AddComponent("pickable")
        inst.components.pickable.picksound = "dontstarve/wilson/pickup_plants"
        inst.components.pickable:SetUp(name.."cap",  TUNING.GRASS_REGROW_TIME)
        inst.components.pickable:SetOnPickedFn(onpickedfn)
        inst.components.pickable:SetOnRegenFn( onregenfn)
        inst.components.pickable:SetMakeEmptyFn(makeemptyfn)
        --inst.components.pickable.quickpick = true
        
      	return inst
end



    local function capfn(name)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()

        MakeInventoryPhysics(inst)
        
        inst.AnimState:SetBank(name)
        inst.AnimState:SetBuild(name)
        inst.AnimState:PlayAnimation("idle")
        
        inst:AddComponent("stackable")
        inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

        inst:AddComponent("tradable")
        inst:AddComponent("inspectable")
        
        MakeSmallBurnable(inst, TUNING.TINY_BURNTIME)
        MakeSmallPropagator(inst)
        inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname="images/inventoryimages/"..name..".xml"

        --this is where it gets interesting
        inst:AddComponent("edible")
        inst.components.edible.healthvalue = 1
        inst.components.edible.hungervalue = 1
        inst.components.edible.sanityvalue = 1
        inst.components.edible.foodtype = "VEGGIE"
        
        inst:AddComponent("perishable")
        inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
        inst.components.perishable:StartPerishing()
        inst.components.perishable.onperishreplacement = "spoiled_food"


        return inst
    end


local function redcap()
    local inst=capfn("fa_redshroomcap")
    return inst
end
local function greencap()
    local inst=capfn("fa_greenshroomcap")
    return inst
end
local function pinkcap()
    local inst=capfn("fa_pinkshroomcap")
    return inst
end
local function redfn()
    local inst=shroomfn("fa_redshroom")
    return inst
end
local function pinkfn()
    local inst=shroomfn("fa_pinkshroom")
    return inst
end
local function greenfn()
    local inst=shroomfn("fa_greenshroom")
    return inst
end


return Prefab( "common/fa_redshroomcap", redcap, redshroomcapassets, prefabs),
Prefab( "common/fa_pinkshroomcap", pinkcap, pinkshroomcapassets, prefabs),
Prefab( "common/fa_greenshroomcap", greencap, greenshroomcapassets, prefabs),
Prefab( "common/fa_redshroom", redfn, redshroomassets, prefabs),
Prefab( "common/fa_pinkshroom", pinkfn, pinkshroomassets, prefabs),
Prefab( "common/fa_greenshroom", greenfn, greenshroomassets, prefabs)