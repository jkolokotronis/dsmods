local matchers=require "fa_smelter_matcher"
local assets =
{
    Asset("ANIM", "anim/fa_smeltingfurnace.zip"),
}

local slotpos = {}

for y = 0, 3 do
	table.insert(slotpos, Vector3(-162, -y*75 + 114 ,0))
	table.insert(slotpos, Vector3(-162 +75, -y*75 + 114 ,0))
end

local widgetbuttoninfo = {
	text = "Smelt",
	position = Vector3(-130, -165, 0),
	fn = function(inst)
		inst.components.fa_furnace:StartCooking()	
	end,
	
	validfn = function(inst)
		return inst.components.fa_furnace:CanCook()
	end,
}


local function onhammered(inst, worker)
	if inst.components.fa_furnace.product and inst.components.fa_furnace.done then
		inst.components.lootdropper:AddChanceLoot(inst.components.fa_furnace.product, 1)
	end
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_small").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	
end

local function itemtest(inst, item, slot)
	--to bother or not to bother? should prob add some tag
--	if cooking.IsCookingIngredient(item.prefab) then
		return true
--	end
end

--anim and sound callbacks

local function startcookfn(inst)
	inst.AnimState:PlayAnimation("working", true)
	--play a looping sound
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
	inst.Light:Enable(true)
end


local function onopen(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_open", "open")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot", "snd")
end

local function onclose(inst)
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_close", "close")
end

local function donecookfn(inst)
	inst.AnimState:PlayAnimation("finished",true)
--	inst.AnimState:PushAnimation("idle_far",true)
--	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.fa_furnace.product)
	
	inst.SoundEmitter:KillSound("snd")
	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_finish", "snd")
	inst.Light:Enable(false)
	--play a one-off sound
end

local function continuedonefn(inst)
	inst.AnimState:PlayAnimation("finished",true)
--	inst.AnimState:PlayAnimation("idle_far",true)
--	inst.AnimState:OverrideSymbol("swap_cooked", "cook_pot_food", inst.components.fa_furnace.product)
end

local function continuecookfn(inst)
	inst.AnimState:PlayAnimation("working", true)
	--play a looping sound
	inst.Light:Enable(true)

	inst.SoundEmitter:PlaySound("dontstarve/common/cookingpot_rattle", "snd")
end

local function harvestfn(inst)
	inst.AnimState:PlayAnimation("idle_close",true)
end

local function getstatus(inst)
	if inst.components.fa_furnace.cooking and inst.components.fa_furnace:GetTimeToCook() > 15 then
		return "COOKING_LONG"
	elseif inst.components.fa_furnace.cooking then
		return "COOKING_SHORT"
	elseif inst.components.fa_furnace.done then
		return "DONE"
	else
		return "EMPTY"
	end
end

local function onfar(inst)
	if(not inst.components.fa_furnace.done and not inst.components.fa_furnace.cooking)then
		inst.AnimState:PlayAnimation("idle_far",true)
	end
	inst.components.container:Close()
end
local function onnear(inst)
	if(not inst.components.fa_furnace.done and not inst.components.fa_furnace.cooking)then
		inst.AnimState:PlayAnimation("idle_close",true)
	end
end

local function onbuilt(inst)
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	
    local light = inst.entity:AddLight()
    inst.Light:Enable(false)
	inst.Light:SetRadius(.6)
    inst.Light:SetFalloff(1)
    inst.Light:SetIntensity(.5)
    inst.Light:SetColour(235/255,62/255,12/255)
    --inst.Light:SetColour(1,0,0)
    
    inst:AddTag("structure")
    MakeObstaclePhysics(inst, 2)
    
    inst.AnimState:SetBank("fa_smeltingfurnace")
    inst.AnimState:SetBuild("fa_smeltingfurnace")
    inst.AnimState:PlayAnimation("idle_close",true)
    inst.Transform:SetScale(2.4, 2.4, 2.4)

    inst:AddComponent("fa_furnace")
    inst.components.fa_furnace.onstartcooking = startcookfn
    inst.components.fa_furnace.oncontinuecooking = continuecookfn
    inst.components.fa_furnace.oncontinuedone = continuedonefn
    inst.components.fa_furnace.ondonecooking = donecookfn
    inst.components.fa_furnace.onharvest = harvestfn
    inst.components.fa_furnace.matcher = matchers.SmelterMatcher
    inst.components.fa_furnace.getverb=function() return STRINGS.ACTIONS.FA_FURNACE.SMELT end
    
    
    
    inst:AddComponent("container")
    inst.components.container.itemtestfn = itemtest
    inst.components.container:SetNumSlots(8)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_backpack_2x4"
    inst.components.container.widgetanimbuild =  "ui_backpack_2x4"
    inst.components.container.widgetpos = Vector3(0,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.widgetbuttoninfo = widgetbuttoninfo
    inst.components.container.acceptsstacks = false
    inst.components.container.type = "smelter"

    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose


    inst:AddComponent("inspectable")
--	inst.components.inspectable.getstatus = getstatus


    inst:AddComponent("playerprox")
    inst.components.playerprox:SetDist(3,5)
    inst.components.playerprox:SetOnPlayerFar(onfar)
    inst.components.playerprox:SetOnPlayerNear(onnear)


    inst:AddComponent("lootdropper")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	MakeSnowCovered(inst, .01)    
	inst:ListenForEvent( "onbuilt", onbuilt)
    return inst
end


return Prefab( "common/fa_smeltingfurnace", fn, assets),
MakePlacer( "common/fa_smeltingfurnace_placer", "fa_smeltingfurnace", "fa_smeltingfurnace", "idle_far" )