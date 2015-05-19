-- changing the original ones would likely cause collisions eventually
-- don't really need to change anything in originals, just add on top under different name, basically
-- all default assets are always preloaded anyway, when/if we turn to custom ones splits may make sense for lazy loading, this is unnecesary anyway
local assets=
{
	Asset("ANIM", "anim/treasure_chest.zip"),
	Asset("ANIM", "anim/ui_chest_3x2.zip"),
	Asset("ANIM", "anim/pandoras_chest.zip"),
	Asset("ANIM", "anim/skull_chest.zip"),
	Asset("ANIM", "anim/pandoras_chest_large.zip"),
	Asset("ANIM", "anim/fa_ui_chest_5x4.zip"),
}

local prefabs =
{
	"collapse_small",
}

local function common(origprefab,locklevel)
    local inst = Prefabs[origprefab].fn()

    inst:AddComponent("lock")
    inst.components.lock.islocked=true
    inst.components.container.canbeopened=false
    inst.components.lock.locktype="chest"
    inst.components.lock.locklevel=locklevel

    inst.components.lock.onunlocked=function(inst, key, doer)
    	inst.components.container.canbeopened=true
    	inst.components.lock.isstuck=true
	end

	if(locklevel)then
		inst.components.lock.locktype=inst.components.lock.locktype.."_t"..locklevel
	end
	--this is stupid - getadjective will show whatever is first in undefined ordering. the other option is getdisplayname 
	inst.displaynamefn=function(object)
		if(object.components.lock.islocked)then return "Locked "..object.name
		else return object.name
		end
	end

	inst:RemoveComponent("burnable")

    --post pass doesnt trigger right after worldgen for some reason, and entity load triggers too early, and why doesn't container save canbeopened field...
    inst:DoTaskInTime(0,function()
    	if(not inst.components.lock.islocked and inst.components.container)then
    		inst.components.container.canbeopened=true
    	else
    		inst.components.container.canbeopened=false
    		inst:RemoveComponent("workable")
    	end
    end)


		inst.OnSave = nil 
        inst.OnLoad = nil

    return inst
end

local slotpos = {}

for y = 3, 0, -1 do
	for x = -1, 3 do
		table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+40,0))
	end
end

local function fa_treasurechest()
	return common("treasurechest",1)
end

local function fa_pandoraschest()
	local inst= common("pandoraschest",3)
		inst.components.container:SetNumSlots(#slotpos)
		inst.components.container.widgetslotpos = slotpos
		inst.components.container.widgetanimbank = "fa_ui_chest_5x4"
		inst.components.container.widgetanimbuild = "fa_ui_chest_5x4"
		inst.components.container.widgetpos = Vector3(0,200,0)
		inst.components.container.side_align_tip = 160
		return inst
end

local function fa_skullchest()
	return common("skullchest",2)
end

local function fa_minotaurchest()
	local inst=common("minotaurchest",4)
			inst.components.container:SetNumSlots(#slotpos)
		inst.components.container.widgetslotpos = slotpos
		inst.components.container.widgetanimbank = "fa_ui_chest_5x4"
		inst.components.container.widgetanimbuild = "fa_ui_chest_5x4"
		inst.components.container.widgetpos = Vector3(0,200,0)
		inst.components.container.side_align_tip = 160
		return inst
end

local function fa_mine_skullchest()

	local inst =Prefabs["skullchest"].fn()
	inst:RemoveComponent("burnable")
		inst.OnSave = nil 
        inst.OnLoad = nil
	return inst
end

return Prefab( "common/fa_treasurechest", fa_treasurechest, assets, prefabs),
		Prefab( "common/fa_pandoraschest", fa_pandoraschest, assets, prefabs),
		Prefab( "common/fa_skullchest", fa_skullchest, assets, prefabs),
		Prefab("common/fa_minotaurchest", fa_minotaurchest, assets, prefabs),
		Prefab("common/fa_mine_skullchest",fa_mine_skullchest,assets,prefabs)