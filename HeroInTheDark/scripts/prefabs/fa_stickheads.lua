local goblin_assets =
{
	Asset("ANIM", "anim/goblinking_head.zip"),
}

local skull_assets={
    Asset("ANIM", "anim/fa_skullstick.zip"),
}
local skullground_assets={
    Asset("ANIM", "anim/fa_skullground.zip"),
}
local skullpillar_assets={
    Asset("ANIM", "anim/fa_skullpillar.zip"),
}

local prefabs={}

local goblin_prefabs=
{
	"spoiled_food",
	"twigs",
}

local FEAR_RANGE=15
local FEAR_DURATION=10

local function OnActivate(inst)
        local item=SpawnPrefab("goblinkinghead_item")
        inst:Remove()
        GetPlayer().components.inventory:GiveItem(item)
end


local function GetVerb(inst)
--    return STRINGS.ACTIONS.PICKUP
    return "Pick up"
end

local function castfear(inst)

        local pos=Vector3(inst.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FEAR_RANGE,{"goblin"},{"pet","player","INLIMBO","companion"})
        for k,v in pairs(ents) do
           
                local inst = CreateEntity()
                inst.entity:AddTransform()

                local spell = inst:AddComponent("spell")
                inst.components.spell.spellname = "fa_fear"
                inst.components.spell.duration = FEAR_DURATION
                inst.components.spell.ontargetfn = function(inst,target)
                    target.fa_fear = inst
                    target:AddTag(inst.components.spell.spellname)

                    local talk=GetString(target.prefab, "FA_FEAR_DEADKING")
                    print("talk",talk)
                    if(talk and target.components.talker) then target.components.talker:Say(talk) end

                end
                --inst.components.spell.onstartfn = function() end
                inst.components.spell.onfinishfn = function(inst)
                    if not inst.components.spell.target then
                    return
                    end
                    inst.components.spell.target.fa_fear = nil
                end
                --inst.components.spell.fn = function(inst, target, variables) end
                inst.components.spell.resumefn = function() end
                inst.components.spell.removeonfinish = true

                inst.components.spell:SetTarget(v)
                inst.components.spell:StartSpell()

                
        end
        return true

end


local function common(name)
    local inst=CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("idle")
    inst.entity:AddSoundEmitter()
    return inst

end

local function create_goblinhead()
	local inst = common("goblinking_head")
    inst.AnimState:PlayAnimation("idle_asleep")

    inst:AddComponent("lootdropper")

--    inst:AddComponent("inspectable")

    inst.flies = inst:SpawnChild("flies")

            inst:AddComponent("activatable")
            inst.components.activatable.OnActivate = OnActivate
            inst.components.activatable.inactive = true
            inst.components.activatable.getverb = GetVerb
            inst.components.activatable.quickaction = true

    inst:DoPeriodicTask(2, castfear)

	return inst
end


local function ondeploy(inst, pt, deployer)
    local turret = SpawnPrefab("goblinkinghead") 
    if turret then 
        pt = Vector3(pt.x, 0, pt.z)
        turret.Physics:SetCollides(false)
        turret.Physics:Teleport(pt.x, pt.y, pt.z) 
        turret.Physics:SetCollides(true)
        turret.SoundEmitter:PlaySound("dontstarve/common/place_structure_wood")
       
        inst:Remove()
    end         
end

local function goblinhead_itemfn(Sim)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
        MakeInventoryPhysics(inst)
	inst.AnimState:SetBank("goblinking_head")
    inst.AnimState:SetBuild("goblinking_head")
    inst.AnimState:PlayAnimation("idle_asleep")

    inst:AddComponent("deployable")
    inst:AddComponent("inventoryitem")
    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.placer = "goblinkinghead_placer"
    inst.components.inventoryitem.imagename="goblinking_head"
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"


    return inst
end

local function skullhead(  )
    local inst=common("fa_skullstick")
    return inst
end

local function skullpillar(  )
    local inst=common("fa_skullpillar")
    return inst
end
local function skullground(  )
    local inst=common("fa_skullground")
    return inst
end
return Prefab("forest/objects/goblinkinghead", create_goblinhead, goblin_assets, goblin_prefabs),
	   Prefab("forest/objects/goblinkinghead_item", goblinhead_itemfn, goblin_assets, goblin_prefabs),
		MakePlacer("common/objects/goblinkinghead_placer", "goblinking_head", "goblinking_head", "idle_asleep"),
        Prefab("forest/objects/fa_skullground", skullground, skullground_assets, prefabs),
        Prefab("forest/objects/fa_skullstick", skullhead, skull_assets, prefabs),
        Prefab("forest/objects/fa_skullpillar", skullpillar, skullpillar_assets, prefabs)