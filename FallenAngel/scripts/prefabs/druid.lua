
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
    "spell_earthquake",
    "spell_lightning",
   "spell_grow",
   "spell_heal",
   "spell_guardian"
}

STRINGS.TABS.SPELLS = "Spells"

STRINGS.NAMES.SPELL_LIGHTNING = "Call Lightning"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_LIGHTNING = "Call Lightning"
STRINGS.RECIPE_DESC.SPELL_LIGHTNING = "Call Lightning"

STRINGS.NAMES.SPELL_EARTHQUAKE = "Earthquake"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_EARTHQUAKE = "Earthquake"
STRINGS.RECIPE_DESC.SPELL_EARTHQUAKE = "Earthquake"

STRINGS.NAMES.SPELL_GROW = "Grow"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_GROW = "Grow"
STRINGS.RECIPE_DESC.SPELL_GROW = "Grow"

STRINGS.NAMES.SPELL_HEAL = "Heal"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_HEAL = "Heal"
STRINGS.RECIPE_DESC.SPELL_HEAL = "Heal"

STRINGS.NAMES.SPELL_GUARDIAN = "Summon Tree Guardian"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_GUARDIAN = "Summon Tree Guardian"
STRINGS.RECIPE_DESC.SPELL_GUARDIAN = "Summon Tree Guardian"


local CHOP_SANITY_DELTA=-5
local DIG_SANITY_DELTA=-5
local PICK_SANITY_DELTA=-2
local PLANT_SANITY_DELTA=10
local MURDER_SANITY_DELTA=-5

local ref



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
    inst.pet = SpawnPrefab("fairy")
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
end

local onsavefn = function(inst, data)
    if(inst.pet and inst.pet.components.health and not inst.pet.components.health:IsDead())then
        data.hasPet=true
    else
        data.hasPet=false
    end
end


local fn = function(inst)

        local ref=inst

        
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
                        if(act.invobject and (act.invobject.name=="Grass Tuft" or act.invobject.name=="Sapling" or act.invobject.name=="Pine Cone")) then
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
    end

    inst:ListenForEvent("killed", onmurder)

    inst:AddComponent("reader")

RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}
    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    local r=Recipe("spell_lightning", {Ingredient("fling", 20), Ingredient("bluegem", 4),Ingredient("papyrus", 5)}, booktab, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_brimstone.tex"
    r=Recipe("spell_earthquake", {Ingredient("rocks", 20), Ingredient("redgem", 5),Ingredient("papyrus", 5)}, booktab,{MAGIC = 2})
    r.image="book_brimstone.tex"
    r=Recipe("spell_grow", {Ingredient("papyrus", 2), Ingredient("seeds", 10), Ingredient("poop", 10)}, booktab, {MAGIC = 2})
    r.image="book_gardening.tex"
    r=Recipe("spell_heal", {Ingredient("papyrus", 5), Ingredient("honey", 5),Ingredient("spidergland",10)}, booktab, {MAGIC = 3})
    r.image="book_gardening.tex"
    r=Recipe("spell_guardian", {Ingredient("papyrus", 5), Ingredient("pinecone", 20),Ingredient("livinglog",10)}, booktab, {MAGIC = 3})
    r.image="book_gardening.tex"


    local ground = GetWorld()
--    if(not ground.components.quaker)then     ground:AddComponent("quaker")

end



return MakePlayerCharacter("druid", prefabs, assets, fn)
