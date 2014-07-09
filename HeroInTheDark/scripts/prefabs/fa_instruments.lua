local assets=
{
	Asset("ANIM", "anim/pan_flute.zip"),
}

local IC_TIMER=4*60
local IA_TIMER=2*60
local FASCINATE_TIMER=120
local IG_TIMER=4*60
local SUGGESTION_TIMER=8*60

local function onfinished(inst)
    inst:Remove()
end

local function hearcouragefn(inst, musician, instrument)
    if(inst:HasTag("player") or inst:HasTag("pet") or inst:HasTag("companion"))then
    	FA_InspireCourageSpellStart(inst,IC_TIMER)
    end
end

local function hearfascinatefn(inst, musician, instrument)
        inst:StopBrain()
--[[    doesnt do anythign really, just interrupts current activity
        if inst.brain then
            inst.brain:Stop()
        end ]]    
        if inst.components.combat then
            inst.components.combat:SetTarget(nil)
        end
        if inst.components.locomotor then
            inst.components.locomotor:Stop()
        end
        inst:AddTag("fascinated")
        if(inst.fa_fascinated_timer)then
            inst.fa_fascinated_timer:Cancel()
        end
        inst.fa_fascinated_timer=inst:DoTaskInTime(FASCINATE_TIMER,function ( )
            inst:RestartBrain()
        end)
end

local function hearagilityfn(inst, musician, instrument)
    if(inst:HasTag("player") or inst:HasTag("companion"))then
        if(inst.components.fa_bufftimers)then
            inst.components.fa_bufftimers:AddBuff("inspireagility","Inspire Agility","InspireAgility",IA_TIMER)
        else
            --because I'm still not sure if i want to add component to everything? kind of overkill...
            FA_InspireAgilitySpellStart(inst,IA_TIMER)
        end
    end
end

local function hearsuggestionfn(inst, musician, instrument)
    if(inst:HasTag("player") or inst:HasTag("companion"))then return end
    if(not inst.components.follower)then return end
    local leader=musician.components.leader
    if(not leader)then return end
    for k,v in pairs(leader.followers) do
        if(k:HasTag("fascinated"))then
            return
        end
    end
    --because of silly checks that would otherwise prevent following altogether...
    inst:AddTag("fascinated")
    if(not inst.components.follower.maxfollowtime)then
        inst.components.follower.maxfollowtime=SUGGESTION_TIMER
    end
    leader:AddFollower(inst)
    inst.components.follower:AddLoyaltyTime(SUGGESTION_TIMER)
    inst:ListenForEvent("loseloyalty",function() inst:RemoveTag("fascinated") end)
end

local function heargreaternessfn(inst, musician, instrument)
    if(inst:HasTag("player") or inst:HasTag("companion"))then
        if(inst.components.fa_bufftimers)then
            inst.components.fa_bufftimers:AddBuff("inspiregreatness","Inspire Greatness","InspireGreatness",IG_TIMER)
        else
            --because I'm still not sure if i want to add component to everything? kind of overkill...
            FA_InspireGreatnessSpellStart(inst,IG_TIMER)
        end
        
    end
end

local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	
	inst:AddTag("flute")
    
    inst.AnimState:SetBank("pan_flute")
    inst.AnimState:SetBuild("pan_flute")
    inst.AnimState:PlayAnimation("idle")
    MakeInventoryPhysics(inst)
    
    inst:AddComponent("inspectable")
    inst:AddComponent("instrument")
    inst.components.instrument.range = TUNING.PANFLUTE_SLEEPRANGE
    inst.components.instrument:SetOnHeardFn(HearPanFlute)
    
    inst:AddComponent("tool")
    inst.components.tool:SetAction(ACTIONS.PLAY)
    
    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetUses(TUNING.PANFLUTE_USES)
    inst.components.finiteuses:SetOnFinished( onfinished)
    inst.components.finiteuses:SetConsumption(ACTIONS.PLAY, 1)
        
    inst:AddComponent("inventoryitem")
    
    return inst
end

return Prefab( "common/inventory/inspirecourage", fn, assets),
Prefab( "common/inventory/fascinate", fn, assets),
Prefab( "common/inventory/inspireagility", fn, assets),
Prefab( "common/inventory/suggestion", fn, assets),
Prefab( "common/inventory/inspiregreatness", fn, assets)
