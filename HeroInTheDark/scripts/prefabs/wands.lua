local assets=
{
    Asset("ANIM", "anim/staffs.zip"),
    Asset("ANIM", "anim/swap_staffs.zip"), 
}

local prefabs = 
{
    "ice_projectile",
    "fire_projectile",
    "lightningboltprojectile",
    "acidarrowprojectile",
    "fireballprojectile",
    "staffcastfx",
    "stafflight",
     "impact",
}

local WEB_USES=25
local AOE_RANGE=20

local INFLICTMASS_DAMAGE=20
local INFLICTMASS_USES=20

local DISRUPTION_DAMAGE=10
local DISRUPTION_USES=50

local HALTUNDEAD_DURATION=2*60
local HALTUNDEAD_USES=20

local MAGICMISSLE_USES=100
local MAGICMISSLE_DAMAGE=20
local MAGICMISSLE_DAMAGE_INC=5

local REDUCE_HUMANOID_DURATION=4*60
local REDUCE_HUMANOID_SPEED=1.25
local REDUCE_HUMANOID_MULT=0.75
local REDUCE_HUMANOID_USES=10

local ENLARGE_HUMANOID_DURATION=4*60
local ENLARGE_HUMANOID_SPEED=0.75
local ENLARGE_HUMANOID_MULT=1.25
local ENLARGE_HUMANOID_USES=10

local ROE_DEBUFF=0.5
local ROE_USES=20
local ROE_DURATION=60

local CHARM_DURATION=8*60
local CHARM_USES=10

local SLOW_MOVEMENTSPEED=0.5
local SLOW_ATTACK=0.5
local SLOW_USES=15
local SLOW_DURATION=2*60

local CHARMPERSON_USES=5
local CHARMPERSON_DURATION=8*60

local DOMINATEPERSON_USES=5
local DOMINATEPERSON_DMG=1.25
local DOMINATEPERSON_AS=1.25

local COMMANDUNDEAD_USES=10
local COMMANDUNDEAD_DURATION=4*60

local ACIDARROW_USES=50
local ACIDARROW_DOT=5
local ACIDARROW_LENGTH=20
local ACIDARROW_PERIOD=2
local ACIDARROW_LENGTH_INC=10

local FIREBALL_USES=33
local FIREBALL_RADIUS=5
local FIREBALL_DAMAGE=15

local FLAMESTRIKE_USES=20
local FLAMESTRIKE_DAMAGE=10
local FLAMESTRIKE_RANGE=12

local ICESTORM_USES=10
local SUNBURST_USES=10
local PRISMATICWALL_USES=5

local ICESTORM_RADIUS=15
local SUNBURST_RADIUS=15
local FIREWALL_WIDTH=15
local FIREWALL_DEPTH=5
local FIREWALL_USES=50
local PRISMATIC_WIDTH=15
local PRISMATIC_DEPTH=5

-- 5,10,20,30,40 dmg at lvs, 1,5,10,15,20 
local ANIMALTRANCE_USES=10
local ANIMALTRANCE_DURATION=2*60
local GUSTOFWIND_USES=20
local HOLDANIMAL_USES=10
local DOMINATEANIMAL_USES=8
local HOLDANIMAL_DURATION=20
local HOLDPERSON_USES=10
local HOLDPERSON_DURATION=20
local HOLDMONSTER_USES=10
local HOLDMONSTER_DURATION=20
local CALLLIGHTNING_DAMAGE=100
local CALLLIGHTNING_USES=12
local POISON_LENGTH=20
local POISON_DAMAGE=7
local POISON_PERIOD=2
local POISON_USES=30
local SNARE_SPEED=0.5
local SNARE_USES=25
local SNARE_DURATION=2*60

local DISEASE_DURATION=20
local DISEASE_USES=33
local DISEASE_DAMAGE=5
local DISEASE_PERIOD=2
local DISEASE_SNARE=0.8

local INFLICT_LIGHT_WOUNDS=20
local INFLICT_LIGHT_USES=33
local INFLICT_MOD_WOUNDS=25
local INFLICT_MOD_USES=30
local INFLICT_SERIOUS_WOUNDS=30
local INFLICT_SERIOUS_USES=28
local INFLICT_CRITICAL_WOUNDS=35
local INFLICT_CRITICAL_USES=25

local FEAR_DURATION=30
local FEAR_USES=20

local ACIDSPLASH_DAMAGE=20
local ACIDSPLASH_USES=50
local FROSTRAY_DAMAGE=20
local FROSTRAY_USES=50

local ICESTORM_LENGTH=120
local ICESTORM_DAMAGE=5
local SUNBURST_DAMAGE=100
local LIGHTNINGBOLT_DAMAGE=100

local DAZEHUMAN_USES=25
local DAZEHUMAN_DURATION=20

local KNOCK_USES=10
local KNOCK_LEVELS={2,8,14,18,22}

local WAND_RANGE=20

local BOW_USES=20
local BOW_DAMAGE=20
local BOW_RANGE=15


local function canCastOnCombatTarget(inst, caster, target, pos)
    if(target and target.components.combat and not (target.components.health and target.components.health:IsDead()) and not target:IsInLimbo())then
        return true
    else
        return false
    end
end

local function onattackacidarrow(inst,attacker,target)
    --no stacking dots
    if(target.acidarrowtask)then
        target.acidarrowtask:Cancel()
    end
    target.acidarrowcounter=ACIDARROW_LENGTH
    target.acidarrowtask=target:DoPeriodicTask(2, function(inst)
        inst.components.combat:GetAttacked(attacker,ACIDARROW_DOT,nil,nil,FA_DAMAGETYPE.ACID)
        if(inst and inst.acidarrowcounter and inst.acidarrowcounter>2)then
            inst.acidarrowcounter=inst.acidarrowcounter-2
        else
            inst.acidarrowtask:Cancel()
            inst.acidarrowtask=nil
        end 
    end)
    
end

local function onattackfireball(inst, attacker, target)
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.EVOCATION)
    end
    local damage=(math.floor(cl/2)+1)*FIREBALL_DAMAGE
    local pos=Vector3(target.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FIREBALL_RADIUS,nil,{"INLIMBO","FX"})
            for k,v in pairs(ents) do
                if  not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and  not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(attacker, damage, nil,nil,FA_DAMAGETYPE.FIRE)
                    end
                end
            end
    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function onattacksunburst(inst,attacker,target)
local pos=Vector3(target.Transform:GetWorldPosition())
    local lightning = SpawnPrefab("lightning")
    lightning.Transform:SetPosition(pos:Get())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, SUNBURST_RADIUS,nil,{"player","pet","FX","companion","INLIMBO"})
            for k,v in pairs(ents) do
                if v.components.combat and not v==target and not (v.components.health and v.components.health:IsDead()) then
                    if(v:HasTag("undead"))then
                       v.components.combat:GetAttacked(attacker, SUNBURST_DAMAGE, nil,nil,FA_DAMAGETYPE.HOLY)
                    else
                        --that would interrupt but not stun... what is a stun? if brain:stop is mez, freeze would be mez too, locomotor.stop? brain would restart it etc
                       v.components.combat:GetAttacked(attacker, 1, nil)
                    end
                end
            end
    local explode = SpawnPrefab("explode_small")
    local pos = inst:GetPosition()
    explode.Transform:SetPosition(pos.x, pos.y, pos.z)

    --local explode = PlayFX(pos,"explode", "explode", "small")
    explode.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )
    explode.AnimState:SetLightOverride(1)

    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function createFireDelta(pos)
local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(600)
    inst:AddTag("noauradamage")
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")
    MakeLargeBurnable(inst)
    MakeLargePropagator(inst)
    inst.components.burnable.flammability = .5
    inst.Transform:SetPosition(pos.x, pos.y, pos.z)
     inst.components.burnable:Ignite()
     return inst
end

local function onattackfirewall(staff, target, orpos)
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end

    for i=0,4 do
        createFireDelta(pos)
        pos.z=pos.z+2
    end
    staff.components.finiteuses:Use(1)
end

local function doicestorm(inst,target)
    local pos=Vector3(inst.Transform:GetWorldPosition())
    print("wtf is target?",target)
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, ICESTORM_RADIUS,nil,{"player","pet","FX","companion","INLIMBO"})
    for k,v in pairs(ents) do
        if v.components.combat and not (v.components.health and v.components.health:IsDead()) then
            --it should have blunt component, do i want to do this twice?
            v.components.combat:GetAttacked(inst.fa_icestorm_caster, ICESTORM_DAMAGE, nil,nil,FA_DAMAGETYPE.COLD)
        end
    end
end

local function onattackicestorm(staff, target, orpos)
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local inst = CreateEntity()
    local caster = staff.components.inventoryitem.owner
    local trans = inst.entity:AddTransform()
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "icestorm"
    inst.components.spell.duration = ICESTORM_LENGTH
--    inst.components.spell.ontargetfn = light_ontarget
--    inst.components.spell.onstartfn = light_start
--    inst.components.spell.onfinishfn = light_onfinish
    inst.components.spell.fn = doicestorm
    inst.components.spell.period=2
--    inst.components.spell.resumefn = light_resume
    inst.components.spell.removeonfinish = true
    inst.components.spell:SetTarget(inst)
    inst.fa_icestorm_caster=caster
    inst.Transform:SetPosition(pos.x, pos.y, pos.z)
    inst.components.spell:StartSpell()
    staff.components.finiteuses:Use(1)
end



function onattackflamestrike(inst, target, orpos)--reader)
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local reader = inst.components.inventoryitem.owner
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.EVOCATION)
    end
    local damage=cl*FLAMESTRIKE_DAMAGE

    local ringfx =SpawnPrefab("fa_firestormfx")
    ringfx.persists=false
    ringfx.Transform:SetPosition(pos.x, pos.y, pos.z)
    ringfx:ListenForEvent("animover", function() 
        ringfx.AnimState:ClearBloomEffectHandle()
        ringfx:Remove() 
    end)

            local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FLAMESTRIKE_RANGE,nil,{"player","FX","companion","INLIMBO"})
            for k,v in pairs(ents) do
                if not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player")) then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(reader, damage, nil,nil,FA_DAMAGETYPE.FIRE)

                        local hitfx =SpawnPrefab("fa_firestormhitfx")
                        hitfx.persists=false
                        hitfx.Transform:SetPosition(v.Transform:GetWorldPosition())
--                        local follower = hitfx.entity:AddFollower()
--                        follower:FollowSymbol( v.GUID, v.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
                        hitfx:ListenForEvent("animover", function() 
                        hitfx.AnimState:ClearBloomEffectHandle()
                        hitfx:Remove() 
                        end)
                    end
                end
            end
    inst.components.finiteuses:Use(1)
    return true
end

local function onfinished(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/gem_shatter")
    inst:Remove()
end

local function commonfn(colour)

    local onequip = function(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_object", "swap_staffs",colour.."staff")
        owner.AnimState:Show("ARM_carry") 
        owner.AnimState:Hide("ARM_normal") 
    end

    local onunequip = function(inst, owner) 
        owner.AnimState:Hide("ARM_carry") 
        owner.AnimState:Show("ARM_normal") 
    end

    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
    
    anim:SetBank("staffs")
    anim:SetBuild("staffs")
    anim:PlayAnimation(colour.."staff")
    
    inst:AddTag("wand")
    -------   
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetOnFinished( onfinished )

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename="firestaff"
    
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )


    inst:AddTag("nopunch")
    
    return inst
end



local function fireball()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackfireball)
    inst.components.weapon:SetProjectile("fireballprojectile")
    inst.components.finiteuses:SetMaxUses(FIREBALL_USES)
    inst.components.finiteuses:SetUses(FIREBALL_USES)

    return inst
end

local function lightningbolt()
local inst = commonfn("blue")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(LIGHTNINGBOLT_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
--    inst.components.weapon:SetOnAttack(onattacklightningbolt)
    inst.components.weapon:SetProjectile("lightningboltprojectile")
inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.ELECTRIC
    inst.components.finiteuses:SetMaxUses(FIREBALL_USES)
    inst.components.finiteuses:SetUses(FIREBALL_USES)

    return inst
end


local function flamestrikefn()
    local inst = commonfn("red")
    inst.components.inventoryitem.imagename="firestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackflamestrike)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(FLAMESTRIKE_USES)
    inst.components.finiteuses:SetUses(FLAMESTRIKE_USES)
    return inst
end

local function icestorm()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackicestorm)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(ICESTORM_USES)
    inst.components.finiteuses:SetUses(ICESTORM_USES)
    return inst
end

local function sunburst()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(BOW_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattacksunburst)
    inst.components.weapon:SetProjectile("fire_projectilex")

    inst.components.finiteuses:SetMaxUses(SUNBURST_USES)
    inst.components.finiteuses:SetUses(SUNBURST_USES)

    return inst
end

local function firewall()
    local inst = commonfn("red")
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackfirewall)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(FIREWALL_USES)
    inst.components.finiteuses:SetUses(FIREWALL_USES)

    return inst
end


local function onattackfirewallinsta(staff, attacker, target)
    local pos=Vector3(target.Transform:GetWorldPosition())
    
    for i=0,4 do
        createFireDelta(pos)
        pos.z=pos.z+2
    end
end

local function firewall_insta()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackfirewallinsta)
    inst.components.weapon:SetProjectile("fireballprojectile")
    inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.FIRE
    inst.components.finiteuses:SetMaxUses(FIREWALL_USES)
    inst.components.finiteuses:SetUses(FIREWALL_USES)

    return inst
end
local function prismaticwall()
    local inst = commonfn("red")

    inst.components.finiteuses:SetMaxUses(PRISMATICWALL_USES)
    inst.components.finiteuses:SetUses(PRISMATICWALL_USES)

    return inst
end 

local ondazedattacked=nil
ondazedattacked=function(inst,data)
    if(data.damage and data.damage>0 and inst and inst.fa_daze)then
        inst.fa_daze.components.spell:OnFinish()
    end    
end

--TODO get rid of consts - way too bored


local function onattackanimaltrance(staff, target, orpos)
   
    if(not target:HasTag("fa_animal")) then return false end

    local attacker = staff.components.inventoryitem.owner
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end

    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_daze)then target.fa_daze.components.spell:OnFinish() end

        local inst=SpawnPrefab("fa_musicnotesfx")
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_animaltranse"
        inst.components.spell.duration = ANIMALTRANCE_DURATION
        inst.components.spell.ontargetfn = function(inst,target)       
            local follower = inst.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
            target.fa_daze = inst
            target:ListenForEvent("attacked", ondazedattacked)
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_daze = nil
            inst.components.spell.target:RemoveEventCallback("attacked",ondazedattacked)
        end
                --inst.components.spell.fn = function(inst, target, variables) end
                inst.components.spell.resumefn = function() end
                inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
        staff.components.finiteuses:Use(1)
        end

    --staff.components.finiteuses:Use(1)
end

local function onattackgustofwind(inst,attacker,target,projectile)
        local coef=10
        local v1=Vector3(target.Physics:GetVelocity())
        --nope, i cant get the original speed by any means it seems
--        local vhit=Vector3(projectile.Physics:GetVelocity())
--        local angle=target:GetAngleToPoint(attacker:GetPosition())
        local vel = (target:GetPosition() - attacker:GetPosition()):GetNormalized()     
        local angle = math.atan2(vel.z, vel.x)

        local vhit=Vector3(coef*math.cos(angle),0,coef*math.sin(angle))
        if(target.components.locomotor)then
            target.components.locomotor:Stop()
        end
        print("vel",vhit)
        print("target",target)
        --tru to make physics actually run for a few... depending on how shit this turns to be, might have to rely on brute force teleporting but thats...
        
        if(target.brain)then
--            target.brain:Stop()  useless 
            target:StopBrain()
            target:DoTaskInTime(1,function()
                target:RestartBrain()
            end)
        end
--        target.Physics:SetVel((vhit):Get())
        
        target.Physics:SetMotorVel((vhit):Get())

end

local function onattackholdanimal(inst1,attacker,target)
    if(not target:HasTag("fa_animal")) then return false end
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end
        
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_holdanimal"
        inst.components.spell.duration = HOLDANIMAL_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

            local fx=SpawnPrefab("fa_spinningstarsfx")
            fx.persists=false
            local follower = fx.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
            target.fa_stun_fx=fx
            target.fa_stun = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_stun = nil
            if(inst.components.spell.target.fa_stun_fx) then inst.components.spell.target.fa_stun_fx:Remove() end
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end
end


local function animaltrance()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackanimaltrance)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(ANIMALTRANCE_USES)
    inst.components.finiteuses:SetUses(ANIMALTRANCE_USES)
    return inst
end

local function gustofwind()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackgustofwind)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(GUSTOFWIND_USES)
    inst.components.finiteuses:SetUses(GUSTOFWIND_USES)

    return inst
end

local function holdanimal()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackholdanimal)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(HOLDANIMAL_USES)
    inst.components.finiteuses:SetUses(HOLDANIMAL_USES)

    return inst
end


local function dopoison(inst,target)
    if(target and not target.components.health:IsDead())then
            target.components.combat:GetAttacked(inst.caster, POISON_DAMAGE, nil,nil,FA_DAMAGETYPE.POISON)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end

local function castpoison(inst1,attacker,target)
    local inst=CreateEntity()
    inst.persists=false
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_poison"
    inst.components.spell.duration = POISON_LENGTH
    inst.components.spell.fn = dopoison
    inst.components.spell.period=POISON_PERIOD
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=attacker
        target.fa_poison = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_poison = nil
    end
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
end


local function poisonwand()
    local inst = commonfn("green")
    inst.components.inventoryitem.imagename="greenstaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(castpoison)
    inst.components.weapon:SetProjectile("acidarrowprojectile")
    inst.components.finiteuses:SetMaxUses(POISON_USES)
    inst.components.finiteuses:SetUses(POISON_USES)

    return inst
end

local function onattackdominateanimal(staff, target, orpos)
    local attacker = staff.components.inventoryitem.owner

    if(not target:HasTag("fa_animal")) then return false end
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/4))*100
    if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab) end
    if target.components.follower and target.components.health and target.components.health.maxhealth<=treshold then
        attacker.components.leader:AddFollower(target)
        staff.components.finiteuses:Use(1)
    end

    --staff.components.finiteuses:Use(1)
end

local function dominateanimal()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackdominateanimal)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(DOMINATEANIMAL_USES)
    inst.components.finiteuses:SetUses(DOMINATEANIMAL_USES)
    return inst
end

function snaredebuff(inst,attacker,target)
    local inst = CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_snare"
    inst.components.spell.duration = SNARE_DURATION
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_snare = inst
        target:AddTag(inst.components.spell.spellname)
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed*SNARE_SPEED
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_snare = nil
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed/SNARE_SPEED
        end
    end
    inst.components.spell.resumefn = function(inst,timeleft)   end 
    inst.components.spell.removeonfinish = true
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
    return true
end

local function snarefn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(snaredebuff)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(SNARE_USES)
    inst.components.finiteuses:SetUses(SNARE_USES)

    return inst
end

local function onattackcalllightning(staff, target, orpos)
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local caster = staff.components.inventoryitem.owner
    local lightning = SpawnPrefab("lightning")
    lightning.Transform:SetPosition(pos:Get())
    if target.components.burnable and not target.components.fueled then
        target.components.burnable:Ignite()
    end
    if(target.components.combat and not (target.components.health and target.components.health:IsDead())) then
        target.components.combat:GetAttacked(caster, CALLLIGHTNING_DAMAGE, nil,nil,FA_DAMAGETYPE.ELECTRIC)
    end
    staff.components.finiteuses:Use(1)
end

local function calllightning()
local inst = commonfn("blue")

    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackcalllightning)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(CALLLIGHTNING_USES)
    inst.components.finiteuses:SetUses(CALLLIGHTNING_USES)

    return inst
end

--for the sake of 'autoscaling', we need to add the 'effect' as opposed of simply giving item a damage and getting over with it

function oninflictwounds(inst,attacker,target,damagelv)
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local damage=(1+math.floor(cl/4))*damagelv
    if(target.components.combat and not (target.components.health and target.components.health:IsDead())) then
        local fx=SpawnPrefab("fa_heal_redfx")
        fx.persists=false
        local follower = fx.entity:AddFollower()
        follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0, 0, -0.0001 )
        fx:ListenForEvent("animover", function()  fx:Remove() end)
        target.components.combat:GetAttacked(attacker, damage, nil,nil,FA_DAMAGETYPE.HOLY)
    end
end

local function inflictlightfn()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        return oninflictwounds(inst,attacker,target,INFLICT_LIGHT_WOUNDS)
        end)
    inst.components.weapon:SetProjectile("fire_projectilex")
    inst.components.inventoryitem.imagename="firestaff"
    inst.components.finiteuses:SetMaxUses(INFLICT_LIGHT_USES)
    inst.components.finiteuses:SetUses(INFLICT_LIGHT_USES)

    return inst
end

local function inflictmodfn()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        return oninflictwounds(inst,attacker,target,INFLICT_MOD_WOUNDS)
        end)
    inst.components.weapon:SetProjectile("fire_projectilex")
    inst.components.inventoryitem.imagename="firestaff"
    inst.components.finiteuses:SetMaxUses(INFLICT_MOD_USES)
    inst.components.finiteuses:SetUses(INFLICT_MOD_USES)

    return inst
end

local function inflictserfn()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        return oninflictwounds(inst,attacker,target,INFLICT_SERIOUS_WOUNDS)
        end)
    inst.components.weapon:SetProjectile("fire_projectilex")
    inst.components.inventoryitem.imagename="firestaff"
    inst.components.finiteuses:SetMaxUses(INFLICT_SERIOUS_USES)
    inst.components.finiteuses:SetUses(INFLICT_SERIOUS_USES)

    return inst
end

local function inflictcriticalfn()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        return oninflictwounds(inst,attacker,target,INFLICT_CRITICAL_WOUNDS)
        end)
    inst.components.weapon:SetProjectile("fire_projectilex")
    inst.components.inventoryitem.imagename="firestaff"
    inst.components.finiteuses:SetMaxUses(INFLICT_CRITICAL_USES)
    inst.components.finiteuses:SetUses(INFLICT_CRITICAL_USES)

    return inst
end


local function onattackfear(inst1,attacker,target)
    if(target:HasTag("undead") or target:HasTag("construct")) then return false end
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local treshold=(1+1*math.floor(cl/4))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_fear)then target.fa_fear.components.spell:OnFinish() end
        
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_fear"
        inst.components.spell.duration = FEAR_DURATION
        inst.components.spell.ontargetfn = function(inst,target)
            target.fa_fear = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_fear = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end
end

local function fearfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackfear)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(FEAR_USES)
    inst.components.finiteuses:SetUses(FEAR_USES)

    return inst
end


local function onattackholdperson(inst1,attacker,target)
    if(not target:HasTag("fa_humanoid")) then return false end
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end

        local inst=SpawnPrefab("fa_spinningstarsfx")
        inst.persists=false
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_holdperson"
        inst.components.spell.duration = HOLDPERSON_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

            local follower = inst.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0, -200, -0.0001 )
            target.fa_stun = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_stun = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end
end

local function holdperson()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackholdperson)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(HOLDPERSON_USES)
    inst.components.finiteuses:SetUses(HOLDPERSON_USES)

    return inst
end

local function dodisease(inst,target)
    local reader=inst.caster
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local damage=DISEASE_DAMAGE*(1+math.floor(cl/4))
    if(target and not target.components.health:IsDead())then
            target.components.combat:GetAttacked(inst.caster, damage, nil,nil,FA_DAMAGETYPE.DEATH)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end


local function castdisease(inst1,attacker,target)
    if(target.fa_disease)then target.fa_disease.components.spell:OnFinish() end

    local inst=CreateEntity()
    inst.persists=false
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_disease"
    inst.components.spell.duration = DISEASE_DURATION
    inst.components.spell.fn = dodisease
    inst.components.spell.period=DISEASE_PERIOD
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=attacker
        target.fa_disease = inst
        target:AddTag(inst.components.spell.spellname)
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed*DISEASE_SNARE
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_disease = nil
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed/DISEASE_SNARE
        end
    end
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
end


local function causediseasefn()
    local inst = commonfn("green")
    inst.components.inventoryitem.imagename="greenstaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(castdisease)
    inst.components.weapon:SetProjectile("acidarrowprojectile")
    inst.components.finiteuses:SetMaxUses(DISEASE_USES)
    inst.components.finiteuses:SetUses(DISEASE_USES)

    return inst
end

local function acidsplashfn()
    local inst = commonfn("green")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        local cl=1
        if(attacker.components.fa_spellcaster)then
            cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
        end
        local damage=(1+math.floor(cl/5))*ACIDSPLASH_DAMAGE
        if(target.components.combat and not (target.components.health and target.components.health:IsDead())) then
            target.components.combat:GetAttacked(attacker, damage, nil,nil,FA_DAMAGETYPE.ACID)
        end
        end)
    inst.components.weapon:SetProjectile("acidarrowprojectile")
    inst.components.inventoryitem.imagename="greenstaff"

    inst.components.finiteuses:SetMaxUses(ACIDSPLASH_USES)
    inst.components.finiteuses:SetUses(ACIDSPLASH_USES)

    return inst
end

--why doesnt this have a HD check?

local function ondazehuman(staff, target, orpos)
    if(not target:HasTag("fa_humanoid")) then return false end
    local attacker = staff.components.inventoryitem.owner
  --[[  local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then]]
        if(target.fa_daze)then target.fa_daze.components.spell:OnFinish() end

        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_animaltranse"
        inst.components.spell.duration = DAZEHUMAN_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

            local fx=SpawnPrefab("fa_musicnotesfx")
            fx.persists=false
            local follower = fx.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
            target.fa_daze_fx=fx
            target.fa_daze = inst
            target:ListenForEvent("attacked", ondazedattacked)
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_daze = nil
            if(inst.components.spell.target.fa_daze_fx) then inst.components.spell.target.fa_daze_fx:Remove() end
            inst.components.spell.target:RemoveEventCallback("attacked",ondazedattacked)
        end
                --inst.components.spell.fn = function(inst, target, variables) end
                inst.components.spell.resumefn = function() end
                inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()

        staff.components.finiteuses:Use(1)
--    end
end


local function dazehumanfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(ondazehuman)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(DAZEHUMAN_USES)
    inst.components.finiteuses:SetUses(DAZEHUMAN_USES)
    return inst
end

local function frostrayfn()
    local inst = commonfn("blue")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        local cl=1
        if(attacker.components.fa_spellcaster)then
            cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.EVOCATION)
        end
        local damage=(1+math.floor(cl/5))*FROSTRAY_DAMAGE
        if(target.components.combat and not (target.components.health and target.components.health:IsDead())) then
            target.components.combat:GetAttacked(attacker, damage, nil,nil,FA_DAMAGETYPE.COLD)
        end
        end)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.inventoryitem.imagename="icestaff"

    inst.components.finiteuses:SetMaxUses(FROSTRAY_USES)
    inst.components.finiteuses:SetUses(FROSTRAY_USES)

    return inst
end

local function magicmissilefn()
    local inst = commonfn("blue")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(function(inst,attacker,target)
        local cl=1
        if(attacker.components.fa_spellcaster)then
            cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.EVOCATION)
        end
        local damage=MAGICMISSLE_DAMAGE+math.floor(cl/5)*MAGICMISSLE_DAMAGE_INC
        if(target.components.combat and not (target.components.health and target.components.health:IsDead())) then
            target.components.combat:GetAttacked(attacker, damage, nil,nil,FA_DAMAGETYPE.FORCE)
        end
        end)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.inventoryitem.imagename="icestaff"

    inst.components.finiteuses:SetMaxUses(MAGICMISSLE_USES)
    inst.components.finiteuses:SetUses(MAGICMISSLE_USES)

    return inst
end

local function onattackcharmperson(staff, target, orpos)
    if(not target:HasTag("fa_humanoid")) then return false end
    local attacker = staff.components.inventoryitem.owner
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/4))*100
    if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab) return false  end
    if target.components.follower and target.components.health and target.components.health.maxhealth<=treshold then
        attacker.components.leader:AddFollower(target)
            target.components.follower.maxfollowtime=math.max(target.components.follower.maxfollowtime or 0,CHARMPERSON_DURATION)
            target.components.follower:AddLoyaltyTime(CHARMPERSON_DURATION)
            staff.components.finiteuses:Use(1)
    end
end

local function charmpersonfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackcharmperson)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(CHARMPERSON_USES)
    inst.components.finiteuses:SetUses(CHARMPERSON_USES)
    return inst
end

local function onattackdominateperson(staff, target, orpos)
    if(not target:HasTag("fa_humanoid")) then return false end
    local attacker = staff.components.inventoryitem.owner
    if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab) return false  end
    if target.components.follower  then
        --this is needed so it resets the timer - it can have a side effect tho
        target.components.follower:SetLeader(nil)
        target.components.follower:SetLeader(attacker)
        if(target.components.combat)then
            --no, this shit wont hold through save/load, what can i do? Is this good enough reason to override combat save/load logic...
            target.components.combat.damagemultiplier=target.components.combat.damagemultiplier*DOMINATEPERSON_DMG
            target.components.combat.min_attack_period=target.components.combat.min_attack_period/DOMINATEPERSON_AS
        end
            staff.components.finiteuses:Use(1)
    end
end

local function dominatepersonfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackdominateperson)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(DOMINATEPERSON_USES)
    inst.components.finiteuses:SetUses(DOMINATEPERSON_USES)
    return inst
end
--why would roe have hd req?
function rayofenfeeblementdebuff(inst,attacker,target)
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local treshold=(1+math.floor(cl/3))*100
    if target.components.health and target.components.health.maxhealth<=treshold then

    local inst = CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_rayofenfeeblement"
    inst.components.spell.duration = ROE_DURATION
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_rayofenfeeblement = inst
        target:AddTag(inst.components.spell.spellname)
        if(target.components.combat)then
            target.components.combat.damagemultiplier=target.components.combat.damagemultiplier*ROE_DEBUFF
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_rayofenfeeblement = nil
        if(target.components.combat)then
            target.components.combat.damagemultiplier=target.components.combat.damagemultiplier/ROE_DEBUFF
        end
    end
    inst.components.spell.resumefn = function(inst,timeleft)   end 
    inst.components.spell.removeonfinish = true
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
    return true

    end
    return false
end

local function rayofenfeeblementfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(rayofenfeeblementdebuff)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(ROE_USES)
    inst.components.finiteuses:SetUses(ROE_USES)

    return inst
end


function slowdebuff(inst,attacker,target)

    local inst = CreateEntity()
    inst.persists=false
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_slow"
    inst.components.spell.duration = SLOW_DURATION
    inst.components.spell.ontargetfn = function(inst,target)
        target.fa_slow = inst
        target:AddTag(inst.components.spell.spellname)
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed*SLOW_MOVEMENTSPEED
        end
        if(target.components.combat)then
            target.components.combat.min_attack_period=target.components.combat.min_attack_period/SLOW_ATTACK
        end
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_slow = nil
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed/SLOW_MOVEMENTSPEED
        end
        if(target.components.combat)then
            target.components.combat.min_attack_period=target.components.combat.min_attack_period*SLOW_ATTACK
        end
    end
    inst.components.spell.resumefn = function(inst,timeleft)   end 
    inst.components.spell.removeonfinish = true
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
    return true

end

local function slowfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(slowdebuff)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(SLOW_USES)
    inst.components.finiteuses:SetUses(SLOW_USES)

    return inst
end

local function onattackcommandundead(staff, target, orpos)
    if(not target:HasTag("undead")) then return false end
    local attacker = staff.components.inventoryitem.owner
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local treshold=(1+3*math.floor(cl/4))*100
    if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab) return false  end
    if target.components.follower and target.components.health and target.components.health.maxhealth<=treshold then
        attacker.components.leader:AddFollower(target)

            target.components.follower.maxfollowtime=COMMANDUNDEAD_DURATION
            target.components.follower:AddLoyaltyTime(COMMANDUNDEAD_DURATION)
            staff.components.finiteuses:Use(1)
    end
end

local function commandundeadfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackcommandundead)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(COMMANDUNDEAD_USES)
    inst.components.finiteuses:SetUses(COMMANDUNDEAD_USES)
    return inst
end

local function onattackholdmonster(inst1,attacker,target)
    if( target:HasTag("undead") or target:HasTag("fa_giant") or target:HasTag("epic") or target:HasTag("fa_construct")) then return false end
    
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end
        --meh. slap spell on fx. lazy to rewrite
        local inst=SpawnPrefab("fa_spinningstarsfx")
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_holdmonster"
        inst.components.spell.duration = HOLDMONSTER_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

        local follower = inst.entity:AddFollower()
        follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0, -200, -0.0001 )
        target.fa_stun = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_stun = nil
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()

end

local function holdmonsterfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackholdmonster)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(HOLDMONSTER_USES)
    inst.components.finiteuses:SetUses(HOLDMONSTER_USES)

    return inst
end

local function onattackcharmmonster(staff, target, orpos)
    if( target:HasTag("undead") or target:HasTag("fa_giant") or target:HasTag("epic") or target:HasTag("fa_construct")) then return false end
    local attacker = staff.components.inventoryitem.owner
    if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab)  return false end
    
        attacker.components.leader:AddFollower(target)

            target.components.follower.maxfollowtime=math.max(target.components.follower.maxfollowtime or 0,CHARM_DURATION)
            target.components.follower:AddLoyaltyTime(CHARM_DURATION)
     staff.components.finiteuses:Use(1)
end

local function charmmonsterfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackcharmmonster)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(CHARM_USES)
    inst.components.finiteuses:SetUses(CHARM_USES)
    return inst
end

local function doacidarrow(inst,target)
    local reader=inst.caster
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end
    local damage=ACIDARROW_DOT*(1+math.floor(cl/10))
    if(target and not target.components.health:IsDead())then
            target.components.combat:GetAttacked(inst.caster, damage, nil,nil,FA_DAMAGETYPE.ACID)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end


local function castacidarrow(inst1,attacker,target)
    if(target.fa_acidarrow)then target.fa_acidarrow.components.spell:OnFinish() end
    local cl=1
    if(attacker.components.fa_spellcaster)then
        cl=attacker.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.CONJURATION)
    end

    local inst=CreateEntity()
    inst.persists=false
    inst:AddTag("FX")
    inst:AddTag("NOCLICK")
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_acidarrow"
    inst.components.spell.duration = ACIDARROW_LENGTH+math.floor(cl/10)*ACIDARROW_LENGTH_INC
    inst.components.spell.fn = doacidarrow
    inst.components.spell.period=ACIDARROW_PERIOD
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=attacker
        target.fa_acidarrow = inst
        target:AddTag(inst.components.spell.spellname)
    end
    inst.components.spell.onfinishfn = function(inst)
        if not inst.components.spell.target then
            return
        end
        inst.components.spell.target.fa_acidarrow = nil
    end
    inst.components.spell:SetTarget(target)
    inst.components.spell:StartSpell()
end

local function acidarrowfn()
    local inst = commonfn("green")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(castacidarrow)
    inst.components.inventoryitem.imagename="greenstaff"
--    inst.AnimState:SetMultColour(0,1,0,1)
    inst.components.weapon:SetProjectile("acidarrowprojectile")

    inst.components.finiteuses:SetMaxUses(ACIDARROW_USES)
    inst.components.finiteuses:SetUses(ACIDARROW_USES)

    return inst
end

local function onattackenlargehumanoid(staff, target, orpos)
    if(not target:HasTag("fa_humanoid")) then return false end
    local attacker = staff.components.inventoryitem.owner
    if(target.fa_enlarge)then 
            target.fa_enlarge.components.spell.lifetime = 0
            target.fa_enlarge.components.spell:ResumeSpell()
    else
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_enlarge"
        inst.components.spell.duration = ENLARGE_HUMANOID_DURATION
        inst.components.spell.ontargetfn = function(inst,target)
        local x,y,z=target.Transform:GetScale()
        target.Transform:SetScale(x*2,y*2,z*2)
        if(target.components.combat)then
            target.components.combat.damagemultiplier=target.components.combat.damagemultiplier*ENLARGE_HUMANOID_MULT
        end    
        if(target.components.locomotor)then
            target.components.locomotor.runspeed=target.components.locomotor.runspeed*ENLARGE_HUMANOID_SPEED
        end    
        target.fa_enlarge = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            if(target:IsValid() and target.Transform and not (target.components.health and target.components.health:IsDead()))then
            local x,y,z=target.Transform:GetScale()
            target.Transform:SetScale(x/2,y/2,z/2)
            if(target.components.combat)then
                target.components.combat.damagemultiplier=target.components.combat.damagemultiplier/ENLARGE_HUMANOID_MULT
            end        
            if(target.components.locomotor)then
                target.components.locomotor.runspeed=target.components.locomotor.runspeed/ENLARGE_HUMANOID_SPEED
            end
            inst.components.spell.target.fa_enlarge = nil
            end
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
        staff.components.finiteuses:Use(1)
    end

end

local function enlargehumanoidfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackenlargehumanoid)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(ENLARGE_HUMANOID_USES)
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetUses(ENLARGE_HUMANOID_USES)
    return inst
end

local function onattackreducehumanoid(staff, target, orpos)
    if(not target:HasTag("fa_humanoid")) then return false end
    local attacker = staff.components.inventoryitem.owner
    if(target.fa_reduce)then 
            target.fa_reduce.components.spell.lifetime = 0
            target.fa_reduce.components.spell:ResumeSpell()
    else
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_reduce"
        inst.components.spell.duration = REDUCE_HUMANOID_DURATION
        inst.components.spell.ontargetfn = function(inst,target)
        local x,y,z=target.Transform:GetScale()
        target.Transform:SetScale(x/2,y/2,z/2)
        if(target.components.combat)then
            target.components.combat.damagemultiplier=target.components.combat.damagemultiplier*REDUCE_HUMANOID_MULT
        end        
        if(target.components.locomotor)then
                target.components.locomotor.runspeed=target.components.locomotor.runspeed*REDUCE_HUMANOID_SPEED
        end
        target.fa_reduce = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            if(target:IsValid() and target.Transform and not (target.components.health and target.components.health:IsDead()))then
                local x,y,z=target.Transform:GetScale()
                target.Transform:SetScale(x*2,y*2,z*2)
                if(target.components.combat)then
                    target.components.combat.damagemultiplier=target.components.combat.damagemultiplier/REDUCE_HUMANOID_MULT
                end        
                if(target.components.locomotor)then
                    target.components.locomotor.runspeed=target.components.locomotor.runspeed/REDUCE_HUMANOID_SPEED
                end        
              inst.components.spell.target.fa_reduce = nil
            end
        end
        inst.components.spell.resumefn = function() end
        inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
        staff.components.finiteuses:Use(1)
    end

end

local function reducehumanoidfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackreducehumanoid)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.spellcaster:SetSpellTestFn(canCastOnCombatTarget)
    inst.components.finiteuses:SetMaxUses(REDUCE_HUMANOID_USES)
    inst.components.finiteuses:SetUses(REDUCE_HUMANOID_USES)
    return inst
end

local function onattackweb(staff, target, orpos)
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local inst = SpawnPrefab("fa_webspell_spawn")
    inst.Transform:SetPosition(pos.x, pos.y, pos.z)
    staff.components.finiteuses:Use(1)
end

local function webfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onattackweb)
    inst.components.spellcaster.canuseontargets = false
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(WEB_USES)
    inst.components.finiteuses:SetUses(WEB_USES)
    return inst
end

function inflictlightmass(staff, target, orpos)
    local reader = staff.components.inventoryitem.owner
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local damage=INFLICTMASS_DAMAGE*(1+math.floor(cl/4))
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end

    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, AOE_RANGE,nil,{"INLIMBO","FX","companion","player"})
            for k,v in pairs(ents) do
                if not(v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player"))
                    and not v:IsInLimbo() then
                    
                    if(v.components.combat and not(v.components.health and v.components.health:IsDead())) then
                        local boom =SpawnPrefab("fa_heal_redfx")
                        local follower = boom.entity:AddFollower()
                        follower:FollowSymbol(v.GUID,reader.components.combat.hiteffectsymbol, 0, 0, -0.0001)
                        boom.persists=false
                        boom:ListenForEvent("animover", function()  boom:Remove() end)
                        
                        v.components.combat:GetAttacked(reader, damage, nil,nil,FA_DAMAGETYPE.HOLY)
                    end
                end
            end
    staff.components.finiteuses:Use(1)
    return true
end

local function inflictlightmassfn()
    local inst = commonfn("red")
    inst.components.inventoryitem.imagename="firestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(inflictlightmass)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(INFLICTMASS_USES)
    inst.components.finiteuses:SetUses(INFLICTMASS_USES)
    return inst
end

--why doesnt this have a HD check?
local function haltundeadmass(staff, target, orpos)
    local reader = staff.components.inventoryitem.owner
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end

    local treshold=(1+3*math.floor(cl/5))*100
    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, AOE_RANGE ,{'undead'}, {'smashable',"companion","player","INLIMBO","FX"})
        for k,v in pairs(ents) do
                if (v.components.health and v.components.health.maxhealth<=treshold) and
                 not (v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player")) then
                    if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end
                    
                    local inst=SpawnPrefab("fa_musicnotesfx")
                    inst.persists=false
                    local spell = inst:AddComponent("spell")
                    inst.components.spell.spellname = "fa_haltundeadmass"
                    inst.components.spell.duration = HALTUNDEAD_DURATION
                    inst.components.spell.ontargetfn = function(inst,target)
                    local follower = inst.entity:AddFollower()
                    follower:FollowSymbol( v.GUID, target.components.combat.hiteffectsymbol, 0,  -200, -0.0001 )
                    target.fa_stun = inst
                    end
                    inst.components.spell.onfinishfn = function(inst)
                        if not inst.components.spell.target then return end
                        inst.components.spell.target.fa_stun = nil
                    end
                    inst.components.spell.resumefn = function() end
                    inst.components.spell.removeonfinish = true

                    inst.components.spell:SetTarget(v)
                    inst.components.spell:StartSpell()

                end
            end
    staff.components.finiteuses:Use(1)
    return true
end

local function haltundeadmassfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(haltundeadmass)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(HALTUNDEAD_USES)
    inst.components.finiteuses:SetUses(HALTUNDEAD_USES)
    return inst
end

function disruptundead(staff, target, orpos)
    local reader = staff.components.inventoryitem.owner
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.NECROMANCY)
    end
    local damage=DISRUPTION_DAMAGE*cl

    local pos=orpos
    if(pos==nil and target~=nil)then
        pos=Vector3(target.Transform:GetWorldPosition())
    end
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, AOE_RANGE ,{'undead'}, {'smashable',"companion","player","INLIMBO","FX"})
            for k,v in pairs(ents) do
                if ( not (v.components.follower and v.components.follower.leader and v.components.follower.leader:HasTag("player")) )then
                    
                    if(v.components.combat and not(v.components.health and v.components.health:IsDead())) then
                        local boom =SpawnPrefab("fa_heal_redfx")
                        local follower = boom.entity:AddFollower()
                        follower:FollowSymbol(v.GUID,reader.components.combat.hiteffectsymbol, 0, 100, -0.0001)
                        boom.persists=false
                        boom:ListenForEvent("animover", function()  boom:Remove() end)
                        
                        v.components.combat:GetAttacked(reader, damage, nil,nil,FA_DAMAGETYPE.HOLY)
                    end
                end
            end
    staff.components.finiteuses:Use(1)
    return true
end

local function disruptundeadfn()
    local inst = commonfn("red")
    inst.components.inventoryitem.imagename="firestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(disruptundead)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = true
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(DISRUPTION_USES)
    inst.components.finiteuses:SetUses(DISRUPTION_USES)
    return inst
end


local function canCastOnLockedTarget(inst, caster, target, pos)
    if(target and target.components.lock and target.components.lock:IsLocked()  and not target:IsInLimbo())then
        return true
    else
        return false
    end
end

local function onknock(staff, target, orpos)
    local reader = staff.components.inventoryitem.owner
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.TRANSMUTATION)
    end
    local maxlv=0
    for k,v in ipairs(KNOCK_LEVELS) do
        if(cl>=v)then 
            maxlv=maxlv+1
        else
            break
        end
    end
    if(target and target.components.lock and target.components.lock:IsLocked() )then
        if target.components.lock.locklevel~=nil and   target.components.lock.locklevel<maxlv then
            target.components.lock:Unlock(nil, reader)
            staff.components.finiteuses:Use(1)
        end
    end
end

local function knockfn()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("spellcaster")
    inst.components.spellcaster:SetSpellFn(onknock)
    inst.components.spellcaster.canuseontargets = true
    inst.components.spellcaster.canuseonpoint = false
    inst.components.spellcaster.canusefrominventory = false
    inst.components.finiteuses:SetMaxUses(KNOCK_USES)
    inst.components.spellcaster:SetSpellTestFn(canCastOnLockedTarget)
    inst.components.finiteuses:SetUses(KNOCK_USES)
    return inst
end

return 
Prefab("common/inventory/fa_spell_animaltrance", animaltrance, assets, prefabs),
Prefab("common/inventory/fa_spell_gustofwind", gustofwind, assets, prefabs),
Prefab("common/inventory/fa_spell_holdanimal", holdanimal, assets, prefabs),
Prefab("common/inventory/fa_spell_calllightning", calllightning, assets, prefabs),
Prefab("common/inventory/fa_spell_dominateanimal", dominateanimal, assets, prefabs),
Prefab("common/inventory/fa_spell_poison", poisonwand, assets, prefabs),
Prefab("common/inventory/fa_spell_snare", snarefn, assets, prefabs),
Prefab("common/inventory/fa_spell_firewall", firewall, assets, prefabs),
Prefab("common/inventory/fa_spell_fear", fearfn, assets, prefabs),
Prefab("common/inventory/fa_spell_inflictlightwounds", inflictlightfn, assets, prefabs),
Prefab("common/inventory/fa_spell_inflictmoderatewounds", inflictmodfn, assets, prefabs),
Prefab("common/inventory/fa_spell_inflictseriouswounds", inflictserfn, assets, prefabs),
Prefab("common/inventory/fa_spell_inflictcriticalwounds", inflictcriticalfn, assets, prefabs),
Prefab("common/inventory/fa_spell_holdperson", holdperson, assets, prefabs),
Prefab("common/inventory/fa_spell_causedisease", causediseasefn, assets, prefabs),
Prefab("common/inventory/fa_spell_acidsplash", acidsplashfn, assets, prefabs),
Prefab("common/inventory/fa_spell_dazehuman", dazehumanfn, assets, prefabs),
Prefab("common/inventory/fa_spell_frostray", frostrayfn, assets, prefabs),
Prefab("common/inventory/fa_spell_magicmissile", magicmissilefn, assets, prefabs),
Prefab("common/inventory/fa_spell_charmperson", charmpersonfn, assets, prefabs),
Prefab("common/inventory/fa_spell_rayofenfeeblement", rayofenfeeblementfn, assets, prefabs),
Prefab("common/inventory/fa_spell_commandundead", commandundeadfn, assets, prefabs),
Prefab("common/inventory/fa_spell_acidarrow", acidarrowfn, assets, prefabs),
Prefab("common/inventory/fa_spell_slow", slowfn, assets, prefabs),
Prefab("common/inventory/fa_spell_fireball", fireball, assets, prefabs),
Prefab("common/inventory/fa_spell_charmmonster", charmmonsterfn, assets, prefabs),
Prefab("common/inventory/fa_spell_holdmonster", holdmonsterfn, assets, prefabs),
Prefab("common/inventory/fa_spell_dominateperson", dominatepersonfn, assets, prefabs),
Prefab("common/inventory/fa_spell_enlargehumanoid", enlargehumanoidfn, assets, prefabs),
Prefab("common/inventory/fa_spell_reducehumanoid", reducehumanoidfn, assets, prefabs),
Prefab("common/inventory/fa_spell_web", webfn, assets, prefabs),
Prefab("common/inventory/fa_spell_flamestrike", flamestrikefn, assets, prefabs),
Prefab("common/inventory/fa_spell_inflictlightwoundsmass", inflictlightmassfn, assets, prefabs),
Prefab("common/inventory/fa_spell_haltundeadmass", haltundeadmassfn, assets, prefabs),
Prefab("common/inventory/fa_spell_disruptundead", disruptundeadfn, assets, prefabs),
Prefab("common/inventory/fa_spell_knock", knockfn, assets, prefabs),
Prefab("common/inventory/firewallwand_insta", firewall_insta, assets, prefabs),

    --DEPRECATED
Prefab("common/inventory/magicmissilewand", magicmissilefn, assets, prefabs),
    Prefab("common/inventory/lightningboltwand", lightningbolt, assets, prefabs),
    Prefab("common/inventory/icestormwand", icestorm, assets, prefabs),
    Prefab("common/inventory/sunburstwand", sunburst, assets, prefabs),
    Prefab("common/inventory/prismaticwand", prismaticwall, assets, prefabs)