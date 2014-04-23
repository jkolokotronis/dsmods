local assets =
{
    Asset("ANIM", "anim/nightmare_crack_white_fx.zip"),
    Asset("ANIM", "anim/nightmare_crack_red_fx.zip"),    
}


local function crackfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    anim:SetBank("nightmare_crack_white_fx")
    anim:SetBuild("nightmare_crack_white_fx")
    anim:PlayAnimation("idle_closed", false)

    inst.persists = false

    return inst
end

local function upper_crackfn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()

    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
--    inst:AddComponent("colourtweener")
    anim:SetBank("nightmare_crack_red_fx")
    anim:SetBuild("nightmare_crack_red_fx")
    anim:PlayAnimation("idle_closed", false)
--    anim:PlayAnimation("idle_open")

    inst.persists = false

    return inst
end

return 
Prefab("common/nightmare_crack_white_fx", crackfn, assets),
Prefab("common/nightmare_crack_red_fx", upper_crackfn, assets)