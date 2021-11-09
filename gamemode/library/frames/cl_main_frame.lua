Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Frames = Falcon.UI.Presets.Frames or {}
local scrw, scrh = ScrW(), ScrH()

-- COLORS
local color_black = Color( 0, 0, 0 )
local color_blackgrey = Color( 30, 30, 30 )
local color_middarkgrey = Color( 45, 45, 45 )
local color_darkgrey = Color( 62, 62, 62 )
local whiteish = Color( 245, 245, 245 )

local f = Falcon.UI.Presets.Frames
f.CreateBaseFrame = function( w, h, x, y, extras )
    local extras = extras or {}
    local f = vgui.Create( "DFrame", extras.parent )
    f:SetSize( scrw * (w or 0.5), scrh * (h or 0.5) )
    f:SetPos( scrw * (x or 0.25), scrh * (y or 0.25) )
    f:SetTitle("")
    f:SetDraggable( extras.draggable or false )
    f:ShowCloseButton( extras.showclose or false )
    f:MakePopup()

    if extras.shouldAnimate then
        f:SetAlpha( 0 )
        f.Think = function( self )
            local alpha = self:GetAlpha()
            if alpha >= 255 then
                self.Think = nil
                return
            end
            self:SetAlpha( math.Clamp(alpha + ((FrameTime() * (extras.animSpeed or 3)) * 255), 0, 255) )
        end
    end

    f.Paint = function( self, w, h )
        Falcon.UI.Presets.Other.DrawPanelBlur( self )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 125 )
        surface.DrawRect( 0, 0, w, h )
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-u"),
            color = color_blackgrey,
            x = 0,
            y = scrh * 0.03,
            w = w,
            h = h * 0.015
        })
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local banner = vgui.Create("DPanel", f)
    banner:SetSize( scrw * (w or 0.5), scrh * 0.03 )
    banner:SetPos( 0, 0 )
    banner.Paint = function( self, w, h )
        surface.SetDrawColor( color_darkgrey )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( color_blackgrey )
        surface.DrawOutlinedRect( 0, 0, w, h )
        	
        draw.TexturedQuad({
            texture = surface.GetTextureID("vgui/gradient-d"),
            color = color_middarkgrey,
            x = 0,
            y = h * 0.0,
            w = w,
            h = h * 0.95
        })

        draw.DrawText( extras.text or "", "F12", w * 0.5, h * 0, whiteish, TEXT_ALIGN_CENTER )
    end

    local w, h = f:GetWide(), f:GetTall()
    local content = vgui.Create("DPanel", f)
    content:SetSize( w, h - (scrh * 0.03) )
    content:SetPos( 0, scrh * 0.03 )
    content.Paint = nil

    return content, f
end
