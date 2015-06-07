local assets_copper=
{
    Asset("ANIM", "anim/fa_copperarmor.zip"),
}
local assets_iron=
{
    Asset("ANIM", "anim/fa_ironarmor.zip"),
}
local assets_steel=
{
    Asset("ANIM", "anim/fa_steelarmor.zip"),
}
local assets_silver=
{
    Asset("ANIM", "anim/fa_silverarmor.zip"),
}
local assets_gold=
{
    Asset("ANIM", "anim/fa_goldarmor.zip"),
}
local assets_adamantine=
{
    Asset("ANIM", "anim/fa_adamantinearmor.zip"),
}
local assets_fa_abjurationrobe=
{
    Asset("ANIM", "anim/fa_abjurationrobe.zip"),
}
local assets_fa_conjurationrobe=
{
    Asset("ANIM", "anim/fa_conjurationrobe.zip"),
}
local assets_fa_divinationrobe=
{
    Asset("ANIM", "anim/fa_divinationrobe.zip"),
}
local assets_fa_enchantmentrobe=
{
    Asset("ANIM", "anim/fa_enchantmentrobe.zip"),
}
local assets_fa_evocationrobe=
{
    Asset("ANIM", "anim/fa_evocationrobe.zip"),
}
local assets_fa_illusionrobee=
{
    Asset("ANIM", "anim/fa_illusionrobe.zip"),
}
local assets_fa_necromancyrobe=
{
    Asset("ANIM", "anim/fa_necromancyrobe.zip"),
}
local assets_fa_transmutationrobe=
{
    Asset("ANIM", "anim/fa_transmutationrobe.zip"),
}
local assets_fa_heavyleatherarmor=
{
    Asset("ANIM", "anim/fa_heavyleatherarmor.zip"),
}
local assets_fa_lightleatherarmor=
{
    Asset("ANIM", "anim/fa_lightleatherarmor.zip"),
}
local assets_fa_plainrobe=
{
    Asset("ANIM", "anim/fa_plainrobe.zip"),
}


local ARMOR_ABSORPTION_T1=0.70
local ARMOR_ABSORPTION_T2=0.80
local ARMOR_ABSORPTION_T3=0.95
local ARMOR_DURABILITY_T1=1800
local ARMOR_DURABILITY_T2=2800
local ARMOR_DURABILITY_T3=4000
local ARMOR_DURABILITY_SILVER=2500
local ARMOR_ABSORPTION_SILVER=0.85
local ARMOR_DURABILITY_GOLD=2000
local ARMOR_ABSORPTION_GOLD=0.7
local ARMOR_DURABILITY_SILVER=2500
local ARMOR_ABSORPTION_SILVER=0.85
local ARMOR_DURABILITY_ADAMANT=8500
local ARMOR_ABSORPTION_ADAMANT=0.95
local ARMOR_DURABILITY_LEATHER=1200
local ARMOR_ABSORPTION_LEATHER=0.65
local ARMOR_DURABILITY_HEAVYLEATHER=1500
local ARMOR_ABSORPTION_HEAVYLEATHER=0.75

local ARMOR_GOLD_DAPPERNESS=5.0/60
local ARMOR_GOLD_FUELLEVEL=1200
local DIV_ROBE_DAPPERNESS=5.0/60

local ARMOR_ROBE_DURA=1000
local ARMOR_ROBE_ABSO=0.6
local ARMOR_ROBE_ABJ_ABSO=0.65
local ROBE_CL_BONUS=2

local FA_BuffUtil=require "buffutil"

    local function generic_perish(inst)
        inst:Remove()
    end


local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn(name)
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
    inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon( name..".tex" )
    
    inst.AnimState:SetBank(name)
    inst.AnimState:SetBuild(name)
    inst.AnimState:PlayAnimation("anim")
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.foleysound = "dontstarve/movement/foley/marblearmour"
     inst.components.inventoryitem.atlasname = "images/inventoryimages/fa_inventoryimages.xml"
    inst.components.inventoryitem.imagename=name
    
    inst:AddComponent("armor")
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    
    inst.components.equippable:SetOnEquip(function(inst,owner)
    	owner.AnimState:OverrideSymbol("swap_body", name, "swap_body")
    end)
    inst.components.equippable:SetOnUnequip( onunequip )
    
    return inst
end

local function copperarmor()
    local inst =fn("fa_copperarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T1, ARMOR_ABSORPTION_T1)
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.3
    return inst
end
local function steelarmor()
    local inst =fn("fa_steelarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T3, ARMOR_ABSORPTION_T3)
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.2
    return inst
end
local function adamantinearmor()
    local inst =fn("fa_adamantinearmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_ADAMANT, ARMOR_ABSORPTION_ADAMANT)
    return inst
end
local function ironarmor()
    local inst =fn("fa_ironarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_T2, ARMOR_ABSORPTION_T2)
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.2
    return inst
end
local function silverarmor()
    local inst =fn("fa_silverarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_SILVER, ARMOR_ABSORPTION_SILVER)
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.2
    return inst
end
local function goldarmor()
    local inst =fn("fa_goldarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_GOLD, ARMOR_ABSORPTION_GOLD)
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=-0.1


        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = ARMOR_GOLD_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = ARMOR_GOLD_DAPPERNESS
        end


        inst:AddComponent("fueled")
        inst.components.fueled.fueltype = "USAGE"
        inst.components.fueled:InitializeFuelLevel(ARMOR_GOLD_FUELLEVEL)
        inst.components.fueled:SetDepletedFn( generic_perish )


        inst:ListenForEvent("rainstop", function() inst.components.fueled.rate=1 end, GetWorld()) 
        inst:ListenForEvent("rainstart", function() inst.components.fueled.rate=2 end, GetWorld()) 

    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_goldarmor", "swap_body")
        inst.components.fueled:StartConsuming()        
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        inst.components.fueled:StopConsuming()        
        onunequip(inst,owner)
    end)

    return inst
end

local function fa_heavyleatherarmor()
    local inst =fn("fa_heavyleatherarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_HEAVYLEATHER, ARMOR_ABSORPTION_HEAVYLEATHER)
    return inst
end

local function fa_lightleatherarmor()
    local inst =fn("fa_lightleatherarmor")
    inst.components.armor:InitCondition(ARMOR_DURABILITY_LEATHER, ARMOR_ABSORPTION_LEATHER)
    return inst
end

local function fa_plainrobe()
    local inst =fn("fa_plainrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    return inst
end

local function aburationproc(owner,data) 
    local roll=math.random()
    print("roll",roll)
    local variables={}
    if(roll<=0.01)then
        variables.cloverride=20
        FA_BuffUtil.Shield(owner,nil,variables)
    elseif(roll<=0.1)then
        variables.cloverride=10
        FA_BuffUtil.Shield(owner,nil,variables)
    end
end
local function fa_abjurationrobe()
    local inst =fn("fa_abjurationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABJ_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ABJURATION]=ROBE_CL_BONUS

    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_abjurationrobe", "swap_body")
        inst:ListenForEvent("attacked", aburationproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", aburationproc, owner)
    end)
    return inst
end

-- imo it should be separate frmo 'manual' summons as well as normal pets
-- but at the same time should not encourage having 10 items to swap in/out until stuff spawns
local function killprocsummons(inst)
 local leader=inst.components.leader
    for k,v in pairs(leader.followers) do
        if(k:HasTag("fa_proc_summon"))then
            if(k.components.health and not k.components.health:IsDead()) then
                k.components.health:Kill()
            else
                k:Remove()
            end
        end
    end
end

local function conjurationproc(owner,data) 
    local roll=math.random()
    if(roll<=0.07 and owner.components.leader)then
        killprocsummons(owner)
        local spawn_point= Vector3(owner.Transform:GetWorldPosition())
        local tree = SpawnPrefab("fa_animatedarmor_copper") 
        tree:AddTag("fa_proc_summon")
        tree.persists=false
        tree.Transform:SetPosition( spawn_point.x, spawn_point.y, spawn_point.z )
        owner.components.leader:AddFollower(tree)
        tree:ListenForEvent("stopfollowing",function(f)
            f.components.health:Kill()
        end)
    end
end

local function fa_conjurationrobe()
    local inst =fn("fa_conjurationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.CONJURATION]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.POISON]=0.2
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_conjurationrobe", "swap_body")
        inst:ListenForEvent("attacked", conjurationproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", conjurationproc, owner)
    end)
    return inst
end

local function divinationproc(owner,data) 
    if(math.random()<=0.05)then
        FA_BuffUtil.CureSerious(owner,nil,{cloverride=10})
    end
end
local function fa_divinationrobe()
    local inst =fn("fa_divinationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.DIVINATION]=ROBE_CL_BONUS
        if(FA_DLCACCESS)then
            inst.components.equippable.dapperness = DIV_ROBE_DAPPERNESS
        else
            inst:AddComponent("dapperness")
            inst.components.dapperness.dapperness = DIV_ROBE_DAPPERNESS
        end
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_divinationrobe", "swap_body")
        inst:ListenForEvent("attacked", divinationproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", divinationproc, owner)
    end)
    return inst
end

local function enchantmentproc(owner,data) 
    local target=data.attacker
    if(math.random()<=0.05)then
        if(not target.components.follower)then print("using dominate on a mob that does not support follower logic: "..target.prefab) return false  end
        owner.components.leader:AddFollower(target)
        target.components.follower.maxfollowtime=math.max(target.components.follower.maxfollowtime or 0,4*60)
        target.components.follower:AddLoyaltyTime(4*60)
    elseif(math.random()<=0.1)then
        if(target.fa_stun)then target.fa_stun.components.spell:OnFinish() end

        local inst=SpawnPrefab("fa_spinningstarsfx")
        inst.persists=false
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_holdperson"
        inst.components.spell.duration = 5
        inst.components.spell.ontargetfn = function(inst,target)
            local follower = inst.entity:AddFollower()
            follower:FollowSymbol( target.GUID, target.components.combat.hiteffectsymbol, 0, -200, -0.0001 )
            target.fa_stun = inst
        end

        inst.components.spell.onfinishfn = function(inst)
            inst.components.spell.target.fa_stun = nil
        end
        inst.components.spell.removeonfinish = true
        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    end
end
local function fa_enchantmentrobe()
    local inst =fn("fa_enchantmentrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ENCHANTMENT]=ROBE_CL_BONUS
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_enchantmentrobe", "swap_body")
        inst:ListenForEvent("attacked", enchantmentproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", enchantmentproc, owner)
    end)
    return inst
end

local function divinationproc(owner,data) 
    if(math.random()<=0.05)then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
        if(data and data.attacker)then
        if  data.attacker.components.burnable and  data.attacker.components.burnable:IsBurning() then
            data.attacker.components.burnable:Extinguish()
        end
        if data.attacker.components.freezable then
            data.attacker.components.freezable:AddColdness(4)
            data.attacker.components.freezable:SpawnShatterFX()
        end
        data.attacker.components.combat:GetAttacked(owner, 50, nil,nil,FA_DAMAGETYPE.COLD)  
    end
    elseif(math.random()<0.1)then
        owner.SoundEmitter:PlaySound("dontstarve/wilson/hit_armour")
        if(data and data.attacker and  data.attacker.components.burnable and not data.attacker.components.fueled )then
            data.attacker.components.burnable:Ignite()    
        end
        data.attacker.components.combat:GetAttacked(owner, 50, nil,nil,FA_DAMAGETYPE.FIRE)    
    end
end

local function fa_evocationrobe()
    local inst =fn("fa_evocationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.EVOCATION]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.ELECTRIC]=0.3
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_evocationrobe", "swap_body")
        inst:ListenForEvent("attacked", divinationproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", divinationproc, owner)
    end)
    return inst
end


local function illusionproc(owner,data) 
    local spawn=nil
    if(math.random()<=0.1 and owner.components.leader)then
        spawn="fa_magedecoy"
        
    elseif(math.random()<=0.1 and owner.components.leader)then
        spawn="fa_horrorpet"
    end
    if(spawn)then
        killprocsummons(owner)
        local spawn_point= Vector3(owner.Transform:GetWorldPosition())
        local tree = SpawnPrefab(spawn) 
        tree:AddTag("fa_proc_summon")
        tree.persists=false
        tree.Transform:SetPosition( spawn_point.x, spawn_point.y, spawn_point.z )
        owner.components.leader:AddFollower(tree)
        tree:ListenForEvent("stopfollowing",function(f)
            f.components.health:Kill()
        end)
    end
end

local function fa_illusionrobe()
    local inst =fn("fa_illusionrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.ILLUSION]=ROBE_CL_BONUS
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_illusionrobe", "swap_body")
        inst:ListenForEvent("attacked", illusionproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", illusionproc, owner)
    end)
    return inst
end

local function necroproc(owner,data)
    local target=data.attacker
    if(math.random()<=0.2)then
        if(target.fa_fear)then target.fa_fear.components.spell:OnFinish() end        
        local inst=CreateEntity()
        inst.persists=false
        inst:AddTag("FX")
        inst:AddTag("NOCLICK")
        local spell = inst:AddComponent("spell")
        inst.components.spell.spellname = "fa_fear"
        inst.components.spell.duration = 30
        inst.components.spell.ontargetfn = function(inst,target)
            target.fa_fear = inst
        end
        inst.components.spell.onfinishfn = function(inst)
            if not inst.components.spell.target then return end
            inst.components.spell.target.fa_fear = nil
        end
        inst.components.spell.removeonfinish = true
        inst.components.spell:SetTarget(target)
        inst.components.spell:StartSpell()
    elseif(math.random()<=0.01)then
        target.components.combat:GetAttacked(owner, 500, nil,nil,FA_DAMAGETYPE.DEATH)
        local boom =SpawnPrefab("fa_bloodsplashfx")
        local follower = boom.entity:AddFollower()
        follower:FollowSymbol(target.GUID, target.components.combat.hiteffectsymbol, 0, 0.1, -0.0001)
        boom.fa_rotate(owner)
        boom.persists=false
        boom:ListenForEvent("animover", function()  boom:Remove() end)
    end
end

local function fa_necromancyrobe()
    local inst =fn("fa_necromancyrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.NECROMANCY]=ROBE_CL_BONUS
    inst.components.armor.fa_resistances={}
    inst.components.armor.fa_resistances[FA_DAMAGETYPE.DEATH]=0.2
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_necromancyrobe", "swap_body")
        inst:ListenForEvent("attacked", necroproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", necroproc, owner)
    end)
    return inst
end

local function transmutationproc(owner,data)
    local target=data.attacker
    if(math.random()<=0.03 and not target:HasTag("epic"))then
        local pig=SpawnPrefab("pig")
        local spawn_point= Vector3(target.Transform:GetWorldPosition())
        target:Remove()
        pig.Transform:SetPosition( spawn_point.x, spawn_point.y, spawn_point.z )
        owner.components.leader:AddFollower(pig)
        pig.components.follower:AddLoyaltyTime(target.components.follower.maxfollowtime or 4*60)
    end
end

local function fa_transmutationrobe()
    local inst =fn("fa_transmutationrobe")
    inst:AddTag("fa_robe")
    inst.components.armor:InitCondition(ARMOR_ROBE_DURA, ARMOR_ROBE_ABSO)
    inst.components.equippable.fa_casterlevel={}
    inst.components.equippable.fa_casterlevel[FA_SPELL_SCHOOLS.TRANSMUTATION]=ROBE_CL_BONUS
    inst.components.equippable:SetOnEquip(function(inst,owner)
        owner.AnimState:OverrideSymbol("swap_body", "fa_transmutationrobe", "swap_body")
        inst:ListenForEvent("attacked", transmutationproc,owner)
    end)
    inst.components.equippable:SetOnUnequip( function(inst,owner)
        owner.AnimState:ClearOverrideSymbol("swap_body")
        inst:RemoveEventCallback("attacked", transmutationproc, owner)
    end)
    return inst
end

return
    Prefab( "common/inventory/fa_copperarmor",copperarmor, assets_copper),
    Prefab( "common/inventory/fa_steelarmor",steelarmor, assets_steel),
    Prefab( "common/inventory/fa_adamantinearmor",adamantinearmor, assets_adamantine),
    Prefab( "common/inventory/fa_ironarmor", ironarmor, assets_iron),
    Prefab( "common/inventory/fa_silverarmor", silverarmor, assets_silver),
    Prefab( "common/inventory/fa_goldarmor", goldarmor, assets_gold),
    Prefab( "common/inventory/fa_plainrobe", fa_plainrobe, assets_fa_plainrobe),
    Prefab( "common/inventory/fa_lightleatherarmor", fa_lightleatherarmor, assets_fa_lightleatherarmor),
    Prefab( "common/inventory/fa_heavyleatherarmor", fa_heavyleatherarmor, assets_fa_heavyleatherarmor),
    Prefab( "common/inventory/fa_abjurationrobe", fa_abjurationrobe, assets_fa_abjurationrobe),
    Prefab( "common/inventory/fa_conjurationrobe", fa_conjurationrobe, assets_fa_conjurationrobe),
    Prefab( "common/inventory/fa_divinationrobe", fa_divinationrobe, assets_fa_divinationrobe),
    Prefab( "common/inventory/fa_enchantmentrobe", fa_enchantmentrobe, assets_fa_enchantmentrobe),
    Prefab( "common/inventory/fa_evocationrobe", fa_evocationrobe, assets_fa_evocationrobe),
    Prefab( "common/inventory/fa_illusionrobe", fa_illusionrobe, assets_fa_illusionrobee),
    Prefab( "common/inventory/fa_necromancyrobe", fa_necromancyrobe, assets_fa_necromancyrobe),
    Prefab( "common/inventory/fa_transmutationrobe", fa_transmutationrobe, assets_fa_transmutationrobe)