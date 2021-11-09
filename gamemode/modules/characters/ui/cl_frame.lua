Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Characters = Falcon.UI.Characters or {}
local scrw, scrh = ScrW(), ScrH()

local f = Falcon.UI.Characters

local scenes = {
    {
        Start = { Pos = Vector(), Ang = Angle() },
        End = { Pos = Vector(-4446.068848, -2281.912842, 314.031250), Ang = Angle(0, 47, 0) },
    },
}
f.OpenFrame = function()
    local f = vgui.Create("DFrame")
    f:SetSize(scrw, scrh)
    f:Center()
    f:MakePopup()
    f.Paint = nil

    local anim = Falcon.UI.Presets.Other.CreateChangingScenes( f, 1, 1, 0, 0, scenes )

    Falcon.UI.Presets.Buttons.ExitButton( f )
end

concommand.Add("OPEN_CHARACTERS", function()
    f.OpenFrame()
end)