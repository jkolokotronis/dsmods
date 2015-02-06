local assets =
{
    Asset("ANIM", "anim/fa_dryadtree.zip"),       
}
local prefabs = 
{
}

local CHOPS_LEFT=10


local function workcallback(inst, worker, workleft)
    inst.SoundEmitter:PlaySound("dontstarve/wilson/use_axe_mushroom")          
    if workleft <= 0 then
        local pt = Point(inst.Transform:GetWorldPosition())
        inst.SoundEmitter:PlaySound("dontstarve/forest/treefall")
        inst.components.lootdropper:DropLoot(pt)
        inst:Remove()

    else            
--        inst.AnimState:PlayAnimation("chop")
--        inst.AnimState:PushAnimation("idle_loop", true)
    end
end

local function fn()
    local inst = CreateEntity()
    local trans = inst.entity:AddTransform()
    local anim = inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    local shadow = inst.entity:AddDynamicShadow()
    shadow:SetSize( 6, 3 )

    local minimap = inst.entity:AddMiniMapEntity()
    minimap:SetIcon("mushroom_tree.png")

    MakeObstaclePhysics(inst, 1)

    anim:SetBank("fa_dryadtree")
    anim:SetBuild("fa_dryadtree") 
    anim:PlayAnimation("spring")
    inst.animindex=1

    inst:AddComponent("lootdropper") 
    inst.components.lootdropper:SetLoot({"livinglog", "livinglog", "livinglog","livinglog","livinglog"})
    inst:AddComponent("inspectable")
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.CHOP)
    inst.components.workable:SetWorkLeft(CHOPS_LEFT)
    inst.components.workable:SetOnWorkCallback(workcallback)


    inst.AnimState:SetBloomEffectHandle( "shaders/anim.ksh" )

    local light = inst.entity:AddLight()
    light:SetFalloff(0.5)
    light:SetIntensity(.8)
    light:SetRadius(1.5)
    light:SetColour(111/255, 111/255, 227/255)
    light:Enable(true)

    inst:AddComponent("childspawner")
    inst.components.childspawner.childname = "fa_dryad"
    inst.components.childspawner:SetRegenPeriod(TUNING.SPIDERDEN_REGEN_TIME)
    inst.components.childspawner:SetSpawnPeriod(TUNING.SPIDERDEN_RELEASE_TIME)
    inst.components.childspawner:SetMaxChildren(1)
    inst.components.childspawner:StartSpawning()

    local anims={"spring","summer","autumn","winter"}

    inst:DoPeriodicTask(15,function()
        inst.animindex=inst.animindex%(#anims)+1
        anim:PlayAnimation(anims[inst.animindex])
    end)
    
    return inst
end




return Prefab( "common/objects/fa_dryadtree", fn, assets, prefabs )