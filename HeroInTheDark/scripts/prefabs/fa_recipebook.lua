local FA_RecipeBookScreen=require "screens/fa_recipebookscreen"
local spell=require "screens/fa_spellbookscreen"
-- I suppose I'll merge all the smaller images into one atlas eventually - when i fix the sizes and positions in place
local assets=
{
    Asset( "IMAGE", "images/notebookparts/background.tex" ),
    Asset( "ATLAS", "images/notebookparts/background.xml" ),

    Asset( "IMAGE", "images/notebookparts/notebookparts.tex" ),
    Asset( "ATLAS", "images/notebookparts/notebookparts.xml" ),

}


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	local anim=inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

            anim:SetBank("books")
            anim:SetBuild("books")
            anim:PlayAnimation("book_birds")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="book_birds"

        inst:AddComponent("useableitem")
    inst.components.useableitem:SetCanInteractFn(function() return true end)
    inst.components.useableitem:SetOnUseFn(function()
	    local owner = inst.components.inventoryitem.owner
    	TheFrontEnd:PushScreen(FA_RecipeBookScreen())
    end)

    return inst
end

local function fa_recipe(cat,name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	local anim=inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    anim:SetBank("blueprint")
    anim:SetBuild("blueprint")
    anim:PlayAnimation("idle")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem:ChangeImageName("blueprint")

    inst:AddComponent("useableitem")
    --I need to override this cause default crashes on non-equippables... klei
    inst.components.useableitem:SetCanInteractFn(function() return not inst.components.useableitem.inuse end)
    inst.components.useableitem:SetOnUseFn(function()
	    local owner = inst.components.inventoryitem.owner
	    GetPlayer().components.fa_recipebook:AddRecipe(inst.category,inst.recipename)
--    	TheFrontEnd:PushScreen(FA_RecipeBookScreen(owner,inst.category))
    	inst:Remove()
    end)

    inst.category=cat
    inst.recipename=name

    inst.OnLoad=function(inst,data)
    	if(data)then
	    	inst.category=data.category
    		inst.recipename=data.recipename
    	end
	end

    inst.OnSave=function(inst,data)
    	data.category=inst.category
    	data.recipename=inst.recipename
	end

    return inst
end

local function recipegen(cat,name)
	return function()
		return fa_recipe(cat,name)
	end
end


return Prefab( "common/inventory/fa_recipebook", fn, assets),
-- stupid default recipe system enforces uniqueness, theres nothing i can do
 Prefab( "common/inventory/fa_coppersword_recipe", recipegen("ForgeMatcher","fa_coppersword"), assets),
 Prefab( "common/inventory/fa_copperaxe_recipe",  recipegen("ForgeMatcher","fa_copperaxe"), assets),
 Prefab( "common/inventory/fa_copperdagger_recipe",  recipegen("ForgeMatcher","fa_copperdagger"), assets),
 Prefab( "common/inventory/fa_ironsword_recipe",  recipegen("ForgeMatcher","fa_ironsword"), assets),
 Prefab( "common/inventory/fa_ironaxe_recipe",  recipegen("ForgeMatcher","fa_ironaxe"), assets),
 Prefab( "common/inventory/fa_irondagger_recipe",  recipegen("ForgeMatcher","fa_irondagger"), assets),
 Prefab( "common/inventory/fa_steelsword_recipe",  recipegen("ForgeMatcher","fa_steelsword"), assets),
 Prefab( "common/inventory/fa_steelaxe_recipe",  recipegen("ForgeMatcher","fa_steelaxe"), assets),
 Prefab( "common/inventory/fa_steeldagger_recipe",  recipegen("ForgeMatcher","fa_steeldagger"), assets),

 Prefab( "common/inventory/fa_copperarmor_recipe",  recipegen("ForgeMatcher","fa_copperarmor"), assets),
 Prefab( "common/inventory/fa_ironarmor_recipe",  recipegen("ForgeMatcher","fa_ironarmor"), assets),
 Prefab( "common/inventory/fa_steelarmor_recipe",  recipegen("ForgeMatcher","fa_steelarmor"), assets),
 Prefab( "common/inventory/fa_hat_copper_recipe",  recipegen("ForgeMatcher","fa_hat_copper"), assets),
 Prefab( "common/inventory/fa_hat_iron_recipe",  recipegen("ForgeMatcher","fa_hat_iron"), assets),
 Prefab( "common/inventory/fa_hat_steel_recipe",  recipegen("ForgeMatcher","fa_hat_steel"), assets),

 Prefab( "common/inventory/fa_copperbar_recipe",  recipegen("SmelterMatcher","fa_copperbar"), assets),
 Prefab( "common/inventory/fa_ironbar_recipe",  recipegen("SmelterMatcher","fa_ironbar"), assets),
 Prefab( "common/inventory/fa_pigironbar_recipe",  recipegen("SmelterMatcher","fa_pigironbar"), assets),
 Prefab( "common/inventory/fa_steelbar_recipe",  recipegen("SmelterMatcher","fa_steelbar"), assets),
 Prefab( "common/inventory/fa_goldbar_recipe",  recipegen("SmelterMatcher","fa_goldbar"), assets),
 Prefab( "common/inventory/fa_silverbar_recipe",  recipegen("SmelterMatcher","fa_silverbar"), assets),
 Prefab( "common/inventory/fa_lavabar_recipe",  recipegen("SmelterMatcher","fa_lavabar"), assets),
 Prefab( "common/inventory/fa_coalbar_recipe",  recipegen("SmelterMatcher","fa_coalbar"), assets),

 Prefab( "common/inventory/fa_bottle_empty_recipe",  recipegen("ForgeMatcher","fa_bottle_empty"), assets),
 Prefab( "common/inventory/fa_bottle_y_recipe",  recipegen("AlchemyMatcher","fa_bottle_y"), assets),
 Prefab( "common/inventory/fa_bottle_g_recipe",  recipegen("AlchemyMatcher","fa_bottle_g"), assets),
 Prefab( "common/inventory/fa_bottle_r_recipe",  recipegen("AlchemyMatcher","fa_bottle_r"), assets),

 Prefab( "common/inventory/fa_heavyleatherarmor_recipe",  recipegen("ForgeMatcher","fa_heavyleatherarmor"), assets),
 Prefab( "common/inventory/fa_hat_heavyleather_recipe",  recipegen("ForgeMatcher","fa_hat_heavyleather"), assets)

