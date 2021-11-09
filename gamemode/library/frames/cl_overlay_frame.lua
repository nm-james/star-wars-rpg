Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Frames = Falcon.UI.Presets.Frames or {}
local scrw, scrh = ScrW(), ScrH()

local f = Falcon.UI.Presets.Frames

f.CreateOverlayFrame = function( w, h, x, y, overlay, extras )
    if not overlay or not overlay:IsValid() then return end
    local extras = extras or {}
    local contentPnlThingy, fr = f.CreateBaseFrame( w, h, x, y, extras )

    local overlayFr = overlay:GetParent()
    overlayFr:SetMouseInputEnabled( false )
    overlayFr:SetKeyboardInputEnabled( false )


    local e = Falcon.UI.Presets.Buttons.ExitButton( fr, overlayFr )

    return contentPnlThingy, e
end