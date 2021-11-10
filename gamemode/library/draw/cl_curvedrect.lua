Falcon = Falcon or {}

local curvedRect = Material("f_coop/curved_square.png")
function surface.DrawCurvedRect( x, y, h, w, rotation, color )
    draw.NoTexture()
    surface.SetDrawColor( color or Color( 255, 255, 255, 255 ) )
    surface.SetMaterial(curvedRect)
    surface.DrawTexturedRectRotated( x, y, w, h, (rotation or 0) )
    draw.NoTexture()
end