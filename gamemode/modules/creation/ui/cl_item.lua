Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Creation = Falcon.UI.Creation or {}
local f = Falcon.UI.Creation

-- COLORS
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

local scrw, scrh = ScrW(), ScrH()
f.OpenItemDetails = function( contentPnl )
    
end

local types = { "COSMETIC", "WEAPON", "ABILITY" }
f.CreateNewItem = function( parent )
    local fr, ex = Falcon.UI.Presets.Frames.CreateOverlayFrame( 0.2, 0.2, 0.4, 0.375, parent:GetParent(), { text = "CREATE A NEW REGIMENT", shouldAnimate = true, animSpeed = 10 } )
    local newItemName = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.9, 0.175, 0.05, 0.175 )
    local itemType = Falcon.UI.Presets.ComboBoxes.CreateComboBox( fr, types, 0.9, 0.175, 0.05, 0.415, { text = "COSMETIC", font = "F14" } )

    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( fr, function( self )
        if not newItemName or newItemName:GetValue() == "" then return false end 
        if not itemType or itemType:GetValue() == "" then return false end 

        return true
    end, 0.9, 0.175, 0.05, 0.65, { text = "CREATE", click = function( self )
        local namae = newItemName:GetValue()
        local itemType = itemType:GetValue()

        net.Start("FALCON:ITEMS:CREATE")
            net.WriteString( namae )
            net.WriteString( itemType )
        net.SendToServer()

        ex.DoClick( ex )
        local count = table.Count( Falcon.Items )
        parent:Clear()
        timer.Simple(0.2, function()
            if parent and parent:IsValid() then
                f.LoadItemCreation( parent )
            end
        end)
    end } )
end

f.LoadItemDetails = function( parent, item )

end

f.LoadItemsInPanel = function( scroll, it )
    local dullPnl = vgui.Create("DPanel", scroll)
    dullPnl:SetSize( scroll:GetWide(), scroll:GetTall() * 0.05 )
    dullPnl:Dock( TOP )
    dullPnl.Paint = nil

    for id, item in pairs( Falcon.Items ) do
        local b = Falcon.UI.Presets.Buttons.CreateCategoricalButton( scroll, 0.9, 0.075, 0, 0, { text = item.name, fade = true, font = "F18", paint = function( self, w, h )
            surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end, click = function( self )
            f.LoadItemDetails( )
        end } )
        b:Dock( TOP )

        local w, h = b:GetWide(), b:GetTall()
        local removeBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( b, function( self )
            if b:IsHovered() or self:IsHovered() then
                return true
            end
            return false
        end, h / w, 1, 0, 0, { baseAlpha = 0, text = "REMOVE", click = function( self )
        end } )
        removeBtn:Dock( RIGHT )

        if regimentID and regimentID == id then
            b.DoClick( b )
        end
    end

    local e = Falcon.UI.Presets.Entry.CreateUpdatedOnTypeEntry( it, function( self )

    end, 1, 0.05, 0, 0)
    e:SetPos( 0, scrh * 0.0225 )
end

f.LoadItemCreation = function( parent )
    parent:Clear()

    local items, t, banner = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( parent, 0.3, 0.99, 0, 0.01, { text = "CURRENT ITEMS"} )
    local addItems = Falcon.UI.Presets.Buttons.TextButton( banner, 0.02, 1, 0.93, 0, { text = "+", font = "F18", 
        click = function( self ) 
            f.CreateNewItem( parent )
        end 
    } )
    local bW, bH = banner:GetWide(), banner:GetTall()
    addItems:SetSize( bH, bH )
    addItems:SetPos( bW - bH, 0 )
    f.LoadItemsInPanel( items, t )

    local itemDetails, t, banner = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.69, 0.99, 0.31, 0.01, { text = "ITEM PREVIEW"} )

end