Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Inventory = Falcon.UI.Inventory or {}
local f = Falcon.UI.Inventory

local shadowOverlay = Color( 0, 0, 0, 195 )
local color_white = Color( 255, 255, 255, 255 )
local color_black = Color( 0, 0, 0, 255 )
local color_green = Color( 0, 155, 0, 125 )
local color_yellow = Color( 200, 200, 25 )
f.OpenPlayerSlots = function( content )
    local w, h = content:GetWide(), content:GetTall()
    for i = 1, 4 do
        local invI = i + 6

        local p = vgui.Create("DPanel", content) 
        p:SetSize( w * 0.9, w * 0.9 )
        p:SetPos( w * 0.05, h * (0.05 + ((i-1) * 0.225)) )
        p.Paint = nil

        local w, h = p:GetWide(), p:GetTall()

        local invItem = Falcon.Inventory.equipped[invI]
        if invItem and invItem ~= "" then 
            local itemId = Falcon.ItemsIdentifier[invItem]
            local i = Falcon.Items[itemId]
            local mdl = vgui.Create("DModelPanel", p)
            mdl:SetSize( w, h )
            mdl:SetModel( i.model.string )
            mdl.LayoutEntity = function( self ) end
            mdl:SetCamPos( i.model.inventory.pos )
            mdl:SetLookAng( i.model.inventory.ang )
            mdl:SetFOV( i.model.inventory.fov )
        end

        local btn = vgui.Create("DButton", p)
        btn:SetSize( w, h )
        btn.Paint = function( self, w, h )
            local color = color_white
            if f.ActiveCategory == invI then
                if not f.EquipedItem and not Falcon.Inventory.equipped[invI] then
                    color = color_green
                elseif f.EquipedItem then
                    color = color_yellow
                end
            end
            surface.DrawBorderedRect( 0, 0, w, h, shadowOverlay, color )
        end 
        if invItem and invItem ~= "" then
            local itemId = Falcon.ItemsIdentifier[invItem]
            local item = Falcon.Items[itemId]

            btn.DoClick = function( self )
                f.ActiveItem = invI
                f.ActiveCategory = invI
                f.EquipedItem = true
                f.ResetCurrentHovered()
            end
            btn.DoRightClick = function( self )
                f.ActiveItem = nil
                f.ActiveCategory = nil
                f.EquipedItem = false
                f.ResetCurrentHovered()
            end 
            btn.Paint = function( self, w, h )
                local color = Falcon.ItemsRarities.Colors[item.rarity]
                if f.ActiveCategory == invI then
                    if not f.EquipedItem and not Falcon.Inventory.equipped[invI] then
                        color = color_green
                    elseif f.EquipedItem then
                        color = color_yellow
                    end
                end
                surface.DrawBorderedRect( 0, 0, w, h, shadowOverlay, color )
            end 
        else
            btn.DoClick = function( self )
                if f.ActiveCategory ~= invI then return end
                local b = Falcon.Inventory.backpack[f.ActiveItem].item
                local itemIDDD = Falcon.ItemsIdentifier[b]
                local item = Falcon.Items[itemIDDD]

                net.Start("FALCON:INVENTORY:ADDTOEQUIP")
                    net.WriteInt( f.ActiveItem, 32 )
                    net.WriteInt( invI, 32 )
                net.SendToServer()

                Falcon.Inventory.equipped[invI] = item.name
                table.remove( Falcon.Inventory.backpack, f.ActiveItem )
                f.OpenMainContent( content:GetParent() )
            end
        end
    end 
end
f.LoadPlayerUI = function( fr )
    local _, _, back = Falcon.UI.Presets.Models.CreateFullModel( fr, 0.975, 1, 0.025, 0, {} )
    back.Paint = function( self, w, h )
        surface.SetDrawColor( shadowOverlay )
        surface.DrawRect( 0, 0, w, h )
        surface.SetDrawColor( shadowOverlay )
        surface.DrawRect( w * 0.025, w * 0.025, w - (w * 0.05), h - (w * 0.05) )
        surface.SetDrawColor( color_white )
        surface.DrawOutlinedRect( 0, 0, w, h )
    end
    local p = fr:GetParent()
    local w, h = p:GetWide(), p:GetTall()

    local armorSlots = vgui.Create("DPanel", p )
    armorSlots:SetSize( w * 0.085, fr:GetTall() )
    armorSlots:SetPos( w * 0.325, h * 0.175 )
    armorSlots.Paint = nil

    f.OpenPlayerSlots( armorSlots )
end
f.LoadInventoryUI = function( fr )
    f.OpenInventoryGrid( fr )
end

f.LoadWeaponUI = function( content )
    local w, h = content:GetWide(), content:GetTall()
    for i = 1, 6 do
        local p = vgui.Create("DPanel", content) 
        p:SetSize( w * 0.1375, w * 0.1375 )
        p:SetPos( w * (0.055 + ((i-1) * 0.15)), h * 0.05 )
        p.Paint = nil

        local w, h = p:GetWide(), p:GetTall()

        local invItem = Falcon.Inventory.equipped[i]
        if invItem and invItem ~= "" then 
            local itemId = Falcon.ItemsIdentifier[invItem]
            local i = Falcon.Items[itemId]
            local mdl = vgui.Create("DModelPanel", p)
            mdl:SetSize( w, h )
            mdl:SetModel( i.model.string )
            mdl.LayoutEntity = function( self ) end
            mdl:SetCamPos( i.model.inventory.pos )
            mdl:SetLookAng( i.model.inventory.ang )
            mdl:SetFOV( i.model.inventory.fov )
        end

        local btn = vgui.Create("DButton", p)
        btn:SetSize( w, h )
        btn.Paint = function( self, w, h )
            local color = color_white
            if f.ActiveCategory == i then
                if not f.EquipedItem and not Falcon.Inventory.equipped[i] then
                    color = color_green
                elseif f.EquipedItem then
                    color = color_yellow
                end
            end
            surface.DrawBorderedRect( 0, 0, w, h, shadowOverlay, color )
        end 
        if invItem and invItem ~= "" then
            local itemId = Falcon.ItemsIdentifier[invItem]
            local item = Falcon.Items[itemId]

            btn.DoClick = function( self )
                f.ActiveItem = i
                f.ActiveCategory = i
                f.EquipedItem = true
                f.ResetCurrentHovered()
            end
            btn.DoRightClick = function( self )
                f.ActiveItem = nil
                f.ActiveCategory = nil
                f.EquipedItem = false
                f.ResetCurrentHovered()
            end 
            btn.Paint = function( self, w, h )
                local color = Falcon.ItemsRarities.Colors[item.rarity]
                if f.ActiveCategory == i then
                    if not f.EquipedItem and not Falcon.Inventory.equipped[i] then
                        color = color_green
                    elseif f.EquipedItem then
                        color = color_yellow
                    end
                end

                surface.DrawBorderedRect( 0, 0, w, h, shadowOverlay, color )
            end 
        else
            btn.DoClick = function( self )
                if f.ActiveCategory ~= i then return end
                local b = Falcon.Inventory.backpack[f.ActiveItem].item
                local itemIDDD = Falcon.ItemsIdentifier[b]
                local item = Falcon.Items[itemIDDD]
                
                net.Start("FALCON:INVENTORY:ADDTOEQUIP")
                    net.WriteInt( f.ActiveItem, 32 )
                    net.WriteInt( i, 32 )
                net.SendToServer()

                Falcon.Inventory.equipped[i] = item.name
                table.remove( Falcon.Inventory.backpack, f.ActiveItem )
                f.OpenMainContent( content:GetParent() )
            end
        end
    end 
end