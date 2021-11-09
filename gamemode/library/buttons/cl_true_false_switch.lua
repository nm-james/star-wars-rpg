Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local f = Falcon.UI.Presets.Buttons 

f.CreateTrueFalseSwitch = function( parent, starting, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local p = vgui.Create("DPanel", parent)
    p:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    p:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    p.Paint = nil

    local noBtn = f.CreateCategoricalButton( p, 0.5, 1, 0, 0, { text = "OFF", fade = true, click = function( self )
        p.CurrentSwitchValue = 0
    end  } )

    local yesBtn = f.CreateCategoricalButton( p, 0.5, 1, 0.5, 0, { text = "ON", fade = true, click = function( self )
        p.CurrentSwitchValue = 1
    end } )

    if not starting then
        noBtn.IsActive = true
        p.CurrentActiveButton = noBtn
        p.CurrentSwitchValue = 0
    else
        yesBtn.IsActive = true
        p.CurrentActiveButton = yesBtn
        p.CurrentSwitchValue = 1
    end

    return p
end