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
    if(inst.trapped)then
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local particle = SpawnPrefab("poopcloud")
        particle.Transform:SetPosition( pt.x, pt.y, pt.z )

        local prefabname="fa_animatedarmor_"..inst.rack_type
        local spider = SpawnPrefab(prefabname)
        spider.Transform:SetPosition( pt.x, pt.y, pt.z )
        --container.onopenfn call doesn't have opener ref, nothing i can do
        local player = GetPlayer()
        if(spider.components.combat)then
            spider.components.combat:SuggestTarget(player)
        end
--      should i kill myself?
        inst.trapped=false
--        inst:Remove()
    else
--       for k,v in pairs(inst.components.inventory.equipslots) do
        if(inst.components.inventory.equipslots[EQUIPSLOTS.HEAD])then
            local i=inst.components.inventory:Unequip(EQUIPSLOTS.HEAD)
            if(i~=nil and FA_SWACCESS)then
                inst.components.container:GiveItem(i)
            end
        end
        if(inst.components.inventory.equipslots[EQUIPSLOTS.BODY])then
            local i=inst.components.inventory:Unequip(EQUIPSLOTS.BODY)
            if(i~=nil and FA_SWACCESS)then
                inst.components.container:GiveItem(i)
            end
        end
        inst.AnimState:ClearOverrideSymbol("swap_hat")
        inst.AnimState:ClearOverrideSymbol("swap_body")
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
--  for some moronic reason the order is reverted in sw
--        item.components.inventoryitem:RemoveFromOwner(true)

        if item.components.inventoryitem.owner.components.inventory then
            item.components.inventoryitem.owner.components.inventory:RemoveItem(item, true)
        end
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
        if item.components.inventoryitem.owner.components.inventory then
            item.components.inventoryitem.owner.components.inventory:RemoveItem(item, true)
        end
        inst.components.inventory:Equip(item)
    end
end 

--in truth rack_type is just init value but id rather have it here than make 50 more scenarios 
local onload = function(inst, data)
    if(data)then
        inst.rack_type =   data.rack_type 
        inst.trapped = data.trapped 
    end
end

local onsave = function(inst, data)
    data.rack_type = inst.rack_type
    inst.trapped = data.trapped 
end


local loadpostpass=function(inst,data)
    if(inst.components.container.onclosefn)then
        inst.components.container.onclosefn(inst)
    end
end

local function fn(name)
    local inst = CreateEntity()
    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
    MakeObstaclePhysics(inst, .5)
    
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
    inst.OnSave = onsave
    inst.OnLoad = onload

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

local function WeaponOnOpen(inst)
    if(inst.trapped)then
        local pt = Vector3(inst.Transform:GetWorldPosition())
        local particle = SpawnPrefab("poopcloud")
        particle.Transform:SetPosition( pt.x, pt.y, pt.z )

        local prefabname="fa_animatedarmor_"..inst.rack_type
        local spider = SpawnPrefab(prefabname)
        spider.Transform:SetPosition( pt.x, pt.y, pt.z )
        --container.onopenfn call doesn't have opener ref, nothing i can do
        local player = GetPlayer()
        if(spider.components.combat)then
            spider.components.combat:SuggestTarget(player)
        end
--      should i kill myself?
        inst.trapped=false
    end
--        inst.AnimState:ClearOverrideSymbol("swap_hat")
end 

local function WeaponOnClose(inst) 
    print("triggered onclose")
    local toprow=inst.components.container:FindItems(function(item)
            if(item:HasTag("dagger") or item:HasTag("sword"))then
                return true
            else
                return false
            end
        end)
    for i=1,math.min(#toprow,4) do 
        inst.AnimState:OverrideSymbol("sword"..i,toprow[i].prefab,"swap_weapon")
    end
    for i= #toprow+1,4 do
        inst.AnimState:ClearOverrideSymbol("sword"..i)
    end
    local bottomrow=inst.components.container:FindItems(function(item)
            if(item:HasTag("axe"))then
                return true
            else
                return false
            end
        end)

    for i=1,math.min(#bottomrow,3) do 
        inst.AnimState:OverrideSymbol("axe"..i,bottomrow[i].prefab,"swap_weapon")
    end
    for i= #bottomrow+1,3 do
        inst.AnimState:ClearOverrideSymbol("axe"..i)
    end

end 

local function fnweap()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    local anim=inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddDynamicShadow()
    inst.DynamicShadow:SetSize( 2, 1.5 )
    MakeObstaclePhysics(inst, .5)    
    inst.Transform:SetScale(0.5, 0.5, 0.5)

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
    inst.components.container.onopenfn = WeaponOnOpen
    inst.components.container.onclosefn = WeaponOnClose
    inst.components.container.itemtestfn=itemtest
    
    inst.components.container.widgetslotpos = slotpos
    inst.components.container.widgetanimbank = "ui_chest_3x3"
    inst.components.container.widgetanimbuild = "ui_chest_3x3"
    inst.components.container.widgetpos = Vector3(0,-180,0)
    inst.components.container.widgetpos_controller = Vector3(0,200,0)
    inst.components.container.side_align_tip = 160

    inst:AddComponent("lootdropper")
    inst.OnSave = onsave
    inst.OnLoad = onload
    inst.LoadPostPass=loadpostpass

    return inst
end

return Prefab( "common/fa_bluerack", bluefn, blueassets, prefabs),
Prefab( "common/fa_pinkrack", redfn, pinkassets, prefabs),
Prefab( "common/fa_greenrack", greenfn, greenassets, prefabs),
Prefab( "common/fa_weaponrack", fnweap, weaponrackassets, prefabs)
