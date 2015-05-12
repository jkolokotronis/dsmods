
local MakePlayerCharacter = require "prefabs/player_common"
local KiBadge=require "widgets/kibadge"
local KiBar=require "components/kibar"
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
        Asset( "ANIM", "anim/fa_monk.zip" ),
        Asset( "ANIM", "anim/fa_ghoul.zip" ),
        Asset( "ANIM", "anim/fa_monk_level_overrides.zip" ),
}
local prefabs = {}

local BASE_MS=1.0*TUNING.WILSON_RUN_SPEED
local UNARMED_DAMAGE=TUNING.UNARMED_DAMAGE*4
local MAX_KI=10
local KI_LEVEL_INCREASE=10
local KI_ATTACK_INCREASE=1

local KIBUFF_MS=0.5*TUNING.WILSON_RUN_SPEED
local KIBUFF_EVASION=0.3
local KIBUFF_GREATEREVASION=0.65
local KIBUFF_STRIKE=1
local KIBUFF_IMPROVEDSTRIKE=2
local KIBUFF_ABSORB=50
local KIBUFF_REGEN=1
local KIBUFF_SANITY=1

local HEALTH_PER_LEVEL=7
local HUNGER_PER_LEVEL=-2
local CAPSTONE_DR=10

local onhitother=function(inst,data)
    local damage=data.damage
    local weapon=inst.components.combat:GetWeapon()
    local item=inst.components.inventory:GetEquippedItem(EQUIPSLOTS.BODY)
    if(item and item.components.armor and not (item:HasTag("fa_robe") or item:HasTag("fa_cloth")))then return end
    local item=inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HEAD)
    if(item and item.components.armor and not (item:HasTag("fa_robe") or item:HasTag("fa_cloth")))then return end
    --not catching onequip because of all sorts of 'usable' objects that shouldnt reset ki - cutting trees, mining, whatever particular 'usable' thing
    --shouldn't be 'that' problematic performance wise
    if(weapon and not weapon:HasTag("unarmed"))then
        inst.components.kibar:SetPercent(0)
        return
    end
    if(damage and damage>0) and (not weapon or weapon:HasTag("unarmed"))then
        local kiboost=KI_ATTACK_INCREASE
        if(weapon and weapon.fa_kiboost)then
            kiboost=kiboost+weapon.fa_kiboost
        end
        inst.components.kibar:DoDelta(kiboost)
    end
end
local function headoverride(inst,level)
    if(level>=20)then
        inst.AnimState:OverrideSymbol("headbase_hat", "fa_monk_level_overrides", "headbase_3")
        inst.AnimState:OverrideSymbol("headbase", "fa_monk_level_overrides", "headbase_3")
    elseif(level>=10)then
        inst.AnimState:OverrideSymbol("headbase_hat", "fa_monk_level_overrides", "headbase_2")
        inst.AnimState:OverrideSymbol("headbase", "fa_monk_level_overrides", "headbase_2")
    end
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    inst.components.kibar.max=math.min(KI_LEVEL_INCREASE*level,100)
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL*(level-1)
        headoverride(inst,level)
        if(level>=3)then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if(level>=4)then
            inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
        end
        if level>=5 then
        end
        if level>=6 then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=8 then
            inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]+0.5
        end
        if level>=11 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=13 then
            inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1       
        end
        if level>=15 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=18 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
        end
        if level>=19 then
            inst.components.hunger.hungerrate=inst.components.hunger.hungerrate*0.75
        end
        if level==20 then
            inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]+CAPSTONE_DR
        end
    end
end

local function onlevelup(inst,data)
    local level=data.level
    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL
    headoverride(inst,level)
    if(level<=10)then
        inst.components.kibar.max=KI_LEVEL_INCREASE*level
    end
    if(level==3)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif(level==4)then
            inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    elseif(level==5)then
        inst.meditateCooldownButton:Show()
    elseif level==6 then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==8 then
        inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]+0.5
    elseif(level==10)then
        inst.kickCooldownButton:Show()
    elseif level==11 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==13 then
            inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1   
    elseif(level==14)then
            inst.furyCooldownButton:Show()
    elseif level==15 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif level==17 then
            inst.whirlwindCooldownButton:Show()
    elseif level==18 then
            inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED        
    elseif level==19 then
            inst.components.hunger.hungerrate=inst.components.hunger.hungerrate*0.75
    elseif level==20 then
        inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]+CAPSTONE_DR
    end
end

local function onequip(inst,data)
    local item=data.item
    local eslot=data.eslot
    if(item and item.components.armor and (eslot==EQUIPSLOTS.BODY or eslot==EQUIPSLOTS.HEAD) and not (item:HasTag("fa_robe") or item:HasTag("fa_cloth")))then
        inst.components.kibar:SetPercent(0)
    end
end

local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
    inst.meditatecolldowntimer=data.meditatecolldowntimer
    inst.kickcooldowntimer=data.kickcooldowntimer
    inst.furycooldowntimer=data.furycooldowntimer
    inst.whirlwindcooldowntimer=data.whirlwindcooldowntimer
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
    data.meditatecolldowntimer=inst.meditateCooldownButton.cooldowntimer
    data.kickcooldowntimer=inst.kickCooldownButton.cooldowntimer
    data.furycooldowntimer=inst.furyCooldownButton.cooldowntimer
    data.whirlwindcooldowntimer=inst.whirlwindCooldownButton.cooldowntimer
end

local updatekiboosts=function(inst,data)
    for i=1,math.floor((data.new+0.9)/10) do
        local bufftostart=inst.kibuffs[i]
        if(bufftostart and not bufftostart.active)then
            bufftostart.active=true
            bufftostart.onenter()
        end
    end
    if(data.old>data.new)then
        for i=math.floor((data.new+0.9)/10)+1,math.floor((data.old+0.9)/10) do
            local bufftostart=inst.kibuffs[i]
            if(bufftostart and bufftostart.active)then
                bufftostart.active=false
                bufftostart.onexit()
            end
        end
    end
end

local fn = function(inst)
	
  	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

    inst.AnimState:SetBuild("fa_monk")

	-- todo: Add an example special power here.
    inst.components.locomotor.runspeed=BASE_MS
	inst.components.health:SetMaxHealth(150)
    --just so i dont have to run extra tests
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=0
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(150)
    inst.components.combat:SetDefaultDamage(UNARMED_DAMAGE)
    inst.fa_meleedamagemultiplier=1
    inst.components.health.fa_damagereduction={}
    inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]=0
    inst.components.health.fa_damagereduction[FA_DAMAGETYPE.FIRE]=0
    inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ACID]=0
    inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ELECTRIC]=0
    inst.components.health.fa_damagereduction[FA_DAMAGETYPE.COLD]=0

    local calcdamage_old=inst.components.combat.CalcDamage
    function inst.components.combat:CalcDamage (target, weapon, multiplier)
        local old=calcdamage_old(self,target,weapon,multiplier)

        if(weapon and not weapon.components.weapon:CanRangedAttack())then
            old=old*inst.fa_meleedamagemultiplier
        end
        return old
    end

    inst:AddComponent("xplevel")

    inst:AddComponent("kibar")
    inst.components.kibar.max=MAX_KI
    inst.components.kibar.current=0

    inst.kibuffs={
        [1]={
            onenter=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+KIBUFF_MS
            end,
            onexit=function()
                inst.components.locomotor.runspeed=inst.components.locomotor.runspeed-KIBUFF_MS
            end,
            active=false
        },
        [2]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false

        },
        [3]={
            onenter=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier+KIBUFF_STRIKE
            end,
            onexit=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier-KIBUFF_STRIKE
            end,
            active=false
        },
        [4]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION
            end,
            active=false
        },
        [5]={
            onenter=function()
            end,
            onexit=function()
            end,
            active=false
        },
        [6]={
            onenter=function()
                inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=1
                inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]+0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]+0.5
            end,
            onexit=function()
                inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0
                inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ACID]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=inst.components.health.fa_resistances[FA_DAMAGETYPE.ELECTRIC]-0.5
                inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]-0.5
            end,
            active=false
        },
        [7]={
            onenter=function()
                if not inst.components.health.regen or not inst.components.health.regen.task then
                    inst.components.health:StartRegen(KIBUFF_REGEN, 1)
                else
                    --patching up potential collisions 
                    local amount = (inst.components.health.regen.amount/inst.components.health.regen.period)+KIBUFF_REGEN
                     inst.components.health:StartRegen(amount, 1)
                end
                inst.components.sanity.dapperness=(inst.components.sanity.dapperness or 0)+KIBUFF_SANITY
            end,
            onexit=function()
                inst.components.health.regen.amount=inst.components.health.regen.amount-KIBUFF_REGEN
                if(inst.components.health.regen.amount<=0)then
                    inst.components.health:StopRegen()
                end
                inst.components.sanity.dapperness=inst.components.sanity.dapperness-KIBUFF_SANITY
            end,
            active=false
        },
        [8]={
            onenter=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance-KIBUFF_EVASION+KIBUFF_GREATEREVASION
            end,
            onexit=function()
            inst.components.health.fa_dodgechance=inst.components.health.fa_dodgechance+KIBUFF_EVASION-KIBUFF_GREATEREVASION
            end,
            active=false
        },
        [9]={
        --it is possible this will lead to heal effects - if there are additional effects on this layer... will have to come back here later
            onenter=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier+KIBUFF_IMPROVEDSTRIKE-KIBUFF_STRIKE
            inst.fa_damagetype=FA_DAMAGETYPE.HOLY
            end,
            onexit=function()
            inst.components.combat.damagemultiplier=inst.components.combat.damagemultiplier-KIBUFF_IMPROVEDSTRIKE+KIBUFF_STRIKE
            inst.fa_damagetype=nil
            end,
            active=false
        },
        [10]={
            onenter=function()
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]+KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.FIRE]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.FIRE]+KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ACID]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ACID]+KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ELECTRIC]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ELECTRIC]+KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.COLD]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.COLD]+KIBUFF_ABSORB
            end,
            onexit=function()
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.PHYSICAL]-KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.FIRE]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.FIRE]-KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ACID]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ACID]-KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ELECTRIC]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.ELECTRIC]-KIBUFF_ABSORB
                inst.components.health.fa_damagereduction[FA_DAMAGETYPE.COLD]= inst.components.health.fa_damagereduction[FA_DAMAGETYPE.COLD]-KIBUFF_ABSORB
            end,
            active=false
        },
    }

    inst:ListenForEvent("onhitother", onhitother)
    inst:ListenForEvent("kidelta", updatekiboosts)
    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)
    inst:ListenForEvent("equip",onequip)

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn


    local sg=inst.sg.sg

    sg.states["fa_meditate"]=State{
        name = "fa_meditate",
        
        onenter = function(inst)
            inst.AnimState:PlayAnimation("sleep",true)
            if(inst.meditateTask)then
                inst.meditateTask:Cancel()
            end
            inst.meditateTask=inst:DoPeriodicTask(1,function()
                if(inst.components.kibar:GetCurrent()<30)then
                    inst.components.kibar:DoDelta(2)
                    inst.components.hunger:DoDelta(-3)
                end
            end)
        end,

        onexit=function(inst)
            if(inst.meditateTask)then
                inst.meditateTask:Cancel()
                inst.meditateTask=nil
            end
        end,
    }

    sg.states["fa_flying_kick"]=State{
        name = "fa_flying_kick",
        tags = {"doing", "busy", "canrotate"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            if(inst.components.combat.target==nil) then inst.sg:GoToState("idle")  return end
            inst:ForceFacePoint(inst.components.combat.target:GetPosition())
            inst.sg.statemem.target = inst.components.combat.target

            inst.components.playercontroller:Enable(false)
            inst.components.health:SetInvincible(true)
            inst.AnimState:PlayAnimation("fa_flying_kick")
        end,

        onexit=function(inst)
            inst.components.playercontroller:Enable(true)
        end,
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },

        timeline=
        {
            TimeEvent(8*FRAMES, function(inst)
                local pos=Vector3(inst.Transform:GetWorldPosition())
                local v=inst.sg.statemem.target
                local p1=Vector3(v.Transform:GetWorldPosition())
                local dsq = inst:GetDistanceSqToInst(v)
                local r=inst.Physics:GetRadius() + v.Physics:GetRadius() + 1
                local vector = (pos-p1):GetNormalized()
                local newpos=p1+vector*r
                print("r",r,"oldpos",pos,"newpos",newpos)
                if GetWorld().Map and GetWorld().Map:GetTileAtPoint(newpos.x, newpos.y, newpos.z) ~= GROUND.IMPASSABLE then
                    local particle = SpawnPrefab("poopcloud")
                    particle.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    inst.Transform:SetPosition( newpos.x, newpos.y, newpos.z )
                    local damage=10*inst.components.xplevel.level
                    v.components.combat:GetAttacked(inst, damage, nil,nil,nil)

                end
                inst.components.health:SetInvincible(false)

            end),
        },
    }

    sg.states["fa_fistoffury"]=State{
        name = "fa_fistoffury",
        tags = {"attack", "notalking", "abouttoattack", "busy"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            if(inst.components.combat.target==nil) then inst.sg:GoToState("idle")  return end
            print("fists",inst.components.combat.target)
            inst.components.combat:StartAttack()
            inst.sg.statemem.target = inst.components.combat.target
            inst.AnimState:PlayAnimation("fa_fistoffury")
        end,

        onexit=function(inst)
            inst.components.playercontroller:Enable(true)
        end,
        events=
        {
            EventHandler("animover", function(inst)
                inst.sg:GoToState("idle")
            end),
        },


        timeline=
        {
            TimeEvent(8*FRAMES, function(inst) 
                local target=inst.sg.statemem.target
                inst.components.combat:DoAttack(target, nil, nil, nil, 3)

    local treshold=inst.components.xplevel.level*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end
        
        local stunning=CreateEntity()
        stunning.persists=false
        stunning:AddTag("FX")
        stunning:AddTag("NOCLICK")
        local spell = stunning:AddComponent("spell")
        stunning.components.spell.spellname = "fa_stun"
        stunning.components.spell.duration = 10
        stunning.components.spell.ontargetfn = function(inst,target)
            local fx=SpawnPrefab("fa_spinningstarsfx")
            fx.persists=false
            local follower = fx.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
            target.fa_stun_fx=fx
            target.fa_stun = stunning
        end
        stunning.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_stun = nil
            if(inst.components.spell.target.fa_stun_fx) then inst.components.spell.target.fa_stun_fx:Remove() end
        end
        stunning.components.spell.resumefn = function() end
        stunning.components.spell.removeonfinish = true
        stunning.components.spell:SetTarget(target)
        stunning.components.spell:StartSpell()
    end

                inst.sg:RemoveStateTag("abouttoattack") 
            end),
            TimeEvent(12*FRAMES, function(inst) 
                inst.sg:RemoveStateTag("busy")
            end),               
            TimeEvent(24*FRAMES, function(inst)
                inst.sg:RemoveStateTag("attack")
                
            end),            
        },
    }


    inst.newControlsInit = function (cnt)
        if(cnt.buffbar)then
            cnt.buffbar.width=550
        end

        inst.meditateCooldownButton=CooldownButton(cnt.owner)
        inst.meditateCooldownButton:SetText("Meditate")
        inst.meditateCooldownButton:SetOnClick(function() 
            inst.sg:GoToState("fa_meditate")
            return true
        end)
        inst.meditateCooldownButton:SetCooldown(5)
        local htbtn=cnt:AddChild(inst.meditateCooldownButton)
        htbtn:SetPosition(-250,0,0)
        if(inst.components.xplevel.level<5)then
            inst.meditateCooldownButton:Hide()
        end

        inst.kickCooldownButton=CooldownButton(cnt.owner)
        inst.kickCooldownButton:SetText("Kick")
        inst.kickCooldownButton:SetOnClick(function() 
            local target=nil
            local pos=Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 15,nil,{"INLIMBO","FX","DECOR","player","companion"})
                for k,v in pairs(ents) do
                    if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) 
                        and not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))then
                        target=v
                        break
                    end
                end
            if(target)then
                inst.components.combat:SetTarget(target)
                inst.components.combat.target=target
                inst.sg:GoToState("fa_flying_kick")
                return true
            end
        end)
        inst.kickCooldownButton:SetCooldown(240)
        if(inst.kickcooldowntimer and inst.kickcooldowntimer>0)then
             inst.kickCooldownButton:ForceCooldown(inst.kickcooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.kickCooldownButton)
        htbtn:SetPosition(-150,0,0)
        if(inst.components.xplevel.level<10)then
            inst.kickCooldownButton:Hide()
        end

        inst.furyCooldownButton=CooldownButton(cnt.owner)
        inst.furyCooldownButton:SetText("Fury")
        inst.furyCooldownButton:SetOnClick(function() 
            local target=nil
                local pos=Vector3(inst.Transform:GetWorldPosition())
            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 5,nil,{"INLIMBO","FX","DECOR","player","companion"})
                for k,v in pairs(ents) do
                    if v:IsValid() and v.components.combat and not (v.components.health and v.components.health:IsDead()) 
                        and not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))then
                        target=v
                        break
                    end
                end
            if(target)then
                inst.components.combat:SetTarget(target)
                inst.components.combat.target=target
                inst.sg:GoToState("fa_fistoffury")
                return true
            end
        end)
        inst.furyCooldownButton:SetCooldown(480)
        if(inst.furycooldowntimer and inst.furycooldowntimer>0)then
             inst.furyCooldownButton:ForceCooldown(inst.furycooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.furyCooldownButton)
        htbtn:SetPosition(-250,-40,0)
        if(inst.components.xplevel.level<14)then
            inst.furyCooldownButton:Hide()
        end

        inst.whirlwindCooldownButton=CooldownButton(cnt.owner)
        inst.whirlwindCooldownButton:SetText("Wrlwind")
        inst.whirlwindCooldownButton:SetOnClick(function() 
            inst.sg:GoToState("fa_whirlwind")
            return true
        end)
        inst.whirlwindCooldownButton:SetCooldown(240)
        if(inst.whirlwindcooldowntimer and inst.whirlwindcooldowntimer>0)then
             inst.whirlwindCooldownButton:ForceCooldown(inst.whirlwindcooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.whirlwindCooldownButton)
        htbtn:SetPosition(-150,-40,0)
        if(inst.components.xplevel.level<17)then
            inst.whirlwindCooldownButton:Hide()
        end


        cnt.ki = cnt:AddChild(KiBadge(cnt.owner))
        cnt.ki:SetPercent(inst.components.kibar:GetPercent(), inst.components.kibar.max)
        cnt.ki:SetPosition(0,-80,0)

        inst:ListenForEvent("kidelta", function(inst, data)  cnt.ki:DoDelta(data.old,data.new,data.max) end)
    end
end

return MakePlayerCharacter("monk", prefabs, assets, fn)
