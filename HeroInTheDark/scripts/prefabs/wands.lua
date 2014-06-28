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

local MAGICMISSLE_USES=30
local ACIDARROW_USES=15
local FIREBALL_USES=10
local ICESTORM_USES=10
local SUNBURST_USES=10
local PRISMATICWALL_USES=5
local FIREWALL_USES=10

local FIREBALL_RADIUS=5
local ICESTORM_RADIUS=15
local SUNBURST_RADIUS=15
local FIREWALL_WIDTH=15
local FIREWALL_DEPTH=5
local PRISMATIC_WIDTH=15
local PRISMATIC_DEPTH=5

-- 5,10,20,30,40 dmg at lvs, 1,5,10,15,20 
local ANIMALTRANCE_USES=5
local ANIMALTRANCE_DURATION=2*60
local GUSTOFWIND_USES=10
local HOLDANIMAL_USES=5
local HOLDANIMAL_DURATION=20
local CALLLIGHTNING_DAMAGE=100
local CALLLIGHTNING_USES=12
local POISON_LENGTH=20
local POISON_DAMAGE=7
local POISON_USES=7
local SNARE_SPEED=0.5
local SNARE_DURATION=2*60

local MAGICMISSLE_DAMAGE=15
local ACIDARROW_DOT=10
local ACIDARROW_LENGTH=24
local FIREBALL_DAMAGE=100
local ICESTORM_LENGTH=120
local ICESTORM_DAMAGE=5
local SUNBURST_DAMAGE=100
local LIGHTNINGBOLT_DAMAGE=100



local WAND_RANGE=15

local BOW_USES=20
local BOW_DAMAGE=20
local BOW_RANGE=15


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
    --since i cant set weapon to aoe...
    local pos=Vector3(target.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, FIREBALL_RADIUS,nil,{"INLIMBO"})
            for k,v in pairs(ents) do
                if  not v:IsInLimbo() then
                    if v.components.burnable and not v.components.fueled then
                     v.components.burnable:Ignite()
                    end

                    if(v.components.combat and not v==target and not (v.components.health and v.components.health:IsDead())) then
                        v.components.combat:GetAttacked(attacker, FIREBALL_DAMAGE, nil,nil,FA_DAMAGETYPE.FIRE)
                    end
                end
            end
    attacker.SoundEmitter:PlaySound("dontstarve/wilson/fireball_explo")
end

local function onattacksunburst(inst,attacker,target)
local pos=Vector3(target.Transform:GetWorldPosition())
    local lightning = SpawnPrefab("lightning")
    lightning.Transform:SetPosition(pos:Get())
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, SUNBURST_RADIUS,nil,{"player","pet","companion","INLIMBO"})
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
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, ICESTORM_RADIUS,nil,{"player","pet","companion","INLIMBO"})
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
---------COMMON FUNCTIONS---------
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


local function magicmissile()
    local inst = commonfn("blue")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(MAGICMISSLE_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
--    inst.components.weapon:SetOnAttack(onattack_red)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.FORCE
    inst.components.inventoryitem.imagename="icestaff"

    inst.components.finiteuses:SetMaxUses(MAGICMISSLE_USES)
    inst.components.finiteuses:SetUses(MAGICMISSLE_USES)

    return inst
end

local function acidarrow()
    local inst = commonfn("green")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(ACIDARROW_DOT)
    inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.ACID
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackacidarrow)
    inst.components.inventoryitem.imagename="greenstaff"
--    inst.AnimState:SetMultColour(0,1,0,1)
    inst.components.weapon:SetProjectile("acidarrowprojectile")

    inst.components.finiteuses:SetMaxUses(ACIDARROW_USES)
    inst.components.finiteuses:SetUses(ACIDARROW_USES)

    return inst
end

local function fireball()
    local inst = commonfn("red")
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(FIREBALL_DAMAGE)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackfireball)
    inst.components.weapon:SetProjectile("fireballprojectile")
inst.components.weapon.fa_damagetype=FA_DAMAGETYPE.FIRE
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

local function onattackanimaltrance(inst,attacker,target)
    if(not target:HasTag("fa_animal")) then return false end
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_daze)then target.fa_daze.components.spell:OnFinish() end

        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_animaltranse"
        inst.components.spell.duration = ANIMALTRANCE_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

            local fx=SpawnPrefab("fa_musicnotesfx")
            fx.persists=false
            local follower = fx.entity:AddFollower()
            follower:FollowSymbol( inst.GUID, target.components.combat.hiteffectsymbol, 0, 0, -0.0001 )
            target.fa_daze_fx=fx
            target.fa_daze = inst
            target:ListenForEvent("attacked", ondazedattacked)
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_daze = nil
            if(inst.components.spell.target.fa_daze_fx) then inst.components.spell.target.fa_daze_fx:Remove() end
            inst.components.spell.target:RemoveEventListener("attacked",ondazedattacked)
        end
                --inst.components.spell.fn = function(inst, target, variables) end
                inst.components.spell.resumefn = function() end
                inst.components.spell.removeonfinish = true

        inst.components.spell:SetTarget(v)
        inst.components.spell:StartSpell()
    end
end

local function onattackgustofwind(inst,attacker,target)
        local v1=target.Physics:GetVelocity()
        local vhit=inst.Physics:GetVelocity()--will this end up being 0 due to it hitting the target or the actual velocity before the hit?
        local coef=1
        target.Physics:SetVelocity((v1+vhit*coef):Get())
end

local function onattackholdanimal(inst,attacker,target)
    if(not target:HasTag("fa_animal")) then return false end
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/5))*100
    if target.components.health and target.components.health.maxhealth<=treshold then
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end
        
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_holdanimal"
        inst.components.spell.duration = HOLDANIMAL_DURATION
        inst.components.spell.ontargetfn = function(inst,target)

            local fx=SpawnPrefab("fa_spinningstarsfx")
            fx.persists=false
            local follower = fx.entity:AddFollower()
            follower:FollowSymbol( inst.GUID, target.components.combat.hiteffectsymbol, 0, 0, -0.0001 )
            target.fa_daze_fx=fx
            target.fa_daze = inst
        end
               --inst.components.spell.onstartfn = function() end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_daze = nil
            if(inst.components.spell.target.fa_daze_fx) then inst.components.spell.target.fa_daze_fx:Remove() end
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
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackanimaltrance)
    inst.components.weapon:SetProjectile("ice_projectilex")
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
        --bypassing armor - but this also bypasses potential retarget
--        target.components.health:DoDelta(-POISON_DAMAGE)
            target.components.combat:GetAttacked(inst.caster, POISON_DAMAGE, nil,nil,FA_DAMAGETYPE.POISON)

                local boom =SpawnPrefab("fa_poisonfx")
                local follower = boom.entity:AddFollower()
                follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
                boom.persists=false
                boom:ListenForEvent("animover", function()  boom:Remove() end)
       
    end
end

local function castpoison(inst,attacker,target)
    local spell = inst:AddComponent("spell")
    inst.components.spell.spellname = "fa_poison"
    inst.components.spell.duration = POISON_LENGTH
    inst.components.spell.fn = dopoison
    inst.components.spell.period=POISON_PERIOD
    inst.components.spell.removeonfinish = true
    inst.components.spell.ontargetfn = function(inst,target)
        inst.caster=caster
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


local function onattackdominateanimal(inst,attacker,target)
    if(not target:HasTag("fa_animal")) then return false end
    local cl=1
    if(reader.components.fa_spellcaster)then
        cl=reader.components.fa_spellcaster:GetCasterLevel(FA_SPELL_SCHOOLS.ENCHANTMENT)
    end
    local treshold=(1+3*math.floor(cl/4))*100
    if target.components.follower and target.components.health and target.components.health.maxhealth<=treshold then
        reader.components.leader:AddFollower(target)
    end
end

local function dominateanimal()
    local inst = commonfn("blue")
    inst.components.inventoryitem.imagename="icestaff"
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(0)
    inst.components.weapon:SetRange(WAND_RANGE-2, WAND_RANGE)
    inst.components.weapon:SetOnAttack(onattackdominateanimal)
    inst.components.weapon:SetProjectile("ice_projectilex")
    inst.components.finiteuses:SetMaxUses(HOLDANIMAL_USES)
    inst.components.finiteuses:SetUses(HOLDANIMAL_USES)

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
    inst.components.finiteuses:SetMaxUses(HOLDANIMAL_USES)
    inst.components.finiteuses:SetUses(HOLDANIMAL_USES)

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
    inst.components.finiteuses:SetMaxUses(CALLLIGHTNING_USES)
    inst.components.finiteuses:SetUses(CALLLIGHTNING_USES)

    return inst
end

return 


Prefab("common/inventory/fa_spell_animaltrance", onattackanimaltrance, assets, prefabs),
Prefab("common/inventory/fa_spell_gustofwind", gustofwind, assets, prefabs),
Prefab("common/inventory/fa_spell_holdanimal", holdanimal, assets, prefabs),
Prefab("common/inventory/fa_spell_calllightning", calllightning, assets, prefabs),
Prefab("common/inventory/fa_spell_dominateanimal", dominateanimal, assets, prefabs),
Prefab("common/inventory/fa_spell_poison", poisonwand, assets, prefabs),
Prefab("common/inventory/fa_spell_snare", snarefn, assets, prefabs),
Prefab("common/inventory/fa_spell_firewall", firewall, assets, prefabs),

Prefab("common/inventory/magicmissilewand", magicmissile, assets, prefabs),
    Prefab("common/inventory/acidarrowwand", acidarrow, assets, prefabs),
    Prefab("common/inventory/fireballwand", fireball, assets, prefabs),
    Prefab("common/inventory/lightningboltwand", lightningbolt, assets, prefabs),
    Prefab("common/inventory/icestormwand", icestorm, assets, prefabs),
    Prefab("common/inventory/firewallwand_insta", firewall_insta, assets, prefabs),
    Prefab("common/inventory/sunburstwand", sunburst, assets, prefabs),
    Prefab("common/inventory/prismaticwand", prismaticwall, assets, prefabs)