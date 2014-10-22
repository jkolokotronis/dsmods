
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
local fa_absorbredfx_assets={
        Asset( "ANIM", "anim/fa_absorb_red.zip" ),
}
local fa_firebombfx_assets={
        Asset( "ANIM", "anim/firebomb.zip" ),
}
local fa_heal_greenfx_assets={
        Asset( "ANIM", "anim/fa_heal_green_fx.zip" ),
}
local fa_heal_redfx_assets={
        Asset( "ANIM", "anim/fa_heal_red_fx.zip" ),
}
local fa_musicnotesfx_assets={
        Asset( "ANIM", "anim/fa_musicnotes.zip" ),
}
local fa_spinningstarsfx_assets={
        Asset( "ANIM", "anim/fa_spinningstars.zip" ),
}
local fa_birdsfx_assets={
        Asset( "ANIM", "anim/fa_birds_fx.zip" ),
}
local fa_firestormhit_assets =
{
    Asset("ANIM", "anim/fa_firestorm_hit_fx.zip"),
}
local fa_firestormringfx_assets =
{
    Asset("ANIM", "anim/fa_firestorm_ring_fx.zip"),
}
local fa_fireball_hit_assets={
    Asset("ANIM", "anim/fireball_hit.zip"),
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

local function firebombfx()
    return fn("firebomb","firebomb","idle",true)
end

local function absorbredfx()
    return fn("fa_absorb_red","fa_absorb_red","idle",false)
end

local function heal_greenfx()
    local inst= fn("fa_heal_green_fx","fa_heal_green_fx","idle",false)
    inst.Transform:SetScale(2,2,2)
    return inst
end

local function heal_redfx()
    local inst= fn("fa_heal_red_fx","fa_heal_red_fx","idle",false)
    inst.Transform:SetScale(2,2,2)
    return inst
end

local function fa_musicnotesfx()
    local inst= fn("fa_musicnotes","fa_musicnotes","idle",true)
    inst.Transform:SetScale(0.5,0.5,0.5)
    return inst
end
local function fa_spinningstarsfx()
    local inst= fn("fa_spinningstars","fa_spinningstars","idle",true)
    inst.Transform:SetScale(0.5,0.5,0.5)
    return inst
end
local function fa_birdsfx()
    local inst= fn("fa_birds_fx","fa_birds_fx","idle",true)
    inst.Transform:SetScale(0.5,0.5,0.5)
    return inst
end
local function fa_firestormfx()
    local inst= fn("fa_firestorm_ring_fx","fa_firestorm_ring_fx","idle",false)
    inst.AnimState:SetFinalOffset(-1)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.OnGround )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    return inst
end
local function fa_firestormhitfx()
    local inst= fn("fa_firestorm_hit_fx","fa_firestorm_hit_fx","idle",false)
    inst.AnimState:SetFinalOffset(-1)

    inst.AnimState:SetOrientation( ANIM_ORIENTATION.Default )
    inst.AnimState:SetLayer( LAYER_BACKGROUND )
    inst.AnimState:SetSortOrder( 3 )

    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    
    return inst
end
local function fa_fireball_hit()
    local inst= fn("fireball_hit")
    return inst

end

return Prefab( "common/fa_bladebarrier_hitfx", bladebarrier_hit_fx, bladebarrier_hit_fx_assets),
Prefab( "common/fa_bladebarrierfx", bladebarrier_fx, bladebarrier_fx_assets),
Prefab( "common/fa_blooddownfx", blood_downfx, fa_blooddownfx_assets),
Prefab( "common/fa_blooddropfx", blood_dropfx, blood_dropfx_assets),
Prefab( "common/fa_bloodsplashfx", blood_splashfx, blood_splashfx_assets),
Prefab( "common/fa_poisonfx", poisonfx, poisonfx_assets),
Prefab( "common/fa_absorbredfx", absorbredfx, fa_absorbredfx_assets),
Prefab( "common/fa_firebombfx", firebombfx, fa_firebombfx_assets),
Prefab( "common/fa_heal_greenfx", heal_greenfx, fa_heal_greenfx_assets),
Prefab( "common/fa_heal_redfx", heal_redfx, fa_heal_redfx_assets),
Prefab( "common/fa_musicnotesfx", fa_musicnotesfx, fa_musicnotesfx_assets),
Prefab( "common/fa_spinningstarsfx", fa_spinningstarsfx, fa_spinningstarsfx_assets),
Prefab( "common/fa_birdsfx", fa_birdsfx, fa_birdsfx_assets),
--this is... questionable... i'd rather use something else
Prefab( "common/fa_firestormfx", fa_firestormfx, fa_firestormringfx_assets),
Prefab( "common/fa_firestormhitfx", fa_firestormhitfx, fa_firestormhit_assets),
Prefab( "common/fa_fireball_hit",fa_fireball_hit,fa_fireball_hit_assets)
