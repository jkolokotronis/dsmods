
local MakePlayerCharacter = require "prefabs/player_common"
local CooldownButton=require "widgets/cooldownbutton"

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
        Asset( "ANIM", "anim/ranger.zip" ),
        Asset( "ANIM", "anim/fa_arrowpointers.zip" ),
}
local prefabs = {}


STRINGS.NAMES.NATURESHEALING = "Nature's Healing Medicine"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NATURESHEALING = "Nature's Healing Medicine"
STRINGS.RECIPE_DESC.NATURESHEALING = "Nature's Healing Medicine"

local DAMAGE_MULT=1
local FLURRY_COOLDOWN=480
local FORAGE_COOLDOWN=480
local MURDER_SANITY_DELTA=-1
local EXTERMINATE_SANITY_DELTA=5
local FLURRY_RANGE=20
local TRACK_RANGE=100

local forage_table={
    "carrot",
    "cave_banana",
    "corn",
    "pumpkin",
    "eggplant",
    "durian",
    "pomegranate",
    "dragonfruit",
    "berries",
    "mandrake"
}


local function onmurder(inst,data)
    local victim=data.victim
    if(victim:HasTag("animal") or victim:HasTag("bird"))then
        inst.components.sanity:DoDelta(MURDER_SANITY_DELTA)
    else
        if(victim:HasTag("monster") or victim:HasTag("undead"))then
             inst.components.sanity:DoDelta(EXTERMINATE_SANITY_DELTA)
        end
    end
end

local onforage=function()
    local roll=forage_table[math.random(1, #forage_table)]
    local item=SpawnPrefab(roll)
    local spawn_point= Vector3(GetPlayer().Transform:GetWorldPosition())
    item.Physics:Teleport(spawn_point.x,35,spawn_point.z)
    return true
end

local onflurry=function()
    local weapon=GetPlayer().components.combat:GetWeapon()
    local pos=Getplayer():GetPosition()
    if(weapon and weapon:HasTag("bow"))then
        local targ=nil
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FLURRY_RANGE,nil,{"player","pet","companion","INLIMBO"})
        for k,v in pairs(ents) do
            if( v.components.combat and not (v.components.health and v.components.health:IsDead()) and v.components.combat.target==GetPlayer()) then
                targ=v
                break
            end
        end
        
        inst:DoTaskInTime(0,function()
            for i=1,3 do
                weapon.components.weapon:LaunchProjectile(GetPlayer(), targ)
                Sleep(0.2)
            end
        end)
        
    end
    return false
end

local track=function(tags)
        local targ=nil
        local pos=Getplayer():GetPosition()
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TRACK_RANGE,tags,{"player","pet","companion","INLIMBO"})
        for k,v in pairs(ents) do
            if( v.components.combat and not (v.components.health and v.components.health:IsDead()) and v.components.combat.target==GetPlayer()) then
                targ=v
                local angle = node:GetAngleToPoint(v:GetPosition())
                local boom = CreateEntity()
                boom:AddTag("FX")
                boom:AddTag("NOCLICK")
                boom.entity:AddTransform()
                local anim=boom.entity:AddAnimState()
                anim:SetBank("fa_arrowpointers")
                anim:SetBuild("fa_arrowpointers")
                boom.Transform:SetPosition(pos.x, pos.y, pos.z)
                anim:SetOrientation( ANIM_ORIENTATION.OnGround )
                boom.Transform:SetRotation(angle)
                anim:PlayAnimation("idle",true)
                boom.persists=false

                local follower = boom.entity:AddFollower()
                follower:FollowSymbol( GetPlayer().GUID, "swap_object", 0.1, -50, -0.0001 )

                break
            end
        end
end

local onloadfn = function(inst, data)
    inst.foragecooldowntimer=data.foragecooldowntimer
    inst.flurrycooldowntimer=data.flurrycooldowntimer
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    data.foragecooldowntimer=inst.forageCooldownButton.cooldowntimer
    data.flurrycooldowntimer=inst.flurryCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
end

local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "ranger.tex" )

	-- todo: Add an example special power here.
    inst.components.combat.damagemultiplier=DAMAGE_MULT
	inst.components.health:SetMaxHealth(190)
	inst.components.sanity:SetMax(150)
	inst.components.hunger:SetMax(200)

    inst:AddComponent("xplevel")
    inst:ListenForEvent("killed", onmurder)
   
    local r=Recipe("arrows", {Ingredient("twigs", 5), Ingredient("houndstooth", 1)},  RECIPETABS.WAR,  {SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("bow", {Ingredient("twigs", 2), Ingredient("rope", 1),Ingredient("pigskin", 1)}, RECIPETABS.WAR,{SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("natureshealing", {Ingredient("berries", 2), Ingredient("honey", 1),Ingredient("papyrus", 2)},  RECIPETABS.SURVIVAL,{SCIENCE = 1})
    r.image="book_brimstone.tex"

    inst.newControlsInit = function (cnt)

        inst.forageCooldownButton=CooldownButton(cnt.owner)
        inst.forageCooldownButton:SetText("Forage")
        inst.forageCooldownButton:SetOnClick(onforage)
        inst.forageCooldownButton:SetCooldown(FORAGE_COOLDOWN)
        if(inst.foragecooldowntimer and inst.foragecooldowntimer>0)then
             inst.forageCooldownButton:ForceCooldown(inst.foragecooldowntimer)
        end
        local foragebtn=cnt:AddChild(inst.forageCooldownButton)
        foragebtn:SetPosition(-100,0,0)

        inst.flurryCooldownButton=CooldownButton(cnt.owner)
        inst.flurryCooldownButton:SetText("Flurry")
        inst.flurryCooldownButton:SetCooldown(FLURRY_COOLDOWN)
        inst.flurryCooldownButton:SetOnClick(onflurry)
        if(inst.flurrycooldowntimer and inst.flurrycooldowntimer>0)then
             inst.flurryCooldownButton:ForceCooldown(inst.flurrycooldowntimer)
        end
        local flurrybtn=cnt:AddChild(inst.flurryCooldownButton)
        flurrybtn:SetPosition(100,0,0)
    end

end

return MakePlayerCharacter("ranger", prefabs, assets, fn)
