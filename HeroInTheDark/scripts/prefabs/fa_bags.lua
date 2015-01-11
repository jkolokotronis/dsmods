local assets=
{
	Asset("ANIM", "anim/backpack.zip"),
	Asset("ANIM", "anim/swap_krampus_sack.zip"),
    Asset("ANIM", "anim/fa_scroll_case.zip"),
    Asset("ANIM", "anim/fa_wand_case.zip"),
    Asset("ANIM", "anim/ui_chest_3x2.zip"),
    Asset("ANIM", "anim/ui_chester_shadow_3x4.zip"),
}

local bagassets={
    Asset("ANIM", "anim/fa_bag.zip"),
    
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

local function f3x2(inst)

local slotpos = {}

for y = 1, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-40,0))
    end
end

    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x2"
    inst.components.container.widgetanimbuild = "ui_chest_3x2"
    --inst.components.container.widgetpos = Vector3(645,-85,0)
    inst.components.container.widgetpos = Vector3(-100,-75,0)
    inst.components.container.side_widget = true    

end

local function f1x4(inst)

    local slotpos = {   Vector3(0,64+32+8+4,0), 
                    Vector3(0,32+4,0),
                    Vector3(0,-(32+4),0), 
                    Vector3(0,-(64+32+8+4),0)}

    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_cookpot_1x4"
    inst.components.container.widgetanimbuild = "ui_cookpot_1x4"
    --inst.components.container.widgetpos = Vector3(645,-85,0)
    inst.components.container.widgetpos = Vector3(-100,-75,0)
    inst.components.container.side_widget = true    

end

local function f3x4(inst)

local slotpos_3x4 = {}

for y = 2.5, -0.5, -1 do
    for x = 0, 2 do
        table.insert(slotpos_3x4, Vector3(75*x-75*2+75, 75*y-75*2+75,0))
    end
end

    inst.components.container:SetNumSlots(#slotpos_3x4)
    inst.components.container.widgetslotpos = slotpos_3x4
    inst.components.container.widgetanimbank = "ui_chester_shadow_3x4"
    inst.components.container.widgetanimbuild = "ui_chester_shadow_3x4"
    inst.components.container.widgetpos = Vector3(0,220,0)
--    inst.components.container.widgetpos_controller = Vector3(0,220,0)
    inst.components.container.side_align_tip = 160  

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
    inst.components.container.widgetpos = Vector3(450,50,0)
    return inst
end
local function tinydorfbag()
    local inst=fn()
    f1x4(inst)
    inst.components.container.type = "fa_bag"
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false  
    inst.components.container.widgetpos = Vector3(450,50,0)
    inst.AnimState:SetBank("fa_bag")
    inst.AnimState:SetBuild("fa_bag")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_bag"
    return inst
end
local function smalldorfbag()
    local inst=fn()
    f3x2(inst)
    inst.components.container.type = "fa_bag"
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false  
    inst.components.container.widgetpos = Vector3(450,50,0)
    inst.AnimState:SetBank("fa_bag")
    inst.AnimState:SetBuild("fa_bag")
    inst.AnimState:PlayAnimation("idle")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_bag"
    return inst
end

local function scrollcase()
    local inst=fn()
    krampus_sized(inst)

    inst.components.container.widgetpos = Vector3(0,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_scrollcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"book","scroll"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_scroll_case"
    inst.AnimState:SetBank("fa_scroll_case")
    inst.AnimState:SetBuild("fa_scroll_case")
    inst.AnimState:PlayAnimation("idle")
    return inst
end

local function wandcase()
    local inst=fn()
    krampus_sized(inst)
    inst.components.container.widgetpos = Vector3(150,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_wandcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"wand","staff"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_wand_case"
    inst.AnimState:SetBank("icepack")
    inst.AnimState:SetBuild("fa_wand_case")
    inst.AnimState:PlayAnimation("anim")
    return inst
end

local function tinyscrollcase()
    local inst=fn()
    f3x2(inst)

    inst.components.container.widgetpos = Vector3(0,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_scrollcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"book","scroll"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_scroll_case"
    inst.AnimState:SetBank("fa_scroll_case")
    inst.AnimState:SetBuild("fa_scroll_case")
    inst.AnimState:PlayAnimation("idle")
    return inst
end

local function tinywandcase()
    local inst=fn()
    f3x2(inst)
    inst.components.container.widgetpos = Vector3(150,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_wandcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"wand","staff"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_wand_case"
    inst.AnimState:SetBank("icepack")
    inst.AnimState:SetBuild("fa_wand_case")
    inst.AnimState:PlayAnimation("anim")
    return inst
end

local function smallscrollcase()
    local inst=fn()
    f3x4(inst)

    inst.components.container.widgetpos = Vector3(0,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_scrollcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"book","scroll"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_scroll_case"
    inst.AnimState:SetBank("fa_scroll_case")
    inst.AnimState:SetBuild("fa_scroll_case")
    inst.AnimState:PlayAnimation("idle")
    return inst
end

local function smallwandcase()
    local inst=fn()
    f3x4(inst)
    inst.components.container.widgetpos = Vector3(150,50,0)
    inst.components.container.side_align_tip = 100
    inst.components.container.side_widget = false    
    inst.components.container.type = "fa_wandcase"
    inst.components.container.itemtestfn = function(cnt, item, slot) return tagitemtest(item,{"wand","staff"}) end
    inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename="fa_wand_case"
    inst.AnimState:SetBank("icepack")
    inst.AnimState:SetBuild("fa_wand_case")
    inst.AnimState:PlayAnimation("anim")
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
 Prefab( "common/inventory/fa_tinydorfbag", tinydorfbag, bagassets),
  Prefab( "common/inventory/fa_smalldorfbag", smalldorfbag, bagassets),
Prefab( "common/inventory/fa_scrollcase", scrollcase, assets),
Prefab( "common/inventory/fa_wandcase", wandcase, assets),
Prefab( "common/inventory/fa_tinyscrollcase", tinyscrollcase, assets),
Prefab( "common/inventory/fa_tinywandcase", tinywandcase, assets),
Prefab( "common/inventory/fa_smallscrollcase", smallscrollcase, assets),
Prefab( "common/inventory/fa_smallwandcase", smallwandcase, assets),
Prefab( "common/inventory/fa_potioncase", potioncase, assets),
Prefab( "common/inventory/fa_foodbag", foodbag, assets)