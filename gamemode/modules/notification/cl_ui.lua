Falcon = Falcon or {}
local function inQuad(fraction, beginning, change)
	return change * (fraction ^ 2) + beginning
end

Falcon.CreateNotification = function( parent, title, message )
    local parent = parent or nil
    local scrw, scrh = ScrW(), ScrH()
    local frame = vgui.Create("DFrame", parent)
    frame:SetSize( scrw * 0.15, scrh * 0.13 )
    frame:SetPos( 0 - (scrw * 0.16), scrh * 0.125 )
    frame:SetDraggable( false )
    frame:ShowCloseButton( false )
    frame:SetTitle( "" )
    frame.Paint = function( self, w, h )
        local rainbow = HSVToColor(  ( CurTime() * 200 ) % 360, 1, 1 )
        surface.SetDrawColor( 0, 0, 0, 215 )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( rainbow )
        surface.DrawOutlinedRect( 0, 0, w, h )
        draw.DrawText( title, "F7", w * 0.5, h * 0.1, rainbow, TEXT_ALIGN_CENTER )
    end

    local Description = vgui.Create("DLabel", frame)
    Description:SetSize( frame:GetWide() * 0.8, frame:GetTall() * 0.7 )
    Description:SetPos( frame:GetWide() * 0.1, frame:GetTall() * 0.2 )
    Description:SetWrap( true )
    Description:SetText( message )
    Description:SetContentAlignment( 5 )
    Description:SetFont("F6")

    local goforward = Derma_Anim("EaseInQuad", frame, function(pnl, anim, delta, data)
        pnl:SetPos(inQuad(delta, 0 - (scrw * 0.17), scrw * 0.18), scrh * 0.125) -- Change the X coordinate from 200 to 200+600
    end)
    local goback = Derma_Anim("EaseInQuad", frame, function(pnl, anim, delta, data)
        pnl:SetPos(inQuad(delta, scrw * 0.01, 0 - (scrw * 0.18) ), scrh * 0.125) -- Change the X coordinate from 200 to 200+600
    end)

    goforward:Start( 1 )
    timer.Simple( 7, function()
        goback:Start( 1 )
        timer.Simple( 1.1, function()
            frame:Remove()
        end)
    end)
    frame.Think = function( self )
        if goforward:Active() then
            goforward:Run()
        elseif goback:Active() then
            goback:Run()
        end
    end
end