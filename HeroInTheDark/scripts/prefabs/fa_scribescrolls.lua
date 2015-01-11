--why not just blueprints? every single rng-scribe mech made me want to break my screen. Lower rng influence. 
require "recipes"

assets = 
{
	Asset("ANIM", "anim/blueprint.zip"),
	Asset("ANIM", "anim/fa_scrolls.zip"),
}

local function onload(inst, data)
	if data then
		if data.recipetouse then
			inst.recipetouse = data.recipetouse
			inst.components.teacher:SetRecipe(inst.recipetouse)
	    	inst.components.named:SetName(STRINGS.NAMES[string.upper(inst.recipetouse)].." "..STRINGS.NAMES.BLUEPRINT)
	    end
		inst.lowbound=data.lowbound
		inst.highbound=data.highbound
	end
end

local function onsave(inst, data)
	if inst.recipetouse then
		data.recipetouse = inst.recipetouse

	end
	data.lowbound=inst.lowbound
	data.highbound=inst.highbound
	
end

local function OnTeach(inst, learner)
	local recipe=GetRecipe(inst.recipetouse)
	print("in onteach ",recipe)
        local prod = SpawnPrefab(recipe.product)
        if recipe.numtogive > 1 and prod.components.stackable then
           	prod.components.stackable:SetStackSize(recipe.numtogive)
			learner.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
        elseif recipe.numtogive > 1 and not prod.components.stackable then
			learner.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
			for i = 2, recipe.numtogive do
				local addt_prod = SpawnPrefab(recipe.product)
				learner.components.inventory:GiveItem(addt_prod, nil, TheInput:GetScreenPosition())
			end
	    else
			learner.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
        end
		prod:OnBuilt(learner)
	return true
end


local function selectrecipe_any(recipes)
	if next(recipes) then
		return recipes[math.random(1, #recipes)]
	end
end

local function fn()

	local inst = CreateEntity()
	inst.entity:AddTransform()
    MakeInventoryPhysics(inst)
	inst.entity:AddAnimState()
    inst.AnimState:SetBank("blueprint")
	inst.AnimState:SetBuild("blueprint")
	inst.AnimState:PlayAnimation("idle")
    inst:AddComponent("inspectable")    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")
    inst:AddComponent("named")
    inst.components.named:SetName("Unknown Scroll")
    inst:AddComponent("teacher")

    inst.lowbound=1
    inst.highbound=9999

    --too late
--    inst.components.teacher.onteach = OnTeach

    inst.setRecipe=function(low, high,caster)
    	if(caster.fa_spellcraft and caster.fa_spellcraft.spells and GetTableSize(caster.fa_spellcraft.spells)>0) then 
    		local spells = {}
    		local unknownnspells={}
   			for i=low,math.min(GetTableSize(caster.fa_spellcraft.spells),high) do
				for k,v in pairs(caster.fa_spellcraft.spells[i]) do
					table.insert(spells,v)
					if(caster.components.builder and not caster.components.builder:KnowsRecipe(v.recname))then
						table.insert(unknownnspells,v)
					end
				end
			end
			local spell=nil
			if(GetTableSize(unknownnspells)>0)then
				spell=unknownnspells[math.random(1,#unknownnspells)]
				inst.recipetouse=spell.recname
			elseif(GetTableSize(spells)>0)then
				spell=spells[math.random(1,#spells)]
				inst.recipetouse=spell.recname
			end
			if(inst.recipetouse)then
				local assetname="fa_scroll_"..spell.school
				inst.components.teacher:SetRecipe(inst.recipetouse)
				inst.components.named:SetName(STRINGS.NAMES[string.upper(inst.recipetouse)].." Scroll")
    			inst.components.inventoryitem.imagename=assetname
			    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"
			end
		end
		if(not inst.recipetouse) then
	  		print("no caster, no failsafe, sorry")
	  	end
	end

    local old_teach=inst.components.teacher.Teach
    function inst.components.teacher:Teach(target)
    	if(not self.recipe)then
    		--try one more time - should really find a cleaner way to deal with unassigned recipes
    		inst.setRecipe(inst.lowbound,inst.highbound,target)
    	end
    	local known=false
    	if target.components.builder then
			if self.recipe then
				known=target.components.builder:KnowsRecipe(self.recipe)
    		end
    	end
    	print("known?",known)
    	--i guess to keep prototyping? 
    	local retval= old_teach(self,target)
    	if(known)then
		 	return OnTeach(inst, target)
		else
			return retval
		end
    end
    
    inst.OnLoad = onload
    inst.OnSave = onsave

   	return inst
end

local function fnpick()
	local inst=fn()
	inst.components.inventoryitem.onpickupfn=function(inst, pickupguy)
		if(inst.recipetouse) then return end
		local low=inst.lowbound or 1
		local high=inst.highbound or 9999
		inst.setRecipe(low,high,pickupguy) 
	end
	return inst
end

local function fn1()
	local inst=fnpick()
	inst.lowbound=1
	inst.highbound=1
	return inst
end
local function fn12()
	local inst=fnpick()
	inst.lowbound=1
	inst.highbound=2
	return inst
end
local function fn13()
	local inst=fnpick()
	inst.lowbound=1
	inst.highbound=3
	return inst
end
local function fn14()
	local inst=fnpick()
	inst.lowbound=1
	inst.highbound=4
	return inst
end
local function fn15()
	local inst=fnpick()
	inst.lowbound=1
	inst.highbound=5
	return inst
end
local function fn25()
	local inst=fnpick()
	inst.lowbound=2
	inst.highbound=5
	return inst
end
local function fn35()
	local inst=fnpick()
	inst.lowbound=3
	inst.highbound=5
	return inst
end
local function fn45()
	local inst=fnpick()
	inst.lowbound=4
	inst.highbound=5
	return inst
end
local function fn5()
	local inst=fnpick()
	inst.lowbound=5
	inst.highbound=5
	return inst
end

--really wish i could set this crap in a less...retarded way, but setting up lootdroppers and shit with actual setup is proving to be annoying hassle otherwise
return Prefab( "common/objects/fa_scroll_free", fn, assets),
Prefab( "common/objects/fa_scroll_1", fn1, assets),
Prefab( "common/objects/fa_scroll_12", fn12, assets),
Prefab( "common/objects/fa_scroll_13", fn13, assets),
Prefab( "common/objects/fa_scroll_14", fn14, assets),
Prefab( "common/objects/fa_scroll_15", fn15, assets),
Prefab( "common/objects/fa_scroll_25", fn25, assets),
Prefab( "common/objects/fa_scroll_35", fn35, assets),
Prefab( "common/objects/fa_scroll_45", fn45, assets),
Prefab( "common/objects/fa_scroll_5", fn5, assets)