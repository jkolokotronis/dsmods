
local assets_goblinking={
    Asset("ANIM", "anim/hat_goblinking_swap.zip"),
    Asset("ANIM", "anim/hat_goblinking.zip"),
    
}
local assets_pot={
    Asset("ANIM", "anim/hat_pot_swap.zip"),
    Asset("ANIM", "anim/hat_pot_goblin_swap.zip"),
    Asset("ANIM", "anim/hat_pot.zip"),  
}
local assets_copper={
    Asset("ANIM", "anim/fa_hat_copper.zip"), 
}
local assets_iron={
    Asset("ANIM", "anim/fa_hat_iron.zip"), 
}
local assets_steel={
    Asset("ANIM", "anim/fa_hat_steel.zip"), 
}
local assets_adamant={
    Asset("ANIM", "anim/fa_hat_adamantine.zip"), 
}
local assets_silver={
    Asset("ANIM", "anim/fa_hat_silver.zip"), 
}
local assets_gold={
    Asset("ANIM", "anim/fa_hat_gold.zip"), 
}
local asset_dorfcrown={
    Asset("ANIM", "anim/fa_dorf_crown.zip"),     
}
local assets_dorfking={
    Asset("ANIM", "anim/fa_hat_dorfking.zip"),     
    
}
local assets_orcking={
    Asset("ANIM", "anim/fa_hat_orcking.zip"),     
    
}

local assets_fa_hat_abjuration=
{
    Asset("ANIM", "anim/fa_hat_abjuration.zip"),
}
local assets_fa_hat_conjuration=
{
    Asset("ANIM", "anim/fa_hat_conjuration.zip"),
}
local assets_fa_hat_divination=
{
    Asset("ANIM", "anim/fa_hat_divination.zip"),
}
local assets_fa_hat_enchantment=
{
    Asset("ANIM", "anim/fa_hat_enchantment.zip"),
}
local assets_fa_hat_evocation=
{
    Asset("ANIM", "anim/fa_hat_evocation.zip"),
}
local assets_fa_hat_illusion=
{
    Asset("ANIM", "anim/fa_hat_illusion.zip"),
}
local assets_fa_hat_necromancy=
{
    Asset("ANIM", "anim/fa_hat_necromancy.zip"),
}
local assets_fa_hat_transmutation=
{
    Asset("ANIM", "anim/fa_hat_transmutation.zip"),
}
local assets_fa_hat_heavyleather=
{
    Asset("ANIM", "anim/fa_hat_heavyleather.zip"),
}
local assets_fa_hat_lightleather=
{
    Asset("ANIM", "anim/fa_hat_lightleather.zip"),
}
local assets_fa_hat_plain=
{
    Asset("ANIM", "anim/fa_hat_plain.zip"),
}
local assets_fa_hat_leprechaun=
{
    Asset("ANIM", "anim/fa_hat_leprechaun.zip"),
}
local assets_hat_pigking=
{
    Asset("ANIM", "anim/fa_hat_pigking.zip"),
}
local assets_hat_witch=
{
    Asset("ANIM", "anim/fa_hat_witch.zip"),
}

local prefabs ={}

local ARMOR_POTHAT = 500
local ARMOR_POTHAT_ABSORPTION = .2
local ARMOR_POTHAT_WATERPROOFNESS=0.2
local ARMOR_COPPERHAT = 1500
local ARMOR_COPPERHAT_ABSORPTION = .6
local ARMOR_COPPERHAT_WATERPROOFNESS=0.2
local ARMOR_IRONHAT = 2500
local ARMOR_IRONHAT_ABSORPTION = .8
local ARMOR_IRONHAT_WATERPROOFNESS=0.2
local ARMOR_STEELHAT = 3500
local ARMOR_STEELHAT_ABSORPTION = .9
local ARMOR_STEELHAT_WATERPROOFNESS=0.2
local ARMOR_ADAMANTHAT = 4500
local ARMOR_ADAMANTHAT_ABSORPTION = .95
local ARMOR_ADAMANTHAT_WATERPROOFNESS=0.2
local ARMOR_SILVERHAT = 2500
local ARMOR_SILVERHAT_ABSORPTION = .85
local ARMOR_SILVERHAT_WATERPROOFNESS=0.2
local ARMOR_GOLDHAT = 2000
local ARMOR_GOLDHAT_ABSORPTION = .7
local ARMOR_GOLDHAT_WATERPROOFNESS=0.2
local ARMOR_GOBLINKING=20000
local ARMOR_GOBLINKING_ABSORPTION= 0.3
local ARMOR_DORFKINGHAT = 8500
local ARMOR_DORFKINGHAT_ABSORPTION = .95
local ARMOR_ORCKINGHAT = 8500
local ARMOR_ORCKINGHAT_ABSORPTION = .95

local ARMOR_GOLD_DAPPERNESS=5.0/60
local ARMOR_GOLD_FUELLEVEL=1200
local ARMOR_POT_DAPPERNESS=-5.0/60
local ARMOR_SILVER_DR=5

local ARMOR_DORF_CROWN=1000
local ARMOR_DORF_CROWN_ABSORPTION=0.2

local ARMOR_LEATHERHAT=1200
local ARMOR_ABSORPTION_LEATHER=0.55
local ARMOR_HEAVYLEATHERHAT=1500
local ARMOR_ABSORPTION_HEAVYLEATHER=0.70

local ARMOR_ROBE_DURA=1000
local ARMOR_ROBE_ABSO=0.5
local ARMOR_ABJURATION_ABSO=0.55
local ROBE_CL_BONUS=2

    local function generic_perish(inst)
        inst:Remove()
    end

local function onequip(inst, owner, build)
        owner.AnimState:OverrideSymbol("swap_hat", build, "swap_hat")
        owner.AnimState:Show("HAT")
--      TODO I should prob remove old names
--        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Show("HAIR_HAT")
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
--        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_HAT")
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

    local function common(build)
        local inst = CreateEntity()

        inst.entity:AddTransform()
        inst.entity:AddAnimState()
        MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( build..".tex" )

        inst.AnimState:SetBank(build)
        inst.AnimState:SetBuild(build)
        inst.AnimState:PlayAnimation("idle")
        inst:AddTag("hat")

        inst:AddComponent("inspectable")

        if(FA_DLCACCESS)then
        inst:AddComponent("waterproofer")
        inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_ABSOLUTE)
        end

        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename = build
        inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
        inst:AddComponent("tradable")

        inst:AddComponent("equippable")
        inst.components.equippable.equipslot = EQUIPSLOTS.HEAD

        inst.components.equippable:SetOnUnequip( onunequip )

        return inst
    end
    local function fnpot()
    	local inst=common("hat_pot")
        inst.components.equippable:SetOnEquip(function(inst,owner)
            if(owner and owner:HasTag("goblin"))then    
                onequip(inst,owner,"hat_pot_goblin_swap") 
            else
                onequip(inst,owner,"hat_pot_swap") 
            end
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance+0.2
            end
        end )

        inst.components.equippable:SetOnUnequip(function(inst,owner) 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance-0.2
            end
            onunequip(inst,owner)
        end)

        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_POTHAT_WATERPROOFNESS)
        end

        local dapperfn=function(inst,owner)
            local seasonmanager=GetSeasonManager()
            if(seasonmanager and seasonmanager:IsRaining())then
                return ARMOR_POT_DAPPERNESS
            else
                return 0
            end
        end
        if(FA_DLCACCESS)then
            inst.components.equippable.dapperfn = dapperfn
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperfn = dapperfn
        end

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_POTHAT, ARMOR_POTHAT_ABSORPTION)
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.ACID]=0.2
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.5
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    	return inst
    end
    local function fnking()
    	local inst=common("hat_goblinking")
        inst.components.equippable:SetOnEquip( function(inst,owner) opentop_onequip(inst,owner,"hat_goblinking_swap") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_GOBLINKING, ARMOR_GOBLINKING_ABSORPTION)
    	return inst
    end

    local function fncopper()
        local inst=common("fa_hat_copper")
        inst.components.equippable:SetOnEquip( function(inst,owner) 
            onequip(inst,owner,"fa_hat_copper") 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance+0.3
            end
        end  )

        inst.components.equippable:SetOnUnequip(function(inst,owner) 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance-0.3
            end
            onunequip(inst,owner)
        end)

        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_COPPERHAT_WATERPROOFNESS)
        end
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_COPPERHAT, ARMOR_COPPERHAT_ABSORPTION)
        return inst
    end

    local function fniron()
        local inst=common("fa_hat_iron")
        inst.components.equippable:SetOnEquip( function(inst,owner) 
            onequip(inst,owner,"fa_hat_iron") 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance+0.2
            end
        end  )

        inst.components.equippable:SetOnUnequip(function(inst,owner) 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance-0.2
            end
            onunequip(inst,owner)
        end)
        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_IRONHAT_WATERPROOFNESS)
        end
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_IRONHAT, ARMOR_IRONHAT_ABSORPTION)
        return inst
    end

    local function fnsilver()
        local inst=common("fa_hat_silver")

        inst.components.equippable:SetOnEquip( function(inst,owner) 
            onequip(inst,owner,"fa_hat_silver") 
        end  )

        inst.components.equippable:SetOnUnequip(function(inst,owner)     
            onunequip(inst,owner)
        end)

        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_SILVERHAT_WATERPROOFNESS)
        end
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_SILVERHAT, ARMOR_SILVERHAT_ABSORPTION)
        return inst
    end

    local function fngold()
        local inst=common("fa_hat_gold")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_gold") end  )
        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_GOLDHAT_WATERPROOFNESS)
        end
        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = ARMOR_GOLD_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = ARMOR_GOLD_DAPPERNESS
        end

        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "USAGE"
        inst.components.fueled:InitializeFuelLevel(ARMOR_GOLD_FUELLEVEL)
        inst.components.fueled:SetDepletedFn( generic_perish )

        inst:ListenForEvent("rainstop", function() inst.components.fueled.rate=1 end, GetWorld()) 
        inst:ListenForEvent("rainstart", function() inst.components.fueled.rate=2 end, GetWorld()) 

        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_GOLDHAT, ARMOR_GOLDHAT_ABSORPTION)
        return inst
    end

    local function fnsteel()
        local inst=common("fa_hat_steel")
        inst.components.equippable:SetOnEquip( function(inst,owner) 
            onequip(inst,owner,"fa_hat_steel") 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance+0.2
            end
        end  )
        inst.components.equippable:SetOnUnequip(function(inst,owner) 
            if(owner and owner.components.playerlightningtarget and owner.components.playerlightningtarget.hitchance)then
                owner.components.playerlightningtarget.hitchance=owner.components.playerlightningtarget.hitchance-0.2
            end
            onunequip(inst,owner)
        end)
        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_STEELHAT_WATERPROOFNESS)
        end
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_STEELHAT, ARMOR_STEELHAT_ABSORPTION)
        return inst
    end

    local function fnadamant()
        local inst=common("fa_hat_adamantine")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_adamantine") end  )
        if(FA_DLCACCESS)then
        inst.components.waterproofer:SetEffectiveness(ARMOR_ADAMANTHAT_WATERPROOFNESS)
        end
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_ADAMANTHAT, ARMOR_ADAMANTHAT_ABSORPTION)
        return inst
    end

    local function fncrown()
        local inst=common("fa_dorf_crown")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_dorf_crown") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_DORF_CROWN, ARMOR_DORF_CROWN_ABSORPTION)
        return inst
    end

    local function fndorfking()
        local inst=common("fa_hat_dorfking")
        inst.components.equippable:SetOnEquip( function(inst,owner) opentop_onequip(inst,owner,"fa_hat_dorfking") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_DORFKINGHAT, ARMOR_DORFKINGHAT_ABSORPTION)
        return inst
    end
    local function fnorcking()
        local inst=common("fa_hat_orcking")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_orcking") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_ORCKINGHAT, ARMOR_ORCKINGHAT_ABSORPTION)
        return inst
    end

    local function fa_hat_abjuration()
        local inst=common("fa_hat_abjuration")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_abjuration") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ABJURATION_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.COLD]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ABJURATION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_conjuration()
        local inst=common("fa_hat_conjuration")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_conjuration") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.POISON]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.CONJURATION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_divination()
        local inst=common("fa_hat_divination")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_divination") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.HOLY]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.DIVINATION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_enchantment()
        local inst=common("fa_hat_enchantment")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_enchantment") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ENCHANTMENT]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_evocation()
        local inst=common("fa_hat_evocation")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_evocation") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.FIRE]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.EVOCATION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_illusion()
        local inst=common("fa_hat_illusion")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_illusion") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ILLUSION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_necromancy()
        local inst=common("fa_hat_necromancy")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_necromancy") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.armor.fa_resistances={}
        inst.components.armor.fa_resistances[FA_DAMAGETYPE.DEATH]=0.25
        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.NECROMANCY]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_transmutation()
        local inst=common("fa_hat_transmutation")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_transmutation") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        inst.components.waterproofer:SetEffectiveness(1)

        if(FA_DLCACCESS)then
            inst:ListenForEvent("rainstop", function() 
                if(inst.fa_raintask)then
                    inst.fa_raintask:Cancel()
                end
            end, GetWorld()) 
            inst:ListenForEvent("rainstart", function() 
                if(inst.fa_raintask)then
                    inst.fa_raintask:Cancel()
                end
                inst.fa_raintask=inst:DoPeriodicTask(60,function()
                    if(inst.components.equippable:IsEquipped() and math.random()<0.5)then
                        local owner=inst.components.inventoryitem.owner
                        if(owner and owner:IsValid() and not (owner.components.health and owner.components.health:IsDead()))then
                            local ice = SpawnPrefab("ice")
                            ice.Transform:SetPosition(owner.Transform:GetWorldPosition())  
                        end
                    end
                end)
            end, GetWorld()) 
        end

        inst.components.equippable.fa_casterlevel={}
        inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.TRANSMUTATION]=ROBE_CL_BONUS
        return inst
    end
    local function fa_hat_heavyleather()
        local inst=common("fa_hat_heavyleather")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_heavyleather") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_HEAVYLEATHERHAT, ARMOR_ABSORPTION_HEAVYLEATHER)
        return inst
    end
    local function fa_hat_lightleather()
        local inst=common("fa_hat_lightleather")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_lightleather") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_LEATHERHAT, ARMOR_ABSORPTION_LEATHER)
        return inst
    end
    local function fa_hat_plain()
        local inst=common("fa_hat_plain")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_plain") end  )
        inst:AddComponent("armor")
        inst:AddTag("fa_cloth")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        return inst
    end
    local function fa_hat_leprechaun()
        local inst=common("fa_hat_leprechaun")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_leprechaun") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        return inst
    end
    local function fa_hat_pigking()
        local inst=common("fa_hat_pigking")
        inst.components.equippable:SetOnEquip( function(inst,owner) opentop_onequip(inst,owner,"fa_hat_pigking") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_GOBLINKING, ARMOR_GOBLINKING_ABSORPTION)
        return inst
    end
    local function fa_hat_witch()
        local inst=common("fa_hat_witch")
        inst.components.equippable:SetOnEquip( function(inst,owner) onequip(inst,owner,"fa_hat_witch") end  )
        inst:AddComponent("armor")
        inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
        return inst
    end



return Prefab( "common/inventory/hat_goblinking", fnking, assets_goblinking, prefabs),
Prefab( "common/inventory/hat_pot", fnpot, assets_pot, prefabs),
Prefab( "common/inventory/fa_hat_adamantine", fnadamant, assets_adamant, prefabs),
Prefab( "common/inventory/fa_hat_copper", fncopper, assets_copper, prefabs),
Prefab( "common/inventory/fa_hat_iron", fniron, assets_iron, prefabs),
Prefab( "common/inventory/fa_hat_silver", fnsilver, assets_silver, prefabs),
Prefab( "common/inventory/fa_hat_gold", fngold, assets_gold, prefabs),
Prefab( "common/inventory/fa_hat_steel", fnsteel, assets_steel, prefabs),
Prefab( "common/inventory/fa_dorf_crown", fncrown, asset_dorfcrown, prefabs),
Prefab( "common/inventory/fa_hat_dorfking", fndorfking, assets_dorfking, prefabs),
Prefab( "common/inventory/fa_hat_orcking", fnorcking, assets_orcking, prefabs),
Prefab( "common/inventory/fa_hat_abjuration", fa_hat_abjuration, assets_fa_hat_abjuration, prefabs),
Prefab( "common/inventory/fa_hat_conjuration", fa_hat_conjuration, assets_fa_hat_conjuration, prefabs),
Prefab( "common/inventory/fa_hat_divination", fa_hat_divination, assets_fa_hat_divination, prefabs),
Prefab( "common/inventory/fa_hat_enchantment", fa_hat_enchantment, assets_fa_hat_enchantment, prefabs),
Prefab( "common/inventory/fa_hat_evocation", fa_hat_evocation, assets_fa_hat_evocation, prefabs),
Prefab( "common/inventory/fa_hat_illusion", fa_hat_illusion, assets_fa_hat_illusion, prefabs),
Prefab( "common/inventory/fa_hat_necromancy", fa_hat_necromancy, assets_fa_hat_necromancy, prefabs),
Prefab( "common/inventory/fa_hat_transmutation", fa_hat_transmutation, assets_fa_hat_transmutation, prefabs),
Prefab( "common/inventory/fa_hat_heavyleather", fa_hat_heavyleather, assets_fa_hat_heavyleather, prefabs),
Prefab( "common/inventory/fa_hat_lightleather", fa_hat_lightleather, assets_fa_hat_lightleather, prefabs),
Prefab( "common/inventory/fa_hat_plain", fa_hat_plain, assets_fa_hat_plain, prefabs),
Prefab( "common/inventory/fa_hat_pigking", fa_hat_pigking, assets_hat_pigking, prefabs),
Prefab( "common/inventory/fa_hat_leprechaun", fa_hat_leprechaun, assets_fa_hat_leprechaun, prefabs),
Prefab( "common/inventory/fa_hat_witch", fa_hat_witch, assets_hat_witch, prefabs)



