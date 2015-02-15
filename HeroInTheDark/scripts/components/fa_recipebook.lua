local matchers=require "fa_smelter_matcher"


local FA_RecipeBook_Category=Class(function(self,inst,matcher)
    self.inst=inst
    self.matcher=matcher
    self.recipes={}
end)


local FA_RecipeBook = Class(function(self, inst)
    self.inst = inst
    self.recipes={}
    self.recipes["SmelterMatcher"]=FA_RecipeBook_Category(self.inst,matchers["SmelterMatcher"])
    self.recipes["AlchemyMatcher"]=FA_RecipeBook_Category(self.inst,matchers["AlchemyMatcher"])
    self.recipes["ForgeMatcher"]=FA_RecipeBook_Category(self.inst,matchers["ForgeMatcher"])
    self.recipes["KegMatcher"]=FA_RecipeBook_Category(self.inst,matchers["KegMatcher"])
    self.recipes["DistillerMatcher"]=FA_RecipeBook_Category(self.inst,matchers["DistillerMatcher"])
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