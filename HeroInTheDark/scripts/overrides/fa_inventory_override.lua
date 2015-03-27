require "constants"
require "fa_constants"
local Inventory=require "components/inventory"


    EQUIPSLOTS.RING = "ring"
    EQUIPSLOTS.BOOT = "boot"
    EQUIPSLOTS.QUIVER = "quiver"
    EQUIPSLOTS.PACK = "pack"
    EQUIPSLOTS.NECK = "neck"
--does not have to correspond to numequipslots, tho I find it hard to think of a case where the compatibility would even matter
local NUMEQUIPSORTED=8

Inventory.OrderedEquips={
[EQUIPSLOTS.HANDS] =1, 
[EQUIPSLOTS.BODY]=2, 
[EQUIPSLOTS.HEAD]=3,
[EQUIPSLOTS.PACK]=4,
[EQUIPSLOTS.BOOT]=5,
[EQUIPSLOTS.NECK]=6,
[EQUIPSLOTS.RING]=7,
[EQUIPSLOTS.QUIVER]=8
}

local function inventorypostinit(component,inst)
    inst.components.inventory.numequipslots = 8
    if(inst:HasTag("player"))then
        inst.components.inventory.ignorescangoincontainer=true
    end
end
FA_ModUtil.AddComponentPostInit("inventory", inventorypostinit)

--make extra equip checks BEFORE thing is being equipped to prevent all forms of race conditi9ons


local inventory_equip=Inventory.Equip

function Inventory:Equip(item, old_to_active)

    if not item or not item.components.equippable or not item:IsValid() then
        return
    end
    local old = self.equipslots[item.components.equippable.equipslot]
    if (item.components.equippable.fa_canequip and not item.components.equippable.fa_canequip(self.inst) or (old and old:HasTag("cursed"))) then
        if(not old_to_active)then
            self:GiveItem(item)
        end
    else
        return inventory_equip(self,item,old_to_active)
    end
end

local inventory_unequip=Inventory.Unequip
function Inventory:Unequip(equipslot, slip,force)
    local item = self.equipslots[equipslot]
    if((not force) and item and item:HasTag("cursed"))then
        print("cant unequip cursed item!")  
    else
        return inventory_unequip(self,equipslot,slip)
    end
end

--should this thing be additive??
function Inventory:GetDodgeChance()
    local dodge=0
    for k,v in pairs(self.equipslots) do
        if v.components.armor and v.components.armor.fa_dodgechance then
            dodge=dodge+ v.components.armor.fa_dodgechance
        end
    end
    return dodge
end

function Inventory:GetStunResistance()
    local stunresistance=0
    for k,v in pairs(self.equipslots) do
        if v.components.armor and v.components.armor.fa_stunresistance then
            stunresistance=stunresistance+ v.components.armor.fa_stunresistance
        end
    end
    return stunresistance
end

function Inventory:RollSpellReflect()
    --just run through each one and do separate rolls, otherwise how the heck would I could which one to damage?
    local reflected=false
    for k,v in pairs(self.equipslots) do
        if v.components.armor and v.components.armor.fa_spellreflect then
            if(math.random()<v.components.armor.fa_spellreflect)then
                v.components.armor:SetCondition(v.components.armor.condition - v.components.armor.fa_spellreflectdrain)
                reflected=true
                break
            end
        end
    end
    return reflected
end

local inventory_applydamage_def=Inventory.ApplyDamage
function Inventory:ApplyDamage(damage, attacker, weapon,type)
--check resistance
    for k,v in pairs(self.equipslots) do
        if v.components.resistance and v.components.resistance:HasResistance(attacker, weapon) then
            return 0
        end
    end
    --check specialised armor
    for k,v in pairs(self.equipslots) do
        if v.components.armor and v.components.armor.tags then
            damage = v.components.armor:TakeDamage(damage, attacker, weapon,type)
            if damage == 0 then
                return 0
            end
        end
    end
    --check general armor
    -- to enforce order I can't use a table indexed by strings
    local postpass={}
    for k,v in pairs(self.equipslots) do
        if v.components.armor then
            local index=self.OrderedEquips[k]
            if(index)then
                postpass[index]=v
            else
                --for speed reasons, the equips that are added by other mods fire first - that can be fixed by either running after me and fixing OrderedEquips 
                --or warning me of their existence. RPGHUD is included as is
                damage = v.components.armor:TakeDamage(damage, attacker, weapon,type)
                if damage == 0 then
                    return 0
                end
            end
        end
    end
    for i=1,NUMEQUIPSORTED do
    --sparse table
        if(postpass[i])then
            damage = postpass[i].components.armor:TakeDamage(damage, attacker, weapon,type)
            if damage == 0 then
                return 0
            end
        end
    end
    
    return damage
end


--why the hell do you have ignoregoincontainer when you're not even using it... 
--need to prevent autodropping of containers
function Inventory:SetActiveItem(item)
    if item and (item.components.inventoryitem.cangoincontainer or self.ignorescangoincontainer) or item == nil then
        self.activeitem = item
        self.inst:PushEvent("newactiveitem", {item=item})

        if item and item.components.inventoryitem and item.components.inventoryitem.onactiveitemfn then
            item.components.inventoryitem.onactiveitemfn(item, self.inst)
        end
    else
        self:DropItem(item, true, true)
    end
end

local inventory_finditem_def=Inventory.FindItem
function Inventory:FindItem(fn)
    local found=inventory_finditem_def(self,fn)
    --do base stuff first
    if(not found)then
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                found=v.components.container:FindItem(fn)
                if(found)then
                    break
                end
            end
        end
    end
    return found
end
--not sure if this can cause some issues, if fn returns true on both container and an item inside and then.... do i want to care?

local inventory_finditems_def=Inventory.FindItems
function Inventory:FindItems(fn)
    local items = inventory_finditems_def(self,fn)
    for k,v in pairs(self.itemslots) do
        if(v.components.container)then
            local overflow_items = v.components.container:FindItems(fn)
            --mergemaps or something should work but I'm lazy
            if #overflow_items > 0 then
                for k1,v1 in pairs(overflow_items) do
                    table.insert(items, v1)
                end
            end
        end
    end
    return items
end
--actual overflow - TODO do proper recursion but meh bags shouldnt fit in bags, no matter what friendly RPGHUD tells you
local inventory_getnextavailable_def=Inventory.GetNextAvailableSlot
function Inventory:GetNextAvailableSlot(item)
    --find if it can be stacked first - side effect is being used before the main container, which is likely way slower
    --is there a reason we dont want it to stack into closed backpacks?
    local empty=nil
    local cont=nil
    if(item and item.components.stackable)then
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                for k1,v1 in pairs(v.components.container.slots) do
                    if v1.prefab == item.prefab and v1.components.stackable and not v1.components.stackable:IsFull() then
                        return k1, v
                    end
                end
            end
        end
    end
    empty,cont=inventory_getnextavailable_def(self,item)
    if(not empty)then
        --now find an empty slot in one of the bags
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                for i=1,v.components.container.numslots do
                    if(v.components.container:CanTakeItemInSlot(item,i) and not v.components.container.slots[i])then
                        print("found empty at ",i,v.prefab)
                        return i,v
                    end
                end
            end
        end
    end
    return empty,cont
end
local inventory_removeitem_def=Inventory.RemoveItem
--if decrementing dtack original works, if item is in inventory or backpack original works
--if neither are true, overflow code should crash or return null since there is no such item. 
--sadly it will just return original item with no indication of failure of either inv:remove or container:remove 
function Inventory:RemoveItem(item, wholestack)

    local dec_stack = not wholestack and item and item.components.stackable and item.components.stackable:IsStack() and item.components.stackable:StackSize() > 1
    
    local prevslot = item.components.inventoryitem and item.components.inventoryitem:GetSlotNum() or nil

    if dec_stack then
        local dec = item.components.stackable:Get()
        dec.prevslot = prevslot
        return dec
    else
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                for k1,v1 in pairs(v.components.container.slots) do
                    if(v1==item)then
                        local item = v.components.container:RemoveItem(item, wholestack)
                        item.prevslot = prevslot
                        item.prevcontainer = v.components.container
                        return item
                    end
                end
            end
        end
    return inventory_removeitem_def(self,item, wholestack)
    end
end

local inventory_has_def=Inventory.Has
function Inventory:Has(item, amount)
    local test, num_found=inventory_has_def(self,item,amount)
    for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                local overflow_enough, overflow_found = v.components.container:Has(item, amount)
                num_found = num_found + overflow_found
            end       
    end
    return num_found >= amount, num_found
end


--inline functions are so amazing when you try to overload behavior... who would have thought
local inventory_consumebyname_def=Inventory.ConsumeByName
function Inventory:ConsumeByName(item, amount)
    
    local total_num_found = 0
    
    local function tryconsume(v)
        local num_found = 0
        if v and v.prefab == item then
            local num_left_to_find = amount - total_num_found
            
            if v.components.stackable then
                if v.components.stackable.stacksize > num_left_to_find then
                    v.components.stackable:SetStackSize(v.components.stackable.stacksize - num_left_to_find)
                    num_found = amount
                else
                    num_found = num_found + v.components.stackable.stacksize
                    self:RemoveItem(v, true):Remove()
                end
            else
                num_found = num_found + 1
                self:RemoveItem(v):Remove()
            end
        end
        return num_found
    end
    

    for k = 1,self.maxslots do
        local v = self.itemslots[k]
        total_num_found = total_num_found + tryconsume(v)
        
        if total_num_found >= amount then
            break
        end
    end
    
    if self.activeitem and self.activeitem.prefab == item and total_num_found < amount then
        total_num_found = total_num_found + tryconsume(self.activeitem)
    end

    
    if self.overflow and total_num_found < amount then
        local overflow_enough, overflow_found = self.overflow.components.container:Has(item, (amount - total_num_found))
        if(overflow_found>0)then
            self.overflow.components.container:ConsumeByName(item, (amount - total_num_found))
            total_num_found=total_num_found+overflow_found
        end
    end

    if(total_num_found<amount) then
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                local overflow_enough, overflow_found = v.components.container:Has(item, (amount - total_num_found))
                if(overflow_found>0)then
                    v.components.container:ConsumeByName(item, (amount - total_num_found))
                    total_num_found=total_num_found+overflow_found
                    if(total_num_found>=amount)then
                        break
                    end
                end
            end       
        end
    end

    --not done by default, not used by anything in base game
    return total_num_found

end

if(FA_DLCACCESS)then

function Inventory:GetItemByName(item, amount)
    local total_num_found = 0
    local items = {}

    local function tryfind(v)
        local num_found = 0
        if v and v.prefab == item then
            local num_left_to_find = amount - total_num_found
            if v.components.stackable then
                if v.components.stackable.stacksize > num_left_to_find then
                    items[v] = num_left_to_find
                    num_found = amount
                else
                    items[v] = v.components.stackable.stacksize
                    num_found = num_found + v.components.stackable.stacksize
                end
            else
                items[v] = 1
                num_found = num_found + 1
            end
        end
        return num_found
    end

    for k = 1,self.maxslots do
        local v = self.itemslots[k]
        total_num_found = total_num_found + tryfind(v)
        if total_num_found >= amount then
            break
        end
    end
    
    if self.activeitem and self.activeitem.prefab == item and total_num_found < amount then
        total_num_found = total_num_found + tryfind(self.activeitem)
    end
    
    --TODO is this working properly?! shouldnt it , i dunno, do either items[v]=v (above)? even if keys are items themselves its ambiguous
    if self.overflow and total_num_found < amount then
        local overflow_items = self.overflow.components.container:GetItemByName(item, (amount - total_num_found))
        for k,v in pairs(overflow_items) do
            items[k] = v
        end
    end

    if(total_num_found<amount) then
        for k,v in pairs(self.itemslots) do
            if(v.components.container)then
                local overflow_items = v.components.container:GetItemByName(item, (amount - total_num_found))
                for k1,v1 in pairs(overflow_items) do
                    items[k1] = v1
                end
            end       
        end
    end

    return items
end

end
-- sigh... I have to overwrite 300 lines because of 3
local inventory_giveitem_def=Inventory.GiveItem
function Inventory:GiveItem( inst, slot, screen_src_pos )
--    print("Inventory:GiveItem", inst, slot, screen_src_pos)
    
    if not inst.components.inventoryitem or not inst:IsValid() then
        return
    end

    local eslot = self:IsItemEquipped(inst)
    if(eslot and inst:HasTag("cursed"))then
        return
    end
    
    if eslot then
       self:Unequip(eslot) 
    end

    local new_item = inst ~= self.activeitem
    if new_item then
        for k, v in pairs(self.equipslots) do
            if v == inst then
                new_item = false
                break
            end
        end
    end

    if inst.components.inventoryitem.owner and inst.components.inventoryitem.owner ~= self.inst then
        inst.components.inventoryitem:RemoveFromOwner(true)
    end

    local objectDestroyed = inst.components.inventoryitem:OnPickup(self.inst)
    if objectDestroyed then
        return
    end

    local can_use_suggested_slot = false

    if not slot and inst.prevslot and not inst.prevcontainer then
        slot = inst.prevslot
    end

    if not slot and inst.prevslot and inst.prevcontainer then
        if inst.prevcontainer.inst.components.inventoryitem and inst.prevcontainer.inst.components.inventoryitem.owner == self.inst and inst.prevcontainer:IsOpen() and inst.prevcontainer:GetItemInSlot(inst.prevslot) == nil then
            if inst.prevcontainer:GiveItem(inst, inst.prevslot, false) then
                return true
            else
                inst.prevcontainer = nil
                inst.prevslot = nil
                slot = nil
            end
        end
    end

    if slot then
        local olditem = self:GetItemInSlot(slot)
        can_use_suggested_slot = slot ~= nil and slot <= self.maxslots and ( olditem == nil or (olditem and olditem.components.stackable and olditem.prefab == inst.prefab)) and self:CanTakeItemInSlot(inst,slot)
    end

    local container = self.itemslots
    if not can_use_suggested_slot then
        slot,container = self:GetNextAvailableSlot(inst)
    end

    if slot then
        if new_item then
            self.inst:PushEvent("gotnewitem", {item = inst, slot = slot})
        end
        
        local leftovers = nil
        if container == self.overflow and self.overflow and self.overflow.components.container then
            local itemInSlot = self.overflow.components.container:GetItemInSlot(slot) 
            if itemInSlot then
                leftovers = itemInSlot.components.stackable:Put(inst, screen_src_pos)
            end
        elseif container == self.equipslots then
            if self.equipslots[slot] then
                leftovers = self.equipslots[slot].components.stackable:Put(inst, screen_src_pos)
            end
        elseif container~=self.itemslots then
            local itemInSlot = container.components.container:GetItemInSlot(slot) 
            if itemInSlot then
                leftovers = itemInSlot.components.stackable:Put(inst, screen_src_pos)
            else
                container.components.container:GiveItem(inst, slot, screen_src_pos, true)
            end
        else
            --custom container will hit this spot, and burn in a fire
            if self.itemslots[slot] ~= nil then
                if self.itemslots[slot].components.stackable:IsFull() then
                    leftovers = inst
                    inst.prevslot = nil
                else
                    leftovers = self.itemslots[slot].components.stackable:Put(inst, screen_src_pos)
                end
            else
                inst.components.inventoryitem:OnPutInInventory(self.inst)
                self.itemslots[slot] = inst
                self.inst:PushEvent("itemget", {item=inst, slot = slot, src_pos = screen_src_pos})
            end

            if inst.components.equippable then
                inst.components.equippable:ToPocket()
            end
        end
        
        if leftovers then
            self:GiveItem(leftovers)
        end
        
        return slot
    elseif self.overflow and self.overflow.components.container then
        if self.overflow.components.container:GiveItem(inst, nil, screen_src_pos) then
            return true
        end
    end
    self.inst:PushEvent("inventoryfull", {item=inst})
    
    --can't hold it!    
    if not self.activeitem and not TheInput:ControllerAttached() then
        inst.components.inventoryitem:OnPutInInventory(self.inst)
        self:SetActiveItem(inst)
        return true
    else
        self:DropItem(inst, true, true)
    end
    
end