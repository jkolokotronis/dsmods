local assets =
{
	Asset("ANIM", "anim/spell_books.zip"),
	--Asset("SOUND", "sound/common.fsb"),
}
 
local prefabs =
{
    "tentacle",
    "splash_ocean",
    "book_fx"
}    

local SPELL_HEAL_AMOUNT=150
local BUFF_LENGTH=30


function tentaclesfn(inst, reader)
    local pt = Vector3(reader.Transform:GetWorldPosition())

    local numtentacles = 3

    reader.components.sanity:DoDelta(-TUNING.SANITY_HUGE)

    reader:StartThread(function()
        for k = 1, numtentacles do
        
            local theta = math.random() * 2 * PI
            local radius = math.random(3, 8)

            -- we have to special case this one because birds can't land on creep
            local result_offset = FindValidPositionByFan(theta, radius, 12, function(offset)
                local x,y,z = (pt + offset):Get()
                local ents = TheSim:FindEntities(x,y,z , 1)
                return not next(ents) 
            end)

            if result_offset then
                local tentacle = SpawnPrefab("tentacle")
                
                tentacle.Transform:SetPosition((pt + result_offset):Get())
                GetPlayer().components.playercontroller:ShakeCamera(reader, "FULL", 0.2, 0.02, .25, 40)
                
                --need a better effect
                local fx = SpawnPrefab("splash_ocean")
                local pos = pt + result_offset
                fx.Transform:SetPosition(pos.x, pos.y, pos.z)
                --PlayFX((pt + result_offset), "splash", "splash_ocean", "idle")
                tentacle.sg:GoToState("attack_pre")
            end

            Sleep(.33)
        end
    end)
    return true    

end

function growfn(inst, reader)
    print("got into grow")
    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    local range = 30
    local pos = Vector3(reader.Transform:GetWorldPosition())
    local ents = TheSim:FindEntities(pos.x,pos.y,pos.z, range)
    for k,v in pairs(ents) do
        if v.components.pickable then
            v.components.pickable:FinishGrowing()
        end

        if v.components.crop then
            v.components.crop:DoGrow(TUNING.TOTAL_DAY_TIME*3)
        end
        
        if v:HasTag("tree") and v.components.growable and not v:HasTag("stump") then
            v.components.growable:DoGrowth()
        end
    end
    return true
end



function firefn(inst, reader)

    local num_lightnings =  15
    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    reader:StartThread(function()
        for k = 0, num_lightnings do

            local rad = math.random(3, 15)
            local angle = k*((4*PI)/num_lightnings)
            local pos = Vector3(reader.Transform:GetWorldPosition()) + Vector3(rad*math.cos(angle), 0, rad*math.sin(angle))
            GetSeasonManager():DoLightningStrike(pos)
            Sleep(math.random( .3, .5))
        end
    end)
    return true
end

function healfn(inst, reader)

    reader.components.sanity:DoDelta(-TUNING.SANITY_LARGE)
    reader.components.health:DoDelta(SPELL_HEAL_AMOUNT)
    return true
end

function divinemightfn(inst, reader)

    reader.origDamageMultiplier=reader.origDamageMultiplier or reader.components.combat.damagemultiplier
    reader.components.combat.damagemultiplier=DAMAGE_MULT
--    inst.components.health:SetMaxHealth(300)
    if(reader.divineMightTimer) then
        reader.divineMightTimer:Cancel()
    end
    reader.divineMightTimer=reader:DoTaskInTime(BUFF_LENGTH, function() 
        reader.divineMightTimer=nil 
        reader.components.combat.damagemultiplier=reader.origDamageMultiplier
    end)
    return true
end

function lightfn(inst, reader)

    --it WILL crash and burn if applied to wx
    if(not reader.Light) then
        reader.entity:AddLight()
    end

    if(reader.lightTimer) then
        reader.lightTimer:Cancel()
    end
    reader.Light:SetRadius(3)
    reader.Light:SetFalloff(0.75)
    reader.Light:SetIntensity(.9)
    reader.Light:SetColour(235/255,121/255,12/255)

    reader.Light:Enable(true)
    
    reader.lightTimer=reader:DoTaskInTime(BUFF_LENGTH, function() 
        reader.lightTimer=nil
        reader.Light:Enable(false)
    end)
    return true
end

function onfinished(inst)
    inst:Remove()
end

function MakeSpell(name, usefn, bookuses )
    
    local function fn(Sim)
        print("make spell",name,usefn,bookuses)
    	local inst = CreateEntity()
    	local trans = inst.entity:AddTransform()
    	local anim = inst.entity:AddAnimState()
        local sound = inst.entity:AddSoundEmitter()
        anim:SetBank("spell_books")
        anim:SetBuild("spell_books")

        anim:PlayAnimation("book_birds")

--        anim:PlayAnimation(name)
        MakeInventoryPhysics(inst)
        
        -----------------------------------
        
        inst:AddComponent("inspectable")
        inst:AddComponent("book")
        inst.components.book.onread = usefn

--        inst:AddComponent("characterspecific")
--        inst.components.characterspecific:SetOwner("druid")
        
        inst:AddComponent("inventoryitem")
        inst.components.inventoryitem.imagename="book_brimstone"

        inst:AddComponent("finiteuses")
        inst.components.finiteuses:SetMaxUses( bookuses )
        inst.components.finiteuses:SetUses( bookuses )
        inst.components.finiteuses:SetOnFinished( onfinished )

        MakeSmallBurnable(inst)
        MakeSmallPropagator(inst)


        return inst
    end

    return Prefab( "common/"..name, fn, assets, prefabs) 
end


return MakeSpell("spell_lightning", firefn, 5),
       MakeSpell("spell_earthquake", tentaclesfn, 5),
       MakeSpell("spell_grow", growfn, 5),
       MakeSpell("spell_heal", healfn, 5),
       MakeSpell("spell_divinemight", divinemightfn, 5),
       MakeSpell("spell_firestorm", firefn, 5),
       MakeSpell("spell_light", lightfn, 5)
