
local bladebarrier_hit_fx_assets={
    Asset( "ANIM", "anim/flash_b.zip" ),
}
local bladebarrier_fx_assets={
     Asset( "ANIM", "anim/betterbarrier.zip" ),
}
local fa_blooddownfx_assets={
        Asset( "ANIM", "anim/blood_down.zip" ),
}
local blood_dropfx_assets={
        Asset( "ANIM", "anim/blood_drop.zip" ),    
}
local blood_splashfx_assets={
        Asset( "ANIM", "anim/blood_splash.zip" ),    
}
local poisonfx_assets={
    Asset( "ANIM", "anim/fa_poison.zip" ),
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
	return fn("flash_b")
end

local function bladebarrier_fx()
	return fn("betterbarrier","betterbarrier","idle",true)
end

local function blood_downfx()
	return fn("blood_down","blood_down","idle",false)
end

local function blood_dropfx()
	return fn("blood_drop","blood_drop","idle",true)
end

local function blood_splashfx()
	return fn("blood_splash")
end

local function poisonfx()
	return fn("fa_poison")
end

return Prefab( "common/fa_bladebarrier_hitfx", bladebarrier_hit_fx, bladebarrier_hit_fx_assets),
Prefab( "common/fa_bladebarrierfx", bladebarrier_fx, bladebarrier_fx_assets),
Prefab( "common/fa_blooddownfx", blood_downfx, fa_blooddownfx_assets),
Prefab( "common/fa_blooddropfx", blood_dropfx, blood_dropfx_assets),
Prefab( "common/fa_bloodsplashfx", blood_splashfx, blood_splashfx_assets),
Prefab( "common/fa_poisonfx", poisonfx, poisonfx_assets)
