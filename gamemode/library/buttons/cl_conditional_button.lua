Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local f = Falcon.UI.Presets.Buttons

-- COLOR
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

f.CreateConditionalButton = function( parent, condition, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()
    local baseAlpha = extras.baseAlpha or 110

    local btn = vgui.Create( "DButton", parent )
    btn:SetSize( wP * (w or 0.0125), hP * (h or 0.1) )
    btn:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    btn:SetFont( extras.font or "F10" )
    btn:SetText( extras.text or "UNTITLED" )
    btn:SetColor( extras.color or color_white )
    btn.CurColor = color_black
    btn.Paint = extras.paint or function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 200 )
        surface.DrawRect( 0, 0, w, h )
    end
    btn.DoClick = function( self )
        local con = condition( self )
        if not con then return end

        if extras.click then
            extras.click( self )
        end
    end

    btn:SetAlpha( baseAlpha )
    btn.Think = function( self )
        local alpha = self:GetAlpha()
        local con = condition( self )
        if con then
            self:SetAlpha( math.Clamp(alpha + ((FrameTime() * 6) * 255), baseAlpha, 255) )
        else
            if alpha <= baseAlpha then return end
            self:SetAlpha( math.Clamp(alpha - ((FrameTime() * 6) * 255), baseAlpha, 255) )
        end
    end

    return btn
end
