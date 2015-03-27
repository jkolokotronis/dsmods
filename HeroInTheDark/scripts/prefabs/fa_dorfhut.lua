local hutassets =
{
    Asset("ANIM", "anim/fa_dwarfhut.zip"),    
}
local bedassets =
{
    Asset("ANIM", "anim/fa_dwarfbed.zip"),    
}
local standassets =
{
    Asset("ANIM", "anim/fa_dwarfstand.zip"),    
}
local throneassets =
{
    Asset("ANIM", "anim/fa_dorf_throne.zip"),    
}
local prefabs = 
{
	"fa_dorf",
}

local DWARF_BED_USES=10
local DWARF_BED_HP=100
local DWARF_BED_SANITY=50
local DWARF_BED_HUNGER=-50


        
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
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "fa_dorf.tex" )

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

local function fnthrone()
    local inst=fn()
    MakeObstaclePhysics(inst, 1)

    inst.AnimState:SetBank("fa_dorf_throne")
    inst.AnimState:SetBuild("fa_dorf_throne")
    inst.AnimState:PlayAnimation("idle",true)
    return inst
end

local function fnhut(Sim)
    local inst=fn()
    inst.Transform:SetScale(1.4,1.4, 1.4)

--    inst.Transform:SetScale(2,2, 2)
    local light = inst.entity:AddLight()

    light:SetFalloff(2)
    light:SetIntensity(.5)
    light:SetRadius(3)
    light:Enable(true)
    light:SetColour(180/255, 35/255, 50/255)
    
    MakeObstaclePhysics(inst, 2)

    inst.AnimState:SetBank("fa_dwarfhut")
    inst.AnimState:SetBuild("fa_dwarfhut")
    inst.AnimState:PlayAnimation("light_closed",true)

--	inst.components.workable:SetOnWorkCallback(onhit)
	
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dorf"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()

    return inst
end

local function fnbed()
    local inst=fn()
     MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(1.3,1.3, 1.3)
    inst.AnimState:SetBank("fa_dwarfbed")
    inst.AnimState:SetBuild("fa_dwarfbed")
    inst.AnimState:PlayAnimation("full",true)
    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dorf"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()
    return inst
end


local function tentonfinished(inst)
  inst.AnimState:PlayAnimation("destroy")
  inst:ListenForEvent("animover", function(inst, data) inst:Remove() end)
  inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_pre")
  inst.persists = false
  inst:DoTaskInTime(16*FRAMES, function() inst.SoundEmitter:PlaySound("dontstarve/common/tent_dis_twirl") end)
end


local function onsleep(inst, sleeper)
  
  local hounded = GetWorld().components.hounded
  local danger = FindEntity(inst, 10, function(target) return  target.components.combat and target.components.combat.target == inst end)  
  if hounded and (hounded.warning or hounded.timetoattack <= 0) then
    danger = true
  end
  
  if danger then
    if sleeper.components.talker then
      sleeper.components.talker:Say(GetString(sleeper.prefab, "ANNOUNCE_NODANGERSLEEP"))
    end
    return
  end
    if sleeper.components.hunger.current < -DWARF_BED_HUNGER then
        sleeper.components.talker:Say(GetString(sleeper.prefab, "ANNOUNCE_NOHUNGERSLEEP"))
        return
    end

  sleeper.components.health:SetInvincible(true)
  sleeper.components.playercontroller:Enable(false)

  GetPlayer().HUD:Hide()
  TheFrontEnd:Fade(false,1)

  inst:DoTaskInTime(1.2, function() 
    
    GetPlayer().HUD:Show()
    TheFrontEnd:Fade(true,1) 
    
    
    if sleeper.components.sanity then
      sleeper.components.sanity:DoDelta(DWARF_BED_SANITY)
    end
    if sleeper.components.health then
      sleeper.components.health:DoDelta(DWARF_BED_HP, false, "tent", true)
    end
        if sleeper.components.hunger then
            sleeper.components.hunger:DoDelta(DWARF_BED_HUNGER, false, true)
        end
    if(FA_DLCACCESS)then
      if sleeper.components.temperature and sleeper.components.temperature.current < TUNING.TARGET_SLEEP_TEMP then
        sleeper.components.temperature:SetTemperature(TUNING.TARGET_SLEEP_TEMP)
      end 
    else    
      if sleeper.components.temperature then
        sleeper.components.temperature:SetTemperature(sleeper.components.temperature.maxtemp)
      end
    end  
    
    inst.components.finiteuses:Use()
    GetClock():MakeNextDay()
--[[
    if(sleeper.components.moisture)then
      sleeper.components.moisture.moisture=0
    end
    ]]

    sleeper.components.health:SetInvincible(false)
    sleeper.components.playercontroller:Enable(true)
    sleeper.sg:GoToState("wakeup")  
  end)  
  
end

local function fnbed_player()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst:AddTag("tent")    
    inst:AddTag("structure")
     MakeObstaclePhysics(inst, 0.5)
    inst.Transform:SetScale(1.3,1.3, 1.3)
    inst.AnimState:SetBank("fa_dwarfbed")
    inst.AnimState:SetBuild("fa_dwarfbed")
    inst.AnimState:PlayAnimation("idle",true)
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "tent.png" )
    inst:AddComponent("inspectable")

    inst:AddComponent("lootdropper")
    inst:AddComponent("sleepingbag")
    inst.components.sleepingbag.onsleep = onsleep

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(DWARF_BED_USES)
    inst.components.finiteuses:SetUses(DWARF_BED_USES)
    inst.components.finiteuses:SetOnFinished( tentonfinished )

    MakeSnowCovered(inst, .01)
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
    inst.AnimState:SetBank("fa_dwarfstand")
    inst.AnimState:SetBuild("fa_dwarfstand")
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

local function fnfoodstand1()
    local inst=fnstand("FA_FOODSTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfitemstand()
    local inst=fnstand("FA_DORFITEMSTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfpotionstand()
    local inst=fnstand("FA_DORFPOTIONSTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfresourcestand()
    local inst=fnstand("FA_DORFRESOURCESTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fnweaponrecipes()
    local inst=fnstand("FA_DORFWEAPONRECIPES")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfequipment()
    local inst=fnstand("FA_DORFEQUIPMENT")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfarmorrecipes()
    local inst=fnstand("FA_DORFARMORRECIPES")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfsmelterrecipes()
    local inst=fnstand("FA_DORFSMELTRECIPESTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorfotherrecipes()
    local inst=fnstand("FA_DORFOTHERRECIPESTAND")
    inst.AnimState:PlayAnimation("full",true)
    inst.AnimState:OverrideSymbol("swap_item_1", "cook_pot_food", "baconeggs")
    inst.AnimState:OverrideSymbol("swap_item_2", "cook_pot_food", "meatballs")
    inst.AnimState:OverrideSymbol("swap_item_3", "cook_pot_food", "bonestew")
    inst.AnimState:OverrideSymbol("swap_item_4", "cook_pot_food", "kabobs")
    inst.AnimState:OverrideSymbol("swap_item_5", "cook_pot_food", "icecream")

    return inst
end

local function fndorflantern()
    local inst = Prefabs["lantern"].fn()
    inst.components.inventoryitem.imagename="lantern"
    return inst
end
local function fndorfgunpowder()
    local inst = Prefabs["gunpowder"].fn()
    inst.components.inventoryitem.imagename="gunpowder"
    return inst
end

local function fa_dorf_sewing_kit()
    local inst = Prefabs["sewing_kit"].fn()
    inst.components.inventoryitem.imagename="sewing_kit"
    return inst
end

local function fa_dorf_pickaxe()
    local inst = Prefabs["multitool_axe_pickaxe"].fn()
    inst.components.inventoryitem.imagename="multitool_axe_pickaxe"
    return inst
end
local function fa_dorf_trap()
    local inst = Prefabs["trap_teeth"].fn()
    inst.components.inventoryitem.imagename="trap_teeth"
    return inst
end
local function fa_dorf_hungerbelt()
    local inst = Prefabs["armorslurper"].fn()
    inst.components.inventoryitem.imagename="armorslurper"
    return inst
end
local function fa_dorf_yellowstaff()
    local inst = Prefabs["yellowstaff"].fn()
    inst.components.inventoryitem.imagename="yellowstaff"
    return inst
end

return Prefab( "common/objects/fa_dorfhut", fnhut, hutassets, prefabs ),
Prefab( "common/objects/fa_dorfbed", fnbed, bedassets, prefabs ),
Prefab( "common/objects/fa_dorfstand", fnstand, standassets, prefabs ),
Prefab( "common/objects/fa_dorfthrone", fnthrone, throneassets, prefabs ),
Prefab( "common/objects/fa_dorfbed_player", fnbed_player, bedassets),
MakePlacer( "common/fa_dorfbed_player_placer", "fa_dwarfbed", "fa_dwarfbed", "idle" ),
Prefab( "common/objects/fa_dorfstand_food_1", fnfoodstand1, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_items_2", fndorfitemstand, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_potions_3", fndorfpotionstand, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_resources_4", fndorfresourcestand, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_recipe_weapon_5", fnweaponrecipes, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_equipment_6", fndorfequipment, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_recipe_armor_7", fndorfarmorrecipes, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_recipe_smelting_8", fndorfsmelterrecipes, standassets, prefabs ),
Prefab( "common/objects/fa_dorfstand_recipe_other_9", fndorfotherrecipes, standassets, prefabs ),
Prefab( "common/objects/fa_dorf_lantern", fndorflantern, {}, {} ),
Prefab( "common/objects/fa_dorf_gunpowder", fndorfgunpowder, {}, {} ),
Prefab( "common/objects/fa_dorf_sewing_kit", fa_dorf_sewing_kit, {}, {} ),
Prefab( "common/objects/fa_dorf_pickaxe", fa_dorf_pickaxe, {}, {} ),
Prefab( "common/objects/fa_dorf_trap", fa_dorf_trap, {}, {} ),
Prefab( "common/objects/fa_dorf_hungerbelt", fa_dorf_hungerbelt, {}, {} ),
Prefab( "common/objects/fa_dorf_yellowstaff", fa_dorf_yellowstaff, {}, {} )



