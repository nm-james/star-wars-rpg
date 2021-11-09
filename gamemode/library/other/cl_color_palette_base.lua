Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Other = Falcon.UI.Presets.Other or {}

local f = Falcon.UI.Presets.Other
local color_white = Color( 255, 255, 255 )

f.CreateColorPalette = function( parent, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local colorPicker = vgui.Create( "DColorMixer", parent )
    colorPicker:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    colorPicker:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    colorPicker:SetWangs( extras.wangs or false )
    colorPicker:SetAlphaBar( extras.alphaBar or false )
    colorPicker:SetPalette( extras.palette or false )

    return colorPicker
end
