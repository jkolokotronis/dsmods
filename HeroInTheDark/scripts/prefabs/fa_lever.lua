local assets=
{
	Asset("ANIM", "anim/fa_dorf_lever.zip"),
}

local DETECTION_RANGE=60 --at max zoom that's still over 2 screens, tho I'm not sure if limit even impacts performance

local onloadfn = function(inst, data)
    inst.state=data.state
    if(inst.state)then
	    inst.AnimState:PlayAnimation("on")
		inst.components.activatable.inactive = false
	end
	inst.control_lever =data.control_lever 
end

local onsavefn = function(inst, data)
    data.state=inst.state
    data.control_lever=inst.control_lever 
end

local function GetVerb(inst)
	return STRINGS.ACTIONS.ACTIVATE.GENERIC
end

local function OnActivate(inst,doer)
	--inst.SoundEmitter:PlaySound("fa/teleporter/activate")
	inst.AnimState:PlayAnimation("switchingon")
	inst.AnimState:PushAnimation("on", true)
	print("lever",inst.control_lever)
	local pos=inst:GetPosition()
    local ents = TheSim:FindEntities(pos.x, pos.y, pos.z, 60,{inst.control_lever},{"INLIMBO"})
	
	for k,v in pairs(ents) do
		print("caught",v)
		if(v.leverfn)then
			v:leverfn(inst,doer)
		end
	end

end


local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    
    inst.AnimState:SetBank("fa_dorf_lever")
    inst.AnimState:SetBuild("fa_dorf_lever")
    inst.AnimState:PlayAnimation("off")
    inst.state=0
    MakeInventoryPhysics(inst)
    
    inst:AddComponent("inspectable")
    
	inst:AddComponent("activatable")
	inst.components.activatable.OnActivate = OnActivate
	inst.components.activatable.inactive = true
	inst.components.activatable.getverb = GetVerb
	inst.components.activatable.quickaction = true

    inst.OnLoad = onloadfn
    inst.OnSave = onsavefn

    return inst
end

return Prefab( "common/fa_dorf_lever", fn, assets) 
