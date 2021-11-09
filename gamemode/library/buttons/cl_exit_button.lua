Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local scrw, scrh = ScrW(), ScrH()
Falcon.UI.Presets.Buttons.ExitButton = function( parent, overlay )
    local wP, hP = parent:GetWide(), parent:GetTall()

    local e = Falcon.UI.Presets.Buttons.TextButton( parent, 0.0125, 0.0315, (1 - 0.015), 0, {
        text = "x",
        font = "F12",
        fade = true,
        click = function( self )
            parent:Close()

            if overlay and overlay:IsValid() then
                overlay:SetMouseInputEnabled( true )
                overlay:SetKeyboardInputEnabled( true )
            end
        end,
    } )

    e:SetSize( scrh * 0.03, scrh * 0.03 )
    e:SetPos( wP - (scrh * 0.03), 0 )

    return e
end