Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Panel = Falcon.UI.Presets.Panel or {}

local f = Falcon.UI.Presets.Panel
local scrw, scrh = ScrW(), ScrH()

-- COLORS
local color_black = Color( 0, 0, 0 )
local color_blackgrey = Color( 45, 45, 45 )
local color_middarkgrey = Color( 65, 65, 65 )
local color_darkgrey = Color( 125, 125, 125 )
local whiteish = Color( 245, 245, 245 )

f.CreateBanneredPanel = function( parent, w, h, x, y, extras )
    if not parent or not parent:IsValid() then return end
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local pnl = vgui.Create("DPanel", parent)
    pnl:SetSize(wP * (w or 0.5), hP * (h or 0.5))
    pnl:SetPos(wP * (x or 0.25), hP * (y or 0.25))
    pnl.Paint = function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 185 )
        surface.DrawRect( 0, 0, w, h )
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-u"),
            color = color_blackgrey,
            x = 0,
            y = scrh * 0.0225,
            w = w,
            h = scrh * 0.011
        })
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local pW, pH = pnl:GetWide(), pnl:GetTall()
    local banner = vgui.Create("DPanel", pnl)
    banner:SetSize( pW, scrh * 0.0225 )
    banner:Dock( TOP )
    banner.Paint = function( self, w, h )
        surface.SetDrawColor( color_darkgrey )
        surface.DrawRect( 0, 0, w, h )
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-d"),
            color = color_middarkgrey,
            x = 0,
            y = h * 0.0,
            w = w,
            h = h * 0.95
        })
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText( extras.text or "", "F9", w * 0.5, h * 0, whiteish, TEXT_ALIGN_CENTER )
    end

    local content = vgui.Create("DScrollPanel", pnl)
    content:SetSize( pW, pH - (scrh * 0.0225) )
    content:SetPos( 0, scrh * 0.0225 )

    return content, pnl, banner
end


f.CreateBanneredScrollPanel = function( parent, w, h, x, y, extras )
    if not parent or not parent:IsValid() then return end
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()
    local pnl = vgui.Create("DPanel", parent)
    pnl:SetSize(wP * (w or 0.5), hP * (h or 0.5))
    pnl:SetPos(wP * (x or 0.25), hP * (y or 0.25))
    pnl.Paint = function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 185 )
        surface.DrawRect( 0, 0, w, h )
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-u"),
            color = color_blackgrey,
            x = 0,
            y = scrh * 0.0225,
            w = w,
            h = scrh * 0.011
        })
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local pW, pH = pnl:GetWide(), pnl:GetTall()
    local banner = vgui.Create("DPanel", pnl)
    banner:SetSize( pW, scrh * 0.0225 )
    banner:Dock( TOP )
    banner.Paint = function( self, w, h )
        surface.SetDrawColor( color_darkgrey )
        surface.DrawRect( 0, 0, w, h )
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-d"),
            color = color_middarkgrey,
            x = 0,
            y = h * 0.0,
            w = w,
            h = h * 0.95
        })
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText( extras.text or "", "F9", w * 0.5, h * 0, whiteish, TEXT_ALIGN_CENTER )
    end

    local content = vgui.Create("DScrollPanel", pnl)
    content:SetSize( pW, pH - (scrh * 0.0225) )
    content:SetPos( 0, scrh * 0.0225 )

    local sbar = content:GetVBar()
    function sbar:Paint(w, h)
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
    end
    function sbar.btnUp:Paint(w, h)
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( whiteish )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnDown:Paint(w, h)
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( whiteish )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    function sbar.btnGrip:Paint(w, h)
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( whiteish )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    
    return content, pnl, banner
end

