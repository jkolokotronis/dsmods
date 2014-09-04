local assets=
{
    Asset("ANIM", "anim/fa_rings.zip"),
    
    Asset("ATLAS", "images/inventoryimages/fa_rings.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_rings.tex"),
}
local FROZEN_DAPPERNESS=-1
local BURNING_DAPPERNESS=-1
local LIGHT_DAPPERNESS=1
local RING_FUELLEVEL=200
local SPEED_MULT=1.5

local function onfinished(inst)
    inst:Remove()
end

local function fn(color,type)
		local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		MakeInventoryPhysics(inst)
		
    inst.AnimState:SetBank("fa_ring_"..color.."_"..type)
    inst.AnimState:SetBuild("fa_rings")
    inst.AnimState:PlayAnimation("idle")
	    
	    local minimap = inst.entity:AddMiniMapEntity()
    	minimap:SetIcon( "fa_key.tex" )

		inst:AddComponent("inspectable")
	    inst:AddComponent("inventoryitem")
    	inst.components.inventoryitem.imagename="fa_ring_"..color.."_"..type
    	inst.components.inventoryitem.atlasname="images/inventoryimages/fa_rings.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.RING

	    
		inst:AddComponent("tradable")
	    
		return inst
	end

local function fnfoli()
	return fn("green","gold")
end


local function startfueled(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function stopfueled(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
end

local function fnfrozen()
	local inst=fn("blue","silver")
	if(FA_DLCACCESS)then
		inst.components.equippable.dapperness =FROZEN_DAPPERNESS
	else
		inst:AddComponent("dapperness")
		inst.components.dapperness.dapperness =FROZEN_DAPPERNESS    
	end

        inst.components.equippable:SetOnEquip( startfueled )
        inst.components.equippable:SetOnUnequip( stopfueled )
        inst:AddComponent("heater")
        inst.components.heater.iscooler = true
        --i want it to decline x/sec, so it should return always xc lower than current i guess, although it is still subject to summer/winter insulation
        inst.components.heater.equippedheatfn=function(owner, observer)
        	if(owner and owner.components.temperature and owner.components.temperature.current)then
        		return owner.component.temperature.current-1
        	else
        		return 0
        	end
	    end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
	return inst
end

local function fnburning()
	local inst=fn("red","bronze")
	if(FA_DLCACCESS)then
		inst.components.equippable.dapperness =BURNING_DAPPERNESS
	else
		inst:AddComponent("dapperness")
		inst.components.dapperness.dapperness =BURNING_DAPPERNESS    
	end

        inst.components.equippable:SetOnEquip( startfueled )
        inst.components.equippable:SetOnUnequip( stopfueled )
    inst:AddComponent("heater")
	inst.components.heater.equippedheatfn=function(owner, observer)
        	if(owner and owner.components.temperature and owner.components.temperature.current)then
        		return owner.component.temperature.current+1
        	else
        		return 0
        	end
	    end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
	return inst
end

local function fnspeed()
	local inst=fn("green","silver")
    inst.components.equippable.walkspeedmult = SPEED_MULT
        inst.components.equippable:SetOnEquip( startfueled )
        inst.components.equippable:SetOnUnequip( stopfueled )
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
	return inst
end


local function startlight(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    inst.pooptask=inst:DoPeriodicTask(2,function()
            if(owner.components.hunger)then
                owner.components.hunger:DoDelta(-1)
            end
    end)

    local le = CreateEntity()
    le.entity:AddTransform()

    le:AddComponent("lighttweener")
    le.light = le.entity:AddLight()
    le.light:Enable(true)
    le:AddTag("FX")
    le:AddTag("NOCLICK")
    le.persists=false
    le.components.lighttweener:StartTween(le.light, 4, 0.8, 0.8, {180/255, 100/255, 100/255}, 1)
    local follower = le.entity:AddFollower()
    follower:FollowSymbol( owner.GUID, owner.components.combat.hiteffectsymbol, 0, 0, 1 )
    inst.light_entity=le
end

local function stoplight(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    if(inst.light_entity)then
        inst.light_entity:Remove()
        inst.light_entity=nil
    end
end

local function fnlight()
	local inst=fn("yellow","gold")

    local light = inst.entity:AddLight()
    light:SetFalloff(0.8)
    light:SetIntensity(.8)
    light:SetRadius(1)
    light:Enable(true)
    light:SetColour(180/255, 100/255, 100/255)


        inst.components.equippable:SetOnEquip( startlight )
        inst.components.equippable:SetOnUnequip( stoplight )

	if(FA_DLCACCESS)then
		inst.components.equippable.dapperness =LIGHT_DAPPERNESS
	else
		inst:AddComponent("dapperness")
		inst.components.dapperness.dapperness =LIGHT_DAPPERNESS    
	end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
	return inst
end


local function startpoop(inst, owner) 
	if(inst.pooptask)then
		inst.pooptask:Cancel()
		inst.pooptask=nil
	end
	inst.pooptask=inst:DoPeriodicTask(2,function()
		if(owner and owner:IsValid() and not (owner.components.health and owner.components.health:IsDead()))then
			local poo = SpawnPrefab("poop")
	        poo.Transform:SetPosition(owner.Transform:GetWorldPosition())  
            --simply making a hunger_drain comp might be better... cant just change 'rate' because changing that would get overwritten by various other factors
            if(owner.components.hunger)then
                owner.components.hunger:DoDelta(-owner.components.hunger.hungerrate*2)
            end
		else
			print("warning: invalid owner of equipped ring!")
		end
	end)
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function stoppoop(inst, owner) 
	if(inst.pooptask)then
		inst.pooptask:Cancel()
		inst.pooptask=nil
	end
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
end

local function fnpoop()
	local inst=fn("orange","bronze")
        inst.components.equippable:SetOnEquip( startpoop )
        inst.components.equippable:SetOnUnequip( stoppoop )

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
	return inst
end 

return	Prefab( "common/inventory/fa_ring_green_gold", fnfoli, assets),
Prefab( "common/inventory/fa_ring_frozen", fnfrozen, assets),
Prefab( "common/inventory/fa_ring_burning", fnburning, assets),
Prefab( "common/inventory/fa_ring_speed", fnspeed, assets),
Prefab( "common/inventory/fa_ring_poop", fnpoop, assets),
Prefab( "common/inventory/fa_ring_light", fnlight, assets)