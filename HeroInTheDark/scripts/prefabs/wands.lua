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


local MAGICMISSLE_DAMAGE=15
local MAGICMISSLE_DAMAGE_2=20
local MAGICMISSLE_DAMAGE_3=30
local MAGICMISSLE_DAMAGE_4=40
local MAGICMISSLE_DAMAGE_5=50
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

    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
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
    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
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

    inst:AddTag("nopunch")
    return inst
end
local function prismaticwall()
    local inst = commonfn("red")

    inst.components.finiteuses:SetMaxUses(PRISMATICWALL_USES)
    inst.components.finiteuses:SetUses(PRISMATICWALL_USES)

    return inst
end 

return Prefab("common/inventory/magicmissilewand", magicmissile, assets, prefabs),
    Prefab("common/inventory/acidarrowwand", acidarrow, assets, prefabs),
    Prefab("common/inventory/fireballwand", fireball, assets, prefabs),
    Prefab("common/inventory/lightningboltwand", lightningbolt, assets, prefabs),
    Prefab("common/inventory/icestormwand", icestorm, assets, prefabs),
    Prefab("common/inventory/firewallwand", firewall, assets, prefabs),
    Prefab("common/inventory/firewallwand_insta", firewall_insta, assets, prefabs),
    Prefab("common/inventory/sunburstwand", sunburst, assets, prefabs),
    Prefab("common/inventory/prismaticwand", prismaticwall, assets, prefabs)