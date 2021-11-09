Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Entry = Falcon.UI.Presets.Entry or {}

-- COLORS
local color_white = Color( 255, 255, 255 )
local t_color_black_alpha = Color( 0, 0, 0, 195 )
local t_color_grey = Color( 65, 65, 65 )

local f = Falcon.UI.Presets.Entry
f.CreateBaseEntry = function( parent, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()
    local entry = vgui.Create("DTextEntry", parent)
    entry:SetSize( wP * (w or 0.4), hP * (h or 0.2) )
    entry:SetPos( wP * (x or 0.2), hP * (y or 0.2) )
    entry:SetFont( extras.font or "F15" )
    entry.TextColor = color_white
    entry.Paint = function( self, w, h )
        surface.SetDrawColor( t_color_black_alpha )
        surface.DrawRect( 0, 0, w, h )
        self:DrawTextEntryText( self.TextColor, t_color_grey, color_white )
    end

    return entry
end