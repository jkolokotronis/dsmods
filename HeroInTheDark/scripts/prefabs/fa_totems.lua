local red_assets =
{
    Asset("ANIM", "anim/fa_redtotem.zip"),
    Asset("ANIM", "anim/swap_fa_redtotem.zip"),
    Asset("ANIM", "anim/fa_shieldpuff.zip"),
    Asset("ANIM", "anim/bolt_tesla.zip"),
}

local blue_assets =
{
    Asset("ANIM", "anim/fa_bluetotem.zip"),
    Asset("ANIM", "anim/swap_fa_bluetotem.zip"),
    Asset("ANIM", "anim/fa_shieldpuff.zip"),
    Asset("ANIM", "anim/bolt_tesla.zip"),
}

local prefabs = 
{
    "fireballprojectile",
    "fa_firebombfx"
}

local prefabskos = 
{
    "fa_firebombfx",
    "fireballprojectilekos"
}

local fences=require "fa_electricalfence"
local FenceManager=fences.FenceManager
--local PlayerFence=fences.PlayerFence
--local MobFence=fences.MobFence

local REDTOTEM_RANGE=10
local REDTOTEM_USES=20
local REDTOTEM_DAMAGE=100
local REDTOTEM_ATTACKPERIOD=1.5
local KOS_TOTEM_HEALTH=300
local TOTEM_HEALTH=1000
local BLUETOTEM_DURATION=1000
local FIREBALL_RADIUS=5

local function onbluesavefn(inst,data)
    if(inst.fa_fencetag)then
        data.fa_fencetag=inst.fa_fencetag
    end
end

local function onblueloadfn(inst,data)
    
    if(data and data.fueled and data.fueled.rate~=nil)then
        inst.components.fueled.rate=data.fueled.rate
    end
    if(data and data.fa_fencetag)then
        inst.fa_fencetag=data.fa_fencetag
        inst:AddTag(inst.fa_fencetag)
    end
end

local function onhammered(inst, worker)
		
		SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
		
		inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")		
		
		inst.components.health:Kill()
	end

local function dotweenin(inst, l)
    inst.components.lighttweener:StartTween(nil, 0, .65, .7, nil, 0.15, 
        function(i, light) if light then light:Enable(false) end end)
end

local function onhitother(inst)
--	inst.components.finiteuses:Use(1)
end

local function retargetfn(inst)
    local newtarget = FindEntity(inst, 20, function(guy)
            return  guy.components.combat and 
                    inst.components.combat:CanTarget(guy) and
                    (guy.components.combat.target == GetPlayer() or GetPlayer().components.combat.target == guy)
    end)

    return newtarget
end

local function retargetfnkos(inst)
    local newtarget = FindEntity(inst, 20, function(guy)
            return   guy:HasTag("character") and guy.components.combat and 
                    inst.components.combat:CanTarget(guy) 
    end)

    return newtarget
end

local function shouldKeepTarget(inst, target)
    if target and target:IsValid() and
        (target.components.health and not target.components.health:IsDead()) then
        local distsq = target:GetDistanceSqToInst(inst)
        return distsq < 20*20
    else
        return false
    end
end

local function OnAttacked(inst, data)
    local attacker = data and data.attacker
    if attacker == GetPlayer() then
        return
    end
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, 15, function(dude) return dude:HasTag("totem") end, 10)
end

local function ondeployred(inst, pt, deployer)
    local turret = SpawnPrefab("fa_redtotem") 
    if turret then 
        pt = Vector3(pt.x, 0, pt.z)
        turret.Physics:SetCollides(false)
        turret.Physics:Teleport(pt.x, pt.y, pt.z) 
        turret.Physics:SetCollides(true)
        turret.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
        if(inst.components.finiteuses)then
            turret.fa_currentuses=inst.components.finiteuses.current
        end
        inst:Remove()
    end         
end

local function ondeployblue(inst, pt, deployer)
    local turret = SpawnPrefab("fa_bluetotem") 
    if turret then 
        pt = Vector3(pt.x, 0, pt.z)
        turret.Physics:SetCollides(false)
        turret.Physics:Teleport(pt.x, pt.y, pt.z) 
        turret.Physics:SetCollides(true)
        turret.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")

        if(inst.components.fueled) then
            turret.components.fueled:InitializeFuelLevel(inst.components.fueled.currentfuel)
        end
        
--        PlayerFence:AddNode(turret)
        
        inst:Remove()
    end         
end

local function WeaponDropped(inst)
    inst:Remove()
end


local function onfinishedred( inst )
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")      
    inst:Remove()
end

local function onattackfireball(inst, attacker, target)
    --since i cant set weapon to aoe...
    local pos=Vector3(target.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FIREBALL_RADIUS,nil,{"INLIMBO"})
            for k,v in pairs(ents) do
                if  not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(attacker, REDTOTEM_DAMAGE, nil,nil,FA_DAMAGETYPE.FIRE)
                    end
                end
            end
    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function EquipWeaponRedKos(inst)
    if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(0)
        weapon.components.weapon:SetRange(REDTOTEM_RANGE, REDTOTEM_RANGE+4)
        weapon.components.weapon:SetProjectile("fireballprojectilekos")
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(WeaponDropped)
        weapon.components.weapon:SetOnAttack(onattackfireball)
        weapon.components.weapon.fa_damagetype=FA_DAMAGETYPE.FIRE
        weapon:AddComponent("equippable")
        
        inst.components.inventory:Equip(weapon)
        return weapon
    end
end

local function EquipWeaponRed(inst)
    if inst.components.inventory and not inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS) then
--        local weapon = EquipWeaponRedKos(inst)
        local weapon = CreateEntity()
        weapon.entity:AddTransform()
        weapon:AddComponent("weapon")
        weapon.components.weapon:SetDamage(0)
        weapon.components.weapon:SetRange(REDTOTEM_RANGE, REDTOTEM_RANGE+4)
        weapon:AddComponent("inventoryitem")
        weapon.persists = false
        weapon.components.inventoryitem:SetOnDroppedFn(WeaponDropped)
        weapon.components.weapon:SetOnAttack(onattackfireball)
        weapon.components.weapon.fa_damagetype=FA_DAMAGETYPE.FIRE
        weapon:AddComponent("equippable")

        weapon.components.weapon:SetProjectile("fireballprojectile")
        weapon:AddComponent("finiteuses")
        weapon.components.finiteuses:SetMaxUses(REDTOTEM_USES)
        weapon.components.finiteuses:SetUses(REDTOTEM_USES)
        weapon.components.finiteuses:SetOnFinished( onfinishedred )
        inst.components.inventory:Equip(weapon)
        return weapon
    end
end

local function itemfn(Sim)
    local inst = CreateEntity()
   
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    
    inst:AddTag("totem")

    --Tag to make proper sound effects play on hit.
    inst:AddTag("largecreature")

    inst:AddComponent("deployable")
    inst.components.deployable.test = function() return true end
    inst.components.deployable.min_spacing = 0
    
    return inst
end

local function redtotem_itemfn(Sim)
    local inst=itemfn(Sim)
	inst.AnimState:SetBank("fa_redtotem")
    inst.AnimState:SetBuild("fa_redtotem")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.components.deployable.ondeploy = ondeployred
    inst.components.deployable.placer = "fa_redtotem_placer"
    inst.components.inventoryitem.imagename="fa_redtotem"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(REDTOTEM_USES)
    inst.components.finiteuses:SetUses(REDTOTEM_USES)

    return inst
end

local function bluetotem_itemfn(Sim)
    local inst=itemfn(Sim)
	inst.AnimState:SetBank("fa_bluetotem")
    inst.AnimState:SetBuild("fa_bluetotem")
    inst.AnimState:PlayAnimation("idle")
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    inst.components.deployable.ondeploy = ondeployblue
    inst.components.deployable.placer = "fa_bluetotem_placer"
    inst.components.inventoryitem.imagename="fa_bluetotem"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "BURNABLE"
    inst.components.fueled:InitializeFuelLevel(BLUETOTEM_DURATION)
--    inst.components.fueled:SetDepletedFn(outoffuel)
--    inst.components.fueled.ontakefuelfn = refuel
    inst.components.fueled.accepting = false

    return inst
end



local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
 	inst.entity:AddSoundEmitter()
--    inst.Transform:SetFourFaced()
    inst.Transform:SetScale(1.5, 1.5, 1.5)

    MakeInventoryPhysics(inst)
--    MakeObstaclePhysics(inst, 0.1)
        
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("eyeball_turret.png")

    inst:AddTag("totem")
	inst:AddComponent("lootdropper")
    inst:AddComponent("inspectable")


    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(TOTEM_HEALTH) 
    inst.components.health:StartRegen(5, 5)
    
    inst:AddComponent("combat")

	inst:AddComponent("repairable")
    inst.components.repairable.repairmaterial = "wood"
--	inst.components.repairable.onrepaired = onrepaired

	inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(3)
		inst.components.workable:SetOnFinishCallback(onhammered)

    return inst
end


local function redfnbase(Sim)
	local inst=fn(Sim)
    inst:AddComponent("lighttweener")
    local light = inst.entity:AddLight()
    inst.components.lighttweener:StartTween(light, 0, .65, .7, {251/255, 134/255, 134/255}, 0, 
        function(inst, light) if light then light:Enable(false) end end)

    inst.dotweenin = dotweenin

    inst.AnimState:SetBank("fa_redtotem")
    inst.AnimState:SetBuild("fa_redtotem")
	inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
--    MakeMediumFreezableCharacter(inst)

    inst.components.lootdropper:SetLoot({"redgem",  "boards"})
    
    inst:ListenForEvent("attacked", OnAttacked)
    inst:ListenForEvent("onhitother",onhitother)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=1

    inst:AddComponent("inventory")

    inst.components.combat:SetRange(REDTOTEM_RANGE)
    inst.components.combat:SetDefaultDamage(REDTOTEM_DAMAGE)
    inst.components.combat:SetAttackPeriod(REDTOTEM_ATTACKPERIOD)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)

     local boom = SpawnPrefab("fa_firebombfx")
     boom.persists=false

    inst.fa_puffanim=boom
    --[[
    inst:DoTaskInTime(0,function()
        if(boom)then
            local x,y,z=inst:GetPosition():Get()
            boom.Transform:SetPosition(x, y+1, z)
        end
    end)]]
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fa_redtotem", 0, 50, -0.0001 )
--    boom.entity:SetParent( inst.entity )
--    follower:FollowSymbol( inst.GUID, "fa_redtotem", 0, 0, -0.0001 )

   inst:ListenForEvent("death",function(inst)
        if(inst.fa_puffanim)then
            inst.fa_puffanim:Remove()
        end
    end)

    inst:SetStateGraph("SGredtotem")
    local brain = require "brains/eyeturretbrain"
    inst:SetBrain(brain)


    return inst
end

local function redfnkos(Sim)
    local inst=redfnbase(Sim)

    inst.components.health:SetMaxHealth(KOS_TOTEM_HEALTH) 
    inst.components.combat:SetRetargetFunction(1, retargetfnkos)
    inst:DoTaskInTime(0.1, EquipWeaponRedKos)
    return inst
end

local function redfn(Sim)
    local inst=redfnbase(Sim)
    inst:AddTag("companion")
--    inst:AddTag("pet")
    inst:AddComponent("machine")
    inst.components.machine.ison = true
    local function pickup(inst)
        inst.components.machine.ison = true
        
        local item=SpawnPrefab("fa_redtotem_item")
        local weapon=inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        if(weapon)then
            item.components.finiteuses:SetUses(weapon.components.finiteuses.current)
        end
        if(inst.fa_puffanim)then
            inst.fa_puffanim:Remove()
        end
        inst:Remove()
        GetPlayer().components.inventory:GiveItem(item)
    end
    inst.components.machine.turnofffn  = pickup

    inst.components.combat:SetRetargetFunction(1, retargetfn)
    inst:DoTaskInTime(0.1, EquipWeaponRed)
    return inst
end

local function outoffuel(inst)
--	FenceManager:RemoveNode(inst)
	inst.components.health:Kill()
end

local function bluefn(Sim)
	local inst=fn(Sim)
	inst:AddTag("lightningfence") 
--    inst:AddTag("pet")

    inst.AnimState:SetBank("fa_bluetotem")
    inst.AnimState:SetBuild("fa_bluetotem")
	inst.AnimState:PlayAnimation("idle")
--    inst.Transform:SetScale(2, 2, 1)
    
    inst.components.lootdropper:SetLoot({"bluegem",  "boards"})
    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    local light = inst.entity:AddLight()
    
    light:SetIntensity(.6)
    light:SetRadius(.7)
    light:SetFalloff(.6)
    light:Enable(true)
    light:SetColour(180/255, 195/255, 255/255)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=1

--the only purpose is to allow combat:getattacked
    inst.components.combat:SetRange(0)
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat:SetAttackPeriod(9999)


    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "BURNABLE"
    inst.components.fueled:InitializeFuelLevel(BLUETOTEM_DURATION)
    inst.components.fueled:SetDepletedFn(outoffuel)
--    inst.components.fueled.ontakefuelfn = refuel
    inst.components.fueled.accepting = false

    inst.OnLoad=onblueloadfn
    inst.OnSave=onbluesavefn
	inst.fa_nodelist={}
	inst.fa_effectlist={}


    inst.OnRemoveEntity = function()
        FenceManager:RemoveNode(inst)
    end

    return inst
end

local function bluefn_player()
    local inst=bluefn()
    inst:AddTag("companion")
    inst.fa_fencetag="lightningfence"
    inst:AddTag(inst.fa_fencetag)
    
    inst:AddComponent("machine")
    inst.components.machine.ison = true
    local function pickup(inst)
        local item=SpawnPrefab("fa_bluetotem_item")
        item.components.fueled:InitializeFuelLevel(inst.components.fueled.currentfuel)
        inst:Remove()
        GetPlayer().components.inventory:GiveItem(item)
    end
    inst.components.machine.turnofffn  = pickup
    --delay enough for placers and crap to finish, otherwise it will fail to connect
    --the only real reason i do register special is so it can get sorted out in one go on file load - both for speed and sync sake
    if(FenceManager.initialized)then
        inst:DoTaskInTime(0.1,function(inst)
            FenceManager:AddNode(inst)
        end)
    else
        FenceManager:RegisterNode(inst)
    end

    return inst
end

 local function onloadbluekos(inst,data)
    
    if(data and data.fueled and data.fueled.rate~=nil)then
        inst.components.fueled.rate=data.fueled.rate
    end
    if(data and data.fa_fencetag)then
        inst.fa_fencetag=data.fa_fencetag
        inst:RemoveTag("lightningfence_kos")
        inst:AddTag(inst.fa_fencetag)
        --something has to do configuration, and tags are unknown before load
        --this is extremely ugly place to put it in
        if(FenceManager:GetFence(inst.fa_fencetag)==nil)then
            FenceManager:ConfigFence(inst.fa_fencetag,nil,{inst.fa_fencetag},{"FX", "DECOR","INLIMBO","lightningfence"})
        end
    end
end

local function bluefn_kos(Sim)
    local inst=bluefn(Sim)
    inst.fa_fencetag="lightningfence_kos"
        inst:AddTag("lightningfence_kos")
    if(FenceManager.initialized)then
        inst:DoTaskInTime(0.1,function(inst)
            FenceManager:AddNode(inst)
        end)
    else
        FenceManager:RegisterNode(inst)
    end
    
    inst.OnLoad=onloadbluekos
   
    return inst
end

return Prefab( "common/fa_redtotem", redfn, red_assets, prefabs),
Prefab( "common/fa_redtotem_kos", redfnkos, red_assets, prefabskos)
,Prefab("common/fa_redtotem_item", redtotem_itemfn, red_assets, prefabs),
MakePlacer("common/fa_redtotem_placer", "fa_redtotem", "fa_redtotem", "idle"),
Prefab( "common/fa_bluetotem", bluefn_player, blue_assets, prefabs),
Prefab( "common/fa_bluetotem_kos", bluefn_kos, blue_assets, prefabs),
Prefab("common/fa_bluetotem_item", bluetotem_itemfn, blue_assets, prefabs),
MakePlacer("common/fa_bluetotem_placer", "fa_bluetotem", "fa_bluetotem", "idle")
