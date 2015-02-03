local matchers=require "fa_smelter_matcher"


    Asset( "IMAGE", "images/notebookparts/alchemy-tab-Kopie.tex" ),
    Asset( "IMAGE", "images/notebookparts/alchemy-tab.tex" ),
    Asset( "IMAGE", "images/notebookparts/Alchemy-table-sketch.tex" ),
    Asset( "IMAGE", "images/notebookparts/background.tex" ),
    Asset( "IMAGE", "images/notebookparts/Exit-button.tex" ),
    Asset( "IMAGE", "images/notebookparts/Foodpot-sketch.tex" ),
    Asset( "IMAGE", "images/notebookparts/food_drinks-tab-Kopie.tex" ),
    Asset( "IMAGE", "images/notebookparts/food_drinks-tab.tex" ),
    Asset( "IMAGE", "images/notebookparts/Forge-sketch.tex" ),
    Asset( "IMAGE", "images/notebookparts/forge-tab-Kopie.tex" ),
    Asset( "IMAGE", "images/notebookparts/forge-tab.tex" ),
    Asset( "IMAGE", "images/notebookparts/left.tex" ),
    Asset( "IMAGE", "images/notebookparts/Other-sketch.tex" ),
    Asset( "IMAGE", "images/notebookparts/other-tab-Kopie.tex" ),
    Asset( "IMAGE", "images/notebookparts/other-tab.tex" ),
    Asset( "IMAGE", "images/notebookparts/right.tex" ),
    Asset( "IMAGE", "images/notebookparts/Smelter-sketch.tex" ),
    Asset( "IMAGE", "images/notebookparts/smelter-tab-Kopie.tex" ),
    Asset( "IMAGE", "images/notebookparts/smelter-tab.tex" ),

local FA_RecipeBook_Category=Class(function(self,inst,matcher)
    self.inst=inst
    self.matcher=matcher
    self.recipes={}
end)


local FA_RecipeBook = Class(function(self, inst)
    self.inst = inst

    SmelterMatcher=FA_Matcher(smelt_recipes),
    AlchemyMatcher=FA_Matcher(alchemy_recipes),
    ForgeMatcher=FA_Matcher(forge_recipes),
    KegMatcher=FA_Matcher(keg_recipes),
    DistillerMatcher=FA_Matcher(distiller_recipes),
    FN_DESCRIPTION=FN_DESCRIPTION

end)

function FA_RecipeBook:AddRecipe(cat,recipe)
    if(self.recipes[cat])then
        table.insert(self.recipes[cat].recipes,recipe)
    end
end

function FA_RecipeBook:GetRecipes(cat)
    return self.recipes[cat]
end

function FA_RecipeBook:OnSave()
    local data={}
    data.recipes={}
    for k,v in pairs(self.recipes) do
        data.recipes[k]={}
        for k1,v1 in ipairs(v.recipes) do
            table.insert(data.recipes[k],v1)
        end
    end 
end

function FA_RecipeBook:OnLoad(data)
    for k,v in pairs(data.recipes) do
        for k1,v1 in ipairs(v.recipes) do
            if(self.recipes(k)==nil)then
                print("WARN: can't find category",k)
                break
            else
                table.insert(self.recipes[k],v1)
            end
        end
    end 
end


return FA_RecipeBook