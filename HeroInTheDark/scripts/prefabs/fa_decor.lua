
local fa_pillar_dwarf_assets={
    Asset( "ANIM", "anim/fa_pillar_dwarf.zip" ),
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
--    inst.Transform:SetScale(0.8,0.8,0.8)
    return inst
end

return Prefab( "common/fa_dorf_gold_pillar", fa_pillar_dwarf, fa_pillar_dwarf_assets)