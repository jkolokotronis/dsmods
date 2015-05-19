local hutassets_a =
{
    Asset("ANIM", "anim/fa_elfhouse_a.zip"),    
}
local hutassets_b =
{
    Asset("ANIM", "anim/fa_elfhouse_b.zip"),   
}
local hutassets_c =
{
    Asset("ANIM", "anim/fa_elfhouse_c.zip"),   
}
local standassets =
{
    Asset("ANIM", "anim/fa_elfstand.zip"),   
}
local prefabs = 
{
}

        
local function onhammered(inst, worker)
    if inst.doortask then
        inst.doortask:Cancel()
        inst.doortask = nil
    end
	if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
    end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    if(inst.fa_flag)then
        inst.fa_flag:Remove()
    end
	inst:Remove()
end

local function onwork(inst, worker, workleft)
    if inst.components.childspawner then
        inst.components.childspawner:ReleaseAllChildren()
        if worker and worker.components.combat then
            for k,v in pairs(inst.components.childspawner.childrenoutside)do
                v.components.combat:SetTarget(worker)
            end
        end
    end    
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3 )
--    local minimap = inst.entity:AddMiniMapEntity()
--    minimap:SetIcon( "fa_dorf.tex" )

    inst:AddTag("structure")
    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({ "rocks", "rocks","rocks","rocks","cutgrass","cutgrass","boards","boards","boards","boards"})
    inst.components.lootdropper:AddFallenLootTable(MergeMaps(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.keys3),FALLENLOOTTABLE.TABLE_WEIGHT+FALLENLOOTTABLE.TABLE_KEYS3_WEIGHT,0.15)
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(8)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable.onwork=onwork
    inst:AddComponent("inspectable")
    
    MakeSnowCovered(inst, .01)
    return inst
end


local function fnhut_a(Sim)
    local inst=fn()
    inst.Transform:SetScale(1.4,1.4, 1.4)

--    inst.Transform:SetScale(2,2, 2)
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(false)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("fa_elfhouse_a")
    inst.AnimState:SetBuild("fa_elfhouse_a")
    inst.AnimState:PlayAnimation("summer day idle",true)

--	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_elf_male"
    inst.components.childspawner:SetRareChild("fa_elf_female", 0.5)
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()

    return inst
end

local function fnhut_b(Sim)
    local inst=fn()
    inst.Transform:SetScale(1.4,1.4, 1.4)

--    inst.Transform:SetScale(2,2, 2)
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(false)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("fa_elfhouse_b")
    inst.AnimState:SetBuild("fa_elfhouse_b")
    inst.AnimState:PlayAnimation("summer day idle",true)

--  inst.components.workable:SetOnWorkCallback(onhit)
    
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_elf_male"
    inst.components.childspawner:SetRareChild("fa_elf_female", 0.5)
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()

    return inst
end

local function fnhut_c(Sim)
    local inst=fn()
    inst.Transform:SetScale(1.4,1.4, 1.4)

--    inst.Transform:SetScale(2,2, 2)
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(false)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("fa_elfhouse_c")
    inst.AnimState:SetBuild("fa_elfhouse_c")
    inst.AnimState:PlayAnimation("summer day idle",true)

--  inst.components.workable:SetOnWorkCallback(onhit)
    
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_elf_male"
    inst.components.childspawner:SetRareChild("fa_elf_female", 0.5)
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(2)
    inst.components.childspawner:StartSpawning()

    return inst
end


local function fnstand(techtree)
    local inst=fn()
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    inst.Transform:SetScale(1.7,1.7, 1.7)
     MakeObstaclePhysics(inst, 2)
    inst.AnimState:SetBank("fa_elfstand")
    inst.AnimState:SetBuild("fa_elfstand")
    inst.AnimState:PlayAnimation("idle",true)

    inst:AddTag("prototyper")
    inst:AddComponent("prototyper")

    inst.components.prototyper.onturnon =function(prot)
        prot.Light:Enable(true)
        light:SetIntensity(.8)
        light:SetRadius(4.5)
    end

    inst.components.prototyper.onturnoff = function(prot)
        light:SetIntensity(.5)
        light:SetRadius(3)
        GetPlayer().components.builder.accessible_tech_trees[techtree] = 0
        GetPlayer():PushEvent("techtreechange", {level = GetPlayer().components.builder.accessible_tech_trees})
    end

    inst.OnRemoveEntity = function(inst)
        GetPlayer().components.builder.accessible_tech_trees[techtree] = 0
        GetPlayer():PushEvent("techtreechange", {level = GetPlayer().components.builder.accessible_tech_trees})
    end

    inst.components.prototyper.trees = TUNING.PROTOTYPER_TREES[techtree]
    inst.components.prototyper.onactivate = function() end

    return inst
end

local function fa_elf_merchant_1()
    local inst=fnstand("FA_ELFROBERECIPESTAND")
    inst.AnimState:PlayAnimation("full",true)
    --[[
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")
]]
    return inst
end
local function fa_elf_merchant_2()
    local inst=fnstand("FA_ELFSPELLSTAND")
    inst.AnimState:PlayAnimation("full",true)
    return inst
end
local function fa_elf_merchant_3()
    local inst=fnstand("FA_ELFWEAPONRECIPESTAND")
    inst.AnimState:PlayAnimation("full",true)
    return inst
end


return Prefab( "common/objects/fa_elfhut_fighter", fnhut_a, hutassets_a),
Prefab( "common/objects/fa_elfhut_ranger", fnhut_b, hutassets_b),
Prefab( "common/objects/fa_elfhut_mage", fnhut_c, hutassets_c),
Prefab( "common/objects/fa_elf_merchant_1", fa_elf_merchant_1, standassets),
Prefab( "common/objects/fa_elf_merchant_2", fa_elf_merchant_2, standassets),
Prefab( "common/objects/fa_elf_merchant_3", fa_elf_merchant_3, standassets)
