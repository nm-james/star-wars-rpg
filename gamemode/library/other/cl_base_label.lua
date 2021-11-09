Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Other = Falcon.UI.Presets.Other or {}

local f = Falcon.UI.Presets.Other

local color_white = Color( 255, 255, 255 )

f.CreateBaseLabel = function( parent, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local lbl = vgui.Create( "DLabel", parent )
    lbl:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    lbl:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    lbl:SetText( extras.text or "UNTITLED LANEL" )
    lbl:SetFont( extras.font or "F11" )
    lbl:SetContentAlignment( extras.alignment or 4 )
    lbl:SetColor( extras.color or color_white )

    return lbl
end