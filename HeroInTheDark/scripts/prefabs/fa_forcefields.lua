local assets_black = 
{
   Asset("ANIM", "anim/fa_forcefield_black.zip")
}
local assets_blue = 
{
   Asset("ANIM", "anim/fa_forcefield_blue.zip")
}
local assets_green = 
{
   Asset("ANIM", "anim/fa_forcefield_green.zip")
}
local assets_grey = 
{
   Asset("ANIM", "anim/fa_forcefield_grey.zip")
}
local assets_orange = 
{
   Asset("ANIM", "anim/fa_forcefield_orange.zip")
}
local assets_pink = 
{
   Asset("ANIM", "anim/fa_forcefield_pink.zip")
}
local assets_purple = 
{
   Asset("ANIM", "anim/fa_forcefield_purple.zip")
}
local assets_red = 
{
   Asset("ANIM", "anim/fa_forcefield_red.zip")
}
local assets_teal = 
{
   Asset("ANIM", "anim/fa_forcefield_teal.zip")
}
local assets_white = 
{
   Asset("ANIM", "anim/fa_forcefield_white.zip")
}
local assets_yellow = 
{
   Asset("ANIM", "anim/fa_forcefield_yellow.zip")
}


local function kill_fx(inst)
   inst.AnimState:PlayAnimation("close")
   if(inst.components.lighttweener)then
     inst.components.lighttweener:StartTween(nil, 0, .9, 0.9, nil, .2)
   end
   inst:DoTaskInTime(0.6, function() inst:Remove() end)    
end

local function fn(type,lighton)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
  local anim = inst.entity:AddAnimState()
  local sound = inst.entity:AddSoundEmitter()

    anim:SetBank("fa_forcefield_"..type)
    anim:SetBuild("fa_forcefield_"..type)
    anim:PlayAnimation("open")
    anim:PushAnimation("idle_loop", true)
    inst:AddTag("NOCLICK")
    inst:AddTag("FX")

    if(lighton)then
      inst:AddComponent("lighttweener")
      local light = inst.entity:AddLight()
      inst.components.lighttweener:StartTween(light, 0, .9, 0.9, {1,1,1}, 0)
      inst.components.lighttweener:StartTween(nil, 3, .9, 0.9, nil, .2)
    end
    inst.kill_fx = kill_fx

--    sound:PlaySound("dontstarve/wilson/forcefield_LP", "loop")

    return inst
end

return Prefab( "common/fa_forcefieldfx_black", function()return fn("black") end, assets_black),
        Prefab( "common/fa_forcefieldfx_blue", function()return fn("blue") end, assets_blue),
        Prefab( "common/fa_forcefieldfx_green", function()return fn("green") end, assets_green),
        Prefab( "common/fa_forcefieldfx_grey", function()return fn("grey") end, assets_grey),
        Prefab( "common/fa_forcefieldfx_orange",function()return fn("orange") end , assets_orange),
        Prefab( "common/fa_forcefieldfx_pink",function()return fn("pink") end , assets_pink),
        Prefab( "common/fa_forcefieldfx_purple",function()return fn("purple") end , assets_purple),
        Prefab( "common/fa_forcefieldfx_red",function()return fn("red") end , assets_red),
        Prefab( "common/fa_forcefieldfx_teal",function()return fn("teal") end , assets_teal),
        Prefab( "common/fa_forcefieldfx_white",function()return fn("white") end , assets_white),
        Prefab( "common/fa_forcefieldfx_yellow",function()return fn("yellow") end , assets_yellow)
