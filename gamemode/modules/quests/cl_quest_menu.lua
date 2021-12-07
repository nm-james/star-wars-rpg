Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Quests = Falcon.UI.Quests or {}

local fq = Falcon.UI.Quests
local color_white = Color( 255, 255, 255, 255 )
local color_grey = Color( 115, 115, 115, 255 )
local color_shadow = Color( 30, 30, 30, 195 )
local color_shadow2 = Color( 45, 45, 45, 115 )

fq.OpenActive = function( content )
    local pnlActiveContent, pnlActive = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( content, 1, 0.3, 0, 0, {
        text = "FOCUSED QUEST"
    } )
    pnlActive:Dock( TOP )

    if Falcon.FocusedQuest > 0 then
        local q = Falcon.Quests[Falcon.FocusedQuest]
        local w, h = pnlActiveContent:GetWide(), pnlActiveContent:GetTall()
        local titlePnl = vgui.Create("DPanel", pnlActiveContent)
        titlePnl:SetSize( w, h * 0.2 )
        titlePnl:Dock( TOP )
        titlePnl.Paint = function( self, w, h )
            surface.SetDrawColor( color_shadow )
            surface.DrawRect( 0, 0, w, h )
            draw.DrawText( q.Name, "F15", w * 0.025, h * 0, color_white, TEXT_ALIGN_LEFT )
        end

        local objectivePnl = vgui.Create("DScrollPanel", pnlActiveContent)
        objectivePnl:SetSize( w, h * 0.8 )
        objectivePnl:Dock( TOP )
        local w, h = objectivePnl:GetWide(), objectivePnl:GetTall()
        
        for _, ob in pairs( q.Objectives ) do
            local isComplete = false
            if ob.Value == ob.Needed then
                isComplete = true
            end

            local objective = vgui.Create("DPanel", objectivePnl)
            objective:SetSize( w, h * 0.175 )
            objective:Dock( TOP )
            objective.Paint = function( self, w, h )
                surface.SetDrawColor( color_shadow2 )
                surface.DrawRect( 0, 0, w, h )

                local color = color_white
                local font = "F10"
                if isComplete then
                    color = color_grey
                end
                local text = ob.Text or ""
                draw.DrawText( "-> " .. text, font, w * 0.025, h * 0.04, color, TEXT_ALIGN_LEFT )

                local t = type(ob.Needed)
                if t == "number" then
                    draw.DrawText( "[" .. ob.Value .. "/" .. ob.Needed .. "]", font, w * 0.97, h * 0.04, color, TEXT_ALIGN_RIGHT )
                end
                if isComplete then
                    surface.SetDrawColor( color_white )
                    surface.DrawLine( w * 0.025, h * 0.5, w * 0.975, h * 0.5 )
                end
            end

            if not isComplete then
                break
            else
                local speakTo = vgui.Create("DPanel", objectivePnl)
                speakTo:SetSize( w, h * 0.175 )
                speakTo:Dock( TOP )
                speakTo.Paint = function( self, w, h )
                    surface.SetDrawColor( color_shadow2 )
                    surface.DrawRect( 0, 0, w, h )

                    draw.DrawText( "", font, w * 0.025, h * 0.04, color_white, TEXT_ALIGN_LEFT )
                end
            end 
        end
    else
        local w, h = pnlActiveContent:GetWide(), pnlActiveContent:GetTall()
        local noObj = vgui.Create("DPanel", pnlActiveContent)
        noObj:SetSize( w, h )
        noObj:Dock( TOP )
        noObj.Paint = function( self, w, h )
            draw.DrawText( "NO QUEST IS CURRENTLY FOCUSED", "F22", w * 0.5, h * 0.275, color_white, TEXT_ALIGN_CENTER )
        end
    end 

    local pnlAvailableContent, pnlAvailable = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( content, 1, 0.7, 0, 0, {
        text = "OTHER ACTIVE QUEST"
    } )
    pnlAvailable:Dock( TOP )

    local ply = LocalPlayer()
    local w, h = pnlAvailableContent:GetWide(), pnlAvailableContent:GetTall()
    for id, status in pairs( Falcon.Player.Quests ) do
        if Falcon.Player.CompletedQuests[id] then continue end
        if Falcon.FocusedQuest == id then continue end
        local q = Falcon.Quests[id]
        local req = q.Requirement( ply )
        if not req then continue end
        if not Falcon.Player.Quests[id] then continue end
        local objective = vgui.Create("DPanel", pnlAvailableContent)
        objective:SetSize( w, h * 0.125 )
        objective:Dock( TOP )

        local object
        for _, obj in pairs( q.Objectives ) do
            if obj.Value == obj.Needed then continue end
            object = obj
            break
        end
        objective.Paint = function( self, w, h )
            surface.SetDrawColor( color_shadow2 )
            surface.DrawRect( 0, 0, w, h )

            draw.DrawText( q.Name, "F15", w * 0.025, h * 0.04, color_white, TEXT_ALIGN_LEFT )

            local text = object.Text or ""
            draw.DrawText( text, "F10", w * 0.025, h * 0.5, color_grey, TEXT_ALIGN_LEFT )

            local t = type(object.Needed)
            if t == "number" then
                draw.DrawText( "[" .. object.Value .. "/" .. object.Needed .. "]", "F9", w * 0.97, h * 0.52, color_grey, TEXT_ALIGN_RIGHT )
            end

        end
    end

end
fq.OpenAdditional = function( content )
    local ply = LocalPlayer()
    local pnlActiveContent, pnlActive = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( content, 1, 0.35, 0, 0, {
        text = "AVAILABLE QUESTS"
    } )
    pnlActive:Dock( TOP )
    local w, h = pnlActiveContent:GetWide(), pnlActiveContent:GetTall()

    for id, quest in pairs( Falcon.Quests ) do
        local req = quest.Requirement( ply )
        if not req then continue end
        if Falcon.ActiveQuests[ id ] then continue end
        if Falcon.Player.CompletedQuests[ id ] then continue end

        local titlePnl = vgui.Create("DPanel", pnlActiveContent)
        titlePnl:SetSize( w, h * 0.175 )
        titlePnl:Dock( TOP )
        titlePnl.Paint = function( self, w, h )
            surface.SetDrawColor( color_shadow )
            surface.DrawRect( 0, 0, w, h )
            draw.DrawText( quest.Name, "F15", w * 0.025, h * 0.025, color_white, TEXT_ALIGN_LEFT )
        end
    end 

    local pnlAvailableContent, pnlAvailable = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( content, 1, 0.65, 0, 0, {
        text = "UNAVAILABLE QUESTS"
    } )
    pnlAvailable:Dock( TOP )
end

local navBtns = { 
    {name = "PROGRESSIVE QUESTS", 
    click=function(pnl) 
        fq.OpenActive( pnl )
    end},
    {name = "AVAILABLE/OTHER QUESTS", 
    click=function(pnl) 
        fq.OpenAdditional( pnl )
    end},
}
fq.OpenNavigation = function( content, startWhat )
    local w, h = content:GetWide(), content:GetTall()
    local pnlNav = vgui.Create("DPanel", content)
    pnlNav:SetSize( w, h * 0.05 )
    pnlNav:Dock( TOP )
    pnlNav.Paint = nil

    local otherPnl = vgui.Create("DScrollPanel", content)
    otherPnl:SetSize( w, h * 0.95 )
    otherPnl:Dock( TOP )

    Falcon.UI.Presets.Buttons.CreateHorizontalButtons( pnlNav, {
        w = 0.5,
        h = 1,
        font = "F10",
        dock = LEFT,
        fade = true,
        shouldStart = startWhat or 1,
        click = function()
            otherPnl:Clear()
        end
    }, navBtns, otherPnl )

end
fq.OpenFrame = function()
    if fq.Content and fq.Content:IsValid() then return end
    local content, f = Falcon.UI.Presets.Frames.CreateBaseFrame(  0.25, 0.8, 0.025, 0.1, {
        shouldAnimate = true,
        text = "QUESTS",
    } )
    fq.Content = content
    fq.OpenNavigation( content, 1 )
    Falcon.UI.Presets.Buttons.ExitButton( f )
end 