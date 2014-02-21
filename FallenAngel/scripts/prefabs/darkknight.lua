
local MakePlayerCharacter = require "prefabs/player_common"

local CooldownButton = require "widgets/cooldownbutton"
local PetBuff = require "widgets/petbuff"
local Widget = require "widgets/widget"
local Sanity=require "components/sanity"

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
        Asset( "ANIM", "anim/darkknight.zip" ),
}
local prefabs = {
    "dksword"
}

--        SANITY_NIGHT_MID = -100/(300*20),
local HT_RANGE=5
local HT_DAMAGE=500
local HT_LEECH=150
local HT_COOLDOWN=480

local BLAST_DMG=30
local BLAST_LEECH=30
local BLAST_HUNGER=-30
local BLAST_RANGE=20
local BLAST_COOLDOWN=60


local function spawnPet(inst)
    local leader=inst.components.leader
    local pet=inst.pet
    if(pet and not pet.components.health:IsDead())then
        return
    end
--    local pet=TheSim:FindFirstEntityWithTag("pet")

--    if(pet)then
--        inst.pet=pet
--    else
        inst.pet = SpawnPrefab("darkknightpet")
--    end
    inst.pet.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
    inst.components.leader:AddFollower(inst.pet)
    inst.pet:ListenForEvent("death",function()
        inst.petBuff:OnPetDies()
    end)
    inst.pet:ListenForEvent("stopfollowing",function(f)
        f.components.health:Kill()
        inst.pet=nil
    end)
end

local function despawnPet(inst)
    local leader=inst.components.leader
    local pet=inst.pet

    if(pet and pet.components.health and not pet.components.health:IsDead()) then
        pet.components.health:Kill()
        inst.pet=nil
    end
end


local onloadfn = function(inst, data)
    inst.hasPet=data.hasPet
    inst.htcooldowntimer=data.htcooldowntimer
    inst.leechcooldowntimer=data.leechcooldowntimer
end

local onsavefn = function(inst, data)
    if(inst.pet and inst.pet.components.health and not inst.pet.components.health:IsDead())then
        data.hasPet=true
    else
        data.hasPet=false
    end
    data.htcooldowntimer=inst.htCooldownButton.cooldowntimer
    data.leechcooldowntimer=inst.leechCooldownButton.cooldowntimer
end

local onleechblast=function(inst)
    local leechamount=0
    local pos=Vector3(GetPlayer().Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BLAST_RANGE)
    for k,v in pairs(ents) do
        if not v:IsInLimbo() then
            if( not v:HasTag("player") and not v:HasTag("pet") and v.components.combat) then
                v.components.combat:GetAttacked(GetPlayer(), BLAST_DMG, nil)
                leechamount=leechamount+BLAST_LEECH
            end
        end
    end
    if(leechamount>0)then
        GetPlayer().components.hunger:DoDelta(BLAST_HUNGER)
        GetPlayer().components.health:DoDelta(leechamount)
        return true
    else
        return false
    end
end

local onharmtouch=function(inst)
    local hit=false
    local pos=Vector3(GetPlayer().Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, HT_RANGE)
    for k,v in pairs(ents) do
        if not v:IsInLimbo() then
            if( not v:HasTag("player") and not v:HasTag("pet") and v.components.combat) then
                v.components.combat:GetAttacked(GetPlayer(), HT_DAMAGE, nil)
                return true
            end
        end
    end
    return hit
end

local fn = function(inst)
	
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.combat.damagemultiplier=1.5
	inst.components.health:SetMaxHealth(250)
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(150)
    inst.components.sanity.night_drain_mult = 0


    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst:AddTag("evil")



    inst.newControlsInit = function (cnt)
        local pet=nil
    
        inst.petBuff=PetBuff(cnt.owner)
        local rage = cnt:AddChild(inst.petBuff)
 --    class.rage:SetHAnchor(ANCHOR_MIDDLE)
  --  class.rage:SetVAnchor(ANCHOR_TOP)
        rage:SetPosition(0,0,0)
        rage:SetOnClick(function(state) 
            if(state and state=="on") then
                spawnPet(inst)
            else
                despawnPet(inst)
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
                inst.pet:ListenForEvent("death",function()
                inst.petBuff:OnPetDies()
                end)
            end
        end

        inst.htCooldownButton=CooldownButton(cnt.owner)
        inst.htCooldownButton:SetText("HT")
        inst.htCooldownButton:SetOnClick(onharmtouch)
        inst.htCooldownButton:SetCooldown(HT_COOLDOWN)
        if(inst.htcooldowntimer and inst.htcooldowntimer>0)then
             inst.htCooldownButton:ForceCooldown(inst.htcooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.htCooldownButton)
        htbtn:SetPosition(-100,0,0)

        inst.leechCooldownButton=CooldownButton(cnt.owner)
        inst.leechCooldownButton:SetText("Blast")
        inst.leechCooldownButton:SetCooldown(BLAST_COOLDOWN)
        inst.leechCooldownButton:SetOnClick(onleechblast)
        if(inst.leechcooldowntimer and inst.leechcooldowntimer>0)then
             inst.leechCooldownButton:ForceCooldown(inst.leechcooldowntimer)
        end
        local leechbtn=cnt:AddChild(inst.leechCooldownButton)
        leechbtn:SetPosition(100,0,0)
    end
local prefabs1 = {
    "dksword",
}
   
    inst.components.inventory:GuaranteeItems(prefabs1)

end



return MakePlayerCharacter("darkknight", prefabs, assets, fn)
