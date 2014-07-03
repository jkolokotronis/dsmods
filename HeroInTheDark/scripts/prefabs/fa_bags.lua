local assets=
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
  Asset("ATLAS", "images/inventoryimages/woodshield.xml"),
  Asset("IMAGE", "images/inventoryimages/woodshield.tex"),
}



local function tagitemtest(item,tags)
    local pass=false
    if(type(tags)=="table")then
        for k,v in pairs(tags) do
            if(item:HasTag(v))then
                pass=true
            end
        end
    else
        pass=item:HasTag(tags)
    end
    return pass
end

local function krampus_sized(inst)

    local slotpos = {}

    for y = 0, 6 do
        table.insert(slotpos, Vector3(-162, -y*75 + 240 ,0))
        table.insert(slotpos, Vector3(-162 +75, -y*75 + 240 ,0))
    end
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_krampusbag_2x8"
    inst.components.container.widgetanimbuild = "ui_krampusbag_2x8"
    --inst.components.container.widgetpos = Vector3(645,-85,0)
    inst.components.container.widgetpos = Vector3(-100,-75,0)
    inst.components.container.side_widget = true    
end


local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
    
    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("krampus_sack.png")

    inst.AnimState:SetBank("backpack1")
    inst.AnimState:SetBuild("swap_krampus_sack")
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.cangoincontainer = false
    inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/krampuspack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages.xml"
    inst.components.inventoryitem.imagename="krampus_sack"

    inst:AddComponent("container")
    
    
--[[
function Container:CollectInventoryActions(doer, actions)
    if doer.components.inventory and self.canbeopened then
        if not (self.side_widget and TheInput:ControllerAttached()) then
            table.insert(actions, ACTIONS.RUMMAGE)
        end
    end
end]]

    return inst
end

local function dorfbag()
    local inst=fn()
    krampus_sized(inst)
    inst.components.container.type = "fa_bag"
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false  
    inst.components.container.widgetpos = Vector3(600,0,0)
    return inst
end

local function scrollcase()
    local inst=fn()
    krampus_sized(inst)

    inst.components.container.widgetpos = Vector3(50,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_scrollcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"book","scroll"}) end
    return inst
end

local function wandcase()
    local inst=fn()
    krampus_sized(inst)
    inst.components.container.widgetpos = Vector3(200,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_wandcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,"wand") end
    return inst
end

local function potioncase()
    local inst=fn()
    krampus_sized(inst)
    inst.components.container.type = "fa_potioncase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,"potion") end
    return inst
end
    
local function foodbag()
    local inst=fn()
    krampus_sized(inst)
    inst.components.container.widgetpos = Vector3(300,0,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_foodbag"
    inst.components.container.itemtestfn = function(cnt, item, slot) return item.components.edible~=nil end
    return inst
end

return Prefab( "common/inventory/fa_dorf_bag", dorfbag, assets),
Prefab( "common/inventory/fa_scrollcase", scrollcase, assets),
Prefab( "common/inventory/fa_wandcase", wandcase, assets),
Prefab( "common/inventory/fa_potioncase", potioncase, assets),
Prefab( "common/inventory/fa_foodbag", foodbag, assets)