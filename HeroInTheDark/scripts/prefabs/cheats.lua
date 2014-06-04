require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/eyeball_turret.zip"),
    Asset("ANIM", "anim/eyeball_turret_object.zip"),

}

local prefabs = 
{
    "eye_charge",
    "eyeturret_base",
}


local function OnAttacked1(inst, data)
    if(data.attacker)then
    	local attacker=data.attacker
		inst.components.combat:SetTarget(attacker)
		if attacker == GetPlayer() and GetPlayer().components.xplevel then
			GetPlayer().components.xplevel:DoDelta(500)
		end
	end
end

local function OnAttacked2(inst, data)
	if(data.attacker)then
		local attacker=data.attacker
		inst.components.combat:SetTarget(attacker)
		if attacker == GetPlayer() and GetPlayer().components.xplevel then
			GetPlayer().components.xplevel:DoDelta(5)
		end
	end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
 	inst.entity:AddSoundEmitter()
    inst.Transform:SetFourFaced()

--    inst.OnLoad=onloadfn
--    inst.OnSave=onsavefn

    MakeObstaclePhysics(inst, 1)
        
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("eyeball_turret.png")



    inst.AnimState:SetBank("eyeball_turret")
    inst.AnimState:SetBuild("eyeball_turret")
    
    inst.AnimState:PlayAnimation("idle_loop")

    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(999999) 
    inst.components.health:StartRegen(5, 5)

    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.1
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.3
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0.4
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    
    inst:AddComponent("combat")
    inst.components.combat:SetRange(TUNING.EYETURRET_RANGE)
    inst.components.combat:SetDefaultDamage(0)
    inst.components.combat:SetAttackPeriod(TUNING.EYETURRET_ATTACK_PERIOD)
--    inst.components.combat:SetRetargetFunction(1, retargetfn)
--    inst.components.combat:SetKeepTargetFunction(shouldKeepTarget)
    inst.components.combat.canattack=function() return false end  

    inst:AddComponent("lighttweener")
    local light = inst.entity:AddLight()
    inst.components.lighttweener:StartTween(light, 0, .65, .7, {251/255, 234/255, 234/255}, 0, 
        function(inst, light) if light then light:Enable(false) end end)


    MakeLargeFreezableCharacter(inst)
    
    
--    inst.components.container.onopenfn = OnOpen
--    inst.components.container.onclosefn = OnClose
    
--    inst.components.container.widgetbuttoninfo = widgetbuttoninfo


    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")
    
--    inst:ListenForEvent("itemget",ammotest)
--    inst:ListenForEvent("itemlose",ammotest)
--    inst:ListenForEvent("onhitother",onhitother)

    inst.syncanim=function()return true end
    inst:SetStateGraph("SGeyeturret")
    local brain = require "brains/eyeturretbrain"
    inst:SetBrain(brain)
    return inst
end
local function fn1(Sim)
	local inst=fn(Sim)
    inst:ListenForEvent("attacked", OnAttacked1)
    inst.Transform:SetScale(1.25, 1.25, 1.25)

    return inst
end

local function fn2(Sim)
	local inst=fn(Sim)
    inst:ListenForEvent("attacked", OnAttacked2)
    inst.Transform:SetScale(0.75, 0.75, 0.75)
    return inst
end


return Prefab( "common/cheatball1", fn1, assets, prefabs),
Prefab( "common/cheatball2", fn2, assets, prefabs)