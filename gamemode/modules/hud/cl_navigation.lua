Falcon = Falcon or {}
local repLogo = Material("f_coop/republic.png")
local healthIcon = Material("f_coop/health.png")
local shieldIcon = Material("f_coop/shield.png")
local lvlIcon = Material("f_coop/levels.png")
local creditIcon = Material("f_coop/credits.png")

hook.Add("HUDPaint", "DrawFalconHUD", function()
    local w, h = ScrW(), ScrH()

    local ply = LocalPlayer()
    local ang = ply:GetAngles()

    surface.SetDrawColor( 0, 0, 0, 200 )
	draw.NoTexture()
    draw.Circle( w * 0.09, h * 0.84, w * 0.06, 360 )

    surface.DrawCircle( w * 0.09, h * 0.84, w * 0.06, Color( 255, 255, 255, 255 ) )
    surface.DrawCircle( w * 0.09, h * 0.84, w * 0.0595, Color( 255, 255, 255, 255 ) )
    surface.DrawCircle( w * 0.09, h * 0.84, w * 0.059, Color( 255, 255, 255, 255 ) )
    surface.DrawCircle( w * 0.09, h * 0.84, w * 0.0586, Color( 255, 255, 255, 255 ) )

    surface.SetDrawColor( 255, 255, 255, 20 )
    draw.DrawARC( w * 0.09, h * 0.84, w * 0.06, -45 - ang.y, 45 - ang.y, 1 )

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.SetMaterial( repLogo )
    surface.DrawTexturedRect( (w * 0.09) - ((w * 0.02) / 2), (h * 0.84) - ((w * 0.02) / 2 ), w * 0.02, w * 0.02 )
	draw.NoTexture()

    surface.SetDrawColor( 255, 255, 255, 255 )
    surface.DrawRect( w * 0.09 + (w * 0.06), (h * 0.84), w * 0.02, h * 0.003 )
    surface.DrawTexturedRectRotated(  w * 0.0975 + (w * 0.06), (h * 0.819), w * 0.025, h * 0.003 , 105 )
    surface.DrawTexturedRectRotated(  w * 0.0975 + (w * 0.06), (h * 0.863), w * 0.025, h * 0.003 , -105 )
    surface.DrawTexturedRectRotated(  w * 0.098 + (w * 0.06), (h * 0.79425), w * 0.01, h * 0.003 , 30 )
    surface.DrawTexturedRectRotated(  w * 0.098 + (w * 0.06), (h * 0.88625), w * 0.01, h * 0.003 , -30 )

    surface.DrawCurvedRect( w * 0.171, h * 0.78, w * 0.03, w * 0.035, 120, Color( 255, 255, 255, 255 ) )
    surface.DrawCurvedRect( w * 0.171, h * 0.78, w * 0.0275, w * 0.0325, 120 )
    surface.DrawCurvedRect( w * 0.18, h * 0.84, w * 0.03, w * 0.035, 90, Color( 255, 255, 255, 255 ) )
    surface.DrawCurvedRect( w * 0.18, h * 0.84, w * 0.0275, w * 0.0325, 90 )
    surface.DrawCurvedRect( w * 0.171, h * 0.9, w * 0.03, w * 0.035, 60, Color( 255, 255, 255, 255 ) )
    surface.DrawCurvedRect( w * 0.171, h * 0.9, w * 0.0275, w * 0.0325, 60 )

--     draw.DrawText( "N", "F14", w * 0.09, h * 0.73, Color(255,255,255,255), TEXT_ALIGN_CENTER )
--     draw.DrawText( "W", "F14", w * 0.09 - (w * 0.05125), h * 0.73 + ((w * 0.05125)), Color(255,255,255,255), TEXT_ALIGN_CENTER )
--     draw.DrawText( "S", "F14", w * 0.09, h * 0.73 + ((w * 0.1035)), Color(255,255,255,255), TEXT_ALIGN_CENTER )
--     draw.DrawText( "E", "F14", w * 0.09 + (w * 0.05125), h * 0.73 + ((w * 0.05125)), Color(255,255,255,255), TEXT_ALIGN_CENTER )

--     surface.SetDrawColor( 0, 0, 0, 155 )
--     draw.DrawARC( w * 0.95, h * 0.925, w * 0.02, 0, 360, 1 )
--     draw.DrawARC( w * 0.9, h * 0.925, w * 0.02, 0, 360, 1 )
--     draw.DrawARC( w * 0.965, h * 0.05, w * 0.02, 0, 360, 1 )

--     local colAdd = 0
--     if ply:Health() < (ply:GetMaxHealth() / 4) then
--         colAdd = math.Clamp( math.sin( CurTime() * 2 ) * 255, 0, 80 )
--     end
--     surface.SetDrawColor( 175 + colAdd, 55, 55, 255 )
--     draw.DrawARC( w * 0.95, h * 0.925, w * 0.02, 0, (ply:Health() / ply:GetMaxHealth()) * 360, 1 )
--     surface.SetDrawColor( 60, 0, 0, 255 )
--     draw.Circle( w * 0.95, h * 0.925, w * 0.017, 360 )

--     draw.NoTexture()
--     surface.SetDrawColor( 175 + colAdd, 55, 55, 255 )
--     surface.SetMaterial( healthIcon )
--     surface.DrawTexturedRect(  w * 0.95 - ((w * 0.025) / 2), h * 0.925 - ((w * 0.0225) / 2), w * 0.025, w * 0.025 )
--     draw.NoTexture()


--     surface.SetDrawColor( 165, 165, 220, 255 )
--     draw.DrawARC( w * 0.9, h * 0.925, w * 0.02, 0, (ply:Armor() / ply:GetMaxArmor()) * 360, 1 )
--     surface.SetDrawColor( 55, 55, 90, 255 )
--     draw.Circle( w * 0.9, h * 0.925, w * 0.017, 360 )

--     draw.NoTexture()
--     surface.SetDrawColor( 165, 165, 220, 255 )
--     surface.SetMaterial( shieldIcon )
--     surface.DrawTexturedRect(  w * 0.9 - ((w * 0.02) / 2), h * 0.925 - ((w * 0.02) / 2), w * 0.02, w * 0.0225 )
--     draw.NoTexture()

--     surface.SetDrawColor( 255, 255, 95, 255 )
--     draw.DrawARC( w * 0.965, h * 0.05, w * 0.02, 0, (ply:GetLevel() / 100) * 360, 1 )
--     surface.SetDrawColor( 145, 145, 45, 255 )
--     draw.Circle( w * 0.965, h * 0.05, w * 0.017, 360 )

--     draw.NoTexture()
--     surface.SetDrawColor( 255, 255, 95, 255 )
--     surface.SetMaterial( lvlIcon )
--     surface.DrawTexturedRect(  w * 0.965 - ((w * 0.03) / 2), h * 0.05 - ((w * 0.03) / 2), w * 0.03, w * 0.03 )
--     draw.NoTexture()

--     draw.DrawText( "LEVEL " .. tostring( ply:GetLevel() ), "F15", w * 0.94, h * 0.015, Color( 255, 255, 255, 255 ), TEXT_ALIGN_RIGHT )
--     draw.DrawText( "XP " .. tostring( ply:GetEXP() ), "F10", w * 0.94, h * 0.04, Color( 185, 185, 185, 255 ), TEXT_ALIGN_RIGHT )
--     draw.DrawText( "$" .. tostring( ply:GetCredits() ), "F10", w * 0.94, h * 0.055, Color( 135, 255, 135, 255 ), TEXT_ALIGN_RIGHT )

--     -- surface.SetDrawColor( 255, 255, 95, 255 )
--     -- draw.DrawARC( w * 0.035, h * 0.05, w * 0.02, 0, (ply:GetLevel() / 100) * 360, 1 )
--     -- surface.SetDrawColor( 145, 145, 45, 255 )
--     -- draw.Circle( w * 0.035, h * 0.05, w * 0.017, 360 )

--     -- draw.NoTexture()
--     -- surface.SetDrawColor( 255, 255, 95, 255 )
--     -- surface.SetMaterial( lvlIcon )
--     -- surface.DrawTexturedRect(  w * 0.035 - ((w * 0.03) / 2), h * 0.05 - ((w * 0.03) / 2), w * 0.03, w * 0.03 )
--     -- draw.NoTexture()

--     -- draw.DrawText( "LEVEL " .. tostring( ply:GetLevel() ), "F15", w * 0.0575, h * 0.015, Color( 255, 255, 95, 255 ), TEXT_ALIGN_LEFT )
--     -- draw.DrawText( "XP " .. tostring( ply:GetEXP() ), "F10", w * 0.0575, h * 0.04, Color( 185, 185, 185, 255 ), TEXT_ALIGN_LEFT )
--     -- draw.DrawText( "$" .. tostring( ply:GetCredits() ), "F10", w * 0.0575, h * 0.055, Color( 135, 255, 135, 255 ), TEXT_ALIGN_LEFT )

end)
