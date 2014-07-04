--modified version of Simplex's damage indicators, see http://forums.kleientertainment.com/topic/30774-mod-idea-damage-indicator/page-1#entry400575

local _G = GLOBAL
local require = _G.require
require "fa_constants"


-- Font size.
LABEL_FONT_SIZE = 22
-- Height to damage label.
LABEL_HEIGHT = 3
-- Label duration.
LABEL_DURATION = 1.2
-- Speed of upwards direction.
LABEL_SPEED = 0.85
-- Update period for label movement.
LABEL_UPDATE_PERIOD = 0.05

LABEL_PRECISION=2

-- rounds a number to the nearest decimal places
--
local function round(val, decimal)
  if (decimal) then
    return math.floor( (val * 10^decimal) + 0.5) / (10^decimal)
  else
    return math.floor(val+0.5)
  end
end

local function TurnIntoDummyChildEntity(inst, parent, remove_cb)
	inst.persists = false
	if not inst.Transform then
		inst.entity:AddTransform()
	end
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")

	if inst.parent ~= parent then
		parent:AddChild(inst)
	end
	_G.assert( inst.parent == parent )

	inst.Transform:SetPosition( 0, 0, 0 )

	inst:ListenForEvent("onremove", function()
		if remove_cb then
			remove_cb(inst)
		end
		inst:Remove()
	end, parent)
	inst:ListenForEvent("onremove", function(inst)
		if parent:IsValid() and inst.parent == parent then
			parent:RemoveChild(inst)
		end
	end)

	return inst
end

local function MakeDummyChildEntity(parent, remove_cb)
	return TurnIntoDummyChildEntity(_G.CreateEntity(), parent, remove_cb)
end

local function StartAnimating(inst)
	inst:StartThread(function()
		local Sleep = _G.Sleep

		local l = inst.Label

		local t = 0
		local t_max = LABEL_DURATION
		local dt = LABEL_UPDATE_PERIOD

		local s = LABEL_SPEED

		local h0 = LABEL_HEIGHT
		local h = h0
		local h_max = h0 + s*t_max
		local dh = s*dt

		while inst:IsValid() and h <= h_max do
			l:SetPos(0, h, 0)
			h = h + dh
			Sleep(dt)
		end

		inst:Remove()
	end)
end

function MakeDamageEntity(parent, amount,damagetype)
	local inst = MakeDummyChildEntity(parent)

	local l = inst.entity:AddLabel()
	l:SetFontSize( LABEL_FONT_SIZE )
	l:SetFont(_G.DEFAULTFONT)
	l:SetPos(0, LABEL_HEIGHT, 0)

	local colour = (amount<0 and _G.FA_DAMAGE_INDICATORS[damagetype]) or _G.FA_DEFAULT_HEAL_INDICATOR
	l:SetColour(colour[1], colour[2], colour[3],colour[4])

	local textual_amount
	if amount == math.floor(amount) then
		textual_amount = ("%+d"):format(amount)
	else
		textual_amount = ("%+.2f"):format(round(amount,LABEL_PRECISION))
	end
	l:SetText( textual_amount )

	l:Enable(true)

	StartAnimating(inst)

	return inst
end

return MakeDamageEntity