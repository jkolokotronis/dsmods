local assets = {
        Asset( "ANIM", "anim/betterbarrier.zip" ),
        Asset( "ANIM", "anim/flash_b.zip" ),

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
    inst:AddTag("FX")

    inst.fa_rotate=function(dest)
    	anim:SetOrientation( ANIM_ORIENTATION.OnGround )
    	local angle = inst:GetAngleToPoint(dest:GetPosition())
    	inst.Transform:SetRotation(angle)
	end
	
    return inst
end

local function bladebarrier_hit_fx()
	local inst=fn("flash_b")
	return inst
end

local function bladebarrier_fx()
	local inst=fn("betterbarrier","betterbarrier","idle",true)
	return inst
end

return Prefab( "common/fa_bladebarrier_hitfx", bladebarrier_hit_fx, assets),
Prefab( "common/fa_bladebarrierfx", bladebarrier_fx, assets)