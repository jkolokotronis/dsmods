local Assets =
{
	Asset("ANIM", "anim/fa_bottle_r.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_bottle_r.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottle_r.tex" ),
	Asset("ANIM", "anim/fa_bottle_y.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_bottle_y.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottle_y.tex" ),
	Asset("ANIM", "anim/fa_bottle_g.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_bottle_g.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottle_g.tex" ),
	Asset("ANIM", "anim/fa_bottle_b.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_bottle_b.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bottle_b.tex" ),
	Asset("ANIM", "anim/frog.zip"),
	Asset("SOUND", "sound/frog.fsb"),
}

local prefabs = {
    "blueprint"
}
local WONDER_EFFECTS={
	{
		fn=function(eater)

			print("haste")
			inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED
			eater:DoTaskInTime(240,function() inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED end)
		end
	},
	{
		fn=function(eater)
		print("slow")
			inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-TUNING.WILSON_RUN_SPEED/2
			eater:DoTaskInTime(240,function() inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+TUNING.WILSON_RUN_SPEED/2 end)
		end
	},
	{
		fn=function(eater)
			eater.components.health:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			eater.components.health:DoDelta(-50)
		end
	},
	{
		fn=function(eater)
			eater.components.hunger:DoDelta(-50)
		end
	},
	{
		fn=function(eater)
		print("sleep")
			eater.components.health:SetInvincible(true)
			eater.components.playercontroller:Enable(false)

			GetPlayer().HUD:Hide()
			TheFrontEnd:Fade(false,1)
			eater:DoTaskInTime(1.2, function() 
		
				GetPlayer().HUD:Show()
				TheFrontEnd:Fade(true,1) 
				eater.components.health:SetInvincible(false)
				eater.components.playercontroller:Enable(true)
				eater.sg:GoToState("wakeup")	
			end)

		end
	},
	{
		fn=function(eater)
			print("gold")
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("goldnugget") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)

			print("LS")
			local pos=Vector3(eater.Transform:GetWorldPosition())
			SeasonManager:DoLightningStrike(pos)			
--			local lightning = SpawnPrefab("lightning")
--            lightning.Transform:SetPosition(pos:Get())
		end
	},
	{
		fn=function(eater)
			eater.components.sanity:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			eater.components.sanity:SetPercent(0.05)
		end
	},
	{
		fn=function(eater)
			eater.components.hunger:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			eater.components.hunger:DoDelta(200)
		end
	},
	{
		fn=function(eater)
			print("nightmare")
			local pt= Vector3(eater.Transform:GetWorldPosition())
		    for i=1,10 do
	        local drop = SpawnPrefab("nightmarefuel") 
    	    drop.Physics:SetCollides(false)
        	drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        	drop.Physics:SetCollides(true)
        	eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
		    end

		end
	},
	{
		fn=function(eater)
			eater.components.kramped:OnNaughtyAction(30)
		end
	},
	{
		fn=function(eater)
			print("break")
			for k,v in pairs(eater.components.inventory.itemslots) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(v.components.fueled:GetPercent()/2)
        		elseif v.components.armor then
        			v.components.armor:SetPercent(v.components.armor:GetPercent()/2)
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(v.components.finiteuses:GetPercent()/2)
        		end
    		end
		end
	},
	{
		fn=function(eater)
			print("repair")
			for k,v in pairs(eater.components.inventory.itemslots) do
		        if v.components.fueled then
        		    v.components.fueled:SetPercent(1)
        		elseif v.components.armor then
        			v.components.armor:SetPercent(1)
        		elseif v.components.finiteuses then
        			v.components.finiteuses:SetPercent(1)
        		end
    		end
		end
	},
	{
		fn=function(eater)
			print("blueprints")
			local b=MakeAnyBlueprint()
			if(b)then
				local pt= Vector3(eater.Transform:GetWorldPosition())
				b.Transform:SetPosition(pt:Get())
			end
		end
	},
	{
		fn=function(eater)
			print("gems!")
			for k,v in pairs({"redgem","bluegem","purplegem"}) do
				local drop = SpawnPrefab(v) 
    		    drop.Physics:SetCollides(false)
        		drop.Physics:Teleport(pt.x+(math.random()-0.5)*5, pt.y+3, pt.z+(math.random()-0.5)*5) 
        		drop.Physics:SetCollides(true)
        		eater.SoundEmitter:PlaySound("dontstarve/common/stone_drop")
        	end
		end
	},
	{
		fn=function(eater)
			print("blueprints")
			local b=MakeAnyBlueprint()
			if(b)then
				local pt= Vector3(eater.Transform:GetWorldPosition())
				b.Transform:SetPosition(pt:Get())
			end
		end
	},

}

local function oneaten(inst,eater)
end

local function eatwonder(inst,data)
	local eater=data.eater
	if(eater and eater:HasTag("player"))then
		local index=math.floor(1+(math.random() * #WONDER_EFFECTS))
		local effect=WONDER_EFFECTS[index]
		if(effect)then
			effect.fn(eater)
		else
			print("no effect??")
		end
	end
end

local function common(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

    MakeInventoryPhysics(inst)
        
    inst:AddComponent("inventoryitem")
	inst:AddComponent("inspectable")	
	
    inst:AddComponent("edible")
    inst.components.edible.healthvalue=0
    inst.components.edible.hungervalue=0
    inst.components.edible.sanityvalue=0
    inst.components.edible.foodtype = "FA_POTION"
    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = 20

    inst.components.edible.oneaten=oneaten
--    inst:ListenForEvent("oneaten",oneaten)
    
    return inst
end

local function fnr(Sim)

	local inst = common(Sim)
    inst.AnimState:SetBank("fa_bottle_r")
    inst.AnimState:SetBuild("fa_bottle_r")
    inst.AnimState:PlayAnimation("idle")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_bottle_r.xml"
    inst.components.inventoryitem.imagename="fa_bottle_r"
    inst.components.edible.healthvalue = 150
    return inst

end

local function fny(Sim)

	local inst = common(Sim)
    inst.AnimState:SetBank("fa_bottle_y")
    inst.AnimState:SetBuild("fa_bottle_y")
    inst.AnimState:PlayAnimation("idle")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_bottle_y.xml"
    inst.components.inventoryitem.imagename="fa_bottle_y"
    inst.components.edible.hungervalue = 150
    return inst

end

local function fng(Sim)

	local inst = common(Sim)
    inst.AnimState:SetBank("fa_bottle_g")
    inst.AnimState:SetBuild("fa_bottle_g")
    inst.AnimState:PlayAnimation("idle")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_bottle_g.xml"
    inst.components.inventoryitem.imagename="fa_bottle_g"
    inst.components.edible.sanityvalue = 150
    return inst

end


local function fnb(Sim)

	local inst = common(Sim)
    inst.AnimState:SetBank("fa_bottle_b")
    inst.AnimState:SetBuild("fa_bottle_b")
    inst.AnimState:PlayAnimation("idle")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_bottle_b.xml"
    inst.components.inventoryitem.imagename="fa_bottle_b"

	inst:ListenForEvent("oneaten",eatwonder)

    return inst

end

return Prefab( "common/inventory/fa_bottle_r", fnr, Assets),
	Prefab( "common/inventory/fa_bottle_y", fny, Assets),
	Prefab( "common/inventory/fa_bottle_g", fng, Assets),
	Prefab( "common/inventory/fa_bottle_b", fnb, Assets)
