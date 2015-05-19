local assets=
{
	Asset("ANIM", "anim/fa_sand.zip"),
}
local ghoultoe_assets=
{
	Asset("ANIM", "anim/fa_ghoultoe.zip"),
}
local mummysand_assets=
{
	Asset("ANIM", "anim/fa_mummysand.zip"),
}
local puremanure_assets=
{
	Asset("ANIM", "anim/fa_puremanure.zip"),
}
local vampirefangs_assets=
{
	Asset("ANIM", "anim/fa_vampirefangs.zip"),
}
local zombietoe_assets=
{
	Asset("ANIM", "anim/fa_zombietoe.zip"),
}
local batdevilheart_assets=
{
	Asset("ANIM", "anim/fa_batdevilheart.zip"),
}
local hellhoundribs_assets=
{
	Asset("ANIM", "anim/fa_hellhoundribs.zip"),
}
local hellwormliver_assets=
{
	Asset("ANIM", "anim/fa_hellwormliver.zip"),
}
local wortoxheart_assets=
{
	Asset("ANIM", "anim/fa_wortoxheart.zip"),
}
local silkroll_assets=
{
    Asset("ANIM", "anim/fa_silkroll.zip"),
}
local unicorn_assets=
{
    Asset("ANIM", "anim/fa_unicornhorn.zip"),
}
local goldenlocks_assets=
{
    Asset("ANIM", "anim/fa_goldenlocks.zip"),
}
local satyrhorn_assets=
{
    Asset("ANIM", "anim/fa_satyrhorn.zip"),
}




local function fn(bank,build,anim)

	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    inst.AnimState:SetBank(bank)
    inst.AnimState:SetBuild(build or bank)
    inst.AnimState:PlayAnimation(anim or "idle")
    inst:AddComponent("inspectable")
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename=bank
    inst.components.inventoryitem.atlasname="images/inventoryimages/fa_inventoryimages.xml"

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    return inst
end

local function BlowAway(inst)
    inst.blowawaytask = nil
    inst.persists = false
    inst:RemoveComponent("inventoryitem")
    inst:RemoveComponent("inspectable")
	inst.SoundEmitter:PlaySound("dontstarve/common/dust_blowaway")
	inst.AnimState:PlayAnimation("disappear")
	inst:ListenForEvent("animover", function() inst:Remove() end)
end

local function StopBlowAway(inst)
	if inst.blowawaytask then
		inst.blowawaytask:Cancel()
		inst.blowawaytask = nil
	end
end
		
local function PrepareBlowAway(inst)
	StopBlowAway(inst)
	inst.blowawaytask = inst:DoTaskInTime(25+math.random()*10, BlowAway)
end


local function sand()
    local inst=fn("fa_sand")
    inst.components.inventoryitem:SetOnPutInInventoryFn(StopBlowAway)
	inst:ListenForEvent("ondropped",  PrepareBlowAway)
	PrepareBlowAway(inst)
    return inst
end
local function ghoultoe()
    local inst=fn("fa_ghoultoe")
    return inst
end
local function mummysand()
    local inst=fn("fa_mummysand")
    return inst
end
local function puremanure()
    local inst=fn("fa_puremanure")
    return inst
end
local function vampirefangs()
    local inst=fn("fa_vampirefangs")
    return inst
end
local function zombietoe()
    local inst=fn("fa_zombietoe")
    return inst
end
local function batdevilheart()
    local inst=fn("fa_batdevilheart")
    return inst
end
local function fa_hellhoundribs()
    local inst=fn("fa_hellhoundribs")
    return inst
end
local function fa_hellwormliver()
    local inst=fn("fa_hellwormliver")
    return inst
end
local function fa_wortoxheart()
    local inst=fn("fa_wortoxheart")
    return inst
end
local function fa_silkroll()
    local inst=fn("fa_silkroll")
    return inst
end
local function fa_unicornhorn()
    local inst=fn("fa_unicornhorn")
    return inst
end
local function fa_goldenlocks()
    local inst=fn("fa_goldenlocks")
    return inst
end
local function fa_satyrhorn()
    local inst=fn("fa_satyrhorn")
    return inst
end

return Prefab( "common/inventory/fa_sand", sand, assets),
Prefab( "common/inventory/fa_ghoultoe", ghoultoe, ghoultoe_assets),
Prefab( "common/inventory/fa_mummysand", mummysand, mummysand_assets),
Prefab( "common/inventory/fa_puremanure", puremanure, puremanure_assets),
Prefab( "common/inventory/fa_vampirefangs", vampirefangs, vampirefangs_assets),
Prefab( "common/inventory/fa_zombietoe", zombietoe, zombietoe_assets),
Prefab( "common/inventory/fa_batdevilheart", batdevilheart, batdevilheart_assets),
Prefab( "common/inventory/fa_hellhoundribs", fa_hellhoundribs, hellhoundribs_assets),
Prefab( "common/inventory/fa_hellwormliver", fa_hellwormliver, hellwormliver_assets),
Prefab( "common/inventory/fa_wortoxheart", fa_wortoxheart, wortoxheart_assets),
Prefab( "common/inventory/fa_silkroll", fa_silkroll, silkroll_assets),
Prefab( "common/inventory/fa_unicornhorn", fa_unicornhorn, unicorn_assets),
Prefab( "common/inventory/fa_goldenlocks", fa_goldenlocks, goldenlocks_assets),
Prefab( "common/inventory/fa_satyrhorn", fa_satyrhorn, satyrhorn_assets)


