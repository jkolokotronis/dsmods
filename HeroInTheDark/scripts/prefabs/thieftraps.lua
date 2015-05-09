local assets=
{
	Asset("ANIM", "anim/trap_teeth.zip"),
	Asset("ANIM", "anim/trap_teeth_maxwell.zip"),
	Asset("ANIM", "anim/gunpowder.zip"),
    Asset("ANIM", "anim/explode.zip"),
    Asset("ANIM", "anim/firebomb.zip"),
    Asset("ANIM", "anim/icebomb.zip"),
    Asset("ANIM", "anim/fuse.zip"),
}

local TRAP_FREEZE_TIME=60
local TRAP_EXPLOSION_RANGE=5
local CIRCLE_OF_DEATH_TRAP_RADIUS=5
local INSTADEATH_TRESHOLD=0.5

local function onfinished_normal(inst)
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("mine")
    inst.persists = false
    inst.AnimState:PushAnimation("used", false)
    inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
    inst:DoTaskInTime(3, function() inst:Remove() end )
end

local function OnToothExplode(inst, target)
    inst.AnimState:PlayAnimation("trap")
    if target then

    	
    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("fuse")
    anim:SetBuild("fuse")
    anim:PlayAnimation("idle",false)

    local pos =inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    boom:ListenForEvent("animover", function() print("cleanup") boom:Remove() end)

        inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
	    target.components.combat:GetAttacked(inst, TUNING.TRAP_TEETH_DAMAGE*2)
        if METRICS_ENABLED then
			FightStat_TrapSprung(inst,target,TUNING.TRAP_TEETH_DAMAGE)
		end
    end
    if inst.components.finiteuses then
	    inst.components.finiteuses:Use(1)
    end
end

local function OnIceExplode(inst, target)


    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("icebomb")
    anim:SetBuild("icebomb")
    anim:PlayAnimation("idle",false)

    local pos =inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    boom:ListenForEvent("animover", function() print("cleanup") boom:Remove() end)

    inst.AnimState:PlayAnimation("trap")
    if target then
    	if(target.components.freezable)then
    		--TODO find better sound 
        	inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_trigger")
--	    	target.components.combat:GetAttacked(inst, TUNING.TRAP_TEETH_DAMAGE*2)
			target.components.freezable:Freeze(TRAP_FREEZE_TIME)
		end
    end
    if inst.components.finiteuses then
	    inst.components.finiteuses:Use(1)
    end
end
local function OnFireExplode(inst, target)
	local pos = Vector3(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:KillSound("hiss")
    inst.SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")

    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("firebomb")
    anim:SetBuild("firebomb")
    anim:PlayAnimation("idle",false)

    local pos =inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    boom:ListenForEvent("animover", function() print("cleanup") boom:Remove() end)

    GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.7, 0.02, .5, 40)

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TRAP_EXPLOSION_RANGE,nil,{"FX","INLIMBO"})

    for k,v in pairs(ents) do

            if v.components.burnable and not v.components.fueled then
                v.components.burnable:Ignite()
            end

            if v.components.combat and v ~= inst then
                v.components.combat:GetAttacked(inst, TUNING.GUNPOWDER_DAMAGE, nil,nil,FA_DAMAGETYPE.FIRE)
            end

    end

    local world = GetWorld()    --bleh, better way to do this?    
    world:PushEvent("explosion", {damage = TUNING.GUNPOWDER_DAMAGE})
   
    --self.inst:PushEvent("explosion")

    inst.AnimState:PlayAnimation("trap")
    if inst.components.finiteuses then
	    inst.components.finiteuses:Use(1)
    end
end

local function OnTentacleExplode(inst,target)
	local pt = Vector3(inst.Transform:GetWorldPosition())

    local numtentacles = 3

    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("fuse")
    anim:SetBuild("fuse")
    anim:PlayAnimation("idle",false)

    local pos =inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    boom:ListenForEvent("animover", function() print("cleanup") boom:Remove() end)

    inst:StartThread(function()
        for k = 1, numtentacles do
        
            local theta = math.random() * 2 * PI
            local radius = 3 --math.random(3, 8)

            -- we have to special case this one because birds can't land on creep
            local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)

            if result_offset then
                local tentacle = SpawnPrefab("tentacle")
                
                tentacle.Transform:SetPosition((pt + result_offset):Get())
--                GetPlayer().components.playercontroller:ShakeCamera(reader, "FULL", 0.2, 0.02, .25, 40)
                
                --need a better effect
--                local fx = SpawnPrefab("splash_ocean")
--                local pos = pt + result_offset
--                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
                --PlayFX((pt + result_offset), "splash", "splash_ocean", "idle")
                tentacle.sg:GoToState("attack_pre")
            end

            Sleep(.33)
        end
    end)

    inst.AnimState:PlayAnimation("trap")
    if inst.components.finiteuses then
        inst.components.finiteuses:Use(1)
    end
    return true    
end

local function OnCODExplode(inst,target)
    local pos =inst:GetPosition()
    GetPlayer().components.playercontroller:ShakeCamera(inst, "FULL", 0.7, 0.02, .5, 40)

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TRAP_EXPLOSION_RANGE)

       for k,v in pairs(ents) do
        local inpocket = v.components.inventoryitem and v.components.inventoryitem:IsHeld()

        if not inpocket then

           if not v:HasTag("player") and not v:HasTag("pet") and not v:IsInLimbo() and v.components.combat and v.components.health and  v ~= inst then
                local rng=math.random()
                if(rng>INSTADEATH_TRESHOLD)then
                    v.components.health:Kill()
                end
           end
           
        end
    end


end

local function OnReset(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_reset")
	inst.AnimState:PlayAnimation("reset")
	inst.AnimState:PushAnimation("idle", false)
end

local function OnResetMax(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/trap_teeth_reset")
	inst.AnimState:PlayAnimation("idle")
	--inst.AnimState:PushAnimation("idle", false)
end


local function SetSprung(inst)
    inst.AnimState:PlayAnimation("trap_idle")
end

local function SetInactive(inst)
    inst.AnimState:PlayAnimation("inactive")
end

local function OnDropped(inst)
	inst.components.mine:Deactivate()
end

local function ondeploy(inst, pt, deployer)
	inst.components.mine:Reset()
	inst.Physics:Teleport(pt:Get())
end

--legacy save support - mines used to start out activated
local function onload(inst, data)
	if not data or not data.mine then
		inst.components.mine:Reset()
	end
end

local function MakeDefaultTrap()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	MakeInventoryPhysics(inst)
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "toothtrap.png" )
   
	anim:SetBank("trap_teeth")
	anim:SetBuild("trap_teeth")
	anim:PlayAnimation("idle")
	
	inst:AddTag("trap")
	
	inst:AddComponent("inspectable")
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.nobounce = true
	inst.components.inventoryitem:SetOnDroppedFn(OnDropped)
    inst.components.inventoryitem.imagename="trap_teeth"
	
	inst:AddComponent("mine")
	inst.components.mine:SetRadius(TUNING.TRAP_TEETH_RADIUS)
	inst.components.mine:SetAlignment("player")
	inst.components.mine:SetOnResetFn(OnReset)
	inst.components.mine:SetOnSprungFn(SetSprung)
	inst.components.mine:SetOnDeactivateFn(SetInactive)
	--inst.components.mine:StartTesting()
	
	inst:AddComponent("finiteuses")
	inst.components.finiteuses:SetMaxUses(TUNING.TRAP_TEETH_USES)
	inst.components.finiteuses:SetUses(TUNING.TRAP_TEETH_USES)
	inst.components.finiteuses:SetOnFinished( onfinished_normal )
	
    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.min_spacing = .75
	
	inst.components.mine:Deactivate()
	inst.OnLoad = onload
	return inst
end

local function MakeDoubleTeethTrap()
	local inst=MakeDefaultTrap()
	inst.components.mine:SetOnExplodeFn(OnToothExplode)
	return inst
end

local function MakeIceTrap()
	local inst=MakeDefaultTrap()
	inst.components.mine:SetOnExplodeFn(OnIceExplode)
	return inst
end

local function MakeFireTrap()
	local inst=MakeDefaultTrap()
	inst.components.mine:SetOnExplodeFn(OnFireExplode)
	return inst
end

local function MakeTentacleTrap()
	local inst=MakeDefaultTrap()
	inst.components.mine:SetOnExplodeFn(OnTentacleExplode)
	return inst
end


local function MakeCircleOfDeath()
    local inst=MakeDefaultTrap()
    inst.components.mine:SetRadius(CIRCLE_OF_DEATH_TRAP_RADIUS)
    inst.components.mine:SetOnExplodeFn(OnCODExplode)
    return inst
end

return Prefab( "common/inventory/trap_doubleteeth", MakeDoubleTeethTrap, assets),
Prefab( "common/inventory/trap_ice", MakeIceTrap, assets),
Prefab( "common/inventory/trap_fire", MakeFireTrap, assets),
Prefab( "common/inventory/trap_tentacle", MakeTentacleTrap, assets),
Prefab( "common/inventory/trap_circleofdeath", MakeCircleOfDeath, assets),
		MakePlacer("common/trap_doubleteeth_placer", "trap_teeth", "trap_teeth", "idle"),
		MakePlacer("common/trap_ice_placer", "trap_teeth", "trap_teeth", "idle"),
		MakePlacer("common/trap_fire_placer", "trap_teeth", "trap_teeth", "idle"),
		MakePlacer("common/trap_tentacle_placer", "trap_teeth", "trap_teeth", "idle"),
        MakePlacer("common/trap_circleofdeath_placer", "trap_teeth", "trap_teeth", "idle")

