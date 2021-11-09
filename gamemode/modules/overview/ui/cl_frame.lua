Falcon = Falcon or {}
Falcon.Overview = Falcon.Overview or {}

local f = Falcon.Overview
local navBtns = { 
    {name = "Regiments", 
    click=function(pnl) 
        f.OpenRegimentInfo( pnl )
    end},
    {name = "Classes", 
    click=function(pnl) 
    end},
}

f.OpenNavigation = function( content, contentRelatedPnl )
    local wC, hC = content:GetWide(), content:GetTall()
    local nav = vgui.Create( "DPanel", content )
    nav:SetSize( wC * 1, hC * 0.055 )
    nav:SetPos( 0, hC * 0.0 )
    nav.Paint = nil
    Falcon.UI.Presets.Buttons.CreateHorizontalButtons( nav, {
        w = 0.1,
        h = 0.4,
        font = "F13",
        dock = LEFT,
        fade = true,
        shouldStart = 1,
        click = function()
            contentRelatedPnl:Clear()
        end
    }, navBtns, contentRelatedPnl )
end
f.OpenContent = function( content )
    local wC, hC = content:GetWide(), content:GetTall()
    local c = vgui.Create( "DPanel", content )
    c:SetSize( wC * 0.95, hC * 0.875 )
    c:SetPos( wC * 0.025, hC * 0.09 )
    c.Paint = nil

    return c
end
f.OpenOverviewFrame = function()
    local content, fr = Falcon.UI.Presets.Frames.CreateBaseFrame( 0.6, 0.5, 0, 0, {
        shouldAnimate = true,
        text = "REGIMENTS",
    } )
    fr:Center()

    Falcon.UI.Presets.Buttons.ExitButton( fr )

    local c = f.OpenContent( content )
    f.OpenNavigation( content, c )
end

net.Receive("FALCON:OPEN:F4MENU", function()
    f.OpenOverviewFrame()
end)