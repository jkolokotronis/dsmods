
local InvSlot = require "widgets/invslot"
local TileBG = require "widgets/tilebg"
local Image = require "widgets/image"
local Widget = require "widgets/widget"
local EquipSlot = require "widgets/equipslot"
local ItemTile = require "widgets/itemtile"
local Text = require "widgets/text"
local ThreeSlice = require "widgets/threeslice"


rpghudmod=nil
for _, mod in ipairs( ModManager.mods ) do
        if mod.modinfo.name == "RPG HUD" or mod.modinfo.id == "RPG HUD" then
            rpghudmod=mod
            print("hud version",mod.modinfo.id,mod.modinfo.name, mod.modinfo.description)
        end
    end


local HUD_ATLAS = "images/hud.xml"

local W = 68
local SEP = 12
local YSEP = 8
local INTERSEP = 28
local CURSOR_STRING_DELAY = 10
local TIP_YFUDGE = 16
local HINT_UPDATE_INTERVAL = 2.0 -- once per second

inventorybarpostconstruct=nil
	table.insert(EQUIPSLOTS, "RING")
	EQUIPSLOTS.RING = "ring"
	table.insert(EQUIPSLOTS, "BOOT")
	EQUIPSLOTS.BOOT = "boot"
	table.insert(EQUIPSLOTS, "QUIVER")
	EQUIPSLOTS.QUIVER = "quiver"

if(not rpghudmod)then
	table.insert(EQUIPSLOTS, "PACK")
	EQUIPSLOTS.PACK = "pack"
	table.insert(EQUIPSLOTS, "NECK")
	EQUIPSLOTS.NECK = "neck"


inventorybarpostconstruct=function(self, owner)

--just kill it off completely again
--	self.bg = self.root:AddChild(Image(HUD_ATLAS, "inventory_bg.tex"))
		self.bg:SetScale(0.97,1,1)
--		self.bgcover = self.root:AddChild(Image(HUD_ATLAS, "inventory_bg_cover.tex"))
		self.bgcover:SetScale(0.97,1,1)

		self.bgequip = self.root:AddChild(Image(HUD_ATLAS, "inventory_bg.tex"))
		self.bgequip:SetScale(0.5,1,1)

		self.equipslotinfo={}

		self:AddEquipSlot(EQUIPSLOTS.HANDS, "images/equipslots.xml", "equip_slot_hand.tex") 
    	self:AddEquipSlot(EQUIPSLOTS.BODY, "images/equipslots.xml", "equip_slot_body.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.HEAD, "images/equipslots.xml", "equip_slot_head.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.NECK, "images/equipslots.xml", "equip_slot_neck.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.PACK, "images/equipslots.xml", "equip_slot_pack.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.RING, "images/equipslots.xml", "equip_slot_ring.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.BOOT, "images/equipslots.xml", "equip_slot_boot.tex")  
    	self:AddEquipSlot(EQUIPSLOTS.QUIVER, "images/equipslots.xml", "equip_slot_quiver.tex")  

function self:Rebuild()

	if self.cursor then
		self.cursor:Kill()
		self.cursor = nil
	end
	
	if self.toprow then
		self.toprow:Kill()
	end

	if self.bottomrow then
		self.bottomrow:Kill()
	end

	self.toprow = self.root:AddChild(Widget("toprow"))
	self.bottomrow = self.root:AddChild(Widget("toprow"))

    self.inv = {}
    self.equip = {}
	self.backpackinv = {}

--    local y = self.owner.components.inventory.overflow and (W/2+YSEP/2) or 0
	local y = 0
    local eslot_order = {}

    local num_slots = self.owner.components.inventory:GetNumSlots()
    local num_equip = #self.equipslotinfo
    local num_intersep = math.floor(num_slots / 5) + 1 
--    local total_w = (num_slots + num_equip)*(W) + (num_slots + num_equip - 2 - num_intersep) *(SEP) + INTERSEP*num_intersep
	local total_w = (num_slots )*(W) + (num_slots - 2 - num_intersep) *(SEP) + INTERSEP*num_intersep
	local total_e = num_equip*W + (num_equip - 1)*SEP


	for k, v in ipairs(self.equipslotinfo) do
		local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
		self.equip[v.slot] = self.toprow:AddChild(slot)
		local x = -total_e/2 + W/2 + (k-1)*W + (k-1)*SEP	
		slot:SetPosition(x,y+85,0)							
		table.insert(eslot_order, slot)						
		
		local item = self.owner.components.inventory:GetEquippedItem(v.slot)
		if item then
			slot:SetTile(ItemTile(item, self.owner.components.inventory))
		end

	end    

    for k = 1,num_slots do
        local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, self.owner.components.inventory)
        self.inv[k] = self.toprow:AddChild(slot)
        local interseps = math.floor((k-1) / 5)
        local x = -total_w/2 + W/2 + interseps*(INTERSEP - SEP) + (k-1)*W + (k-1)*SEP
        slot:SetPosition(x,0,0)
        
		slot.top_align_tip = W*0.5 + YSEP

		local item = self.owner.components.inventory:GetItemInSlot(k)
		if item then
			slot:SetTile(ItemTile(item))
		end
        
    end


	local old_backpack = self.backpack
	if self.backpack then
		self.inst:RemoveEventCallback("itemget", BackpackGet, self.backpack)
		self.inst:ListenForEvent("itemlose", BackpackLose, self.backpack)
		self.backpack = nil
	end


	local new_backpack = self.owner.components.inventory.overflow
	local do_integrated_backpack = TheInput:ControllerAttached() and new_backpack
	if do_integrated_backpack then
		local num = new_backpack.components.container.numslots

		local x = - (num * (W+SEP) / 2)
		--local offset = #self.inv >= num and 1 or 0 --math.ceil((#self.inv - num)/2)
		local offset = 1 + #self.inv - num

		for k = 1, num do
			local slot = InvSlot(k, HUD_ATLAS, "inv_slot.tex", self.owner, new_backpack.components.container)
			self.backpackinv[k] = self.bottomrow:AddChild(slot)

			slot.top_align_tip = W*1.5 + YSEP*2
			
			if offset > 0 then
				slot:SetPosition(self.inv[offset+k-1]:GetPosition().x,0,0)
			else
				slot:SetPosition(x,0,0)
				x = x + W + SEP
			end
			
			local item = new_backpack.components.container:GetItemInSlot(k)
			if item then
				slot:SetTile(ItemTile(item))
			end
			
		end
		
		self.backpack = self.owner.components.inventory.overflow
	    self.inst:ListenForEvent("itemget", BackpackGet, self.backpack)
	    self.inst:ListenForEvent("itemlose", BackpackLose, self.backpack)
	end



	if old_backpack	and not self.backpack then
		self:SelectSlot(self.inv[1])
		self.current_list = self.inv
	end

	--self.bg:Flow(total_w+60, 256, true)
	--what am i supposed to do here?
	if do_integrated_backpack then
		self.bg:SetPosition(Vector3(0,-24,0))
	    self.bgcover:SetPosition(Vector3(0, -135, 0))
		self.toprow:SetPosition(Vector3(0,W/2 + YSEP/2,0))
		self.bottomrow:SetPosition(Vector3(0,-W/2 - YSEP/2,0))
		self.root:MoveTo(self.out_pos, self.in_pos, .5)
	else
		self.bgequip:SetPosition(Vector3(0, 30, 0))
		self.bg:SetPosition(Vector3(0, -64, 0))
	    self.bgcover:SetPosition(Vector3(0, -100, 0))
		self.toprow:SetPosition(Vector3(0,0,0))
		self.bottomrow:SetPosition(0,0,0)
		
		if TheInput:ControllerAttached() then
			self.root:MoveTo(self.in_pos, self.out_pos, .2)
		else
			self.root:SetPosition(self.out_pos)
		end
		
		
	end
	
	self.actionstring:MoveToFront()
	
	self:SelectSlot(self.inv[1])
	self.current_list = self.inv
	self:UpdateCursor()
	
	if self.cursor then
		self.cursor:MoveToFront()
	end


	self.rebuild_pending = false
end

	self.rebuild_pending=true
	
end

else


end

--if(isrpghudenabled)then
--HUD
--[[


    --default equip slots
    
function Inv:AddEquipSlot(slot, atlas, image, sortkey)
    sortkey = sortkey or #self.equipslotinfo
    table.insert(self.equipslotinfo, {slot = slot, atlas = atlas, image = image, sortkey = sortkey})
    table.sort(self.equipslotinfo, function(a,b) return a.sortkey < b.sortkey end)
    self.rebuild_pending = true
end

    for k, v in ipairs(self.equipslotinfo) do
        local slot = EquipSlot(v.slot, v.atlas, v.image, self.owner)
        self.equip[v.slot] = self.toprow:AddChild(slot)
        local x = -total_w/2 + (num_slots)*(W)+num_intersep*(INTERSEP - SEP) + (num_slots-1)*SEP + INTERSEP + W*(k-1) + SEP*(k-1)
        slot:SetPosition(x,0,0)
        table.insert(eslot_order, slot)
        
        local item = self.owner.components.inventory:GetEquippedItem(v.slot)
        if item then
            slot:SetTile(ItemTile(item))
        end

    end    

--RemapSoundEvent("dontstarve/music/music_FE","fa/music/fires")]]