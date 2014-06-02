
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
        Asset("ANIM","anim/blood_splash.zip"),
        Asset("ANIM","anim/blood_down.zip"),
        Asset("ANIM","anim/blood_drop.zip"),
        Asset("ANIM","anim/bloodcircle.zip"),
        Asset("ANIM","anim/fa_skhorns.zip"),
}
local prefabs = {
    "dksword",
    "fa_blooddownfx",
    "fa_blooddropfx",
    "fa_bloodsplashfx"
}

--        SANITY_NIGHT_MID = -100/(300*20),
local HT_RANGE=5
local HT_DAMAGE=500
local HT_LEECH=250
local HT_COOLDOWN=1920

local BLAST_DMG=30
local BLAST_LEECH=30
local BLAST_HUNGER=-30
local BLAST_RANGE=15
local BLAST_COOLDOWN=960


local function spawnPet(inst)
    local leader=inst.components.leader
    local pet=inst.pet
    if(pet and not pet.components.health:IsDead())then
        return
    end
    inst.pet = SpawnPrefab("darkknightpet")
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
    inst.fa_playername=data.fa_playername
end

local onsavefn = function(inst, data)
    if(inst.pet and inst.pet.components.health and not inst.pet.components.health:IsDead())then
        data.hasPet=true
    else
        data.hasPet=false
    end
    data.htcooldowntimer=inst.htCooldownButton.cooldowntimer
    data.leechcooldowntimer=inst.leechCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
end

local onleechblast=function(inst)
    local leechamount=0
    local pos=Vector3(GetPlayer().Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, BLAST_RANGE,nil,{"player","pet","companion","INLIMBO"})
    for k,v in pairs(ents) do
            if( v.components.combat and not (v.components.health and v.components.health:IsDead())) then

                local pos1=v:GetPosition()

                local boom =SpawnPrefab("fa_blooddownfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.fa_rotate(GetPlayer())
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)


                local proj =SpawnPrefab("fa_blooddropfx")
                proj.Transform:SetScale(2, 2, 2)
                MakeInventoryPhysics(proj)
--                RemovePhysicsColliders(proj)    
                proj:AddTag("projectile")    
                proj:AddComponent("projectile")
                proj.Transform:SetPosition(pos1.x, pos1.y, pos1.z)
                proj.fa_rotate(GetPlayer())
                proj.components.projectile:SetSpeed(20)
--                proj.components.projectile:SetOnHitFn(function() proj:Remove() end)
                proj.components.projectile:SetOnMissFn(function() proj:Remove() end)
--              we dont want to hit ourselves                
                function proj.components.projectile:Hit(target)
                    self:Stop()
                    self.inst.Physics:Stop()
                    self.inst:Remove() 
                end
                proj.components.projectile:Throw(v, GetPlayer(), GetPlayer())
--                proj.Transform:SetRotation(angle)

                v.components.combat:GetAttacked(GetPlayer(), BLAST_DMG, nil,nil,FA_DAMAGETYPE.DEATH)
                leechamount=leechamount+BLAST_LEECH

            end
    end
    if(leechamount>0)then
        GetPlayer().components.hunger:DoDelta(BLAST_HUNGER)
        GetPlayer().components.health:DoDelta(leechamount)


        GetPlayer().SoundEmitter:PlaySound("dontstarve/common/blackpowder_explo")
--        boom:DoTaskInTime(1, function() boom:Remove() end )

        
        return true
    else
        return false
    end
end

local onharmtouch=function(inst)
    local hit=false
    local pos=Vector3(GetPlayer().Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, HT_RANGE,nil,{"player","pet","companion","INLIMBO"})
    for k,v in pairs(ents) do
            if(v.components.combat and not (v.components.health and v.components.health:IsDead())) then
                v.components.combat:GetAttacked(GetPlayer(), HT_DAMAGE, nil,nil,FA_DAMAGETYPE.DEATH)

                local boom =SpawnPrefab("fa_bloodsplashfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(v.GUID, v.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.fa_rotate(GetPlayer())
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)

                return true
            end
    end
    return hit
end

local fn = function(inst)
	
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "darkknight.tex" )

	-- todo: Add an example special power here.
	inst.components.combat.damagemultiplier=1.5
	inst.components.health:SetMaxHealth(250)
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(150)
    inst.components.sanity.night_drain_mult = 0

    inst:AddComponent("xplevel")

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst:AddTag("evil")
    inst:AddTag("fa_shielduser")

 inst.AnimState:OverrideSymbol("headbase_hat", "fa_skhorns", "horns4")
inst:ListenForEvent("equip",function(inst,data)
    local slot=data.eslot
    if(EQUIPSLOTS.HEAD==slot)then
        inst.AnimState:OverrideSymbol("headbase_hat", "shadowknight", "headbase_hat")
--        inst.AnimState:Show("HAIR")
--        inst.AnimState:Show("HAIR_NOHAT")
--        inst.AnimState:Show("HEAD")
--    inst.AnimState:OverrideSymbol("face", "fa_skhorns", "horns4")
--    inst.AnimState:OverrideSymbol("hat", "fa_skhorns", "horns4")
--    inst.AnimState:OverrideSymbol("hair", "fa_skhorns", "horns4")
--    inst.AnimState:OverrideSymbol("swap_hat", "fa_skhorns", "horns4")
    end
end)

inst:ListenForEvent("unequip",function(inst,data)
    print("unequip")
    if(EQUIPSLOTS.HEAD==data.eslot)then
         inst.AnimState:OverrideSymbol("headbase_hat", "fa_skhorns", "horns4")
    end
end)



--[[



    inst.skhorns = CreateEntity()
    inst.skhorns.entity:AddTransform()
    local fxanim=inst.skhorns.entity:AddAnimState()
--    inst.skhorns.Transform:SetFourFaced()
    fxanim:SetBank("fa_skhorns")
    fxanim:SetBuild("fa_skhorns")
    
    fxanim:PlayAnimation("horns4",true)
    inst.skhorns:AddTag("NOCLICK")
    inst.skhorns:AddTag("FX")
    inst.skhorns.entity:SetParent( inst.entity )
--    fxanim:SetOrientation( ANIM_ORIENTATION.OnGround )
    local follower = inst.skhorns.entity:AddFollower()
    follower:FollowSymbol(inst.GUID, "hair",0,0,0)
]]

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
