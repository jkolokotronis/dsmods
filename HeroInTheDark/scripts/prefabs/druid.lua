
local MakePlayerCharacter = require "prefabs/player_common"

local PetBuff = require "widgets/petbuff"
local Widget = require "widgets/widget"
require "constants"

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

    Asset( "ANIM", "anim/druid.zip" ),
    Asset( "IMAGE", "images/fa_druid_bookcraft.tex" ),
    Asset( "IMAGE", "images/fa_druid_booknext.tex" ),
    Asset( "IMAGE", "images/fa_druid_bookprev.tex" ),
    Asset( "IMAGE", "images/fa_druid_bookclose.tex" ),
    Asset( "IMAGE", "images/fa_druid_bookbackground.tex" ),
    Asset( "IMAGE", "images/fa_druid_bookframe.tex" ),
    Asset( "ATLAS", "images/fa_druid_bookcraft.xml" ),
    Asset( "ATLAS", "images/fa_druid_booknext.xml" ),
    Asset( "ATLAS", "images/fa_druid_bookprev.xml" ),
    Asset( "ATLAS", "images/fa_druid_bookclose.xml" ),
    Asset( "ATLAS", "images/fa_druid_bookbackground.xml" ),
    Asset( "ATLAS", "images/fa_druid_bookframe.xml" ),
}
local prefabs = {
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
            recname="fa_spell_curelightwounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_faeriefire",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_longstrider",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_naturesally",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="spell_summongoodberries",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
       
    }
    local r=Recipe("fa_spell_curelightwounds", {Ingredient("red_cap", 6), Ingredient("ash", 6), Ingredient("petals", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
     local r=Recipe("fa_spell_faeriefire", {Ingredient("fireflies", 2), Ingredient("torch", 1), Ingredient("redgem", 1)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
     local r=Recipe("fa_spell_longstrider", {Ingredient("houndstooth", 2), Ingredient("batwing", 2), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
     local r=Recipe("fa_spell_naturesally", {Ingredient("silk", 2), Ingredient("spidereggsack", 2), Ingredient("papyrus", 4)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("spell_summongoodberries", {Ingredient("berries", 5), Ingredient("twigs", 10), Ingredient("charcoal", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
end
local function enableL2spells()
    GetPlayer().fa_spellcraft.spells[2]={
        {
            recname="fa_spell_animaltrance",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_gustofwind",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_holdanimal",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },

        {
            recname="fa_spell_naturesally2",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_summonswarm",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
    }

    local r=Recipe("fa_spell_animaltrance", {Ingredient("berries", 10), Ingredient("silk", 6), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_gustofwind", {Ingredient("feather_crow", 6), Ingredient("twigs", 10), Ingredient("rope", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_holdanimal", {Ingredient("berries", 10), Ingredient("silk", 6), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_naturesally2", {Ingredient("livinglog", 5), Ingredient("pinecone", 20), Ingredient("papyrus", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonswarm", {Ingredient("silk", 5), Ingredient("spidereggsack", 1), Ingredient("papyrus", 8)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

end
local function enableL3spells()
    GetPlayer().fa_spellcraft.spells[3]={
       {
            recname="fa_spell_calllightning",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_curemoderatewounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_daylight",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_dominateanimal",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_curepoison",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_grow",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_poison",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_snare",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
    }

    local r=Recipe("fa_spell_calllightning", {Ingredient("flint", 20), Ingredient("bluegem", 1), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curemoderatewounds", {Ingredient("green_cap", 6), Ingredient("ash", 6), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_daylight", {Ingredient("fireflies", 2), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_dominateanimal", {Ingredient("berries", 15), Ingredient("silk", 12), Ingredient("honey", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curepoison", {Ingredient("mosquitosack", 2), Ingredient("silk", 12), Ingredient("honey", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_grow", {Ingredient("papyrus", 2), Ingredient("seeds", 10), Ingredient("poop", 10)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_poison", {Ingredient("spidergland", 6), Ingredient("mosquitosack", 4), Ingredient("twigs", 10)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_snare", {Ingredient("twigs", 10), Ingredient("guano", 4), Ingredient("poop", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

end
local function enableL4spells()
    GetPlayer().fa_spellcraft.spells[4]={
        {
            recname="fa_spell_cureseriouswounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_flamestrike",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
    }
    local r=Recipe("fa_spell_cureseriouswounds", {Ingredient("blue_cap", 6), Ingredient("ash", 8), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_flamestrike", {Ingredient("redgem", 2), Ingredient("ash", 10), Ingredient("gunpowder", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    

   
end
local function enableL5spells()
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="fa_spell_atonement",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_lightningstorm",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_curecriticalwounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_firewall",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
    }

    local r=Recipe("fa_spell_atonement", {Ingredient("charcoal", 10), Ingredient("butterfly", 4), Ingredient("monstermeat", 4)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_lightningstorm", {Ingredient("flint", 20), Ingredient("bluegem", 4), Ingredient("papyrus", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curecriticalwounds", {Ingredient("blue_cap", 12), Ingredient("ash", 8), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_firewall", {Ingredient("redgem", 4), Ingredient("rocks", 10), Ingredient("twigs", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

    
end

local function enableL6spells() end
local function enableL7spells() 
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="fa_spell_heal",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
    }
    local r=Recipe("fa_spell_heal", {Ingredient("papyrus", 5), Ingredient("honey", 5),Ingredient("spidergland",10)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_gardening.tex"
end
local function enableL8spells() 
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="fa_spell_earthquake",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
    }
    local r=Recipe("fa_spell_earthquake", {Ingredient("rocks", 20), Ingredient("redgem", 5),Ingredient("papyrus", 5)},  RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_brimstone.tex"
end
local function enableL9spells() end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    inst.components.fa_spellcaster.casterlevel=level
    if(level>=2)then
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
    if(level>=14)then
        enableL6spells()
    end
    if(level>=16)then
        enableL7spells()
    end
    if(level>=15)then
        inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    end
    if(level>=18)then
        enableL8spells()
    end
    if(level>=20)then
        enableL9spells()
    end
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL*(level-1)
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.fa_spellcaster.casterlevel=level

    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL

    if(level==2)then
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
    elseif(level==14)then
        enableL6spells()
    elseif(level==15)then
        inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    elseif(level==16)then
        enableL7spells()
    elseif(level==18)then
        enableL8spells()
    elseif(level==20)then
        enableL9spells()
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
        inst.pet = SpawnPrefab("fa_druidpet")
    else
        inst.pet=SpawnPrefab("fa_druidpet_l20")
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
	inst.MiniMapEntity:SetIcon( "druid.tex" )

	-- todo: Add an example special power here.
	
	inst.components.health:SetMaxHealth(175)
	inst.components.sanity:SetMax(250)
	inst.components.hunger:SetMax(150)

    inst:RemoveTag("scarytoprey")
    inst:AddTag("fa_spellcaster")
    inst.fa_spellcraft={}
    inst.fa_spellcraft.spells={}
    inst:AddComponent("xplevel")
    inst:AddComponent("fa_spellcaster")

    inst.newControlsInit = function (cnt)
    
        local pet=nil

        inst.petBuff=PetBuff(cnt.owner)
        local rage = cnt:AddChild(inst.petBuff)
 --    class.rage:SetHAnchor(ANCHOR_MIDDLE)
  --  class.rage:SetVAnchor(ANCHOR_TOP)
        rage:SetPosition(-250,0,0)
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

end



return MakePlayerCharacter("druid", prefabs, assets, fn)
