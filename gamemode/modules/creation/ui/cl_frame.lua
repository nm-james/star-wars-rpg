Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Creation = Falcon.UI.Creation or {}
local scrw, scrh = ScrW(), ScrH()

local color_black = Color( 0, 0, 0 )
local f = Falcon.UI.Creation

local navBtns = { 
    {name = "Ranks", 
    click=function(pnl) 
        f.OpenRanksEditor( pnl )
    end},
    {name = "Regiments", 
    click=function(pnl) 
        f.OpenRegimentEditor( pnl ) 
    end},
    {name = "Classes", 
    click=function(pnl) 
        f.OpenClassesEditor( pnl )
    end},
    {name = "Items", 
    click=function(pnl) 
        f.LoadItemCreation( pnl )
    end},
    {name = "Models", 
    click=function(pnl) 
        print("ABILITIES") 
    end},
}
f.OpenNavigation = function( content, contentRelatedPnl )
    local wC, hC = content:GetWide(), content:GetTall()
    local nav = vgui.Create( "DPanel", content )
    nav:SetSize( wC * 0.95, hC * 0.055 )
    nav:SetPos( wC * 0.025, hC * 0.025 )
    nav.Paint = nil
    Falcon.UI.Presets.Buttons.CreateHorizontalButtons( nav, {
        w = 0.175,
        h = 0.4,
        font = "F17",
        dock = LEFT,
        fade = true,
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
f.OpenFrame = function()
    local content, fr = Falcon.UI.Presets.Frames.CreateBaseFrame( 1, 1, 0, 0, {
        shouldAnimate = true,
        text = "CREATION MENU",
    } )

    Falcon.UI.Presets.Buttons.ExitButton( fr )

    local c = f.OpenContent( content )
    f.OpenNavigation( content, c )
end

concommand.Add("OPEN_CREATION", function()
    f.OpenFrame()
end)