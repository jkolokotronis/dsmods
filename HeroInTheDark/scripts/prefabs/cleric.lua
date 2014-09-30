
local MakePlayerCharacter = require "prefabs/player_common"
local CooldownButton = require "widgets/cooldownbutton"
local FA_BuffBar=require "widgets/fa_buffbar"

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
        Asset( "ANIM", "anim/cleric.zip" ),
    Asset( "IMAGE", "images/fa_cleric_bookcraft.tex" ),
    Asset( "IMAGE", "images/fa_cleric_booknext.tex" ),
    Asset( "IMAGE", "images/fa_cleric_bookprev.tex" ),
    Asset( "IMAGE", "images/fa_cleric_bookclose.tex" ),
    Asset( "IMAGE", "images/fa_cleric_bookbackground.tex" ),
    Asset( "IMAGE", "images/fa_cleric_bookframe.tex" ),
    Asset( "ATLAS", "images/fa_cleric_bookcraft.xml" ),
    Asset( "ATLAS", "images/fa_cleric_booknext.xml" ),
    Asset( "ATLAS", "images/fa_cleric_bookprev.xml" ),
    Asset( "ATLAS", "images/fa_cleric_bookclose.xml" ),
    Asset( "ATLAS", "images/fa_cleric_bookbackground.xml" ),
    Asset( "ATLAS", "images/fa_cleric_bookframe.xml" ),
}
local prefabs = {
    "fa_bladebarrier_hitfx",
    "fa_bladebarrierfx"
}

STRINGS.TABS.SPELLS = "Spells"



local HEALTH_PER_LEVEL=3
local SANITY_PER_LEVEL=4
local TURN_UNDEAD_COOLDOWN=480
local TURN_UNDEAD_COOLDOWN_MK2=360
local TURN_UNDEAD_COOLDOWN_MK3=300
local TURN_UNDEAD_INSTA_CHANCE=0.2
local TURN_UNDEAD_RUN_CHANCE=0.7
local TURN_UNDEAD_DURATION=60
local TURN_UNDEAD_RANGE=15

local onloadfn = function(inst, data)
--    inst.lightBuffUp=data.lightBuffUp
--    inst.dmBuffUp=data.dmBuffUp
--    inst.bbBuffUp=data.bbBuffUp
    inst.fa_playername=data.fa_playername
    inst.turncooldowntimer=data.turncooldowntimer
end

local onsavefn = function(inst, data)
--    data.lightBuffUp=inst.buff_timers["light"].cooldowntimer
--    data.dmBuffUp=inst.buff_timers["divinemight"].cooldowntimer
--    data.bbBuffUp=inst.buff_timers["bladebarrier"].cooldowntimer
    data.fa_playername=inst.fa_playername
    data.turncooldowntimer=inst.turnCooldownButton.cooldowntimer
end


local function enableL1spells()
    GetPlayer().fa_spellcraft.spells[1]={
        {
            recname="fa_spell_curelightwounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_mending",
            school=FA_SPELL_SCHOOLS.TRANSMUTATION,
        },
        {
            recname="fa_spell_inflictlightwounds",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_divinemight",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_fear",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_summonmonster1",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_protevil",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
    }
    local r=Recipe("fa_spell_curelightwounds", {Ingredient("red_cap", 6), Ingredient("ash", 6), Ingredient("petals", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_mending", {Ingredient("sewing_kit", 1), Ingredient("nightmarefuel", 6), Ingredient("honey", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_inflictlightwounds", {Ingredient("charcoal", 6), Ingredient("nightmarefuel", 4), Ingredient("monstermeat", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
--    local r=Recipe("fa_spell_resistance", {Ingredient("pigskin", 2), Ingredient("beefalowool", 6), Ingredient("cutgrass", 8)}, RECIPETABS.SPELLS,TECH.NONE)
--    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_fear", {Ingredient("nightmarefuel", 6), Ingredient("twigs", 6), Ingredient("petals_evil", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster1", {Ingredient("papyrus", 4), Ingredient("silk", 2), Ingredient("spidergland", 2)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_protevil", {Ingredient("houndstooth", 2), Ingredient("goldnugget", 6), Ingredient("healingsalve", 2)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_divinemight", {Ingredient("meat", 5), Ingredient("monstermeat", 5), Ingredient("papyrus", 8)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_brimstone.tex"
end
local function enableL2spells()
    GetPlayer().fa_spellcraft.spells[2]={
        {
            recname="fa_spell_aid",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_curemoderatewounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_inflictmoderatewounds",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_holdperson",
            school=FA_SPELL_SCHOOLS.ENCHANTMENT,
        },
        {
            recname="fa_spell_summonmonster2",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
    }
    local r=Recipe("fa_spell_aid", {Ingredient("bird_egg", 1), Ingredient("meat", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curemoderatewounds", {Ingredient("green_cap", 6), Ingredient("ash", 6), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_inflictmoderatewounds", {Ingredient("nightmarefuel", 6), Ingredient("monstermeat", 8), Ingredient("charcoal", 8)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_holdperson", {Ingredient("meat", 2), Ingredient("silk", 6), Ingredient("honey", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster2",  {Ingredient("fish", 4), Ingredient("froglegs", 4), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"


end
local function enableL3spells()
    GetPlayer().fa_spellcraft.spells[3]={
        {
            recname="fa_spell_animatedead",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_causedisease",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_createfood",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_continualflame",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="fa_spell_cureseriouswounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_inflictseriouswounds",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_summonmonster3",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
    }

    local r=Recipe("fa_spell_animatedead", {Ingredient("nightmarefuel", 10), Ingredient("boneshard", 5), Ingredient("papyrus", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_causedisease", {Ingredient("nightmarefuel", 9), Ingredient("spidergland", 5), Ingredient("monstermeat", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_createfood", {Ingredient("seeds", 2), Ingredient("poop", 4), Ingredient("papyrus", 2)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_continualflame", {Ingredient("lantern", 1), Ingredient("nightmarefuel", 8), Ingredient("fireflies", 2)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_cureseriouswounds", {Ingredient("blue_cap", 6), Ingredient("ash", 8), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_inflictseriouswounds", {Ingredient("nightmarefuel", 8), Ingredient("monstermeat", 10), Ingredient("charcoal", 10)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster3", {Ingredient("pigskin", 2), Ingredient("poop", 6), Ingredient("papyrus", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

end
local function enableL4spells()
    GetPlayer().fa_spellcraft.spells[4]={
        {
            recname="fa_spell_curecriticalwounds",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_inflictcriticalwounds",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_curepoison",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_poison",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_summonmonster4",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
    }

    local r=Recipe("fa_spell_curecriticalwounds", {Ingredient("blue_cap", 12), Ingredient("ash", 8), Ingredient("petals", 15)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_inflictcriticalwounds", {Ingredient("nightmarefuel", 10), Ingredient("monstermeat", 12), Ingredient("charcoal", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curepoison", {Ingredient("mosquitosack", 2), Ingredient("silk", 12), Ingredient("honey", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_poison", {Ingredient("spidergland", 6), Ingredient("mosquitosack", 4), Ingredient("twigs", 10)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_summonmonster4", {Ingredient("bluegem", 1), Ingredient("houndstooth", 4), Ingredient("papyrus", 6)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

end
local function enableL5spells()
    GetPlayer().fa_spellcraft.spells[5]={
        {
            recname="fa_spell_atonement",
            school=FA_SPELL_SCHOOLS.ABJURATION,
        },
        {
            recname="fa_spell_curelightwoundsmass",
            school=FA_SPELL_SCHOOLS.CONJURATION,
        },
        {
            recname="fa_spell_inflictlightwoundsmass",
            school=FA_SPELL_SCHOOLS.NECROMANCY,
        },
        {
            recname="fa_spell_flamestrike",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
        {
            recname="spell_bladebarrier",
            school=FA_SPELL_SCHOOLS.EVOCATION,
        },
    }
    local r=Recipe("fa_spell_atonement", {Ingredient("charcoal", 10), Ingredient("butterfly", 4), Ingredient("monstermeat", 4)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_curelightwoundsmass", {Ingredient("red_cap", 12), Ingredient("ash", 12), Ingredient("petals", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_inflictlightwoundsmass", {Ingredient("charcoal", 12), Ingredient("nightmarefuel", 8), Ingredient("monstermeat", 12)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"
    local r=Recipe("fa_spell_flamestrike", {Ingredient("redgem", 2), Ingredient("ash", 10), Ingredient("gunpowder", 5)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_gardening.tex"

    local r=Recipe("spell_bladebarrier", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, RECIPETABS.SPELLS, TECH.NONE)
    r.image="book_gardening.tex"
end

local function enableL6spells() 
    GetPlayer().fa_spellcraft.spells[6]={
        {
            recname="spell_calldiety",
            school=FA_SPELL_SCHOOLS.DIVINATION,
        },
    }
    local  r=Recipe("spell_calldiety", {Ingredient("redgem", 4), Ingredient("cutgrass", 5), Ingredient("rocks", 20)}, RECIPETABS.SPELLS,TECH.NONE)
    r.image="book_brimstone.tex"
end
local function enableL7spells() end
local function enableL8spells() end
local function enableL9spells() end

local function onturnundead(clr)
    local pos=Vector3(clr.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TURN_UNDEAD_RANGE)
        for k,v in pairs(ents) do
            if (not v:HasTag("player") and not v:HasTag("pet") and v.components.combat and not v:IsInLimbo() and v:HasTag("undead")) then

                local rng=math.random()
                print("turn undead rng",rng)
                if(rng<TURN_UNDEAD_INSTA_CHANCE)then
                    --i need instakill but i also need to get this thing to recognize the killer... 2^31-1 or 2^63-1? if he's invuln he wont die but w/e
                    v.components.combat:GetAttacked(clr,999999)
                elseif(rng<TURN_UNDEAD_RUN_CHANCE)then

                local inst = CreateEntity()
                inst.entity:AddTransform()

                local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_turnundead"
    inst.components.spell.duration = TURN_UNDEAD_DURATION
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_fear = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function() end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_fear = nil
    end
    inst.components.spell.fn = function(inst, target, variables) end
    inst.components.spell.resumefn = function() end
    inst.components.spell.removeonfinish = true

                inst.components.spell:SetTarget(v)
                inst.components.spell:StartSpell()

                end
            end
        end
        return true
end
    
local function addLightAura(inst)
--    local inst=GetPlayer()
    print("adding aura",inst)
    local light=inst.Light
     if(light==nil) then
        light=inst.entity:AddLight()
    end

    light:SetRadius(2)
    light:SetFalloff(0.75)
    light:SetIntensity(0.9)
    light:SetColour(235/255,121/255,12/255)

    light:Enable(true)
    
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    inst.components.fa_spellcaster.casterlevel=level
    if(level>=2)then
        enableL1spells()
    end
    if(level>=4)then
    end
    if(level>=5)then
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
    if(level>=18)then
        enableL8spells()
    end
    if(level>=20)then
        addLightAura(inst)
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
    elseif(level==3)then
        inst.turnCooldownButton:Show()
    elseif(level==5)then
        enableL2spells()
    elseif(level==8)then
        enableL3spells()
    elseif(level==9)then
        inst.turnCooldownButton:SetCooldown(TURN_UNDEAD_COOLDOWN_MK2)
    elseif(level==10)then
        enableL4spells()
    elseif(level==12)then
        enableL5spells()
    elseif(level==14)then
        enableL6spells()
    elseif(level==16)then
        enableL7spells()
    elseif(level==18)then
        inst.turnCooldownButton:SetCooldown(TURN_UNDEAD_COOLDOWN_MK3)
        enableL8spells()
    elseif(level==20)then
        addLightAura(inst)
        enableL9spells()
    end
end


local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "cleric.tex" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=1.25
	inst.components.health:SetMaxHealth(200)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

    inst:AddComponent("reader")
    inst:AddComponent("fa_spellcaster")
    inst:AddComponent("xplevel")

--    inst:AddTag("fa_spellcaster")
    inst.fa_spellcraft={}
    inst.fa_spellcraft.spells={}

    inst:AddTag("fa_shielduser")

    inst.buff_timers={}
--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}
    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    
    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)

    inst.newControlsInit = function (class)

    --[[
        local btn=InitBuffBar(inst,"light",inst.lightBuffUp,class,"light")
        btn:SetPosition(-100,0,0)
        LightSpellStart(inst,inst.lightBuffUp )
        local btn=InitBuffBar(inst,"divinemight",inst.dmBuffUp,class,"DM")
        btn:SetPosition(0,0,0)
        DivineMightSpellStart(inst,inst.dmBuffUp )
        local btn=InitBuffBar(inst,"bladebarrier",inst.bbBuffUp,class,"BB")
        btn:SetPosition(100,0,0)
        BladeBarrierSpellStart(inst,inst.bbBuffUp )
]]
        inst.turnCooldownButton=CooldownButton(class.owner)
        inst.turnCooldownButton:SetText("Turn")
        inst.turnCooldownButton:SetOnClick(function() return onturnundead(inst) end)
        local turncooldown=TURN_UNDEAD_COOLDOWN
        if(inst.components.xplevel.level>=18)then
            turncooldown=TURN_UNDEAD_COOLDOWN_MK3
        elseif(inst.components.xplevel.level>=9)then
            turncooldown=TURN_UNDEAD_COOLDOWN_MK2
        end
        inst.turnCooldownButton:SetCooldown(turncooldown)
        if(inst.turncooldowntimer and inst.turncooldowntimer>0)then
             inst.turnCooldownButton:ForceCooldown(inst.turncooldowntimer)
        end
        local htbtn=class:AddChild(inst.turnCooldownButton)
        htbtn:SetPosition(-250,0,0)
        htbtn:Show()         
        if(inst.components.xplevel.level<3)then
            inst.turnCooldownButton:Hide()
        end
    end

end



return MakePlayerCharacter("cleric", prefabs, assets, fn)
