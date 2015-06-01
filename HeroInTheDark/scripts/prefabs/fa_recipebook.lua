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


 Prefab( "common/inventory/fa_silversword_recipe",  recipegen("ForgeMatcher","fa_silversword"), assets),
 Prefab( "common/inventory/fa_silveraxe_recipe",  recipegen("ForgeMatcher","fa_silveraxe"), assets),
 Prefab( "common/inventory/fa_silverdagger_recipe",  recipegen("ForgeMatcher","fa_silverdagger"), assets),
 Prefab( "common/inventory/fa_flamingsword_recipe",  recipegen("ForgeMatcher","fa_flamingsword"), assets),
 Prefab( "common/inventory/fa_fireaxe_recipe",  recipegen("ForgeMatcher","fa_fireaxe"), assets),
 Prefab( "common/inventory/fa_frostsword_recipe",  recipegen("ForgeMatcher","fa_frostsword"), assets),
 Prefab( "common/inventory/fa_iceaxe_recipe",  recipegen("ForgeMatcher","fa_iceaxe"), assets),
 Prefab( "common/inventory/fa_vorpalaxe_recipe",  recipegen("ForgeMatcher","fa_vorpalaxe"), assets),
 Prefab( "common/inventory/fa_dagger_recipe",  recipegen("ForgeMatcher","fa_dagger"), assets),
 Prefab( "common/inventory/fa_lightningsword_recipe",  recipegen("ForgeMatcher","fa_lightningsword"), assets),
 Prefab( "common/inventory/fa_venomdagger1_recipe",  recipegen("ForgeMatcher","fa_venomdagger1"), assets),

 Prefab( "common/inventory/fa_copperarmor_recipe",  recipegen("ForgeMatcher","fa_copperarmor"), assets),
 Prefab( "common/inventory/fa_ironarmor_recipe",  recipegen("ForgeMatcher","fa_ironarmor"), assets),
 Prefab( "common/inventory/fa_steelarmor_recipe",  recipegen("ForgeMatcher","fa_steelarmor"), assets),
 Prefab( "common/inventory/fa_armorfrost_recipe",  recipegen("ForgeMatcher","armorfrost"), assets),
 Prefab( "common/inventory/fa_armorfire_recipe",  recipegen("ForgeMatcher","armorfire"), assets),
 Prefab( "common/inventory/fa_silverarmor_recipe",  recipegen("ForgeMatcher","fa_silverarmor"), assets),
 Prefab( "common/inventory/fa_goldarmor_recipe",  recipegen("ForgeMatcher","fa_goldarmor"), assets),

 Prefab( "common/inventory/fa_hat_copper_recipe",  recipegen("ForgeMatcher","fa_hat_copper"), assets),
 Prefab( "common/inventory/fa_hat_iron_recipe",  recipegen("ForgeMatcher","fa_hat_iron"), assets),
 Prefab( "common/inventory/fa_hat_steel_recipe",  recipegen("ForgeMatcher","fa_hat_steel"), assets),
 Prefab( "common/inventory/fa_hat_silver_recipe",  recipegen("ForgeMatcher","fa_hat_silver"), assets),
 Prefab( "common/inventory/fa_hat_gold_recipe",  recipegen("ForgeMatcher","fa_hat_gold"), assets),

 Prefab( "common/inventory/fa_coppershield_recipe",  recipegen("ForgeMatcher","fa_coppershield"), assets),
 Prefab( "common/inventory/fa_ironshield_recipe",  recipegen("ForgeMatcher","fa_ironshield"), assets),
 Prefab( "common/inventory/fa_goldshield_recipe",  recipegen("ForgeMatcher","fa_goldshield"), assets),
 Prefab( "common/inventory/fa_silvershield_recipe",  recipegen("ForgeMatcher","fa_silvershield"), assets),
 Prefab( "common/inventory/fa_steelshield_recipe",  recipegen("ForgeMatcher","fa_steelshield"), assets),
 Prefab( "common/inventory/fa_boneshield_recipe",  recipegen("AlchemyMatcher","fa_boneshield"), assets),
 Prefab( "common/inventory/fa_reflectshield_recipe",  recipegen("AlchemyMatcher","fa_reflectshield"), assets),

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
 Prefab( "common/inventory/fa_bottle_water_recipe",  recipegen("AlchemyMatcher","fa_bottle_water"), assets),
 Prefab( "common/inventory/fa_bottle_oil_recipe",  recipegen("AlchemyMatcher","fa_bottle_oil"), assets),
 Prefab( "common/inventory/fa_bottle_mineralwater_recipe",  recipegen("AlchemyMatcher","fa_bottle_mineralwater"), assets),
 Prefab( "common/inventory/fa_bottle_frozenessence_recipe",  recipegen("AlchemyMatcher","fa_bottle_frozenessence"), assets),
 Prefab( "common/inventory/fa_bottle_lifeessence_recipe",  recipegen("AlchemyMatcher","fa_bottle_lifeessence"), assets),
 Prefab( "common/inventory/fa_bottle_lightningessence_recipe",  recipegen("AlchemyMatcher","fa_bottle_lightningessence"), assets),
 Prefab( "common/inventory/fa_bottle_poisonessence_recipe",  recipegen("AlchemyMatcher","fa_bottle_poisonessence"), assets),
 Prefab( "common/inventory/fa_bottle_curepoison_recipe",  recipegen("AlchemyMatcher","fa_bottle_curepoison"), assets),
 Prefab( "common/inventory/fa_wineyeast_recipe",  recipegen("AlchemyMatcher","fa_wineyeast"), assets),
 Prefab( "common/inventory/fa_distillingyeast_recipe",  recipegen("AlchemyMatcher","fa_distillingyeast"), assets),
 Prefab( "common/inventory/fa_brewingyeast_recipe",  recipegen("AlchemyMatcher","fa_brewingyeast"), assets),

 Prefab( "common/inventory/fa_abjurationrobe_recipe",  recipegen("AlchemyMatcher","fa_abjurationrobe"), assets),
 Prefab( "common/inventory/fa_conjurationrobe_recipe",  recipegen("AlchemyMatcher","fa_conjurationrobe"), assets),
 Prefab( "common/inventory/fa_divinationrobe_recipe",  recipegen("AlchemyMatcher","fa_divinationrobe"), assets),
 Prefab( "common/inventory/fa_enchantmentrobe_recipe",  recipegen("AlchemyMatcher","fa_enchantmentrobe"), assets),
 Prefab( "common/inventory/fa_evocationrobe_recipe",  recipegen("AlchemyMatcher","fa_evocationrobe"), assets),
 Prefab( "common/inventory/fa_illusionrobe_recipe",  recipegen("AlchemyMatcher","fa_illusionrobe"), assets),
 Prefab( "common/inventory/fa_necromancyrobe_recipe",  recipegen("AlchemyMatcher","fa_necromancyrobe"), assets),
 Prefab( "common/inventory/fa_transmutationrobe_recipe",  recipegen("AlchemyMatcher","fa_transmutationrobe"), assets),

 Prefab( "common/inventory/fa_hat_abjuration_recipe",  recipegen("AlchemyMatcher","fa_hat_abjuration"), assets),
 Prefab( "common/inventory/fa_hat_conjuration_recipe",  recipegen("AlchemyMatcher","fa_hat_conjuration"), assets),
 Prefab( "common/inventory/fa_hat_divination_recipe",  recipegen("AlchemyMatcher","fa_hat_divination"), assets),
 Prefab( "common/inventory/fa_hat_enchantment_recipe",  recipegen("AlchemyMatcher","fa_hat_enchantment"), assets),
 Prefab( "common/inventory/fa_hat_evocation_recipe",  recipegen("AlchemyMatcher","fa_hat_evocation"), assets),
 Prefab( "common/inventory/fa_hat_illusion_recipe",  recipegen("AlchemyMatcher","fa_hat_illusion"), assets),
 Prefab( "common/inventory/fa_hat_necromancy_recipe",  recipegen("AlchemyMatcher","fa_hat_necromancy"), assets),
 Prefab( "common/inventory/fa_hat_transmutation_recipe",  recipegen("AlchemyMatcher","fa_hat_transmutation"), assets),

 Prefab( "common/inventory/fa_ironstaff_recipe",  recipegen("ForgeMatcher","fa_ironstaff"), assets),
 Prefab( "common/inventory/fa_silverstaff_recipe",  recipegen("ForgeMatcher","fa_silverstaff"), assets),
 Prefab( "common/inventory/fa_steelstaff_recipe",  recipegen("ForgeMatcher","fa_steelstaff"), assets),
 Prefab( "common/inventory/fa_copperstaff_recipe",  recipegen("ForgeMatcher","fa_copperstaff"), assets),
 Prefab( "common/inventory/fa_goldstaff_recipe",  recipegen("ForgeMatcher","fa_goldstaff"), assets),
 Prefab( "common/inventory/fa_ironkama_recipe",  recipegen("ForgeMatcher","fa_ironkama"), assets),
 Prefab( "common/inventory/fa_silverkama_recipe",  recipegen("ForgeMatcher","fa_silverkama"), assets),
 Prefab( "common/inventory/fa_steelkama_recipe",  recipegen("ForgeMatcher","fa_steelkama"), assets),
 Prefab( "common/inventory/fa_copperkama_recipe",  recipegen("ForgeMatcher","fa_copperkama"), assets),
 Prefab( "common/inventory/fa_goldkama_recipe",  recipegen("ForgeMatcher","fa_goldkama"), assets),

 Prefab( "common/inventory/fa_mash_recipe",  recipegen("KegMatcher","fa_mash"), assets),
 Prefab( "common/inventory/fa_wort_recipe",  recipegen("KegMatcher","fa_wort"), assets),

 Prefab( "common/inventory/fa_barrel_molasses_recipe",  recipegen("KegMatcher","fa_barrel_molasses"), assets),
 Prefab( "common/inventory/fa_barrel_darkrum_recipe",  recipegen("KegMatcher","fa_barrel_darkrum"), assets),
 Prefab( "common/inventory/fa_barrel_bourbon_recipe",  recipegen("KegMatcher","fa_barrel_bourbon"), assets),
 Prefab( "common/inventory/fa_barrel_goldrum_recipe",  recipegen("KegMatcher","fa_barrel_goldrum"), assets),
 Prefab( "common/inventory/fa_barrel_flavoredrum_recipe",  recipegen("KegMatcher","fa_barrel_flavoredrum"), assets),
 Prefab( "common/inventory/fa_barrel_hotrum_recipe",  recipegen("KegMatcher","fa_barrel_hotrum"), assets),
 Prefab( "common/inventory/fa_lightalemug_recipe",  recipegen("KegMatcher","fa_lightalemug"), assets),
 Prefab( "common/inventory/fa_ronsalemug_recipe",  recipegen("KegMatcher","fa_ronsalemug"), assets),
 Prefab( "common/inventory/fa_barrel_lightale_recipe",  recipegen("KegMatcher","fa_barrel_lightale"), assets),
 Prefab( "common/inventory/fa_barrel_ronsale_recipe",  recipegen("KegMatcher","fa_barrel_ronsale"), assets),
 Prefab( "common/inventory/fa_barrel_drakeale_recipe",  recipegen("KegMatcher","fa_barrel_drakeale"), assets),
 Prefab( "common/inventory/fa_barrel_oriansale_recipe",  recipegen("KegMatcher","fa_barrel_oriansale"), assets),
 Prefab( "common/inventory/fa_barrel_dorfale_recipe",  recipegen("KegMatcher","fa_barrel_dorfale"), assets),
 Prefab( "common/inventory/fa_dwarfalemug_recipe",  recipegen("KegMatcher","fa_dwarfalemug"), assets),
 Prefab( "common/inventory/fa_barrel_deathbrew_recipe",  recipegen("KegMatcher","fa_barrel_deathbrew"), assets),
 Prefab( "common/inventory/fa_pomegranate_wine_recipe",  recipegen("KegMatcher","fa_pomegranate_wine"), assets),
 Prefab( "common/inventory/fa_durian_wine_recipe",  recipegen("KegMatcher","fa_durian_wine"), assets),
 Prefab( "common/inventory/fa_dragon_wine_recipe",  recipegen("KegMatcher","fa_dragon_wine"), assets),
 Prefab( "common/inventory/fa_melon_wine_recipe",  recipegen("KegMatcher","fa_melon_wine"), assets),
 Prefab( "common/inventory/fa_red_wine_recipe",  recipegen("KegMatcher","fa_red_wine"), assets),
 Prefab( "common/inventory/fa_goodberry_wine_recipe",  recipegen("KegMatcher","fa_goodberry_wine"), assets),
 Prefab( "common/inventory/fa_glowing_wine_recipe",  recipegen("KegMatcher","fa_glowing_wine"), assets),
 Prefab( "common/inventory/fa_cactus_wine_recipe",  recipegen("KegMatcher","fa_cactus_wine"), assets),
 Prefab( "common/inventory/fa_mead_recipe",  recipegen("KegMatcher","fa_mead"), assets),
 Prefab( "common/inventory/fa_barrel_lightrum_recipe",  recipegen("DistillerMatcher","fa_barrel_lightrum"), assets),
 Prefab( "common/inventory/fa_barrel_clearbourbon_recipe",  recipegen("DistillerMatcher","fa_barrel_clearbourbon"), assets),
 Prefab( "common/inventory/fa_barrel_vodka_recipe",  recipegen("DistillerMatcher","fa_barrel_vodka"), assets),
 Prefab( "common/inventory/fa_barrel_gin_recipe",  recipegen("DistillerMatcher","fa_barrel_gin"), assets),
 Prefab( "common/inventory/fa_barrel_tequila_recipe",  recipegen("DistillerMatcher","fa_barrel_tequila"), assets),
 Prefab( "common/inventory/fa_barrel_whiskey_recipe",  recipegen("DistillerMatcher","fa_barrel_whiskey"), assets),
 Prefab( "common/inventory/fa_barrel_baijui_recipe",  recipegen("DistillerMatcher","fa_barrel_baijui"), assets),
 Prefab( "common/inventory/fa_barrel_soju_recipe",  recipegen("DistillerMatcher","fa_barrel_soju"), assets),

 Prefab( "common/inventory/fa_heavyleatherarmor_recipe",  recipegen("ForgeMatcher","fa_heavyleatherarmor"), assets),
 Prefab( "common/inventory/fa_hat_heavyleather_recipe",  recipegen("ForgeMatcher","fa_hat_heavyleather"), assets)

