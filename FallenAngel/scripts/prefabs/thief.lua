
local MakePlayerCharacter = require "prefabs/player_common"
local Combat=require "components/combat"
local SneakBuff = require "widgets/sneakbuff"
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
        Asset( "ANIM", "anim/thief.zip" ),
        Asset( "ANIM", "anim/smoke_up.zip" ),
}
local prefabs = {
    "trap_doubleteeth",
    "trap_ice",
    "trap_fire",
    "trap_tentacle"
}

local BACKSTAB_MULTIPLIER=3
local BACKSTAB_MULTIPLIER_MK2=3.5
local RANGE_MULTIPLIER=1.5
local ASSASSINATION_MULTIPLIER=5
local SNEAK_HUNGER_MULT=2.0

local HEALTH_PER_LEVEL=3
local SANITY_PER_LEVEL=3
local HUNGER_PER_LEVEL=3

local POINT_BLANK_STEALTH_DETECTION=0.6
local POINT_BLANK_STEALTH_DETECTION_MK2=0.3
local STEALTH_DETECTION_RANGE=10
local PICKPOCKET_RANGE=5
local PICKPOCKET_CHANCE=0.3
local PICKPOCKET_CHANCE_MK2=0.6
local PICKPOCKET_COOLDOWN=6*60
local PICKPOCKET_COOLDOWN_MK2=4*60

STRINGS.TABS.SUBTERFUGE = "Subterfuge"

STRINGS.NAMES.TRAP_DOUBLETEETH = "Double Teeth Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_DOUBLETEETH = "Double Teeth Trap"
STRINGS.RECIPE_DESC.TRAP_DOUBLETEETH = "Double Teeth Trap"

STRINGS.NAMES.TRAP_ICE = "Ice Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_ICE = "Ice Trap"
STRINGS.RECIPE_DESC.TRAP_ICE = "Ice Trap"

STRINGS.NAMES.TRAP_FIRE = "Fire Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_FIRE = "Fire Trap"
STRINGS.RECIPE_DESC.TRAP_FIRE = "Fire Trap"

STRINGS.NAMES.TRAP_TENTACLE = "Tentacle Trap"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.TRAP_TENTACLE = "Tentacle Trap"
STRINGS.RECIPE_DESC.TRAP_TENTACLE = "Tentacle Trap"


local function enabletraps()

    local r=Recipe("arrows", {Ingredient("twigs", 5), Ingredient("houndstooth", 1)}, RECIPETABS.SUBTERFUGE, {SCIENCE = 1})
    r.image="book_brimstone.tex"
    r=Recipe("bow", {Ingredient("twigs", 2), Ingredient("rope", 1),Ingredient("pigskin", 1)}, RECIPETABS.SUBTERFUGE,{SCIENCE = 1})
    r.image="woodbow.tex"
    r.atlas = "images/inventoryimages/woodbow.xml"
    r=Recipe("trap_doubleteeth", {Ingredient("houndstooth", 5), Ingredient("boards", 2), Ingredient("rocks", 2)}, RECIPETABS.SUBTERFUGE, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_fire", {Ingredient("gunpowder", 4),Ingredient("boards", 2), Ingredient("rocks", 2)}, RECIPETABS.SUBTERFUGE, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_ice", {Ingredient("feather_robin_winter", 2), Ingredient("boards", 2), Ingredient("rocks", 2)}, RECIPETABS.SUBTERFUGE, {SCIENCE = 2})
    r.image="trap_teeth.tex"
    r=Recipe("trap_tentacle", {Ingredient("tentaclespots", 2),Ingredient("boards", 2), Ingredient("nightmarefuel", 2)}, RECIPETABS.SUBTERFUGE, {MAGIC = 2})
    r.image="trap_teeth.tex"
end

local leavestealth=function(inst)
    inst:RemoveTag("notarget")
    inst.sneakBuff:ForceState("off")
    inst.components.hunger:SetRate(TUNING.WILSON_HUNGER_RATE)
    if(inst.fa_stealthdetecttask)then
        inst.fa_stealthdetecttask:Cancel()
    end

end

local onpickpocket=function(inst)
    if(not inst:HasTag("notarget"))then
        return false
    end
    
    local chance=PICKPOCKET_CHANCE
    if(inst.components.xplevel.level>=12)then
        chance=PICKPOCKET_CHANCE_MK2
    end

    local hit=false
    local pos=Vector3(inst.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, PICKPOCKET_RANGE)
    for k,v in pairs(ents) do
        if not v:IsInLimbo() then
            if( not v:HasTag("player") and not v:HasTag("pet") and v:HasTag("pickpocketable") and not(v.components.combat and v.components.combat.target==inst)) then

                if(math.random()<=chance)then
                    local newloot=nil
            --pick one of...
                    local rnd = math.random()*FALLENLOOTTABLE.TABLE_TIER1_WEIGHT
                    for k1,v1 in pairs(FALLENLOOTTABLE.tier1) do
                        rnd = rnd - v1
                        if rnd <= 0 then
                            newloot=k1
                            break
                        end
                    end
                    if(newloot)then
                        print("newloot",newloot)
                        local loot=SpawnPrefab(newloot)
                        --loot.Transform:SetPosition(pos.x, pos.y+5, pos.z)
                        inst.components.inventory:GiveItem(loot, nil, pos)
                    end
                    return true
                else
                    leavestealth(inst)
                    if(v.components.combat)then
                        v.components.combat:SetTarget(inst)
                    end
                    --go on timer on fail? sounds fail
                    return false
                end

            end
        end
    end
    return hit
end


local function sneakdetectionfn(inst)
    local pos=Vector3(inst.Transform:GetWorldPosition())
    local detectionchance=POINT_BLANK_STEALTH_DETECTION
    if(inst.components.xplevel.level>=20)then
        detectionchance=POINT_BLANK_STEALTH_DETECTION_MK2
    end
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, STEALTH_DETECTION_RANGE)
    for k,v in pairs(ents) do
        if not v:HasTag("player") and not v:HasTag("pet") and not v:IsInLimbo() then
            local entry=FA_STEALTHDETECTION_TABLE[v.prefab]
            if(entry)then
                local default=entry.default
                if(entry.tagged)then
                    for k1,v1 in pairs(entry.tagged) do
                        if(v:HasTag(k1))then
                            default=v
                            break
                        end
                    end
                end
                if(default<0)then
                    leavestealth(inst)
                    return true
                elseif(default>0)then
                    local detectchanceat=detectionchance*(1-inst:GetDistanceSqToInst(v)/STEALTH_DETECTION_RANGE)*default
                    if(math.random()<detectchanceat)then
                        print("detected!")
                        leavestealth(inst)
                        return true
                    else
                        print("stealth suceeded")
                        local q = CreateEntity()
                        q.entity:AddTransform()
                        local anim=q.entity:AddAnimState()
                        anim:SetBank("question")
                        anim:SetBuild("question")
                        anim:PlayAnimation("idle",true)
                        if(v.components.locomotor)then
                            v.components.locomotor:Stop()
                        end
                        local pos1 =v:GetPosition()
                        q.Transform:SetPosition(pos1.x, pos1.y+4, pos1.z)
                        q:DoTaskInTime(2,function() q:Remove() end)
                        v:FacePoint(pos)
                        --stealth passed, i gotta grab an image/effect/something
                    end
                end
            end
        end
    end
    return false
end

local enterstealth=function(inst)
    inst.components.hunger:SetRate(SNEAK_HUNGER_MULT*TUNING.WILSON_HUNGER_RATE)
    inst:AddTag("notarget")

    local boom = CreateEntity()
    boom.entity:AddTransform()
    local anim=boom.entity:AddAnimState()
    boom.Transform:SetScale(1, 1, 1)
    anim:SetBank("smoke_up")
    anim:SetBuild("smoke_up")
    anim:PlayAnimation("idle",false)

    local pos =inst:GetPosition()
    boom.Transform:SetPosition(pos.x, pos.y, pos.z)
    
    boom:ListenForEvent("animover", function() print("cleanup") boom:Remove() end)

    if(inst.fa_stealthdetecttask)then
        inst.fa_stealthdetecttask:Cancel()
    end
    inst.fa_stealthdetecttask=inst:DoPeriodicTask(2,function() sneakdetectionfn(inst) end)
end

local function onxploaded(inst)
    local level=inst.components.xplevel.level
    if(level>=4)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    end
    if(level>=5)then
--        inst.pickCooldownButton:Show()
    end
    if(level>=6)then
        enabletraps()
    end
    if(level>=7)then
--        enablelocks()
    end
    if(level>=9)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    end
    if(level>=10)then
--        inst.sneakBuff:Show()
    end
    if(level>=14)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    end
    if(level>1)then
        inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL*(level-1)
        inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL*(level-1)
        inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL*(level-1)
    end
end

local function onlevelup(inst,data)
    local level=data.level

    inst.components.health.maxhealth= inst.components.health.maxhealth+HEALTH_PER_LEVEL
    inst.components.sanity.max=inst.components.sanity.max+SANITY_PER_LEVEL
    inst.components.hunger.max=inst.components.hunger.max+HUNGER_PER_LEVEL

    if(level==4)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.05*TUNING.WILSON_RUN_SPEED
    elseif(level==5)then
        inst.pickCooldownButton:Show()
    elseif(level==6)then
        enabletraps()
    elseif(level==7)then
--      enablelocks()
    elseif(level==9)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif(level==10)then
        inst.sneakBuff:Show()
    elseif(level==12)then
        inst.pickCooldownButton:SetCooldown(PICKPOCKET_COOLDOWN_MK2)
    elseif(level==14)then
        inst.components.locomotor.runspeed=inst.components.locomotor.runspeed+0.1*TUNING.WILSON_RUN_SPEED
    elseif(level==20)then

    end
end

local onloadfn = function(inst, data)
    inst.fa_playername=data.fa_playername
    inst.pickcooldowntimer=data.pickcooldowntimer
end

local onsavefn = function(inst, data)
    data.fa_playername=inst.fa_playername
    data.pickcooldowntimer=inst.pickCooldownButton.cooldowntimer
end


local onattacked=function(inst,data)
    local damage=data.damage
    local weapon=data.weapon
    if(damage and damage>0 and inst:HasTag("notarget"))then
        leavestealth(inst)
    end
end

local onhitother=function(inst,data)
    local damage=data.damage
    if(damage and damage>0 and inst:HasTag("notarget"))then
        leavestealth(inst)
    end
end


local fn = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wolfgang"

	-- a minimap icon must be specified
	inst.MiniMapEntity:SetIcon( "wilson.png" )

	-- todo: Add an example special power here.
	inst.components.sanity.night_drain_mult=0.75
	inst.components.health:SetMaxHealth(125)
	inst.components.sanity:SetMax(200)
	inst.components.hunger:SetMax(175)
        
    inst:AddComponent("xplevel")
    
    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    local combatmod=inst.components.combat

    function combatmod:CalcDamage (target, weapon, multiplier)
        local sneaking=inst:HasTag("notarget")
        local backstab=BACKSTAB_MULTIPLIER
        if(inst.components.xplevel.level>=19)then
            backstab=BACKSTAB_MULTIPLIER_MK2
        end
        local old=Combat.CalcDamage(self,target,weapon,multiplier)
        print("weapon",weapon)
        if(weapon and weapon:HasTag("dagger") and inst.components.xplevel.level>=20)then
            --does it actually give equippable weapon object ref or a component ref?
            print("dagger ",weapon)
            old=old*1.5
        end
        if(weapon and weapon:CanRangedAttack())then
            return old*RANGE_MULTIPLIER
        end
        if(sneaking and not(target.components.combat and target.components.combat.target==GetPlayer()))then
            print("assassin")
            return old*ASSASSINATION_MULTIPLIER
        end
        if(target and target.components.combat and target.components.combat.target==GetPlayer())then
                return old
        else
            print("backstab",backstab)
            return old*backstab
       end
    end

    local sg=inst.sg.sg

    sg.states["sneak"]=State{
        name = "sneak",
        tags = {"idle", "hiding"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hide")
            inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
            enterstealth(inst)
        end,
        
        onexit = function(inst)
--            inst:RemoveTag("notarget")
        end,
        
        events=
        {
 --          EventHandler("animover", function(inst) inst.sg:GoToState("sneak_idle") end),
        },
    }

    sg.states["sneak_idle"]=State{
        name = "sneak_idle",
        tags = {"idle", "hiding"},
        onenter = function(inst)
            inst.components.locomotor:Stop()
            inst.AnimState:PlayAnimation("hide_idle", true)
            enterstealth(inst)
        end,
        
        onexit = function(inst)
--            inst:RemoveTag("notarget")
        end
        
    }

--TODO there's gotta be a better way and move this out of here 

    local action_old=ACTIONS.FORCEATTACK.fn
    ACTIONS.FORCEATTACK.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.EAT.fn
    ACTIONS.EAT.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.MINE.fn
    ACTIONS.MINE.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DIG.fn
    ACTIONS.DIG.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.GIVE.fn
    ACTIONS.GIVE.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.COOK.fn
    ACTIONS.COOK.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DRY.fn
    ACTIONS.DRY.fn = function(act)
       if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.TALKTO.fn
    ACTIONS.TALKTO.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.BUILD.fn
    ACTIONS.BUILD.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.PLANT.fn
    ACTIONS.PLANT.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.HARVEST.fn
    ACTIONS.HARVEST.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.DEPLOY.fn
    ACTIONS.DEPLOY.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.CATCH.fn
    ACTIONS.CATCH.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.FISH.fn
    ACTIONS.FISH.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end
    local action_old=ACTIONS.USEITEM.fn
    ACTIONS.USEITEM.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.READ.fn
    ACTIONS.READ.fn = function(act)
        if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

    local action_old=ACTIONS.PICK.fn
    ACTIONS.PICK.fn = function(act)
         if(act.doer and act.doer:HasTag("player") and act.doer:HasTag("notarget")and act.target.components.pickable and act.target.components.pickable.product 
            and (act.target.components.pickable.product=="cutgrass" or act.target.components.pickable.product=="twigs") ) then
            leavestealth(act.doer)
        end
        return action_old(act)
    end

RECIPETABS["SUBTERFUGE"] = {str = "SUBTERFUGE", sort=999, icon = "trap_teeth.tex", icon_atlas = "images/inventoryimages.xml"}

--    inst.components.builder:AddRecipeTab(booktab)

    inst.newControlsInit = function (class)
        inst.sneakBuff=SneakBuff(class.owner)
        class.rage = class:AddChild(inst.sneakBuff)
        class.rage:SetPosition(0,0,0)
        class.rage:SetOnClick(function(state) 
                     print("onclick",state) 
                        if(state and state=="on") then
--                                inst.sg:GoToState("hide")
                                inst.sg:GoToState("sneak")
                        elseif(inst:HasTag("notarget"))then
                            leavestealth(inst)
                            inst.sg:GoToState("idle")
                        end
                end)
        if(inst.components.xplevel.level>=10)then
            inst.sneakBuff:Show()
        else
            inst.sneakBuff:Hide()
        end

        inst.pickCooldownButton=CooldownButton(class.owner)
        inst.pickCooldownButton:SetText("Steal")
        inst.pickCooldownButton:SetOnClick(function() return onpickpocket(inst) end)
        if(inst.components.xplevel.level>=12)then
            inst.pickCooldownButton:SetCooldown(PICKPOCKET_COOLDOWN_MK2)
        else
            inst.pickCooldownButton:SetCooldown(PICKPOCKET_COOLDOWN)
        end
        if(inst.pickcooldowntimer and inst.pickcooldowntimer>0)then
             inst.pickCooldownButton:ForceCooldown(inst.pickcooldowntimer)
        end
        local htbtn=class:AddChild(inst.pickCooldownButton)
        htbtn:SetPosition(-100,0,0)
        if(inst.components.xplevel.level>=5)then
            inst.pickCooldownButton:Show()
        else
             inst.pickCooldownButton:Hide()
        end


    end

    inst:ListenForEvent("attacked", onattacked)
    inst:ListenForEvent("onhitother", onhitother)
    inst:ListenForEvent("xplevelup", onlevelup)
    inst:ListenForEvent("xplevel_loaded",onxploaded)
end



return MakePlayerCharacter("thief", prefabs, assets, fn)
