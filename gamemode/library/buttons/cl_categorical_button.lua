Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Buttons = Falcon.UI.Presets.Buttons or {}

local f = Falcon.UI.Presets.Buttons

local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

f.CreateCategoricalButton = function( parent, w, h, x, y, extras )
    local extras = extras or {}
    local wP, hP = parent:GetWide(), parent:GetTall()

    local btn = vgui.Create( "DButton", parent )
    btn:SetSize( wP * (w or 0.2), hP * (h or 0.5) )
    btn:SetPos( wP * (x or (1 - 0.0125)), hP * (y or 0) )
    btn:SetFont( extras.font or "F10" )
    btn:SetText( extras.text or "UNTITLED" )
    btn:SetColor( extras.color or color_white )
    btn.CurColor = color_black
    btn.Paint = extras.paint or function( self, w, h )
        surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
        surface.DrawRect( 0, 0, w, h )
    end

    btn.Think = function( self )
        if self.IsActive then
            if self.CurColor == color_white then return end
            self.CurColor = color_white
            self:SetColor( color_black )
        else
            if self.CurColor == color_black then return end
            self.CurColor = color_black
            self:SetColor( color_white )
        end
    end

    btn.DoClick = function( self )
        local curBtn = parent.CurrentActiveButton

        if curBtn and curBtn:IsValid() then
            curBtn.IsActive = false
        end

        self.IsActive = true
        parent.CurrentActiveButton = self

        if extras.click then
            extras.click( self )
        end
    end
   
    if extras.fade then
        btn:SetAlpha( 175 )
        btn.Think = function( self )
            local alpha = self:GetAlpha()
            if self:IsHovered() or self.IsActive then
                if alpha < 255 then
                    self:SetAlpha( math.Clamp(alpha + ((FrameTime() * 6) * 255), 175, 255) )
                end
                if self.IsActive and self.CurColor ~= color_white then
                    self.CurColor = color_white
                    self:SetColor( color_black )
                end
            else
                if alpha > 175 then 
                    self:SetAlpha( math.Clamp(alpha - ((FrameTime() * 6) * 255), 175, 255) )
                end
                if self.CurColor == color_black then return end
                self.CurColor = color_black
                self:SetColor( color_white )
            end
        end
    end

    return btn
end