Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Inventory = Falcon.UI.Inventory or {}
Falcon.UI.Inventory.GridsData = Falcon.UI.Inventory.GridsData or {}
Falcon.UI.Inventory.GridActive = Falcon.UI.Inventory.GridActive or {}


local f = Falcon.UI.Inventory

Falcon.Inventory = {
    equipped = {
        [1] = "ENHANCED WEAPON",
    },
    backpack = {
        {
            pos = { x = 2, y = 5 },
            item = "ENHANCED WEAPON",
        },
        {
            pos = { x = 6, y = 2 },
            item = "ENHANCED WEAPONS",
        }
    },
}
local shadowOverlay = Color( 0, 0, 0, 195 )
local color_white = Color( 255, 255, 255, 255 )

f.ResetCurrentHovered = function()
    for _, p in pairs( f.GridActive ) do
        p.ShouldHover = false
    end
    f.GridActive = {}
end

f.MoveItem = function( nextPnl, nx, ny )
    local itemID = Falcon.ItemsIdentifier[ Falcon.Inventory.backpack[f.ActiveItem].item ]
    local i = Falcon.Items[ itemID ]
    local it = Falcon.Inventory.backpack[f.ActiveItem]
    local y, x = it.pos.y, it.pos.x

    for runningY = y, (y + i.size.y) - 1 do
        for runningX = x, (x + i.size.x) - 1 do
            local p = Falcon.UI.Inventory.GridsData[runningY][runningX]
            p.item = nil
        end 
    end

    for _, it in pairs( Falcon.Inventory.backpack ) do
        if it.pnl and it.pnl:IsValid() then
            it.pnl:Remove()
        end
    end

    it.pos.x = nx
    it.pos.y = ny

    f.LoadInventoryItems( nextPnl:GetParent() )
end

f.EmulateNextTaken = function( curPnl, x, y )
    f.ResetCurrentHovered()
    local itemID = Falcon.ItemsIdentifier[ Falcon.Inventory.backpack[f.ActiveItem].item ]
    local i = Falcon.Items[ itemID ]

    f.ActiveColor = Color( 0, 155, 0, 125 )
    local disSatisfied = false

    for runningY = y, (y + i.size.y) - 1 do
        for runningX = x, (x + i.size.x) - 1 do
            local yP = Falcon.UI.Inventory.GridsData[runningY]
            if not yP then disSatisfied = true continue end
            local p = yP[runningX]
            if not p or not p:IsValid() then disSatisfied = true continue end
            if p.item and p.item ~= f.ActiveItem then disSatisfied = true continue end
            
            p.ShouldHover = true
            table.insert(f.GridActive, p)
        end 
    end

    if disSatisfied then
        f.ActiveColor = Color( 155, 0, 0, 125 )
    end
end

f.LoadInventoryItems = function( self )
    for itemID, it in pairs( Falcon.Inventory.backpack ) do
        local i = Falcon.Items[Falcon.ItemsIdentifier[it.item]]
        local startPnl = Falcon.UI.Inventory.GridsData[it.pos.y][it.pos.x]

        local y, x = it.pos.y, it.pos.x

        local startPnl
        local endPnl

        for runningY = y, (y + i.size.y) - 1 do
            for runningX = x, (x + i.size.x) - 1 do
                local p = Falcon.UI.Inventory.GridsData[runningY][runningX]

                if runningY == y and runningX == x then
                    startPnl = p
                elseif runningY == (y + i.size.y) - 1 and runningX == (x + i.size.x) - 1 then
                    endPnl = p
                end

                p.item = itemID
            end 
        end

        local sX, sY = startPnl:GetPos()
        local eX, eY = endPnl:GetPos()
        local eW, eH = endPnl:GetSize()

        local covidW, covidH = (eX - sX) + eW, (eY - sY) + eH 
        local p = vgui.Create("DPanel", self)
        p:SetSize( covidW, covidH )
        p:SetPos( sX, sY )
        p.Paint = function( self, w, h )
            surface.SetDrawColor( shadowOverlay )
            surface.DrawRect( 0, 0, w, h )
        end

        local mdl = vgui.Create("DModelPanel", p)
        mdl:SetSize( covidW, covidH )
        mdl:SetModel( i.model.string )
        mdl.LayoutEntity = function( self ) end
        mdl:SetCamPos( i.model.inventory.pos )
        mdl:SetLookAng( i.model.inventory.ang )
        mdl:SetFOV( i.model.inventory.fov ) 

        local btn = vgui.Create("DButton", p)
        btn:SetSize( covidW, covidH )
        btn.Paint = function( self, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawOutlinedRect( 0, 0, w, h )
        end
        btn.DoClick = function( self )
            if f.ActiveItem == itemID then return end
            f.ActiveItem = itemID
            f.ResetCurrentHovered()
        end
        btn.DoRightClick = function( self )
            f.ActiveItem = nil
            f.ResetCurrentHovered()
        end

        p.id = itemID

        it.pnl = p
    end
end

f.LoadGrids = function( self )
    local w, h = self:GetWide(), self:GetTall()
    for y = 1, 20 do
        Falcon.UI.Inventory.GridsData[y] = {}
        for x = 1, 25 do
            local p = vgui.Create("DButton", self)
            p:SetSize( w * 0.0375, w * 0.0375 )
            p:SetPos( h * (0.01 + (0.08625 * (x - 1))), h * (0.01 + (0.086 * (y - 1))) )
            p:SetText("")
            p.Paint = function( self, w, h )
                if self.item then return end
                if f.ActiveItem and self.ShouldHover then
                    surface.SetDrawColor( f.ActiveColor )
                    surface.DrawRect( 0, 0, w, h )
                else
                    surface.SetDrawColor( shadowOverlay )
                    surface.DrawRect( 0, 0, w, h )
                end
            end
            p.OnCursorEntered = function( self )
                if not f.ActiveItem then return end
                f.EmulateNextTaken( self, x, y )
            end
            p.DoRightClick = function( self )
                f.ActiveItem = nil
                f.ResetCurrentHovered()
            end
            p.DoClick = function( self )
                if not f.ActiveItem then return end
                if f.ActiveColor == Color( 155, 0, 0, 125 ) then return end
                f.MoveItem( self, x, y )
                f.ResetCurrentHovered()
                f.ActiveItem = nil
            end
            Falcon.UI.Inventory.GridsData[y][x] = p
        end
    end
end

f.OpenInventoryGrid = function( parent )
    local w, h = parent:GetWide(), parent:GetTall()
    local p = vgui.Create( "DPanel", parent )
    p:SetSize( w * 0.86, h * 0.65 )
    p:SetPos( w * 0.14, h * 0.35 )
    p.Paint = function( self, w, h )
        surface.SetDrawColor( shadowOverlay )
        surface.DrawRect( 0, 0, w, h )
    end

    local cP = vgui.Create("DScrollPanel", p)
    cP:SetSize( p:GetWide(), p:GetTall() * 0.99 )


    f.GridActive = {}
    f.ActiveItem = nil

    f.LoadGrids( cP )
    f.LoadInventoryItems( cP )
end