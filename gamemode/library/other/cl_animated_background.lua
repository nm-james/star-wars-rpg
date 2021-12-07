Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Other = Falcon.UI.Presets.Other or {}

local color_black = Color( 0, 0, 0, 255 )
Falcon.UI.Presets.Other.CreateChangingScenes = function( frame, w, h, x, y, scenes )
    if not frame or not frame:IsValid() or not scenes or table.IsEmpty(scenes) then return end
    local wF, hF = frame:GetWide(), frame:GetTall()
    local animP = vgui.Create("DPanel", frame)
    animP:SetSize( wF * (w or 0.5), hF * (h or 0.5) )
    animP:SetPos( wF * (x or 0.25), hF * (y or 0.25) )
    animP.CurrentScene = 1
    animP.SceneMultiplier = 0
    animP.ShouldFade = 0
    animP.Scenes = scenes
    animP.Think = function( self )
        local fr = FrameTime()
        if self.SceneMultiplier > 0.75 then
            self.ShouldFade = math.Clamp(self.ShouldFade + (fr * 0.8), 0, 1)
            if self.SceneMultiplier == 1 and self.ShouldFade == 1 then
                if self.CurrentScene == table.Count( self.Scenes ) then
                    self.CurrentScene = 1
                else
                    self.CurrentScene = self.CurrentScene + 1
                end
                self.SceneMultiplier = 0
            end
        else
            self.ShouldFade = math.Clamp(self.ShouldFade - (fr), 0, 1)
        end
        self.SceneMultiplier = math.Clamp(self.SceneMultiplier + (fr * 0.1), 0, 1)
    end

    animP.Paint = function( self, w, h )
        local x, y = self:GetPos()
        local old = DisableClipping( true )
        render.RenderView( {
            origin = LerpVector(self.SceneMultiplier, self.Scenes[self.CurrentScene].Start.Pos, self.Scenes[self.CurrentScene].End.Pos),
            angles = LerpAngle(self.SceneMultiplier, self.Scenes[self.CurrentScene].Start.Ang, self.Scenes[self.CurrentScene].End.Ang),
            x = x, y = y,
            w = w, h = h
        } )
        DisableClipping( old )

        surface.SetDrawColor( color_black.r, color_black.g, color_black.b, color_black.a * self.ShouldFade )
        surface.DrawRect( 0, 0, w, h )
    end 

    return animP
end