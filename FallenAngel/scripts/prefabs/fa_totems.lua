local assets =
{
    Asset("ANIM", "anim/fa_redtotem.zip"),
    Asset("ANIM", "anim/fa_bluetotem.zip"),
    Asset("ANIM", "anim/swap_fa_redtotem.zip"),
    Asset("ANIM", "anim/swap_fa_bluetotem.zip"),
    Asset("ANIM", "anim/fa_shieldpuff.zip"),
    Asset("ANIM", "anim/firebomb.zip"),
    Asset("ANIM", "anim/bolt_tesla.zip"),
    Asset("ATLAS", "images/inventoryimages/fa_redtotem.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_redtotem.tex"),
    Asset("ATLAS", "images/inventoryimages/fa_bluetotem.xml"),
    Asset("IMAGE", "images/inventoryimages/fa_bluetotem.tex"),
}

local prefabs = 
{
    "fireballprojectile"
}
local REDTOTEM_RANGE=10
local REDTOTEM_USES=20
local REDTOTEM_DAMAGE=100
local REDTOTEM_ATTACKPERIOD=1.5
local TOTEM_HEALTH=1000
local BLUETOTEM_DURATION=1000
local FIREBALL_RADIUS=5

local function onsaveblue(inst,data)

    if self.currentfuel ~= self.maxfuel then
        return {fuel = self.currentfuel}
    end
end

local function onloadblue(inst,data)
    if data.fuel then
        self:InitializeFuelLevel(data.fuel)
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
        
        FA_ElectricalFence.AddNode(turret)
        
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

                    if(v.components.combat and not v==target and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(attacker, REDTOTEM_DAMAGE, nil,FA_DAMAGETYPE.FIRE)
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
        weapon.components.weapon:SetDamage(inst.components.combat.defaultdamage)
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
        local weapon = EquipWeaponRedKos(inst)
        weapon.components.weapon:SetProjectile("fireballprojectile")
        weapon:AddComponent("finiteuses")
        weapon.components.finiteuses:SetMaxUses(REDTOTEM_USES)
        weapon.components.finiteuses:SetUses(REDTOTEM_USES)
        weapon.components.finiteuses:SetOnFinished( onfinishedred )
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
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_redtotem.xml"

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
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_bluetotem.xml"

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

    inst:AddComponent("inventory")

    inst.components.combat:SetRange(REDTOTEM_RANGE)
    inst.components.combat:SetDefaultDamage(REDTOTEM_DAMAGE)
    inst.components.combat:SetAttackPeriod(REDTOTEM_ATTACKPERIOD)
    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)

     local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetTwoFaced()
--    boom.Transform:SetScale(5, 5, 1)
    anim:SetBank("firebomb")
    anim:SetBuild("firebomb")
    boom:AddTag("FX")
        boom:AddTag("NOCLICK")
    anim:PlayAnimation("idle",true)
    inst.fa_puffanim=boom
    local follower = boom.entity:AddFollower()
    follower:FollowSymbol( inst.GUID, "fa_redtotem", 0.5, -60, -0.0001 )
--    boom.entity:SetParent( inst.entity )
    inst.OnRemoveEntity = function(inst)
       if(inst.fa_puffanim)then
            inst.fa_puffanim:Remove()
        end
    end
    inst:SetStateGraph("SGredtotem")
    local brain = require "brains/eyeturretbrain"
    inst:SetBrain(brain)


    return inst
end

local function redfnkos(Sim)
    local inst=redfnbase(Sim)

    inst.components.combat:SetRetargetFunction(1, retargetfnkos)
    inst:DoTaskInTime(0.1, EquipWeaponRedKos)
    return inst
end

local function redfn(Sim)
    local inst=redfnbase(Sim)
    inst:AddTag("companion")
    inst:AddTag("pet")
    inst:AddComponent("machine")
    inst.components.machine.ison = true
    local function pickup(inst)
        inst.components.machine.ison = true
        
        local item=SpawnPrefab("fa_redtotem_item")
        local weapon=inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)

        if(weapon)then
            item.components.finiteuses:SetUses(weapon.components.finiteuses.current)
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
	FA_ElectricalFence.RemoveNode(inst)
	inst.components.health:Kill()
end

local function bluefn(Sim)
	local inst=fn(Sim)
	inst:AddTag("lightningfence") 
    inst:AddTag("companion")
    inst:AddTag("pet")

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

    inst:AddComponent("machine")
    inst.components.machine.ison = true
    local function pickup(inst)
        local item=SpawnPrefab("fa_bluetotem_item")
        item.components.fueled:InitializeFuelLevel(inst.components.fueled.currentfuel)
        inst:Remove()
        GetPlayer().components.inventory:GiveItem(item)
    end
    inst.components.machine.turnofffn  = pickup

    inst:AddComponent("fueled")
    inst.components.fueled.fueltype = "BURNABLE"
    inst.components.fueled:InitializeFuelLevel(BLUETOTEM_DURATION)
    inst.components.fueled:SetDepletedFn(outoffuel)
--    inst.components.fueled.ontakefuelfn = refuel
    inst.components.fueled.accepting = false
	inst.OnRemoveEntity = function(inst)
		FA_ElectricalFence.RemoveNode(inst)
	end

--    inst.OnLoad=onblueloadfn
--    inst.OnSave=onbluesavefn
    FA_ElectricalFence.RegisterNode(inst)
	inst.fa_nodelist={}
	inst.fa_effectlist={}

    return inst
end

return Prefab( "common/fa_redtotem", redfn, assets, prefabs),
Prefab( "common/fa_redtotem_kos", redfnkos, assets, prefabs),
Prefab("common/fa_redtotem_item", redtotem_itemfn, assets, prefabs),
MakePlacer("common/fa_redtotem_placer", "fa_redtotem", "fa_redtotem", "idle"),
Prefab( "common/fa_bluetotem", bluefn, assets, prefabs),
Prefab("common/fa_bluetotem_item", bluetotem_itemfn, assets, prefabs),
MakePlacer("common/fa_bluetotem_placer", "fa_bluetotem", "fa_bluetotem", "idle")