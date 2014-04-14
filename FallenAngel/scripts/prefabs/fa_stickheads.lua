local goblin_assets =
{
	Asset("ANIM", "anim/goblinking_head.zip")
}
local goblin_prefabs=
{
	"spoiled_food",
	"twigs",
}




local function create_common(inst)
	inst.entity:AddSoundEmitter()

	inst.AnimState:PlayAnimation("idle_asleep")

	inst:AddComponent("lootdropper")

	inst:AddComponent("inspectable")

	inst.flies = inst:SpawnChild("flies")

	return inst
end


local function create_goblinhead()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()

	inst.AnimState:SetBank("merm_head")
	inst.AnimState:SetBuild("goblinking_head")

	create_common(inst)


	return inst
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

local function goblinhead_itemfn(Sim)
    local inst=itemfn(Sim)
	inst.AnimState:SetBank("merm_head")
    inst.AnimState:SetBuild("goblinking_head")
    inst.AnimState:PlayAnimation("idle_asleep")

    inst.components.deployable.ondeploy = ondeploy
    inst.components.deployable.placer = "goblinkinghead_placer"
    inst.components.inventoryitem.imagename="goblinking_head"
    inst.components.inventoryitem.atlasname="images/inventoryimages/goblinking_head.xml"

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(REDTOTEM_USES)
    inst.components.finiteuses:SetUses(REDTOTEM_USES)

    return inst
end

return Prefab("forest/objects/goblinkinghead", create_goblinhead, goblin_assets, goblin_prefabs),
	   Prefab("forest/objects/goblinkinghead_item", goblinhead_itemfn, goblin_assets, goblin_prefabs),
		MakePlacer("common/objects/goblinkinghead_placer", "merm_head", "goblinking_head", "idle_asleep")