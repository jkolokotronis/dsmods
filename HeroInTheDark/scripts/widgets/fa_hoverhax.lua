--cause base one doesn't want to play nice outside of HUD

local Text = require "widgets/text"
local Image = require "widgets/image"
local Widget = require "widgets/widget"

local YOFFSETUP = 40
local YOFFSETDOWN = 30
local XOFFSET = 10

local FA_HoverHax = Class(Widget, function(self, owner)
    Widget._ctor(self, "HoverText")
    self.owner = owner
    self.isFE = false
    self:SetClickable(false)
    --self:MakeNonClickable()
    self.text = self:AddChild(Text(UIFONT, 30))
    self.text:SetPosition(0,YOFFSETUP,0)
    self:FollowMouseConstrained()
    self:StartUpdating()
end)

function FA_HoverHax:OnUpdate()
    local playercontroller=GetPlayer().components.playercontroller
    local using_mouse =playercontroller:UsingMouse()        
    
    if using_mouse ~= self.shown then
        if using_mouse then
            self:Show()
        else
            self:Hide()
        end
    end
    
    if not self.shown then 
        return 
    end
    
    local str = self.owner:GetTooltip()
    if str then
        self.text:SetString(str)
        self.text:Show()
    else
        self.text:Hide()
    end

    local changed = (self.str ~= str)
    self.str = str
    if changed then
        local pos = TheInput:GetScreenPosition()
        self:UpdatePosition(pos.x, pos.y)
    end
end

function FA_HoverHax:UpdatePosition(x,y)
    local scale = self:GetScale()
    
    local scr_w, scr_h = TheSim:GetScreenSize()

    local w = 0
    local h = 0

    if self.text and self.str then
        local w0, h0 = self.text:GetRegionSize()
        w = math.max(w, w0)
        h = math.max(h, h0)
    end

    w = w*scale.x
    h = h*scale.y
    
    x = math.max(x, w/2 + XOFFSET)
    x = math.min(x, scr_w - w/2 - XOFFSET)

    y = math.max(y, h/2 + YOFFSETDOWN*scale.y)
    y = math.min(y, scr_h - h/2 - YOFFSETUP*scale.x)

    self:SetPosition(x,y,0)
end

function FA_HoverHax:FollowMouseConstrained()
    if not self.followhandler then
        self.followhandler = TheInput:AddMoveHandler(function(x,y) self:UpdatePosition(x,y) end)
        local pos = TheInput:GetScreenPosition()
        self:UpdatePosition(pos.x, pos.y)
    end
end

return FA_HoverHax