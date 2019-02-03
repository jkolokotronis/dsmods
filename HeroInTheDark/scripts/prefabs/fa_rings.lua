local assets=
{
    Asset("ANIM", "anim/fa_rings.zip"),
}

local demonassets={
    Asset("ANIM", "anim/fa_rings.zip"),
    Asset("ANIM", "anim/wortox.zip"),
}
local FROZEN_DAPPERNESS=-1
local BURNING_DAPPERNESS=-1
local LIGHT_DAPPERNESS=1
local DEMON_DAPPERNESS=-5/60
local RING_FUELLEVEL=200
local DEMON_FUELLEVEL=666
local SPEED_MULT=1.5
-- this is dumb but so are the changes
if(FA_SWACCESS or FA_PORKACCESS)then
    SPEED_MULT=SPEED_MULT-1
end

local function onfinished(inst)
    inst:Remove()
end

local function fn(color,type)
        local inst = CreateEntity()
        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)
        
    inst.AnimState:SetBank("fa_ring_"..color.."_"..type)
    inst.AnimState:SetBuild("fa_rings")
    inst.AnimState:PlayAnimation("idle")
        
        local minimap = inst.entity:AddMiniMapEntity()
        minimap:SetIcon( "fa_key.tex" )

        inst:AddComponent("inspectable")
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename="fa_ring_"..color.."_"..type
        inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"


    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.RING

        
        inst:AddComponent("tradable")
        
        return inst
    end

local function fnfoli()
    return fn("green","gold")
end


local function startfueled(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function stopfueled(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
end


local function startfueledfrozen(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end

    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    inst.pooptask=inst:DoPeriodicTask(1,function()
            if(owner.components.temperature)then
                owner.components.temperature.current = math.max( owner.components.temperature.current-1, owner.components.temperature.mintemp)
            end
    end)
end


local function startfueledburning(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end

    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
   
    inst.pooptask=inst:DoPeriodicTask(1,function()
            if(owner.components.temperature)then
                owner.components.temperature.current =  math.min( owner.components.temperature.current+1, owner.components.temperature.maxtemp)
            end
    end)
end

local function fnfrozen()
    local inst=fn("blue","silver")
    if(FA_DLCACCESS)then
        inst.components.equippable.dapperness =FROZEN_DAPPERNESS
    else
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness =FROZEN_DAPPERNESS    
    end

        inst.components.equippable:SetOnEquip( startfueledfrozen )
        inst.components.equippable:SetOnUnequip( stopfueled )
       

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
    return inst
end

local function fnburning()
    local inst=fn("red","bronze")
    if(FA_DLCACCESS)then
        inst.components.equippable.dapperness =BURNING_DAPPERNESS
    else
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness =BURNING_DAPPERNESS    
    end

        inst.components.equippable:SetOnEquip( startfueledburning )
        inst.components.equippable:SetOnUnequip( stopfueled )

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
    return inst
end

local function fnspeed()
    local inst=fn("green","silver")
    inst.components.equippable.walkspeedmult = SPEED_MULT
        inst.components.equippable:SetOnEquip( startfueled )
        inst.components.equippable:SetOnUnequip( stopfueled )
        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
    return inst
end


local function startlight(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    inst.pooptask=inst:DoPeriodicTask(2,function()
            if(owner.components.hunger)then
                owner.components.hunger:DoDelta(-1)
            end
    end)

    local le = CreateEntity()
    le.entity:AddTransform()

    le:AddComponent("lighttweener")
    le.light = le.entity:AddLight()
    le.light:Enable(true)
    le:AddTag("FX")
    le:AddTag("NOCLICK")
    le.persists=false
    le.components.lighttweener:StartTween(le.light, 4, 0.8, 0.8, {180/255, 100/255, 100/255}, 1)
    local follower = le.entity:AddFollower()
    follower:FollowSymbol( owner.GUID, owner.components.combat.hiteffectsymbol, 0, 0, 1 )
    inst.light_entity=le
end

local function stoplight(inst, owner) 
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    if(inst.light_entity)then
        inst.light_entity:Remove()
        inst.light_entity=nil
    end
end

local function fnlight()
    local inst=fn("yellow","gold")

    local light = inst.entity:AddLight()
    light:SetFalloff(0.8)
    light:SetIntensity(.8)
    light:SetRadius(1)
    light:Enable(true)
    light:SetColour(180/255, 100/255, 100/255)


        inst.components.equippable:SetOnEquip( startlight )
        inst.components.equippable:SetOnUnequip( stoplight )

    if(FA_DLCACCESS)then
        inst.components.equippable.dapperness =LIGHT_DAPPERNESS
    else
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness =LIGHT_DAPPERNESS    
    end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
    return inst
end


local function startpoop(inst, owner) 
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    inst.pooptask=inst:DoPeriodicTask(2,function()
        if(owner and owner:IsValid() and not (owner.components.health and owner.components.health:IsDead()))then
            local poo = SpawnPrefab("poop")
            poo.Transform:SetPosition(owner.Transform:GetWorldPosition())  
            --simply making a hunger_drain comp might be better... cant just change 'rate' because changing that would get overwritten by various other factors
            if(owner.components.hunger)then
                owner.components.hunger:DoDelta(-owner.components.hunger.hungerrate*2)
            end
        else
            print("warning: invalid owner of equipped ring!")
        end
    end)
    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
end

local function stoppoop(inst, owner) 
    if(inst.pooptask)then
        inst.pooptask:Cancel()
        inst.pooptask=nil
    end
    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
end

local function fnpoop()
    local inst=fn("orange","bronze")
        inst.components.equippable:SetOnEquip( startpoop )
        inst.components.equippable:SetOnUnequip( stoppoop )

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "MAGIC"
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(onfinished)
    return inst
end 


local function demonattack(attacker,data)
    local target=data.target
    target.components.combat:GetAttacked(attacker, 20, nil,nil,FA_DAMAGETYPE.FIRE)
    if(target.components.health:IsInvincible() == false and math.random()<=0.2)then
        if(target.components.burnable and not target.components.fueled)then
            target.components.burnable:Ignite()
        end
    end
end

local function OnBlocked(owner,data) 
    if(data and data.attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
        if(math.random()<=0.2)then
            print("reflecting to",data.attacker)
            data.attacker.components.combat:GetAttacked(owner, 20, nil,nil,FA_DAMAGETYPE.FIRE)
            data.attacker.components.burnable:Ignite()
        end
    end
end

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_fire", "swap_body")
end


local function startdemon(inst, owner) 
    if(owner:HasTag("player"))then

    if inst.components.fueled then
        inst.components.fueled:StartConsuming()        
    end
        inst.origprefab=owner.prefab
        owner.AnimState:SetBuild("wortox")
        owner.fa_hasmonster=owner:HasTag("monster")
        owner:AddTag("monster")
        if(owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE])then
            owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+1
        else
            owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1
        end
        if(owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD])then
            owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]+1
        else
            owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=1
        end
        --need to return this to orig - if at some point in between it gets changed, tough luck, one would need a stack not get/set 
        owner.components.eater.fa_foodprefback=owner.components.eater.foodprefs
        owner.components.eater.fa_monsterimmuneback=owner.components.eater.monsterimmune
        owner.components.eater.fa_strongstomachback=owner.components.eater.strongstomach
        owner.components.eater:SetCarnivore(true)
        owner.components.eater.monsterimmune = true
        owner.components.eater.strongstomach = true
        owner.components.hunger.hungerrate=owner.components.hunger.hungerrate+TUNING.WILSON_HUNGER_RATE
        owner.components.combat.fa_defaultdamageback=owner.components.combat.defaultdamage
        owner.components.combat.defaultdamage=40
        owner.components.locomotor.runspeed=owner.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        owner.components.health.maxhealth=owner.components.health.maxhealth+100
        owner.components.health:DoDelta(100)
        owner:ListenForEvent("onattackother",demonattack,owner) 
        owner:ListenForEvent("attacked",OnBlocked,owner)
        owner:ListenForEvent("blocked",OnBlocked,owner)
        local x,y,z=owner.Transform:GetScale()
        owner.Transform:SetScale(x*1.25,y*1.25,z*1.25)

        local  eqhead=owner.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
        if(eqhead)then
            owner.components.inventory:Unequip(EQUIPSLOTS.HEAD,nil,true)   
            owner.components.inventory:GiveItem(eqhead)         
        end

    elseif(owner.prefab=="fa_cursedwortox")then
        if inst.components.fueled then
            inst.components.fueled:StartConsuming()        
        end
    else
        local copy=SpawnPrefab("fa_ring_demon")
        copy.origprefab=owner.prefab
        local wortox=SpawnPrefab("fa_cursedwortox")
        wortox.components.inventory:Equip(copy)
        wortox.Transform:SetPosition(owner.Transform:GetWorldPosition())
        inst:Remove()
        owner:Remove()
    end
end

local function stopdemon( inst,owner )

    if inst.components.fueled then
        inst.components.fueled:StopConsuming()        
    end
    if(owner and owner:HasTag("player"))then
        if(not owner.fa_hasmonster)then
            owner:RemoveTag("monster")
        end
        owner.AnimState:SetBuild(inst.origprefab) --this will work for most cases, where it doesn't, well... I'll have to supply override somehow 
        owner.components.eater.foodprefs=owner.components.eater.fa_foodprefback
        owner.components.eater.monsterimmune=owner.components.eater.fa_monsterimmuneback
        owner.components.eater.strongstomach=owner.components.eater.fa_strongstomachback
        owner.components.hunger.hungerrate=owner.components.hunger.hungerrate-TUNING.WILSON_HUNGER_RATE
        owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=owner.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-1
        owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=owner.components.health.fa_resistances[FA_DAMAGETYPE.COLD]+1
        owner.components.combat.defaultdamage=owner.components.combat.fa_defaultdamageback
        owner.components.locomotor.runspeed=owner.components.locomotor.runspeed-0.1*TUNING.WILSON_RUN_SPEED
        owner:RemoveEventCallback("onattackother", demonattack, owner)
        owner:RemoveEventCallback("attacked", OnBlocked, owner)
        owner:RemoveEventCallback("blocked", OnBlocked, owner)
        owner.components.health.maxhealth=owner.components.health.maxhealth-100
        owner.components.health:DoDelta(0)
        local x,y,z=owner.Transform:GetScale()
        owner.Transform:SetScale(x/1.25,y/1.25,z/1.25)
        inst.components.fueled:InitializeFuelLevel(DEMON_FUELLEVEL)
    else

    end
end

local function demoncursefinish(inst)
    local owner=inst.components.inventoryitem.owner 
    if(not owner or not owner:IsValid())then  return end
    if(owner:HasTag("player"))then
        local eslot = inst.components.equippable.equipslot
        --need to force through it because the cursed state will stay, if klei changes params at some point ill be in trouble...
        owner.components.inventory:Unequip(EQUIPSLOTS.RING,nil,true)
        owner.components.inventory:GiveItem(inst)         
    else
        owner.components.inventory:Unequip(EQUIPSLOTS.RING,nil,true)
        inst.components.fueled:InitializeFuelLevel(RING_FUELLEVEL)
        owner.components.inventory:DropItem(inst, true)        
        local wortox=SpawnPrefab(inst.origprefab)
        wortox.Transform:SetPosition(owner.Transform:GetWorldPosition())
        owner:Remove()
    end
end


local function fndemon()
    local inst=fn("red","gold")
    inst:AddTag("cursed")
    local light = inst.entity:AddLight()
    light:SetFalloff(0.8)
    light:SetIntensity(.8)
    light:SetRadius(1)
    light:Enable(true)
    light:SetColour(160/255, 30/255, 30/255)


    inst.components.equippable:SetOnEquip( startdemon )
        inst.components.equippable:SetOnUnequip( stopdemon )

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "CURSE"
        inst.components.fueled:InitializeFuelLevel(DEMON_FUELLEVEL)
        inst.components.fueled:SetDepletedFn(demoncursefinish)


    if(FA_DLCACCESS)then
        inst.components.equippable.dapperness =DEMON_DAPPERNESS
    else
        inst:AddComponent("dapperness")
        inst.components.dapperness.dapperness =DEMON_DAPPERNESS    
    end


    inst.OnLoad = function(inst, data)
        inst.origprefab=data.origprefab
    end
    inst.OnSave = function(inst, data)
        data.origprefab=inst.origprefab
    end


    return inst
end

return  Prefab( "common/inventory/fa_ring_green_gold", fnfoli, assets),
Prefab( "common/inventory/fa_ring_frozen", fnfrozen, assets),
Prefab( "common/inventory/fa_ring_burning", fnburning, assets),
Prefab( "common/inventory/fa_ring_speed", fnspeed, assets),
Prefab( "common/inventory/fa_ring_poop", fnpoop, assets),
Prefab( "common/inventory/fa_ring_light", fnlight, assets),
Prefab( "common/inventory/fa_ring_demon", fndemon, demonassets)
