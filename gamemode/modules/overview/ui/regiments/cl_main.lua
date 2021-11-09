Falcon = Falcon or {}
Falcon.Overview = Falcon.Overview or {}

local f = Falcon.Overview

local color_black = Color( 0, 0, 0 )
local whiteish = Color( 255, 255, 255 )

local seq = { "taunt_robot", "crab_dance", "dance_shoot", "dancing_girl", "epic_sax_guy", "goatdance", "groovejam", "guitar_walk", "f_zippy_dance", "kpop_dance03", "loser_dance" }
local mainSeq = { "calculated", "hi_five_slap", "iceking", "f_wave2", "f_golfclap" }

f.OpenRegimentMain = function( contentPnl )
    contentPnl:Clear()


end

f.OpenRegimentInfo = function( content )
    content:Clear()

    local c = Falcon.UI.Presets.Panel.CreateHorizontalScroll( content, 1, 1, 0, 0, {} )

    local w, h = c:GetSize()
    for _, reg in pairs( Falcon.Regiments ) do
        local p = vgui.Create("DPanel", c)
        p:SetSize( w * 0.25, h )
        p.Paint = function( self, w, h )
            surface.SetDrawColor( reg.color.r, reg.color.g, reg.color.b, 40 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( reg.color )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end

        -- model
        local content, mdl = Falcon.UI.Presets.Models.CreateFullModel( p, 0.9, 0.85, 0.05, 0.03, {} )
        mdl:SetFOV( 30 )
        mdl:SetLookAt( Vector(0, 0, 35) )
        mdl:SetCamPos( Vector(120, 0, 40) )
        mdl:SetModel( reg.loadouts[1].model )
        content.OnCursorEntered = function( self )
            local e = mdl:GetEntity()

            local newAnim = math.random(1, 2)
            if newAnim == 1 then
                local easterEgg = math.random(1, 100)
                local newSeq = mainSeq[math.random(1, #mainSeq)]
                if easterEgg == 1 then
                    newSeq = seq[math.random(1, #seq)]
                end
                e:SetSequence( newSeq )
            end
        end
        content.OnCursorExited = function( self )
            local e = mdl:GetEntity()
            e:SetSequence("idle_all_01")
        end
        function mdl:LayoutEntity( ent )
            if ent:GetCycle() >= 1 then
                ent:SetCycle( 0 )
            end
            mdl:RunAnimation()
        end

        local w, h = p:GetSize()

        local btn = vgui.Create( "DButton", p )
        btn:SetSize( w * 0.9, h * 0.08 )
        btn:SetPos( w * 0.05, h * 0.9 )
        btn:SetFont( "F13" )
        btn:SetText( reg.name )
        btn:SetColor( color_white )
        btn.Paint = function( self, w, h )
            surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 200 )
            surface.DrawRect( 0, 0, w, h )
        end

        btn:SetAlpha( 175 )
        btn.Think = function( self )
            local alpha = self:GetAlpha()
            if self:IsHovered() then
                if alpha < 255 then
                    self:SetAlpha( math.Clamp(alpha + ((FrameTime() * 6) * 255), 175, 255) )
                end
            else
                if alpha > 175 then 
                    self:SetAlpha( math.Clamp(alpha - ((FrameTime() * 6) * 255), 175, 255) )
                end
            end
        end

        c:AddPanel( p )
    end


end