local blueassets =
{
    Asset("ANIM", "anim/fa_bluerack.zip")
}
local pinkassets =
{
    Asset("ANIM", "anim/fa_pinkrack.zip"),
}
local greenassets =
{
    Asset("ANIM", "anim/fa_greenrack.zip"),
}

local weaponrackassets={
    Asset("ANIM", "anim/fa_weaponrack.zip"),
}

local prefabs =
{
}



local function PuppetOnOpen(inst)
    --this is stupid but so is the fact that inventory cant be accessed as container and all the copy paste between inventory/container 
    local head=inst.components.inventory:Unequip(EQUIPSLOTS.HEAD,nil,true)
    if(head)then
        head.components.inventoryitem:RemoveFromOwner(true)
        inst.components.container:GiveItem(head)
    end
    local body=inst.components.inventory:Unequip(EQUIPSLOTS.BODY,nil,true)
    if(body)then
        body.components.inventoryitem:RemoveFromOwner(true)
        inst.components.container:GiveItem(body)
    end

end 

local function PuppetOnClose(inst) 
    local item=inst.components.container:FindItem(function(item)
            if(item.components.equippable and item.components.equippable.equipslot==EQUIPSLOTS.HEAD)then
                return true
            else
                return false
            end
        end)
    if(item)then
        item.components.inventoryitem.RemoveFromOwner(true)
        inst.components.inventory:Equip(item)
    end
    local item=inst.components.container:FindItem(function(item)
            if(item.components.equippable and item.components.equippable.equipslot==EQUIPSLOTS.BODY)then
                return true
            else
                return false
            end
        end)
    if(item)then
        item.components.inventoryitem.RemoveFromOwner(true)
        inst.components.inventory:Equip(item)
    end
end 

local onloadfn = function(inst, data)
end

local onsavefn = function(inst, data)
end

local function fn(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
    MakeObstaclePhysics(inst, .5)
    
--    inst.OnLoad=onloadfn
--    inst.OnSave=onsavefn


    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( "fa_puppet.tex" )

        anim:SetBank(name)
        anim:SetBuild(name)
        anim:PlayAnimation("idle")
        

    inst:AddComponent("inspectable")

local slotpos = {}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
    end
end

    local function itemtest(inst, item, slot)
        if(item and item.components.equippable)then
            return true
        end
    end
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.onopenfn = PuppetOnOpen
    inst.components.container.onclosefn = PuppetOnClose
    inst.components.container.itemtestfn=itemtest
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,-180,0)
    inst.components.container.widgetpos_controller = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160

    inst:AddComponent("inventory")
    inst.components.inventory.dropondeath = true

    inst:AddComponent("lootdropper")

    return inst
end

local function bluefn()
    local inst=fn("fa_bluerack")
    return inst
end

local function redfn()
    local inst=fn("fa_pinkrack")
    return inst
end

local function greenfn()
    local inst=fn("fa_greenrack")
    return inst
end


local function fnweap()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
    MakeObstaclePhysics(inst, .5)
    
--    inst.OnLoad=onloadfn
--    inst.OnSave=onsavefn


--    local minimap = inst.entity:AddMiniMapEntity()
--    minimap:SetIcon( "fa_puppet.tex" )

        anim:SetBank("fa_weaponrack")
        anim:SetBuild("fa_weaponrack")
        anim:PlayAnimation("idle")
        

    inst:AddComponent("inspectable")

local slotpos = {}

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(slotpos, Vector3(80*x-80*2+80, 80*y-80*2+80,0))
    end
end

    local function itemtest(inst, item, slot)
        if(item and item.components.weapon)then
            return true
        end
    end
    inst:AddComponent("container")
    inst.components.container:SetNumSlots(#slotpos)
    inst.components.container.onopenfn = PuppetOnOpen
    inst.components.container.onclosefn = PuppetOnClose
    inst.components.container.itemtestfn=itemtest
    
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,-180,0)
    inst.components.container.widgetpos_controller = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160


    inst:AddComponent("lootdropper")

    return inst
end

return Prefab( "common/fa_bluerack", bluefn, blueassets, prefabs),
Prefab( "common/fa_pinkrack", redfn, pinkassets, prefabs),
Prefab( "common/fa_greenrack", greenfn, greenassets, prefabs),
Prefab( "common/fa_weaponrack", fnweap, weaponrackassets, prefabs)
