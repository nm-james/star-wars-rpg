Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Models = Falcon.UI.Presets.Models or {}

local f = Falcon.UI.Presets.Models

local color_black = Color( 0, 0, 0 )

f.CreateFullModel = function( parent, w, h, x, y, extras ) 
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local backPnl = vgui.Create( "DPanel", parent )
    backPnl:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    backPnl:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    backPnl.Paint = extras.paint or function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 185 )
        surface.DrawRect( 0, 0, w, h )
    end

    local oW, oH = backPnl:GetWide(), backPnl:GetTall()
    local mdl = vgui.Create("DModelPanel", backPnl)
    mdl:SetSize( oW, oH )
    mdl:SetPos( 0, 0 )
    mdl:SetModel( extras.model or "models/player/Group03/male_01.mdl" )

    local cntPnl = vgui.Create("DPanel", backPnl)
    cntPnl:SetSize( oW, oH )
    cntPnl:SetPos( 0, 0 )
    cntPnl.Paint = nil

    return cntPnl, mdl, backPnl
end

