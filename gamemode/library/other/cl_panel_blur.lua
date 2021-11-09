Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Other = Falcon.UI.Presets.Other or {}

local f = Falcon.UI.Presets.Other
local scrw, scrh = ScrW(), ScrH()
-- COLORS
local color_white = Color( 255, 255, 255 )

-- MATERIALS
local blur = Material( "pp/blurscreen" )

f.DrawPanelBlur = function( panel, intensity )
    local x, y = panel:LocalToScreen( 0, 0 )
    surface.SetMaterial( blur )
    surface.SetDrawColor( color_white )

    for i=0.33, 1, 0.33 do
        blur:SetFloat( "$blur", (intensity or 10) * i ) -- Increase number 5 for more blur
        blur:Recompute()
        if ( render ) then render.UpdateScreenEffectTexture() end
        surface.DrawTexturedRect( x * -1, y * -1, scrw, scrh )
    end
end