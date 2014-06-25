local assets=
{
	Asset("ANIM", "anim/sewing_kit.zip"),
}

local MENDING_USES=10

local function onfinished(inst)
	inst:Remove()
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("sewing_kit")
    inst.AnimState:SetBuild("sewing_kit")
    inst.AnimState:PlayAnimation("idle")
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(MENDING_USES)
    inst.components.finiteuses:SetUses(MENDING_USES)
    inst.components.finiteuses:SetOnFinished( onfinished )
    
    inst:AddComponent("fa_mender")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="sewing_kit"

    return inst
end

return Prefab( "common/inventory/fa_spell_mending", fn, assets) 

