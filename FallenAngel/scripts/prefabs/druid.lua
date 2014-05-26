
local MakePlayerCharacter = require "prefabs/player_common"

local PetBuff = require "widgets/petbuff"
local Widget = require "widgets/widget"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

		-- Don't forget to include your character's custom assets!
        Asset( "ANIM", "anim/druid.zip" ),
}
local prefabs = {
    "fairy",
    "fairy_l20",
    "spell_earthquake",
    "spell_lightning",
   "spell_grow",
   "spell_heal",
   "spell_guardian"
}

STRINGS.TABS.SPELLS = "Spells"



local CHOP_SANITY_DELTA=-5
local DIG_SANITY_DELTA=-5
local PICK_SANITY_DELTA=-2
local PLANT_SANITY_DELTA=10
local MURDER_SANITY_DELTA=-5

local HEALTH_PER_LEVEL=1
local SANITY_PER_LEVEL=5

local ref


local function enableL1spells()
    GetPlayer().fa_spellcraft.spells[1]={
        {
            recname="spell_grow"
        },
        {
            recname="spell_summongoodberries"
        }
    }
    local r=Recipe("spell_grow", {Ingredient("papyrus", 2), Ingredient("seeds", 10), Ingredient("poop", 10)}, RECIPETABS.SPELLS, {MAGIC = 2})
    r.image="book_gardening.tex"
    local r=Recipe("spell_summongoodberries", {Ingredient("berries", 5), Ingredient("twigs", 10), Ingredient("charcoal", 5)}, RECIPETABS.SPELLS, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_gardening.tex"
end
local function enableL2spells()
    GetPlayer().fa_spellcraft.spells[2]={
        {
            recname="spell_guardian"
        },
    }
    local r=Recipe("spell_guardian", {Ingredient("papyrus", 5), Ingredient("pinecone", 20),Ingredient("livinglog",10)}, RECIPETABS.SPELLS, {MAGIC = 3})
    r.image="book_gardening.tex"    
end
local function enableL3spells()
    GetPlayer().fa_spellcraft.spells[3]={
        {
            recname="spell_lightning"
        },
    }
    local r=Recipe("spell_lightning", {Ingredient("flint", 20), Ingredient("bluegem", 4),Ingredient("papyrus", 5)}, RECIPETABS.SPELLS, {MAGIC = 2})
    r.image="book_brimstone.tex"   
end
local function enableL4spells()
    GetPlayer().fa_spellcraft.spells[4]={
        {
            recname="spell_earthquake"
        },
    }
    local r=Recipe("spell_earthquake", {Ingredient("rocks", 20), Ingredient("redgem", 5),Ingredient("papyrus", 5)},  RECIPETABS.SPELLS,{MAGIC = 2})
    r.image="book_brimstone.tex"
end
local function enableL5spells()
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="spell_heal"
        },
    }
    local r=Recipe("spell_heal", {Ingredient("papyrus", 5), Ingredient("honey", 5),Ingredient("spidergland",10)}, RECIPETABS.SPELLS, {MAGIC = 3})
    r.image="book_gardening.tex"
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>=3)then
        enableL1spells()
    end
    if(level>=6)then
        enableL2spells()
    end
    if(level>=8)then
        enableL3spells()
    end
    if(level>=10)then
        enableL4spells()
    end
    if(level>=12)then
        enableL5spells()
    end
    if(level>=15)then
        inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    end
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL*(level-1)
    end
end

local function onlevelup(inst,data)
    local level=data.level

    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL

    if(level==3)then
        enableL1spells()
    elseif(level==5)then
         inst.petBuff:Show()
    elseif(level==6)then
        enableL2spells()
    elseif(level==8)then
        enableL3spells()
    elseif(level==10)then
        enableL4spells()
    elseif(level==12)then
        enableL5spells()
    elseif(level==15)then
        inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    elseif(level==20)then

    end
end

local function oneat(inst,data)
    local food=data.food
    if(inst.components.xplevel.level>=18 and food.components.edible.foodtype == "VEGGIE")then
        -- it already did it once... there's prob a better way
        if food.components.edible.healthvalue > 0 or not inst.components.eater.strongstomach then
            inst.components.health:DoDelta(food.components.edible:GetHealth(inst), nil, food.prefab)
        end
        inst.components.hunger:DoDelta(food.components.edible:GetHunger(inst))
        inst.components.sanity:DoDelta(food.components.edible:GetSanity(inst))
    end

end

local function onmurder(inst,data)
    local victim=data.victim
    if(victim:HasTag("animal") or victim:HasTag("bird"))then
        inst.components.sanity:DoDelta(MURDER_SANITY_DELTA)
    end
end

local function onPetDeath(inst)
     GetPlayer().components.sanity:DoDelta(-TUNING.SANITY_LARGE)
     GetPlayer().petBuff:OnPetDies()
end

local function spawnFairy(inst)

    if(inst.pet and not inst.pet.components.health:IsDead())then
        return
    end
    if(inst.components.xplevel.level<20)then
        inst.pet = SpawnPrefab("fairy")
    else
        inst.pet=SpawnPrefab("fairy_l20")
    end
    inst.pet.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
    inst.components.leader:AddFollower(inst.pet)
    inst.pet:ListenForEvent("death",onPetDeath)
    inst.pet:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
        inst.pet=nil
    end)
end

local function despawnFairy(inst)
    if(inst.pet and inst.pet.components.health and not inst.pet.components.health:IsDead()) then
        inst.pet.components.health:Kill()
        inst.pet=nil
    end
end


local onloadfn = function(inst, data)
    inst.hasPet=data.hasPet
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    if(inst.pet and inst.pet.components.health and not inst.pet.components.health:IsDead())then
        data.hasPet=true
    else
        data.hasPet=false
    end
    data.fa_playername=inst.fa_playername
end


local fn = function(inst)


        
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

        local old_dig=ACTIONS.DIG.fn
        local old_plant=ACTIONS.PLANT.fn
        local old_pick=ACTIONS.PICK.fn
        local old_deploy=ACTIONS.DEPLOY.fn
        local old_chop=ACTIONS.CHOP.fn

        ACTIONS.CHOP.fn = function(act)
                local wkb=act.target.components.workable
                old_chop(act)
                print(wkb.workleft)
                if wkb and wkb.action == ACTIONS.CHOP and wkb.workleft <= 0 and act.doer:HasTag("player")then
                        inst.components.sanity:DoDelta(CHOP_SANITY_DELTA)
                end

                return true
        end

        ACTIONS.DIG.fn = function(act)
                local ret=old_dig(act)
                if ret and act.doer:HasTag("player") and act.target.components.workable and act.target.components.workable.action == ACTIONS.DIG then
                       if(act.target.components.pickable) then
                                if(act.target.components.pickable.product and(act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs"))then
                                        inst.components.sanity:DoDelta(DIG_SANITY_DELTA)
                                end
                        end
                end
                return ret
        end


        ACTIONS.PLANT.fn = function(act)
                local ret=old_plant(act)
                if(ret and act.doer:HasTag("player") and act.target.components.pickable) then
                        print(act.target.components.pickable)
                        if(act.target.components.pickable.product and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs")) then
                                inst.components.sanity:DoDelta(PLANT_SANITY_DELTA)
                        end
                end
                return ret
        end

        
        ACTIONS.PICK.fn = function(act)
                local ret=old_pick(act)
                if(ret and act.doer:HasTag("player") and act.target.components.pickable) then
                        if(act.target.components.pickable.product and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs")) then
                                inst.components.sanity:DoDelta(PICK_SANITY_DELTA)
                        end
                end
                return ret
        end

        ACTIONS.DEPLOY.fn = function(act)
                local ret=old_deploy(act)
--                print(act.invobject:GetPrefabName())
                if(ret and act.doer:HasTag("player")) then
                        if(act.invobject)then print("deplay",act.invobject.prefab) end
                        if(act.invobject and (act.invobject.prefab=="acorn" or act.invobject.prefab=="dug_grass" or act.invobject.prefab=="dug_sapling" or 
                            act.invobject.prefab=="dug_berrybush" or act.invobject.prefab=="pinecone")) then                                
                            inst.components.sanity:DoDelta(PLANT_SANITY_DELTA)
                        end
                       -- print("deploy",act.invobject)
                end
                return ret
        end
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	
	inst.components.health:SetMaxHealth(175)
	inst.components.sanity:SetMax(250)
	inst.components.hunger:SetMax(150)

    inst.fa_spellcraft={}
    inst.fa_spellcraft.spells={}
    inst:AddComponent("xplevel")

    inst.newControlsInit = function (cnt)
    
        local pet=nil

        inst.petBuff=PetBuff(cnt.owner)
        local rage = cnt:AddChild(inst.petBuff)
 --    class.rage:SetHAnchor(ANCHOR_MIDDLE)
  --  class.rage:SetVAnchor(ANCHOR_TOP)
        rage:SetPosition(0,0,0)
        rage:SetOnClick(function(state) 
            if(state and state=="on") then
                spawnFairy(inst)
            else
                despawnFairy(inst)
            end
        end)
        if(inst.hasPet)then
            local leader=inst.components.leader
            for k,v in pairs(leader.followers) do
                if k:HasTag("pet") then
                    pet=k
                end
            end
            print("found pet?",pet)
            inst.pet=pet
            if(pet)then
                inst.petBuff:ForceState("on")
                inst.pet:ListenForEvent("death",onPetDeath)
            end
        end
        if(inst.components.xplevel.level<5)then
            inst.petBuff:Hide()
        end
    end

    inst:ListenForEvent("xplevelup", onlevelup)
    inst:ListenForEvent("killed", onmurder)
    inst:ListenForEvent("oneat", oneat)
    inst:ListenForEvent("xplevel_loaded",onxploaded)

    inst:AddComponent("reader")

RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}
  --[[    local booktab=RECIPETABS.SPELLS
]]

end



return MakePlayerCharacter("druid", prefabs, assets, fn)
