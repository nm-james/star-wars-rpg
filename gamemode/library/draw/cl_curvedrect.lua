Falcon = Falcon or {}
local color_black = Color( 0, 0, 0, 250 )
local curvedRect = Material("f_coop/curved_square.png")
function surface.DrawCurvedRect( x, y, h, w, rotation, color )
    draw.NoTexture()
    surface.SetDrawColor( color or color_black )
    surface.SetMaterial(curvedRect)
    surface.DrawTexturedRectRotated( x, y, w, h, (rotation or 0) )
    draw.NoTexture()
end