local MakePlayerCharacter = require "prefabs/player_common"

local CooldownButton = require "widgets/cooldownbutton"
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
        Asset( "ANIM", "anim/paladin.zip" ),
}
local prefabs = {
    "holysword",
    "fa_forcefieldfx_white"
}

--        SANITY_NIGHT_MID = -100/(300*20),
local LAY_ON_HANDS_HP=250
local LAY_ON_HANDS_COOLDOWN=960
local DIVINE_DEFENDER_COOLDOWN=480*4
local DIVINE_DEFENDER_DURATION=15
local TURN_UNDEAD_COOLDOWN=480
local TURN_UNDEAD_INSTA_CHANCE=0.2
local TURN_UNDEAD_RUN_CHANCE=0.7
local TURN_UNDEAD_DURATION=60
local TURN_UNDEAD_RANGE=15
local HEALTH_PER_LEVEL=5
local SANITY_PER_LEVEL=1


local onloadfn = function(inst, data)
    inst.lohcooldowntimer=data.lohcooldowntimer
    inst.ddcooldowntimer=data.ddcooldowntimer
    inst.fa_playername=data.fa_playername
    inst.turncooldowntimer=data.turncooldowntimer
end

local onsavefn = function(inst, data)
    data.lohcooldowntimer=inst.lohCooldownButton.cooldowntimer
    data.ddcooldowntimer=inst.divinedefenderCooldownButton.cooldowntimer
    data.fa_playername=inst.fa_playername
    data.turncooldowntimer=inst.turnCooldownButton.cooldowntimer
end

local function enableL1spells()
    local r=Recipe("fa_spell_divinemight", {Ingredient("meat", 5), Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS, {SCIENCE = 0, MAGIC = 0, ANCIENT = 0})
    r.image="book_brimstone.tex"
end
local function enableL2spells()
    local r=Recipe("fa_spell_banishdarkness", {Ingredient("fireflies", 2),Ingredient("cutgrass", 5), Ingredient("rocks", 10)}, RECIPETABS.SPELLS, {MAGIC = 2})
    r.image="book_gardening.tex" 
end
local function enableL3spells()
    local r=Recipe("fa_spell_heal", {Ingredient("spidergland",5),Ingredient("cutgrass", 5), Ingredient("rocks", 15)}, RECIPETABS.SPELLS, {MAGIC = 3})
    r.image="book_gardening.tex"
end


local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>=3)then
        inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    end
    if(level>=4)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    end
    if(level>=7)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    end
    if(level>=8)then
         inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    end
    if(level>=11)then
        enableL1spells()
    end
    if(level>=12)then
        inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    end
    if(level>=13)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    end
    if(level>=14)then
        enableL2spells()
    end
    if(level>=15)then
         inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    end
    if(level>=16)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    end
    if(level>=18)then
        enableL3spells()
    end
    if(level>=19)then
         inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    end
    if(level>=20)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
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
        inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    elseif(level==4)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    elseif(level==7)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    elseif(level==5)then
        inst.lohCooldownButton:Show()
    elseif(level==8)then
        inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    elseif(level==9)then
        inst.turnCooldownButton:Show()
    elseif(level==11)then
        enableL1spells()
    elseif(level==12)then
         inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    elseif(level==13)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    elseif(level==14)then
        enableL2spells()
    elseif(level==15)then
         inst.fa_meleedamagemultiplier=inst.fa_meleedamagemultiplier+0.1
    elseif(level==16)then
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    elseif(level==19)then
        enableL3spells()
    elseif(level==20)then
        inst.divinedefenderCooldownButton:Show()
        inst.fa_undeadcombatmultiplier=inst.fa_undeadcombatmultiplier+0.1
    end
end

local function onturnundead(clr)
    local pos=Vector3(clr.Transform:GetWorldPosition())
        local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, TURN_UNDEAD_RANGE,nil,{"FX","INLIMBO","player","companion"})
        for k,v in pairs(ents) do
            if ( v.components.combat  and v:HasTag("undead")) then

                local rng=math.random()
                print("turn undead rng",rng)
                if(rng<TURN_UNDEAD_INSTA_CHANCE)then
                    --i need instakill but i also need to get this thing to recognize the killer... 2^31-1 or 2^63-1? if he's invuln he wont die but w/e
                    v.components.combat:GetAttacked(clr,999999)
                elseif(rng<TURN_UNDEAD_RUN_CHANCE)then

                local inst = CreateEntity()
                inst.entity:AddTransform()
                inst.persists=false
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

local function ondivinedefense(inst)

        inst.components.health.invincible=true

        local fx = SpawnPrefab("fa_forcefieldfx_white")
        fx.entity:SetParent(inst.entity)
        fx.Transform:SetPosition(0, 0.2, 0)
        local fx_hitanim = function()
            fx.AnimState:PlayAnimation("hit")
            fx.AnimState:PushAnimation("idle_loop")
        end
        fx:ListenForEvent("blocked", fx_hitanim, inst)
        fx:ListenForEvent("attacked",fx_hitanim,inst)

        inst:DoTaskInTime(DIVINE_DEFENDER_DURATION, function() 
                fx:RemoveEventCallback("blocked", fx_hitanim, inst)
                fx:RemoveEventCallback("attacked", fx_hitanim, inst)
                fx.kill_fx(fx)
                inst.components.health.invincible=false 
        end)
        return true

end    

local fn = function(inst)
    
    -- choose which sounds this character will play
    inst.soundsname = "paladin"

    -- a minimap icon must be specified
    inst.MiniMapEntity:SetIcon( "paladin.tex" )

    -- todo: Add an example special power here.
    inst.components.combat.damagemultiplier=1
    inst.fa_meleedamagemultiplier=1
    inst.fa_undeadcombatmultiplier=1
    inst.components.health:SetMaxHealth(250)
    inst.components.sanity:SetMax(200)
    inst.components.hunger:SetMax(150)

    inst:AddComponent("xplevel")
     inst:AddTag("fa_shielduser")
   
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    inst:ListenForEvent("xplevel_loaded",onxploaded)
    inst:ListenForEvent("xplevelup", onlevelup)

    inst:AddComponent("reader")
    inst.buff_timers={}
    RECIPETABS["SPELLS"] = {str = "SPELLS", sort=999, icon = "tab_book.tex"}

    local combatmod=inst.components.combat
    local calcdamage_old=inst.components.combat.CalcDamage

    function combatmod:CalcDamage (target, weapon, multiplier)
        local old=calcdamage_old(self,target,weapon,multiplier)

        if(weapon and not weapon.components.weapon:CanRangedAttack() and target and target:HasTag("undead"))then
--        if(target and target:HasTag("undead"))then
            old=old*inst.fa_undeadcombatmultiplier*inst.fa_meleedamagemultiplier
--            print("undead multiplier",old)
        elseif(weapon and not weapon.components.weapon:CanRangedAttack())then
            old=old*inst.fa_meleedamagemultiplier
        end
        return old
    end

    inst.newControlsInit = function (cnt)

        inst.lohCooldownButton=CooldownButton(cnt.owner)
        inst.lohCooldownButton:SetText("LOH")
        inst.lohCooldownButton:SetOnClick(function()
            inst.components.health:DoDelta(LAY_ON_HANDS_HP)
            return true
        end)
        inst.lohCooldownButton:SetCooldown(LAY_ON_HANDS_COOLDOWN)
        if(inst.lohcooldowntimer and inst.lohcooldowntimer>0)then
             inst.lohCooldownButton:ForceCooldown(inst.lohcooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.lohCooldownButton)
        htbtn:SetPosition(-250,0,0)
        htbtn:Show()         
        if(inst.components.xplevel.level<5)then
            inst.lohCooldownButton:Hide()
        end

        inst.divinedefenderCooldownButton=CooldownButton(cnt.owner)
        inst.divinedefenderCooldownButton:SetText("Defense")
        inst.divinedefenderCooldownButton:SetOnClick(function() return ondivinedefense(inst) end)

        inst.divinedefenderCooldownButton:SetCooldown(DIVINE_DEFENDER_COOLDOWN)
        if(inst.ddcooldowntimer and inst.ddcooldowntimer>0)then
             inst.divinedefenderCooldownButton:ForceCooldown(inst.ddcooldowntimer)
             inst.components.health.invincible=false
        end
        local htbtn=cnt:AddChild(inst.divinedefenderCooldownButton)
        htbtn:SetPosition(-150,0,0) 
        htbtn:Show()         
        if(inst.components.xplevel.level<20)then
            inst.divinedefenderCooldownButton:Hide()
        end


        inst.turnCooldownButton=CooldownButton(cnt.owner)
        inst.turnCooldownButton:SetText("Turn")
        inst.turnCooldownButton:SetOnClick(function() return onturnundead(inst) end)
        local turncooldown=TURN_UNDEAD_COOLDOWN
        inst.turnCooldownButton:SetCooldown(turncooldown)
        if(inst.turncooldowntimer and inst.turncooldowntimer>0)then
             inst.turnCooldownButton:ForceCooldown(inst.turncooldowntimer)
        end
        local htbtn=cnt:AddChild(inst.turnCooldownButton)
        htbtn:SetPosition(-50,0,0)
        htbtn:Show()         
        if(inst.components.xplevel.level<9)then
            inst.turnCooldownButton:Hide()
        end

        if(cnt.buffbar)then
            cnt.buffbar.width=500
        end

--[[
        local btn=InitBuffBar(inst,"light",inst.lightBuffUp,cnt,"light")
        btn:SetPosition(200,0,0)
        LightSpellStart(inst,inst.lightBuffUp )
        local btn=InitBuffBar(inst,"divinemight",inst.dmBuffUp,cnt,"DM")
        btn:SetPosition(300,0,0)
        DivineMightSpellStart(inst,inst.dmBuffUp )]]
        
    end
    local prefabs1 = {
        "holysword",
    }
   
    inst.components.inventory:GuaranteeItems(prefabs1)

end

return MakePlayerCharacter("paladin", prefabs, assets, fn)
