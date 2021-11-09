Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Other = Falcon.UI.Presets.Other or {}

local f = Falcon.UI.Presets.Other

-- COLORS
local color_white = Color( 255, 255, 255 )

-- MATERIALS
local blur = Material( "pp/blurscreen" )

f.DrawBlur = function( w, h, x, y, intensity )
    local intensity = intensity or 8
    surface.SetDrawColor( color_white )
    surface.SetMaterial( blur )

    for i = 1, 4 do
        blur:SetFloat( "$blur", ( i / 4 ) * intensity )
        blur:Recompute()

        render.UpdateScreenEffectTexture()
        surface.DrawTexturedRect( x, y, w, h )
    end
end