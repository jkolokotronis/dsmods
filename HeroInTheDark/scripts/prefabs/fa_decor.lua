
local fa_pillar_dwarf_assets={
    Asset( "ANIM", "anim/fa_pillar_dwarf.zip" ),
}
local fa_stool_assets={
    Asset( "ANIM", "anim/fa_stool.zip" ),
}
local fa_table_assets={
    Asset( "ANIM", "anim/fa_table.zip" ),
}
local fa_minecart_assets={
    Asset( "ANIM", "anim/fa_minecart.zip" ),
}
local fa_orcrefuse_assets={
    Asset( "ANIM", "anim/fa_orcrefuse.zip" ),
}
local function fn(bank,bld,animname,loop)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    local build=bld or bank
    local animation=animname or "idle"
    local looping=loop or false

    anim:SetBank(bank)
    anim:SetBuild(build)
    anim:PlayAnimation(animation,looping)
    inst:AddTag("NOCLICK")

    inst.fa_rotate=function(dest)
    	anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    	local angle = inst:GetAngleToPoint(dest:GetPosition())
    	inst.Transform:SetRotation(angle)
	end
	
    return inst
end

local function fa_pillar_dwarf()
	local inst= fn("fa_pillar_dwarf")
    MakeObstaclePhysics(inst, 1)
    inst.Transform:SetScale(1.3,1.3,1.3)
    return inst
end

local function fa_table()
    local inst= fn("fa_table")
    MakeObstaclePhysics(inst, 0.3)
    return inst
end

local function fa_stool_blown()
    local inst= fn("fa_stool")
    MakeInventoryPhysics(inst)
    inst.AnimState:PlayAnimation("blown")
    return inst
end

local function fa_stool()
    local inst= fn("fa_stool")
    MakeInventoryPhysics(inst)
    return inst
end


local function fa_minecart()
    local inst= fn("fa_minecart")
    MakeObstaclePhysics(inst, 1)
    inst:RemoveTag("NOCLICK")
    return inst
end

local function orcrefuse()
    local inst= fn("fa_orcrefuse")
    inst.Transform:SetScale(1.5, 1.5, 1.5)
    MakeObstaclePhysics(inst, 0.5)
    inst:RemoveTag("NOCLICK")
    return inst
end


return Prefab( "common/fa_dorf_gold_pillar", fa_pillar_dwarf, fa_pillar_dwarf_assets),
Prefab( "common/fa_dorf_stool", fa_stool, fa_stool_assets),
Prefab( "common/fa_dorf_stool_blown", fa_stool_blown, fa_stool_assets),
Prefab( "common/fa_dorf_table", fa_table, fa_table_assets),
Prefab( "common/fa_minecart", fa_minecart, fa_minecart_assets),
Prefab( "common/fa_orcrefuse", orcrefuse, fa_orcrefuse_assets)