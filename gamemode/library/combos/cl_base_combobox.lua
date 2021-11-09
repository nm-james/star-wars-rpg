Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.ComboBoxes = Falcon.UI.Presets.ComboBoxes or {}

local f = Falcon.UI.Presets.ComboBoxes

-- COLOR
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

f.CreateComboBox = function( parent, options, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local comboBox = vgui.Create( "DComboBox", parent )
    comboBox:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    comboBox:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    comboBox:SetContentAlignment( 5 )
    comboBox:SetFont( extras.font or "F8" )
    comboBox:SetColor( color_white )
    comboBox.Paint = extras.paint or function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 200 )
        surface.DrawRect( 0, 0, w, h )
    end
    comboBox:SetValue( extras.text or "CLEARANCE" )
    for _, opt in pairs( options ) do
        comboBox:AddChoice( opt )
    end
    
    if extras.onselect then
        comboBox.OnSelect = extras.onselect
    end

    return comboBox
end
