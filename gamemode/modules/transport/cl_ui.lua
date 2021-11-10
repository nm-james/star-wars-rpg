Falcon = Falcon or {}
Falcon.User = Falcon.User or {}
Falcon.User.Quests = Falcon.User.Quests or {}
Falcon.User.Quests.Completed = Falcon.User.Quests.Completed or {}



local transport = {}
local padlockIcon = Material("f_coop/padlock.png")
local blur = Material( "pp/blurscreen" )

local function CreateBlackScreen( newPlanet )
    local nextDrop = transport.NextPlanet

    local f = vgui.Create("DFrame")
    f:SetSize( ScrW(), ScrH() )
    f:Center()
    f.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 255 )
        surface.DrawRect( 0, 0, w, h )
    end
    f.Think = function( self )
        if self.ShouldFade then
            f:SetAlpha( math.Clamp(self:GetAlpha() - ((FrameTime() * 4) * 255), 0, 255) )
            if self:GetAlpha() <= 0 then
                self:Close()
                Falcon.HasNPCSpeaking = false
            end
        end
    end

    net.Start("FALCON:TRANSPORT:TELEPORT")
        net.WriteUInt( transport.ActiveTransport.Dropzone, 32 )
        net.WriteString( newPlanet )
        net.WriteUInt( nextDrop, 32 )
    net.SendToServer()

    transport.NextPlanet = nil
    
    timer.Simple(2, function()
        f.ShouldFade = true
    end)
end

local function CreateDropzoneButtons( data, parent )
    local ply = LocalPlayer()
    local w, h = parent:GetWide(), parent:GetTall()
    local dropZones = table.Count( data ) / 10

    local i = 1
    for _, drp in pairs( data ) do
        local v = drp.VGUI or {}

        local p = vgui.Create("DPanel", parent)
        p:SetSize( w * 0.22025, h )
        p:Dock( LEFT )
        local lMargin = 0
        if i ~= 1 then
            lMargin = w * ((1 / dropZones) / 500)
        end
        p:DockMargin( lMargin, 0, 0, 0 )
        p.Paint = nil

        

        local img = vgui.Create("DImage", p)
        img:Dock( FILL )
        img:SetKeepAspect( true )
        img:SetImage(drp.Wallpaper)
        -- p:SetPos( w * (v.x or 0.3), w * (v.y or 0.3) )
        local req = drp.Requirement()

        local btn = vgui.Create("DButton", p)
        btn:Dock( FILL )
        btn:SetText( "" )
        btn.Alpha = 0

        local text = "QUESTS: "
        local questsColor = Color( 255, 155, 155 )
        local lvlColor = Color( 255, 87, 87 )
        local requirements = drp.Requirements

        if req then
            btn.OnCursorEntered = function( self )
                if transport.ActiveNextPosPnl then return end
                p:SizeTo( w * 0.325, h, 0.25, 0, -1 )
                self.IsAnimating = true
            end
            btn.OnCursorExited = function( self )
                if transport.ActiveNextPosPnl == p then return end
                p:SizeTo( w * 0.22025, h, 0.125, 0, -1 )
            end
            btn.DoClick = function( self )
                transport.ActiveNextPosPnl = p
                p:SizeTo( w * 0.325, h, 0.25, 0, -1 )
                transport.NextPlanet = _
            end 
            btn.Think = function( self )
                if not self:IsHovered() and (not transport.ActiveNextPosPnl or transport.ActiveNextPosPnl ~= p) then
                    p:SizeTo( w * 0.22025, h, 0.125, 0, -1 )
                elseif (self:IsHovered() and not transport.ActiveNextPosPnl) or transport.ActiveNextPosPnl == p then
                    self.Alpha = math.Clamp( self.Alpha + ((FrameTime() * 5) * 255), 0, 185)
                    return
                end
                self.Alpha = math.Clamp( self.Alpha - ((FrameTime() * 5) * 255), 0, 185)
            end
        else
            local completed = Falcon.User.Quests.Completed

            local i = 0
            local amountCompleted = 0
            for _, quest in pairs( requirements.Quests ) do
                if completed[quest] then
                    amountCompleted = amountCompleted + 1
                end

                if i >= 2 then continue end

                if text ~= "QUESTS: " then
                    text = text .. ", " .. string.upper(quest)
                else
                    text = text .. string.upper(quest)
                end
                i = i + 1
            end

            if i < table.Count( requirements.Quests ) then
                text = text .. " AND MORE..."
            end

            if text == "QUESTS: " then
                text = ""
            end

            if amountCompleted == #requirements.Quests then
                questsColor = Color( 177, 177, 177 )
            end

            if ply:GetLevel() >= requirements.Level then
                lvlColor = Color( 242, 242, 242 )
            end
        end

        btn.Paint = function( self, w, h )
            if req then
                surface.SetDrawColor( 0, 0, 0, 155 )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( 0, 0, 0, self.Alpha )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( 225, 225, 225, (self.Alpha * 1.25) )
                surface.DrawRect( 0, h * 0.625, w, h * 0.375 )

                draw.DrawText( drp.Name, "F33", w * 0.5, h * 0.25, Color( 240, 240, 240 ), TEXT_ALIGN_CENTER )
                draw.DrawText( "Level Recommended: " .. drp.Recommendation .. "+", "F20", w * 0.5, h * 0.65, Color( 25, 25, 25, self.Alpha * 1.75 ), TEXT_ALIGN_CENTER )

            else
                surface.SetDrawColor( 45, 45, 45, 255 )
                surface.DrawRect( 0, 0, w, h )

                surface.SetDrawColor( Color( 255, 87, 87 ) )
                surface.SetMaterial( padlockIcon )
                surface.DrawTexturedRect( w * 0.275, h * 0.175, w * 0.5, w * 0.5 )

                draw.DrawText( "LEVEL " .. tostring(requirements.Level), "F15", w * 0.5, h * 0.555, lvlColor, TEXT_ALIGN_CENTER )
                draw.DrawText( text, "F11", w * 0.5, h * 0.62, questsColor, TEXT_ALIGN_CENTER )
            end

            surface.SetDrawColor( 0, 0, 0, 185 )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end

        i = i + 1
    end


end

local function CreateDropzonesFrame( planet, planetID )
    if transport.Frame and transport.Frame:IsValid() then return end
    transport.NextPlanet = false
    transport.ActiveNextPosPnl = false
    
    local f = vgui.Create("DFrame")
    f:SetSize( ScrW(), ScrH() )
    f:ShowCloseButton( false )
    f:Center()
    f.Paint = nil
    
    local mainF = vgui.Create("DImage", f)
    mainF:SetSize( f:GetWide(), f:GetTall() )
    mainF:SetKeepAspect( true )
    mainF:SetImage( planet.VGUI.wallpaper )
    
    local blurPnl = vgui.Create("DPanel", mainF)
    blurPnl:Dock( FILL )
    blurPnl.Paint = function( self, w, h )
        draw.RoundedBox( 0, 0, 0, w, h, Color( 0, 0, 0, 195 ))
        surface.SetDrawColor( 255, 255, 255, alpha )
	    surface.SetMaterial( blur )

        for i = 1, 8 do
	        blur:SetFloat( "$blur", ( i / 4 ) * 4 )
	        blur:Recompute()

	        render.UpdateScreenEffectTexture()
	        surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
	    end

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawLine( w * 0.125, h * 0.195, w * 0.875, h * 0.195 )
        draw.DrawText( planet.Name, "F33", w * 0.125, h * 0.13, Color( 240, 240, 240 ), TEXT_ALIGN_LEFT )
        draw.DrawText( "YASDGDHSDHSDHSDHDSHFJHDFSDHGSDHSD", "F16", w * 0.1275, h * 0.1875, Color( 180, 180, 180 ), TEXT_ALIGN_LEFT )

    end

    local exit = vgui.Create("DButton", f)
    exit:SetSize( f:GetWide() * 0.025, f:GetTall() * 0.025 )
    exit:SetPos( f:GetWide() * 0.975, f:GetTall() * 0.004 )
    exit:SetFont( "F15" )
    exit:SetText( "X" )
    exit:SetColor( Color( 255, 255, 255 ) )
    exit.Paint = nil
    exit.DoClick = function( self )
        f:Close()
        Falcon.HasNPCSpeaking = false
    end

    transport.Frame = f
    local dockPnl = vgui.Create("DPanel", f)
    dockPnl:SetSize( f:GetWide() * 0.75, f:GetTall() * 0.44 )
    dockPnl:SetPos( f:GetWide() * 0.125, f:GetTall() * 0.25 )
    dockPnl.Paint = nil

    CreateDropzoneButtons( planet.Dropzones, dockPnl )

    local nextBtn = vgui.Create("DButton", f)
    nextBtn:SetSize( f:GetWide() * 0.75, f:GetTall() * 0.04 )
    nextBtn:SetPos( f:GetWide() * 0.125, f:GetTall() * 0.725 )
    nextBtn:SetText( "" )
    nextBtn.Paint = function( self, w, h )
        if not transport.NextPlanet then return end
        surface.SetDrawColor( self.CurColor )
        surface.DrawOutlinedRect( 0, 0, w, h )

        if self.SettingUpNextPlanet then
            surface.DrawRect( w * 0.002, w * 0.002, w * 0.997 * ((CurTime() - self.SettingUpNextPlanet) / 2), h - ((w * 0.0015) * 2) )
        end


        draw.SimpleTextOutlined(self.SimpleText or "", "F14", w * 0.5, h * 0.06, self.CurColor, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
    end
    nextBtn.Think = function( self, w, h )
        if not transport.NextPlanet then return end
        local palyerrysast = player.GetAll()
        local nextPlys = 0
        for _, p in pairs( palyerrysast ) do
            if p:GetPos():DistToSqr( transport.ActiveTransport:GetPos() ) < 250000 then
                nextPlys = nextPlys + 1
            end
        end

        if nextPlys < #palyerrysast then
            self.CurColor = Color( 175, 55, 55, 255 )
            self.SimpleText = "Your Squad is not Close Enough to use Transport"
        else
            self.CurColor = Color( 240, 240, 240, 255 )
            self.SimpleText = "Hold to Transport to " .. planet.Dropzones[transport.NextPlanet].Name
        end

        if input.IsMouseDown(MOUSE_LEFT) and self:IsHovered() and nextPlys >= #palyerrysast then
            if not self.SettingUpNextPlanet then
                self.SettingUpNextPlanet = CurTime()
            elseif self.SettingUpNextPlanet + 2 <= CurTime() then
                self.SettingUpNextPlanet = false

                FadeFrame( function()
                    return CreateBlackScreen( planetID )
                end, transport.Frame )                
            end
        else
            self.SettingUpNextPlanet = false
        end
    end


    return f
end

local function CreatePlanetButton( planet, planetID )
    local parent = transport.Frame
    local w, h = parent:GetWide(), parent:GetTall()

    local vguiData = planet.VGUI
    local p = vgui.Create("DPanel", parent)
    p:SetSize( w * (vguiData.w or 0.15), w * (vguiData.h or 0.15) )
    p:SetPos( w * (vguiData.x or 0.3), w * (vguiData.y or 0.3) )
    p.OuterRingColor = Color( 255, 255, 255, 255 )
    p.Paint = function( self, w, h )
        draw.NoTexture()
        surface.SetDrawColor( 255, 255, 255, 15 )
        draw.Circle( w * 0.5, h * 0.5, w * 0.5, 360 )

        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.5, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.4995, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.499, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.4985, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.498, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.4975, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.497, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.4965, self.OuterRingColor )
        surface.DrawCircle( w * 0.5, h * 0.5, w * 0.496, self.OuterRingColor )
    end

    local mdl = vgui.Create("DModelPanel", p)
    mdl:Dock(FILL)
    mdl:SetModel( "models/immigrant/starwars/planet.mdl" )
    mdl:SetLookAt( Vector( 0, 0, 0 ) )
    mdl:SetCamPos( Vector( 45, 45, 45 ) )
    mdl:SetFOV( 62 )
    local ent = mdl:GetEntity()
    ent:SetSkin(vguiData.skin or 0)

    local ply = LocalPlayer()
    local req = planet.Requirement( ply )

    local stuffBtn = vgui.Create("DButton", p)
    stuffBtn:SetAlpha( 0 )
    stuffBtn:SetText("")
    stuffBtn:Dock(FILL)
    stuffBtn.Think = function( self )
        if self:IsHovered() then
            mdl:SetFOV( math.Clamp(mdl:GetFOV() - (FrameTime() * 65), 52, 62) )
            self:SetAlpha( math.Clamp(self:GetAlpha() + ((FrameTime() * 9) * 255), 0, 255) )
            if not req then
                p.OuterRingColor = Color( 255, 87, 87 )
            end
        else
            mdl:SetFOV( math.Clamp(mdl:GetFOV() + (FrameTime() * 65), 52, 62) )
            self:SetAlpha( math.Clamp(self:GetAlpha() - ((FrameTime() * 9) * 255), 0, 255) )

            if p.OuterRingColor == Color( 255, 87, 87 ) then
                p.OuterRingColor = Color( 255, 255, 255 )
            end
            
        end
    end

    stuffBtn.DoClick = function( self )
        if req then
            FadeFrame( function()
                return CreateDropzonesFrame( planet, planetID )
            end, transport.Frame )
        end
    end


    if req then
        stuffBtn.Paint = function( self, w, h )
            surface.SetDrawColor( 0, 0, 0, 195 )
            draw.Circle( w * 0.5, h * 0.5, w * 0.5, 360 )

            surface.SetDrawColor( 0, 0, 0, 200 )
            surface.DrawRect( w * 0.0025, h * 0.4, w * 0.9975, h * 0.2 )
            surface.SetDrawColor( 255, 255, 255, 255 )
            surface.DrawLine( w * 0.01, h * 0.4, w * 0.99, h * 0.4 )
            surface.DrawLine( w * 0.01, h * 0.6, w * 0.99, h * 0.6 )

            draw.DrawText( planet.Name, "F23", w * 0.5, h * 0.375, Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER )
            draw.DrawText( planet.Description, "F11", w * 0.5, h * 0.51, Color( 180, 180, 180, 255 ), TEXT_ALIGN_CENTER )
        end
    else
        local text = "QUESTS: "
        local completed = Falcon.User.Quests.Completed
        local requirements = planet.Requirements

        local i = 0
        local amountCompleted = 0
        for _, quest in pairs( requirements.Quests ) do
            if completed[quest] then
                amountCompleted = amountCompleted + 1
            end

            if i >= 2 then continue end

            if text ~= "QUESTS: " then
                text = text .. ", " .. string.upper(quest)
            else
                text = text .. string.upper(quest)
            end
            i = i + 1
        end

        if i < table.Count( requirements.Quests ) then
            text = text .. " AND MORE..."
        end

        if text == "QUESTS: " then
            text = ""
        end

        local questsColor = Color( 255, 155, 155 )
        if amountCompleted == #requirements.Quests then
            questsColor = Color( 177, 177, 177 )
        end

        local lvlColor = Color( 255, 87, 87 )
        if ply:GetLevel() >= requirements.Level then
            lvlColor = Color( 242, 242, 242 )
        end

        stuffBtn.Paint = function( self, w, h )
            draw.NoTexture()
            surface.SetDrawColor( 0, 0, 0, 245 )
            draw.Circle( w * 0.5, h * 0.5, w * 0.4925, 360 )

            surface.SetDrawColor( Color( 255, 87, 87 ) )
            surface.SetMaterial( padlockIcon )
            surface.DrawTexturedRect( w * 0.335, w * 0.2, w * 0.35, w * 0.35 )

            draw.DrawText( "LEVEL " .. tostring(requirements.Level) .. "+", "F15", w * 0.5, h * 0.54, lvlColor, TEXT_ALIGN_CENTER )
            draw.DrawText( text, "F11", w * 0.5, h * 0.62, questsColor, TEXT_ALIGN_CENTER )
        end
    end
    return p
end

local function UI()
    local f = transport.Frame

    for _, d in pairs( Falcon.Transports ) do
        CreatePlanetButton( d, _ )
    end
end

function OpenNavigation( cent )
    if transport.Frame and transport.Frame:IsValid() then return end
    transport.ActiveTransport = false

    local f = vgui.Create("DFrame")
    f:SetSize( ScrW(), ScrH() )
    f:ShowCloseButton( false )
    f:Center()
    f.Paint = nil
    
    local mainF = vgui.Create("DImage", f)
    mainF:SetSize( f:GetWide(), f:GetTall() )
    mainF:SetKeepAspect( true )
    mainF:SetImage( "materials/f_coop/navigation/navigation.jpg" )

    local exit = vgui.Create("DButton", f)
    exit:SetSize( f:GetWide() * 0.025, f:GetTall() * 0.025 )
    exit:SetPos( f:GetWide() * 0.975, f:GetTall() * 0.004 )
    exit:SetFont( "F15" )
    exit:SetText( "X" )
    exit:SetColor( Color( 255, 255, 255 ) )
    exit.Paint = nil
    exit.DoClick = function( self )
        f:Close()
        Falcon.HasNPCSpeaking = false
    end

    transport.Frame = f
    transport.ActiveTransport = cent

    UI()

    return f
end