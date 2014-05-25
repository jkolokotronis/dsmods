require "prefabutil"
local brain = require "brains/fizzlepetbrain"
local Container=require"components/container"


local assets =
{
    Asset("ANIM", "anim/chester.zip"),
    Asset("ANIM", "anim/ui_chest_3x2.zip"),
    Asset("SOUND", "sound/chester.fsb"),
    Asset("ANIM", "anim/wx78.zip"),
    Asset("SOUND", "sound/wx78.fsb")    
}

local prefabs =
{
    "chester_eyebone",
    "die_fx"
}


local items =
{

    AXE = "swap_axe",
    PICK = "swap_pickaxe",
    SWORD = "swap_nightmaresword"
}

local PET_DAMAGE=50
local PET_HEALTH=500


local function Retarget(inst)

    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function ShouldKeepTarget(inst, target)
--    return false -- chester can't attack, and won't sleep if he has a target
end


local function OnOpen(inst)
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("open")
    end
end 

local function OnClose(inst) 
    if not inst.components.health:IsDead() then
        inst.sg:GoToState("close")
    end
end 

-- eye bone was killed/destroyed
local function OnStopFollowing(inst) 
    --print("chester - OnStopFollowing")
    inst:RemoveTag("companion") 
end

local function OnStartFollowing(inst) 
    --print("chester - OnStartFollowing")
    inst:AddTag("companion") 
end

local function EquipItem(inst, item)
    if item then
        inst.AnimState:OverrideSymbol("swap_object", item, item)
        inst.AnimState:Show("ARM_carry") 
        inst.AnimState:Hide("ARM_normal")
    end
end

local slotpos = {}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
    end
end

local function outoffuel(inst)
    inst.brain:Stop()
    inst.components.combat:SetTarget(nil)
    inst.components.locomotor:Stop()
end
   
local function refuel(inst)
    inst.brain:Start()
    inst.components.fueled:StartConsuming()

end


local onloadfn = function(inst, data)
    inst.currentfuel=data.currentfuel
    if(data.currentfuel and data.currentfuel<=0)then
        inst:StopBrain()
    end
end

local onsavefn = function(inst, data)
    data.currentfuel=inst.components.fueled.currentfuel
end

local function percentchanged(inst,data)
    local percent=data.percent
    if(percent<0.5)then
        local fueled=inst.components.fueled
        local item=inst.components.container:FindItem(function(item)
            if(item.components.fuel and item.components.fuel.fueltype==fueled.fueltype)then
                return true
            else
                return false
            end
        end)
        if(item)then
            local amount=fueled.maxfuel-fueled.currentfuel
            local fuelamount=item.components.fuel.fuelvalue
            print("fuel amount",fuelamount)
            local taken=inst.components.container:RemoveItem(item,false)
            inst.components.fueled:TakeFuelItem(taken)
        end
    end
end

local function fueltest(inst)
    percentchanged(inst,{percent=inst.components.fueled:GetPercent()})
end


local function ondeploy(inst, pt, deployer)
    local turret = SpawnPrefab("fizzlepet") 
    if turret then 
        pt = Vector3(pt.x, 0, pt.z)
        turret.Physics:SetCollides(false)
        turret.Physics:Teleport(pt.x, pt.y, pt.z) 
        turret.Physics:SetCollides(true)
--        turret.syncanim("place")
--        turret.syncanimpush("idle_loop", true)
        turret.SoundEmitter:PlaySound("dontstarve/common/place_structure_stone")
        deployer.components.leader:AddFollower(turret)
        turret:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
        end)

        inst:Remove()
    end         
end

local function fn()
    --print("chester - create_chester")

    local inst = CreateEntity()
    
    inst:AddTag("companion")
    inst:AddTag("character")
    inst:AddTag("scarytoprey")
--    inst:AddTag("chester")
    inst:AddTag("notraptrigger")
    inst:AddTag("pet")


    inst.OnLoad=onloadfn
    inst.OnSave=onsavefn

    inst.entity:AddTransform()

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "wx78.png" )

    --print("   AnimState")
    local anim=inst.entity:AddAnimState()
--    inst.AnimState:SetBank("chester")
--    inst.AnimState:SetBuild("chester")


        anim:SetBank("wilson")
        anim:SetBuild("wx78")
        anim:PlayAnimation("idle")
        
        anim:Hide("ARM_carry")
        anim:Hide("hat")
        anim:Hide("hat_hair")
        anim:OverrideSymbol("fx_wipe", "wilson_fx", "fx_wipe")
        anim:OverrideSymbol("fx_liquid", "wilson_fx", "fx_liquid")
        anim:OverrideSymbol("shadow_hands", "shadow_hands", "shadow_hands")

    --print("   sound")
    inst.entity:AddSoundEmitter()

    --print("   shadow")
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )

    --print("   Physics")
    MakeCharacterPhysics(inst, 75, .5)
    
    --print("   Collision")
    inst.Physics:SetCollisionGroup(COLLISION.CHARACTERS)
    inst.Physics:ClearCollisionMask()
    inst.Physics:CollidesWith(COLLISION.WORLD)
    inst.Physics:CollidesWith(COLLISION.OBSTACLES)
    inst.Physics:CollidesWith(COLLISION.CHARACTERS)

    inst.Transform:SetFourFaced()


    --print("   Userfuncs")

    ------------------------------------------

    --print("   combat")
    inst:AddComponent("combat")
        inst.components.combat.hiteffectsymbol = "torso"
--    inst.components.combat:SetKeepTargetFunction(ShouldKeepTarget)
    inst.components.combat:SetDefaultDamage(PET_DAMAGE)
    inst.components.combat:SetAttackPeriod(0.75)
    inst.components.combat:SetRetargetFunction(0.1, Retarget)
    --inst:ListenForEvent("attacked", OnAttacked)

    --print("   health")
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(PET_HEALTH)
    inst.components.health:StartRegen(TUNING.CHESTER_HEALTH_REGEN_AMOUNT, TUNING.CHESTER_HEALTH_REGEN_PERIOD)
    inst:AddTag("noauradamage")


    --print("   inspectable")
    inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()
    --inst.components.inspectable.getstatus = GetStatus

    --print("   locomotor")
    inst:AddComponent("locomotor")
    inst.components.locomotor.walkspeed = 3
    inst.components.locomotor.runspeed = 7

    --print("   follower")
    inst:AddComponent("follower")
    inst:ListenForEvent("stopfollowing", OnStopFollowing)
    inst:ListenForEvent("startfollowing", OnStartFollowing)


    
    --("   container")
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    
    inst.components.container.onopenfn = OnOpen
    inst.components.container.onclosefn = OnClose
    
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,-180,0)
    inst.components.container.widgetpos_controller = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160


        inst:AddComponent("inventory")
--        inst.components.inventory.starting_inventory = starting_inventory
        inst.components.inventory.dropondeath = true

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "BURNABLE"
    inst.components.fueled:InitializeFuelLevel(TUNING.SEG_TIME*10)
    inst.components.fueled:SetDepletedFn(outoffuel)
    inst.components.fueled.ontakefuelfn = refuel
    inst.components.fueled.accepting = true


    inst:ListenForEvent("itemget",fueltest)
    inst:ListenForEvent("percentusedchange",percentchanged)


    inst:AddComponent("lootdropper")
    inst.components.lootdropper:SetLoot({"gears",  "gears","gears",  "gears","gears",  "gears","purplegem"})

    --print("   sg")
    inst:SetStateGraph("SGfizzlepet")
    inst.sg:GoToState("idle")

    inst.items=items
    inst.equipfn=EquipItem
    
    inst:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
    end)

    inst:SetBrain(brain)    

    inst.components.fueled:StartConsuming()
    --print("   brain")


    --print("chester - create_chester END")
    return inst
end


local function itemfn(Sim)
    local inst = CreateEntity()
   
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    inst.AnimState:SetBank("gears")
    inst.AnimState:SetBuild("gears")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="gears"
    

    --Tag to make proper sound effects play on hit.
    inst:AddTag("largecreature")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.test = function(inst,pt,deployer) 
        if(deployer and deployer.components.leader)then
            local leader=deployer.components.leader
            for k,v in pairs(leader.followers) do
                if k.prefab=="fizzlepet" then
                    return false
                end
            end
        end
        return true 
    end
    inst.components.deployable.min_spacing = 0
    inst.components.deployable.placer = "fizzlepet_placer"

    return inst
end

return Prefab( "common/fizzlepet", fn, assets, prefabs),
Prefab("common/fizzlepet_box", itemfn, assets, prefabs),
MakePlacer("common/fizzlepet_placer", "wilson", "wx78", "idle")
