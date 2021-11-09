Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Panel = Falcon.UI.Presets.Panel or {}

local f = Falcon.UI.Presets.Panel
local scrw, scrh = ScrW(), ScrH()

-- COLORS
local color_black = Color( 0, 0, 0 )
local whiteish = Color( 255, 255, 255 )

f.CreateHorizontalScroll = function( parent, w, h, x, y, extras )
    if not parent or not parent:IsValid() then return end
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local scrll = vgui.Create( "DHorizontalScroller", parent )
    scrll:SetSize( wP * (w or 0.5), hP * (h or 0.5) )
    scrll:SetPos( wP * (x or 0.25), hP * (y or 0.25) )
    scrll:SetOverlap( -5 )
    scrll:SetUseLiveDrag( true )

    scrll.PerformLayout = function( self )
        local w, h = self:GetSize()
    
        self.pnlCanvas:SetTall( h )
    
        local x = 0
    
        for k, v in pairs( self.Panels ) do
            if ( !IsValid( v ) ) then continue end
            if ( !v:IsVisible() ) then continue end
    
            v:SetPos( x, 0 )
            v:SetTall( h )
            if ( v.ApplySchemeSettings ) then v:ApplySchemeSettings() end
    
            x = x + v:GetWide() - self.m_iOverlap
    
        end
    
        self.pnlCanvas:SetWide( x + self.m_iOverlap )
    
        if ( w < self.pnlCanvas:GetWide() ) then
            self.OffsetX = math.Clamp( self.OffsetX, 0, self.pnlCanvas:GetWide() - self:GetWide() )
        else
            self.OffsetX = 0
        end
    
        self.pnlCanvas.x = self.OffsetX * -1
    
        self.btnLeft:SetSize( 50, h * 0.99 )
        self.btnLeft:AlignLeft( 4 )
        self.btnLeft:AlignTop( 4 )
        self.btnLeft:SetText( "<" )
        self.btnLeft:SetFont( "F12" )
        self.btnLeft:SetColor( whiteish )


        self.btnRight:SetSize( 50, h * 0.99 )
        self.btnRight:AlignRight( 4 )
        self.btnRight:AlignTop( 4 )
        self.btnRight:SetText( ">" )
        self.btnRight:SetFont( "F12" )
        self.btnRight:SetColor( whiteish )

        self.btnLeft:SetVisible( self.pnlCanvas.x < 0 )
        self.btnRight:SetVisible( self.pnlCanvas.x + self.pnlCanvas:GetWide() > self:GetWide() )
    end

    local ws, hs = scrll:GetSize()
    local l = scrll.btnLeft
    l.Paint = function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( whiteish )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    local r = scrll.btnRight
    r.Paint = function( self, w, h )
        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 190 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( whiteish )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end

    return scrll
end