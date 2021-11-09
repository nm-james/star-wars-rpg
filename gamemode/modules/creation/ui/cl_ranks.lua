Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Creation = Falcon.UI.Creation or {}
local f = Falcon.UI.Creation

-- COLORS
local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )

local scrw, scrh = ScrW(), ScrH()

f.LoadDepartmentRanks = function( pnl, id, isRefreshing )
    pnl:Clear()

    if not isRefreshing then
        pnl.CurrentRankID = nil
    end

    for id, rank in SortedPairs( Falcon.Departments[id].ranks, true ) do
        local namae = tostring(id) .. ". " .. rank.name .. " [" .. rank.abr .. "] [CL " .. rank.clearance .. "]"
        local b = Falcon.UI.Presets.Buttons.CreateCategoricalButton( pnl, 0.9, 0.075, 0, 0, { text = namae, fade = true, font = "F18", paint = function( self, w, h )
            surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end, click = function( self )
            pnl.CurrentRankID = id
        end } )
        b:Dock( TOP )

        if isRefreshing then
            if id == pnl.CurrentRankID then
                b.IsActive = true
                pnl.CurrentActiveButton = b
            end
        end
    end
end

f.CreateNewDepartment = function( parent )
    local fr, ex = Falcon.UI.Presets.Frames.CreateOverlayFrame( 0.2, 0.15, 0.4, 0.425, parent:GetParent(), { text = "CREATE A NEW DEPARTMENT", shouldAnimate = true, animSpeed = 10 } )
    local newRankEntry = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.9, 0.3, 0.05, 0.175 )
    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( fr, function( self )
        if not newRankEntry or newRankEntry:GetValue() == "" then return false end 
        return true
    end, 0.9, 0.3, 0.05, 0.525, { text = "CREATE", click = function( self )
        local namae = newRankEntry:GetValue()
        net.Start("FALCON:DEPARTMENTS:CREATE")
            net.WriteString( namae )
        net.SendToServer()
        ex.DoClick( ex )

        local count = table.Count( Falcon.Departments )
        Falcon.Departments[count + 1] = { name = namae, ranks = {} }
        parent:Clear()
        f.OpenRanksEditor( parent )
    end } )
end

f.OpenRanksEditor = function( parent )
    local departments, _, banner = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( parent, 0.4, 1, 0, 0.01, { text = "ACTIVE DEPARTMENTS"} )
    local addRanks = Falcon.UI.Presets.Buttons.TextButton( banner, 0.02, 1, 0.93, 0, { text = "+", font = "F18", 
        click = function( self ) 
            f.CreateNewDepartment( parent )
        end 
    } )
    local bW, bH = departments:GetWide(), banner:GetTall()
    addRanks:SetSize( bH, bH )
    addRanks:SetPos( bW - bH, 0 )

    local ranksPnl = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( parent, 0.59, 0.925, 0.41, 0.01, { text = "RANKS" } )
    for id, department in pairs( Falcon.Departments ) do
        local b = Falcon.UI.Presets.Buttons.CreateCategoricalButton( departments, 0.9, 0.075, 0, 0, { text = department.name, fade = true, font = "F18", paint = function( self, w, h )
            surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end, click = function( self )
            departments.CurrentEditorialID = id
            f.LoadDepartmentRanks( ranksPnl, id )
        end } )
        b:Dock( TOP )

        local w, h = b:GetWide(), b:GetTall()
        local removeBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( b, function( self )
            if b:IsHovered() or self:IsHovered() then
                return true
            end
            return false
        end, h / w, 1, 0, 0, { baseAlpha = 0, text = "REMOVE", click = function( self )
            table.remove(Falcon.Departments, id)

            net.Start("FALCON:DEPARTMENTS:DELETE")
                net.WriteUInt( id, 32 )
            net.SendToServer()

            parent:Clear()
            f.OpenRanksEditor( parent )
        end } )
        removeBtn:Dock( RIGHT )
    end


    local newRankEntry = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.14, 0.05, 0.41, 0.95 )
    local abbreviation = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.1, 0.05, 0.56, 0.95 )
    local clearanceLevel = Falcon.UI.Presets.ComboBoxes.CreateComboBox( parent, { 1, 2, 3, 4, 5 }, 0.05, 0.05, 0.67, 0.95 )

    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if not departments.CurrentEditorialID then return false end
        if newRankEntry:GetValue() == "" then return false end 
        if abbreviation:GetValue() == "" then return false end 
        if clearanceLevel:GetValue() == "CLEARANCE" then return false end 

        return true
    end, 0.065, 0.05, 0.73, 0.95, { text = "CREATE", click = function( self )
        local rankTotal = table.Count( Falcon.Departments[departments.CurrentEditorialID].ranks )

        local newR = {
            name = newRankEntry:GetValue(),
            abr = abbreviation:GetValue(),
            clearance = tonumber(clearanceLevel:GetValue())
        }

        Falcon.Departments[departments.CurrentEditorialID].ranks[rankTotal + 1] = newR

        newRankEntry:SetValue( "" )
        abbreviation:SetValue( "" )
        clearanceLevel:SetValue( "CLEARANCE" )

        net.Start("FALCON:DEPARTMENTS:ADDRANK")
            net.WriteUInt( departments.CurrentEditorialID, 32 )
            net.WriteTable( newR )
        net.SendToServer()

        f.LoadDepartmentRanks( ranksPnl, departments.CurrentEditorialID )
    end } )

    local delete = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if not departments.CurrentEditorialID then return false end
        if not ranksPnl.CurrentRankID then return false end 
        return true
    end, 0.065, 0.05, 0.805, 0.95, { text = "DELETE", click = function( self )
        table.remove(Falcon.Departments[departments.CurrentEditorialID].ranks, ranksPnl.CurrentRankID)

        net.Start("FALCON:DEPARTMENTS:DELETERANK")
            net.WriteUInt( departments.CurrentEditorialID, 32 )
            net.WriteUInt( ranksPnl.CurrentRankID, 32 )
        net.SendToServer()

        f.LoadDepartmentRanks( ranksPnl, departments.CurrentEditorialID )
    end } )

    local up = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if not departments.CurrentEditorialID then return false end
        if not ranksPnl.CurrentRankID then return false end 
        if not Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID + 1] then return false end
        return true
    end, 0.055, 0.05, 0.88, 0.95, { text = "UP", click = function()
        local upR = Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID + 1]
        local curR = Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID]
        Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID] = upR
        Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID + 1] = curR

        local oldNum = ranksPnl.CurrentRankID

        net.Start("FALCON:DEPARTMENTS:UPRANK")
            net.WriteUInt( departments.CurrentEditorialID, 32 )
            net.WriteUInt( oldNum, 32 )
        net.SendToServer()

        ranksPnl.CurrentRankID = oldNum + 1

        f.LoadDepartmentRanks( ranksPnl, departments.CurrentEditorialID, true )
    end } )

    local down = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if not departments.CurrentEditorialID then return false end
        if not ranksPnl.CurrentRankID then return false end 
        if not Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID - 1] then return false end
        return true
    end, 0.055, 0.05, 0.945, 0.95, { text = "DOWN", click = function()
        local downR = Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID - 1]
        local curR = Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID]
        Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID] = downR
        Falcon.Departments[departments.CurrentEditorialID].ranks[ranksPnl.CurrentRankID - 1] = curR

        local oldNum = ranksPnl.CurrentRankID

        net.Start("FALCON:DEPARTMENTS:DOWNRANK")
            net.WriteUInt( departments.CurrentEditorialID, 32 )
            net.WriteUInt( oldNum, 32 )
        net.SendToServer()
        
        ranksPnl.CurrentRankID = oldNum - 1

        f.LoadDepartmentRanks( ranksPnl, departments.CurrentEditorialID, true )
    end } )
end 
