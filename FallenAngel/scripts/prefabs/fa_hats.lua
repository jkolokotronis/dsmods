
local assets=
{
	Asset("ANIM", "anim/hat_goblinking_swap.zip"),
	Asset("ANIM", "anim/hat_goblinking.zip"),
	Asset("ANIM", "anim/hat_pot_swap.zip"),
	Asset("ANIM", "anim/hat_pot.zip"),
    Asset("ATLAS", "images/inventoryimages/hat_pot.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_pot.tex"),
    Asset("ATLAS", "images/inventoryimages/hat_goblinking.xml"),
    Asset("IMAGE", "images/inventoryimages/hat_goblinking.tex"),
}

local prefabs ={}

local function onequip(inst, owner, build)
        owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
        
        if owner:HasTag("player") then
			owner.AnimState:Hide("HEAD")
			owner.AnimState:Show("HEAD_HAIR")
		end
        
		if inst.components.fueled then
			inst.components.fueled:StartConsuming()        
		end
    end

    local function onunequip(inst, owner)
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")

		if owner:HasTag("player") then
	        owner.AnimState:Show("HEAD")
			owner.AnimState:Hide("HEAD_HAIR")
		end

		if inst.components.fueled then
			inst.components.fueled:StopConsuming()        
		end
    end

    local function opentop_onequip(inst, owner, build)
        owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
        
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAIR")

		if inst.components.fueled then
			inst.components.fueled:StartConsuming()        
		end
    end

    local function common()
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)

        

        inst:AddTag("hat")

        inst:AddComponent("inspectable")

        inst:AddComponent("inventoryitem")
        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

        inst.components.equippable:SetOnUnequip( onunequip )

        return inst
    end
    local function fnpot()
    	local inst=common()
    	inst.AnimState:SetBank("hat_pot")
        inst.AnimState:SetBuild("hat_pot")
        inst.AnimState:PlayAnimation("idle")
        inst.components.equippable:SetOnEquip(function(inst,owner) onequip(inst,owner,"hat_pot_swap") end )
    	inst.components.inventoryitem.imagename = "hat_pot"
    	inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_pot.xml"
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(400, 0.3)
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    	return inst
    end
    local function fnking()
    	local inst=common()
    	inst.AnimState:SetBank("hat_goblinking")
        inst.AnimState:SetBuild("hat_goblinking")
        inst.AnimState:PlayAnimation("idle")
        inst.components.equippable:SetOnEquip( function(inst,owner) opentop_onequip(inst,owner,"hat_goblinking_swap") end  )
    	inst.components.inventoryitem.imagename = "hat_goblinking"
    	inst.components.inventoryitem.atlasname = "images/inventoryimages/hat_goblinking.xml"
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(400, 0.3)
    	return inst
    end

return Prefab( "common/inventory/hat_goblinking", fnking, assets, prefabs),
Prefab( "common/inventory/hat_pot", fnpot, assets, prefabs)