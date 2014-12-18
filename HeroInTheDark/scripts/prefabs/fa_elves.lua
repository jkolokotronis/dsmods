local assets_male =
{
        Asset("ANIM","anim/fa_elf_male.zip")
}

local assets_female={
        Asset("ANIM","anim/fa_elf_female.zip")
}

local prefabs =
{
}

local ELF_HEALTH=250
local ELF_DAMAGE=50
local ELF_ATTACK_PERIOD=1.5
local ELF_RUN_SPEED=6
local ELf_WALK_SPEED=3

local MAX_TARGET_SHARES = 5
local SHARE_TARGET_DIST = 30

local function ontalk(inst, script)
end


local function CalcSanityAura(inst, observer)
	if inst.components.werebeast
       and inst.components.werebeast:IsInWereState() then
		return -TUNING.SANITYAURA_LARGE
	end
	
	if inst.components.follower and inst.components.follower.leader == observer then
		return TUNING.SANITYAURA_SMALL
	end
	
	return 0
end

local INV_TABLE={
    {"armorfire","fa_fireaxe","fa_hat_copper"},
    {"armormarble","fa_copperaxe","fa_hat_copper"},
    {"armormarble","fa_ironaxe","fa_hat_iron"},
    {"armormarble","fa_steelaxe","fa_hat_steel"}
}

local function getinventory(inst)
        inst:DoTaskInTime(0,function()
            if(inst.loadedSpawn) then return end
            local items=INV_TABLE[math.random(#INV_TABLE)]
            for k,v in ipairs(items) do
                local item=SpawnPrefab(v)
                if(item)then
                    inst.components.inventory:Equip(item)
                end
            end
            inst.loadedSpawn=true
        end)
end

local onload = function(inst, data)
     if(data)then
        inst.loadedSpawn=data.loadedSpawn
    end
end

local onsave = function(inst, data)
    data.loadedSpawn=inst.loadedSpawn
end

local function OnAttacked(inst, data)
    --print(inst, "OnAttacked")
    local attacker = data.attacker
    if(not attacker) then return end
    inst.components.combat:SetTarget(attacker)

        if not (attacker:HasTag("elf") ) then
            inst.components.combat:ShareTarget(attacker, SHARE_TARGET_DIST, function(dude) return dude:HasTag("elf")  end, MAX_TARGET_SHARES)
        end
end

local function NormalRetargetFn(inst)
    return FindEntity(inst, TUNING.PIG_TARGET_DIST,
        function(guy)
                return guy:HasTag("monster") and guy.components.health and not guy.components.health:IsDead() and inst.components.combat:CanTarget(guy) 
        end)
end

local function NormalKeepTargetFn(inst, target)
    return inst.components.combat:CanTarget(target)
end

local function NormalShouldSleep(inst)
    if inst.components.follower and inst.components.follower.leader then
        local fire = FindEntity(inst, 6, function(ent)
            return ent.components.burnable
                   and ent.components.burnable:IsBurning()
        end, {"campfire"})
        return DefaultSleepTest(inst) and fire and (not inst.LightWatcher or inst.LightWatcher:IsInLight())
    else
        return DefaultSleepTest(inst)
    end
end


local function common()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
	local shadow = inst.entity:AddDynamicShadow()
    inst.soundsname="dwarf"
	shadow:SetSize( 1.5, .75 )
    inst.Transform:SetFourFaced()

    inst.Transform:SetScale(0.65,0.65, 0.65)

    inst.entity:AddLightWatcher()
    
    inst:AddComponent("talker")
--    inst.components.talker.ontalk = ontalk
    inst.components.talker.fontsize = 35
    inst.components.talker.font = TALKINGFONT
    --inst.components.talker.colour = Vector3(133/255, 140/255, 167/255)
    inst.components.talker.offset = Vector3(0,-400,0)

    MakeCharacterPhysics(inst, 50, .5)
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.runspeed = ELF_RUN_SPEED
    inst.components.locomotor.walkspeed = ELf_WALK_SPEED

    inst:AddTag("character")
    inst:AddTag("elf")
    inst:AddTag("scarytoprey")
    inst:AddTag("fa_good")
    inst:AddTag("fa_humanoid")

    inst.AnimState:SetBank("wilson")
    inst.AnimState:Hide("hat_hair")
    inst.AnimState:Hide("hat")
    inst.AnimState:Hide("ARM_carry")
    inst.AnimState:PlayAnimation("idle")    

    ------------------------------------------
    inst:AddComponent("combat")
    inst.components.combat.hiteffectsymbol = "torso"
    inst.components.combat:SetDefaultDamage(ELF_DAMAGE)
    inst.components.combat:SetAttackPeriod(ELF_ATTACK_PERIOD)
    inst.components.combat:SetKeepTargetFunction(NormalKeepTargetFn)
    inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)   
 
    inst:AddComponent("trader")
    inst.components.trader.test=function(inst, item)
        if(item and item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.RING)then
            return true
        else
            return false
        end
    end
    inst.components.trader.onaccept=function(inst, giver, item)
        if item.components.equippable and item.components.equippable.equipslot == EQUIPSLOTS.RING then
            local current = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.RING)
            if current then
                inst.components.inventory:DropItem(current)
            end
            inst.components.inventory:Equip(item)
        end
    end

    inst:AddComponent("named")
    inst.components.named.possiblenames = STRINGS.DORFNAMES
    inst.components.named:PickNewName()
    
    inst:AddComponent("follower")
--    inst.components.follower.maxfollowtime = TUNING.PIG_LOYALTY_MAXTIME
    ------------------------------------------
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(ELF_HEALTH)
    inst.components.health.fa_resistances[FA_DAMAGETYPE.FIRE]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.POISON]=0.5
    inst.components.health.fa_resistances[FA_DAMAGETYPE.PHYSICAL]=0.2
    inst.components.health.fa_resistances[FA_DAMAGETYPE.COLD]=-0.3

    ------------------------------------------

    inst:AddComponent("inventory")
    inst.components.inventory.dropondeath=false
    
    ------------------------------------------

    inst:AddComponent("lootdropper")    
    inst.components.lootdropper:SetLoot({ "goldnugget", "meat"})
    inst.components.lootdropper:AddFallenLootTable(FALLENLOOTTABLEMERGED,FALLENLOOTTABLE.TABLE_WEIGHT,0.1)

    ------------------------------------------

    inst:AddComponent("knownlocations")
    
    ------------------------------------------

    MakeMediumBurnableCharacter(inst,"torso")
    MakeMediumFreezableCharacter(inst)
    
    ------------------------------------------


    inst:AddComponent("inspectable")
    
    local brain = require "brains/dorfbrain"
    inst:SetBrain(brain)
    inst:SetStateGraph("SGdorf")
    

    inst.OnSave = onsave
    inst.OnLoad = onload    
    inst:ListenForEvent("attacked", OnAttacked)    
--    inst:ListenForEvent("newcombattarget", OnNewTarget)
    
    return inst
end

local function malefn()
    local inst = common()
    inst.AnimState:SetBuild("fa_elf_male")
    getinventory(inst)
    return inst
end


local function femalefn()
    local inst = common()
    inst.AnimState:SetBuild("fa_elf_female")
    getinventory(inst)
    return inst
end

return Prefab( "common/characters/fa_elf_male", malefn, assets_male, prefabs),
 Prefab( "common/characters/fa_elf_female", femalefn, assets_female, prefabs)