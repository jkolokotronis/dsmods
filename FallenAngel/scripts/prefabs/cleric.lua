
local MakePlayerCharacter = require "prefabs/player_common"
local CooldownButton = require "widgets/cooldownbutton"


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
        Asset( "ANIM", "anim/betterbarrier.zip" ),
        Asset( "ANIM", "anim/flash_b.zip" ),
}
local prefabs = {}

STRINGS.TABS.SPELLS = "Spells"

STRINGS.NAMES.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_DIVINEMIGHT = "Divine Might"
STRINGS.RECIPE_DESC.SPELL_DIVINEMIGHT = "Divine Might"

STRINGS.NAMES.SPELL_CALLDIETY = "Call Diety"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_CALLDIETY = "Call Diety"
STRINGS.RECIPE_DESC.SPELL_CALLDIETY = "Call Diety"

STRINGS.NAMES.SPELL_LIGHT = "Banish Darkness"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_LIGHT = "Banish Darkness"
STRINGS.RECIPE_DESC.SPELL_LIGHT = "Banish Darkness"

STRINGS.NAMES.SPELL_HEAL = "Heal"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_HEAL = "Heal"
STRINGS.RECIPE_DESC.SPELL_HEAL = "Heal"

STRINGS.NAMES.SPELL_BLADEBARRIER = "Blade Barrier"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SPELL_BLADEBARRIER = "Blade Barrier"
STRINGS.RECIPE_DESC.SPELL_BLADEBARRIER = "Blade Barrier"

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
    inst.lightBuffUp=data.lightBuffUp
    inst.dmBuffUp=data.dmBuffUp
    inst.bbBuffUp=data.bbBuffUp
    inst.fa_playername=data.fa_playername
    inst.turncooldowntimer=data.turncooldowntimer
end

local onsavefn = function(inst, data)
    data.lightBuffUp=inst.buff_timers["light"].cooldowntimer
    data.dmBuffUp=inst.buff_timers["divinemight"].cooldowntimer
    data.bbBuffUp=inst.buff_timers["bladebarrier"].cooldowntimer
    data.fa_playername=inst.fa_playername
    data.turncooldowntimer=inst.turnCooldownButton.cooldowntimer
end


local function enableL1spells()
    local r=Recipe("spell_divinemight", {Ingredient("meat", 5), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_brimstone.tex"
end
local function enableL2spells()
    local r=Recipe("spell_light", {Ingredient("fireflies", 2),Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS, {MAGIC = 2})
    r.image="book_gardening.tex" 
end
local function enableL3spells()
    local r=Recipe("spell_heal", {Ingredient("spidergland",5),Ingredient("cutgrass", 5), Ingredient("rocks", 15)}, RECIPETABS.SPELLS, {MAGIC = 3})
    r.image="book_gardening.tex"
end
local function enableL4spells()
    local  r=Recipe("spell_calldiety", {Ingredient("redgem", 4), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS,{MAGIC = 2})
    r.image="book_brimstone.tex"
end
local function enableL5spells()
    local r=Recipe("spell_bladebarrier", {Ingredient("papyrus", 2), Ingredient("redgem", 1)}, RECIPETABS.SPELLS, {MAGIC = 3})
    r.image="book_gardening.tex"
end

local function onturnundead(clr)
    local pos=Vector3(clr.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TURN_UNDEAD_RANGE)
        for k,v in pairs(ents) do
            if (not v:HasTag("player") and not v:HasTag("pet") and v.components.combat and not v:IsInLimbo() and v:HasTag("undead")) then

                local rng=math.random()
                if(rng<TURN_UNDEAD_INSTA_CHANCE)then
                    --i need instakill but i also need to get this thing to recognize the killer... 2^31-1 or 2^63-1? if he's invuln he wont die but w/e
                    v.components.combat:GetAttacked(clr,999999)
                elseif(rng<TURN_UNDEAD_RUN_CHANCE)then

                local inst = CreateEntity()
                inst.entity:AddTransform()

                local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_turnundead"
    inst.components.spell.duration = timer
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_turnundead = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onstartfn = function() end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_turnundead = nil
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
     if(not inst.Light) then
        inst.entity:AddLight()
    end

    inst.Light:SetRadius(2)
    inst.Light:SetFalloff(0.75)
    inst.Light:SetIntensity(0.9)
    inst.Light:SetColour(235/255,121/255,12/255)

    inst.Light:Enable(true)
    
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>=3)then
        inst.turnCooldownButton:Show()
    end
    if(level>=4)then
        enableL1spells()
    end
    if(level>=7)then
        enableL2spells()
    end
    if(level>=9)then
        enableL3spells()
    end
    if(level>=11)then
        enableL4spells()
    end
    if(level>=14)then
        enableL5spells()
    end
    if(level>=20)then
        addLightAura(inst)
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
        inst.turnCooldownButton:Show()
    elseif(level==4)then
        enableL1spells()
    elseif(level==7)then
        enableL2spells()
    elseif(level==9)then
        enableL3spells()
    elseif(level==11)then
        enableL4spells()
    elseif(level==14)then
        enableL5spells()
    elseif(level==20)then
        addLightAura(inst)
    end
end


local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=1.25
	inst.components.health:SetMaxHealth(200)
	inst.components.sanity:SetMax(300)
	inst.components.hunger:SetMax(125)

    inst:AddComponent("reader")
    inst:AddComponent("xplevel")

    inst.buff_timers={}
--    inst.buff_timers["light"]={}
--    inst.buff_timers["divinemight"]={}
--    inst.buff_timers["bladebarrier"]={}

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}--, icon_atlas = "images/inventoryimages/herotab.xml"}
    local booktab=RECIPETABS.SPELLS
--    inst.components.builder:AddRecipeTab(booktab)
    

    inst.newControlsInit = function (class)
        local btn=InitBuffBar(inst,"light",inst.lightBuffUp,class,"light")
        btn:SetPosition(-100,0,0)
        LightSpellStart(inst,inst.lightBuffUp )
        local btn=InitBuffBar(inst,"divinemight",inst.dmBuffUp,class,"DM")
        btn:SetPosition(0,0,0)
        DivineMightSpellStart(inst,inst.dmBuffUp )
        local btn=InitBuffBar(inst,"bladebarrier",inst.bbBuffUp,class,"BB")
        btn:SetPosition(100,0,0)
        BladeBarrierSpellStart(inst,inst.bbBuffUp )

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
        htbtn:SetPosition(200,0,0)
        htbtn:Show()         
        if(inst.components.xplevel.level<3)then
            inst.turnCooldownButton:Hide()
        end
    end

end



return MakePlayerCharacter("cleric", prefabs, assets, fn)
