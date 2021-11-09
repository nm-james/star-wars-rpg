Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local f = Falcon.UI.Presets.Buttons

local color_white = Color( 255, 255, 255, 255 )
f.TextButton = function( parent, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local e = vgui.Create( "DButton", parent )
    e:SetSize( wP * (w or 0.0125), hP * (h or 0.1) )
    e:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    e:SetFont( extras.font or "F10" )
    e:SetText( extras.text or "UNTITLED" )
    e:SetColor( extras.color or color_white )
    e.Paint = nil
    e.DoClick = function( self )
        if extras.click then
            extras.click( self )
        end
    end

    if extras.fade then
        e:SetAlpha( 175 )
        e.Think = function( self )
            local alpha = self:GetAlpha()
            if self:IsHovered() then
                if alpha >= 255 then return end
                self:SetAlpha( math.Clamp(alpha + ((FrameTime() * 6) * 255), 175, 255) )
            else
                if alpha <= 175 then return end
                self:SetAlpha( math.Clamp(alpha - ((FrameTime() * 6) * 255), 175, 255) )
            end
        end
    end

    return e
end