local assets_wood =
{
	Asset("ANIM", "anim/fa_barrel_wood.zip"),	
}
local assets_hotrum =
{
	Asset("ANIM", "anim/fa_barrel_hotrum.zip"),	
}
local assets_darkrum =
{
	Asset("ANIM", "anim/fa_barrel_darkrum.zip"),	
}
local assets_goldrum =
{
    Asset("ANIM", "anim/fa_barrel_goldrum.zip"),    
}
local assets_water =
{
    Asset("ANIM", "anim/fa_barrel_water.zip"),    
}
local assets_molasses =
{
    Asset("ANIM", "anim/fa_barrel_molasses.zip"),    
}

local DR_LENGTH=4*60

local function onfinished(inst)
    inst:Remove()
end

local function fn(name)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)

	inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
	inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("fa_drink")
    inst.components.fa_drink.healthvalue=0
    inst.components.fa_drink.hungervalue=0
    inst.components.fa_drink.sanityvalue=0
    --this might need to change but... I see no reason to care
    inst.components.fa_drink.foodtype = "FA_POTION"
    inst:AddComponent("tradable")

    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="fa_barrel_wood"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

	return inst
end

local function woodfn(Sim)
	local inst= fn("fa_barrel_wood")
     inst:DoPeriodicTask(1,function()
        if(not inst:IsInLimbo() and GetSeasonManager() and GetSeasonManager():IsRaining()) then
            local pos=inst:GetPosition()
            inst:Remove()
            local water=SpawnPrefab("fa_barrel_water")
            water.Transform:SetPosition(pos.x, pos.y, pos.z)
        end
    end)
    inst:RemoveComponent("fa_drink")
    return inst
end 

local function molassesfn(Sim)
    local inst= fn("fa_barrel_molasses")
    inst.components.fa_drink.hungervalue=5
    return inst
end 

local function darkrumfn(Sim)
    local inst= fn("fa_barrel_darkrum")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("physicaldr","PhysicalDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.PHYSICAL,drdelta=20})
    end
    return inst
end 

local function bourbonfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("firedr","FireDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.FIRE,drdelta=20})
    end
    return inst
end 

local function goldrumfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("dmg2sanity","DMG2Sanity","DamageSanityTransform",DR_LENGTH)
    end

    return inst
end 

local function flavoredrumfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.health.fa_temphp=eater.components.health.fa_temphp+200
    end
    return inst
end 

local function hotrumfn(Sim)
	local inst= fn("fa_barrel_hotrum")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("endureelementscold","EndureCold","EndureElements",DR_LENGTH)
        if(eater.components.moisture)then
            eater.components.moisture:DoDelta(-10)
        end
    end
    return inst
end 

local function lightalefn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE

    inst.components.fa_drink.ondrink=function(inst,eater)
        if(eater)then
            if(eater.components.fa_bufftimers)then
                eater.components.fa_bufftimers:AddBuff("damagemultiplier","DmgBoost","DamageMultiplier",2*60,{multiplier=0.1})
            end
        end
    end
    return inst
end 

local function ronsalefn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

    inst.components.fa_drink.ondrink=function(inst,eater)
        if(eater)then
            if(eater.components.fa_bufftimers)then
                eater.components.fa_bufftimers:AddBuff("damagemultiplier","DmgBoost","DamageMultiplier",2*60,{multiplier=0.2})
            end
        end
    end
    return inst
end 

local function drakealefn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

    inst.components.fa_drink.ondrink=function(inst,eater)
        if(eater:HasTag("player"))then
            eater.components.locomotor:Stop()
                eater.sg:GoToState("sleep")
                eater.components.health:SetInvincible(true)
                eater.components.playercontroller:Enable(false)
                GetPlayer().HUD:Hide()
                TheFrontEnd:Fade(false,1)
                eater:DoTaskInTime(1.2, function() 
                    GetPlayer().HUD:Show()
                    TheFrontEnd:Fade(true,1) 
                    eater.components.health:SetInvincible(false)
                    eater.components.playercontroller:Enable(true)
                    GetClock():MakeNextDay()
                    eater.sg:GoToState("wakeup")    

                    local spawn_point= Vector3(eater.Transform:GetWorldPosition())
                    local tree = SpawnPrefab("mandrake") 
                    local pt = Vector3(spawn_point.x, 0, spawn_point.z)
                    tree.Physics:SetCollides(false)
                    tree.Physics:Teleport(pt.x, pt.y, pt.z) 
                    tree.Physics:SetCollides(true)
                    eater.components.leader:AddFollower(tree)
                    local tree = SpawnPrefab("mandrake") 
                    tree.Physics:SetCollides(false)
                    tree.Physics:Teleport(pt.x, pt.y, pt.z) 
                    tree.Physics:SetCollides(true)
                    eater.components.leader:AddFollower(tree)

                    end)
        end
    end
    return inst
end 

local function oriansalefn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

    inst.components.fa_drink.ondrink=function(inst,eater)
            if(eater.components.fa_bufftimers)then
                eater.components.fa_bufftimers:AddBuff("spiderwhisperer","OrianBrew","SpiderWhisperer",8*60)
            end
    end
    return inst
end 

local function dorfalefn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

    return inst
end 

local function deathbrewfn(Sim)
    local inst= fn("fa_barrel_molasses")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=5
    inst.components.fa_drink.intoxication=5
    inst.components.fa_drink.temperaturedelta = TUNING.COLD_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG

    inst.components.fa_drink.ondrink=function(inst,eater)
            if(eater.components.fa_bufftimers)then
                eater.components.fa_bufftimers:AddBuff("deathbrew","DeathBrew","DeathBrew",4*60)
            end
    end
    return inst
end 

local function lightrum(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("physicaldr","PhysicalDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.PHYSICAL,drdelta=5})
    end
    return inst
end 

local function clearbourbonfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("forcedr","ForceDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.FORCE,drdelta=5})
    end
    return inst
end 

local function vodkafn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("poisondr","PoisonDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.POISON,drdelta=5})
    end
    return inst
end 

local function ginfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("aciddr","AcidDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.ACID,drdelta=5})
    end
    return inst
end 

local function tequilafn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("deathdr","DeathDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.DEATH,drdelta=15})
    end
    return inst
end 

local function whiskeyfn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_AVERAGE
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("electricdr","ElectDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.ELECTRIC,drdelta=5})
    end

    return inst
end 

local function baijuifn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("firedr","FireDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.FIRE,drdelta=5})
    end
    return inst
end 

local function sojufn(Sim)
    local inst= fn("fa_barrel_water")
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )
    inst.components.finiteuses:SetMaxUses(3)
    inst.components.finiteuses:SetUses(3)
    inst.components.fa_drink.hungervalue=-10
    inst.components.fa_drink.intoxication=15
    inst.components.fa_drink.temperaturedelta = TUNING.HOT_FOOD_BONUS_TEMP
    inst.components.fa_drink.temperatureduration =TUNING.FOOD_TEMP_LONG
    inst.components.fa_drink.ondrink=function(drink, eater)
        eater.components.fa_bufftimers:AddBuff("colddr","ColdDR","DamageReduction",DR_LENGTH,{damagetype=FA_DAMAGETYPE.COLD,drdelta=5})
    end
    return inst
end 

local function waterfn(Sim)
    return fn("fa_barrel_water")
end 
return Prefab( "common/fa_barrel_wood", woodfn, assets_wood),
Prefab( "common/fa_barrel_hotrum", hotrumfn, assets_hotrum),
Prefab( "common/fa_barrel_darkrum", darkrumfn, assets_darkrum),
Prefab( "common/fa_barrel_goldrum",goldrumfn, assets_goldrum),
Prefab( "common/fa_barrel_water", waterfn, assets_water),
Prefab( "common/fa_barrel_bourbon", bourbonfn, assets_water),
Prefab( "common/fa_barrel_flavoredrum", flavoredrumfn, assets_water),
Prefab( "common/fa_barrel_lightale", lightalefn, assets_water),
Prefab( "common/fa_barrel_ronsale", ronsalefn, assets_water),
Prefab( "common/fa_barrel_drakeale", drakealefn, assets_water),
Prefab( "common/fa_barrel_oriansale", oriansalefn, assets_water),
Prefab( "common/fa_barrel_dorfale", dorfalefn, assets_water),
Prefab( "common/fa_barrel_molasses", molassesfn, assets_molasses),
Prefab( "common/fa_barrel_deathbrew", deathbrewfn, assets_molasses),
Prefab( "common/fa_barrel_lightrum", lightrum, assets_water),
Prefab( "common/fa_barrel_clearbourbon", clearbourbonfn, assets_water),
Prefab( "common/fa_barrel_vodka", vodkafn, assets_water),
Prefab( "common/fa_barrel_gin", ginfn, assets_water),
Prefab( "common/fa_barrel_tequila", tequilafn, assets_water),
Prefab( "common/fa_barrel_whiskey", whiskeyfn, assets_water),
Prefab( "common/fa_barrel_baijui", baijuifn, assets_water),
Prefab( "common/fa_barrel_soju", sojufn, assets_water)