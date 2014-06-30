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
	end
end

local function onsave(inst, data)
	if inst.recipetouse then
		data.recipetouse = inst.recipetouse
	end
end

local function OnTeach(inst, learner)
	if(learner.components.builder:KnowsRecipe(self.recipe))then 

        local prod = SpawnPrefab(self.recipe.product)
        if self.recipe.numtogive > 1 and prod.components.stackable then
           	prod.components.stackable:SetStackSize(self.recipe.numtogive)
			self.inst.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
        elseif self.recipe.numtogive > 1 and not prod.components.stackable then
			self.inst.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
			for i = 2, self.recipe.numtogive do
				local addt_prod = SpawnPrefab(self.recipe.product)
				self.inst.components.inventory:GiveItem(addt_prod, nil, TheInput:GetScreenPosition())
			end
	    else
			self.inst.components.inventory:GiveItem(prod, nil, TheInput:GetScreenPosition())
        end
	end
	if learner.SoundEmitter then
		learner.SoundEmitter:PlaySound("dontstarve/HUD/get_gold")    
	end
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
    inst:AddComponent("teacher")
    inst.components.teacher.onteach = OnTeach

    inst.setRecipe=function(low, high,caster)
    	if(caster.fa_spellcraft and caster.fa_spellcraft.spells and GetTableSize(caster.fa_spellcraft.spells)>0) then 
    		local spells = {}
   			for i=low,math.min(GetTableSize(caster.fa_spellcraft.spells),high) do
				for k,v in pairs(caster.fa_spellcraft.spells[i]) do
					table.insert(spells,v1)
				end
			end
			if(GetTableSize(spells)>0)then
				local spell=spells[amth.random(1,#spells)]
				inst.recipetouse=spell.recname
				local assetname="fa_scroll_"..spell.school
				inst.components.teacher:SetRecipe(inst.recipetouse)
				inst.components.named:SetName(STRINGS.NAMES[string.upper(inst.recipetouse)].." Scroll")
    			inst.components.inventoryitem.imagename=assetname
			    inst.components.inventoryitem.atlasname="images/inventoryimages/"..assetname..".xml"
			end
		end
		if(not inst.recipetouse) then
	  		print("no caster, no failsafe, sorry")
	  	end
	end
--[[
    local old_teach=inst.components.teacher.Teach
    function inst.components.teacher:Teach(target)
    	if(not self.recipe)then

    	end
    	return old_teach(self,target)
    end]]
    
    inst.OnLoad = onload
    inst.OnSave = onsave

   	return inst
end



return Prefab( "common/objects/fa_scroll_any", fn, assets)