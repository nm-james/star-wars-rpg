Falcon = Falcon or {}
Falcon.ActiveSectors = Falcon.ActiveSectors or {}

local c_w = Color( 255, 255, 255 )
local c_b = Color( 0, 0, 0 )
local scrw, scrh = ScrW(), ScrH()
hook.Add("HUDPaint", "PrintTheGoodSheeshForEpicGamemode", function()
    local ply = LocalPlayer() 
    if ply.Location == "Venator" then return end
    local i = 0

    for p, _ in pairs( Falcon.ActiveSectors ) do
        local l = Falcon.Locations[ply.Location][p]
        if not l then continue end
        if not l.isactive then continue end
        draw.SimpleTextOutlined(l.name, "F9", scrw * 0.025, scrh * (0.1575 + (i * 0.016)), c_w, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, c_b )
        i = i + 1
    end

    if i > 0 then
        draw.SimpleTextOutlined("Active Sectors [" .. tostring(i) .. "]", "F18", scrw * 0.025, scrh * 0.12, c_w, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 1, c_b )
        surface.SetDrawColor( c_w )
        surface.DrawLine( scrw * 0.0225, scrh * 0.16, scrw * 0.16, scrh * 0.16 )
    end
end)