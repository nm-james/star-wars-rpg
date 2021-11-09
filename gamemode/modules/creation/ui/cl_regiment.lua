Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Creation = Falcon.UI.Creation or {}
local f = Falcon.UI.Creation

local color_white = Color(255, 255, 255 )
f.CreateNewRegiment = function( parent )
    local fr, ex = Falcon.UI.Presets.Frames.CreateOverlayFrame( 0.2, 0.25, 0.4, 0.375, parent:GetParent(), { text = "CREATE A NEW REGIMENT", shouldAnimate = true, animSpeed = 10 } )
    local newRegName = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.6, 0.175, 0.05, 0.175 )
    local newRegAbr = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.275, 0.175, 0.675, 0.175 )

    local rankStructures = {}
    local rankEasyGetgo = {}
    for _, d in pairs(Falcon.Departments) do
        rankEasyGetgo[d.name] = _
        table.insert(rankStructures, d.name)
    end
    local rankStructure = Falcon.UI.Presets.ComboBoxes.CreateComboBox( fr, rankStructures, 0.9, 0.175, 0.05, 0.415, { text = "RANK STRUCTURE", font = "F14" } )

    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( fr, function( self )
        if not newRegName or newRegName:GetValue() == "" then return false end 
        if not newRegAbr or newRegAbr:GetValue() == "" then return false end 
        if not rankStructure or rankStructure:GetValue() == "RANK STRUCTURE" then return false end 

        return true
    end, 0.9, 0.175, 0.05, 0.65, { text = "CREATE", click = function( self )
        local namae = newRegName:GetValue()
        local abr = newRegAbr:GetValue()
        local department = rankStructure:GetValue()

        net.Start("FALCON:REGIMENTS:CREATE")
            net.WriteString( namae )
            net.WriteString( abr )
            net.WriteUInt( rankEasyGetgo[department], 32 )
        net.SendToServer()
        ex.DoClick( ex )

        local count = table.Count( Falcon.Regiments )
        parent:Clear()
        timer.Simple(0.2, function()
            if parent and parent:IsValid() then
                f.OpenRegimentEditor( parent )
            end
        end)
    end } )
end


f.AddClass = function( parent, class, regiment )
    local fr, ex = Falcon.UI.Presets.Frames.CreateOverlayFrame( 0.2, 0.15, 0.4, 0.425, parent:GetParent(), { text = "ADD CLASS TO REGIMENT", shouldAnimate = true, animSpeed = 10 } )
    local modelString = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.9, 0.3, 0.05, 0.175 )
    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( fr, function( self )
        if not modelString or modelString:GetValue() == "" then return false end 
        return true
    end, 0.9, 0.3, 0.05, 0.525, { text = "ADD CLASS", click = function( self )
        local namae = modelString:GetValue()

        net.Start("FALCON:REGIMENT:ADDCLASS")
            net.WriteUInt( tonumber(Falcon.Regiments[regiment].id), 32 )
            net.WriteUInt( class, 32 )
            net.WriteString( namae )
        net.SendToServer()

        ex.DoClick( ex )

        parent:Clear()

        timer.Simple(0.2, function()
            if not parent or not parent:IsValid() then return end
            f.OpenRegimentEditor( parent, regiment )
        end)
    end } )
end


f.LoadPlayerData = function( parent, regiment, clearance )
    parent:Clear()
    local d = Falcon.Regiments[regiment].loadouts[clearance]
    local rankStructure = Falcon.UI.Presets.ComboBoxes.CreateComboBox( parent, { 1, 2, 3, 4, 5 }, 0.9, 0.1, 0.05, 0.05, { text = "CLEARANCE LOADOUT: " .. tostring(clearance), font = "F10", onselect = function(index, value, data)
        f.LoadPlayerData( parent, regiment, value )
    end } )
    local model = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.55, 0.11, 0.05, 0.2 )
    model:SetValue( d.model )
    model:SetUpdateOnType( true )
    local runspeed = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.3, 0.11, 0.05, 0.325 )
    runspeed:SetValue( d.run )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.3, 0.11, 0.36, 0.325, { text = "RUNSPEED" } )
    
    local health = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.3, 0.11, 0.05, 0.45 )
    health:SetValue( d.health )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.3, 0.11, 0.36, 0.45, { text = "HEALTH" } )

    local armor = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.3, 0.11, 0.05, 0.575 )
    armor:SetValue( d.armor )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.3, 0.11, 0.36, 0.575, { text = "ARMOR" } )

    local weaponString = ""
    for _, wep in pairs( d.weapons ) do
        weaponString = weaponString .. wep

        if _ ~= #d.weapons then
            weaponString = weaponString .. ", "
        end
    end

    local weps = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.425, 0.11, 0.05, 0.7 )
    weps:SetValue( weaponString )

    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.3, 0.11, 0.485, 0.7, { text = "WEAPONS" } )

    local mdlContent, mdl = Falcon.UI.Presets.Models.CreateFullModel( parent, 0.32, 0.75, 0.63, 0.2, { model = d.model } )
    model.OnValueChange = function( self, value )
        mdl:SetModel( value )
    end

    local saveChanges = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if model:GetValue() ~= d.model or tonumber( runspeed:GetValue() ) ~= d.run or tonumber( health:GetValue() ) ~= d.health or tonumber( armor:GetValue() ) ~= d.armor or weps:GetValue() ~= weaponString then return true end
        return false
    end, 0.55, 0.11, 0.05, 0.825, { text = "SAVE CHANGES", click = function( self )
        local ww = string.Explode( ", ", weps:GetValue() )
        if #ww == 1 and ww[1] == "" then
            ww = {}
        end

        local newInfo = {}
        newInfo.newModel = model:GetValue()
        newInfo.newRunspeed = tonumber( runspeed:GetValue() )
        newInfo.newHealth = tonumber( health:GetValue() )
        newInfo.newArmor = tonumber( armor:GetValue() )
        newInfo.newWeapons = ww

        net.Start("FALCON:REGIMENTS:SAVECLEARANCE")
            net.WriteUInt( regiment, 32 )
            net.WriteUInt( clearance, 32 )
            net.WriteTable( newInfo )
        net.SendToServer()

        local par = parent:GetParent():GetParent()
        par:Clear()

        timer.Simple(0.2, function()
            if not par or not par:IsValid() then return end
            f.OpenRegimentEditor( par, regiment )
        end)
    end } )
end

local color_black = Color( 0, 0, 0 )
f.OpenRegimentData = function( regiment, info, curClasses, alrClasses, player )
    local reg = Falcon.Regiments[ regiment ]
    info:Clear()
    local regColor = Falcon.UI.Presets.Other.CreateColorPalette( info, 0.285, 0.7075, 0.665, 0.255, { wangs = false, palette = true } )
    regColor:SetColor( reg.color )

    local namae = Falcon.UI.Presets.Entry.CreateBaseEntry( info, 0.675, 0.175, 0.05, 0.06 )
    namae:SetValue( reg.name )
    namae.TextColor = regColor:GetColor()

    local prefix = Falcon.UI.Presets.Entry.CreateBaseEntry( info, 0.215, 0.175, 0.735, 0.06 )
    prefix:SetValue( reg.abbreviation )
    prefix.TextColor = regColor:GetColor()

    local description = Falcon.UI.Presets.Entry.CreateBaseEntry( info, 0.6, 0.5, 0.05, 0.255, { font = "F9" } )
    description:SetMultiline( true )
    description:SetValue( reg.description )

    regColor.Think = function( self )
        namae.TextColor = self:GetColor()
        prefix.TextColor = self:GetColor()
    end

    local isHidden
    if reg.hidden == 0 then
        isHidden = false
    elseif reg.hidden == 1 then
        isHidden = true
    end

    local hiddenSwitch = Falcon.UI.Presets.Buttons.CreateTrueFalseSwitch( info, isHidden, 0.15, 0.15, 0.5, 0.79 )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( info, 0.15, 0.15, 0.39, 0.79, { text = "IS HIDDEN" } )

    local infoSaveChanges = Falcon.UI.Presets.Buttons.CreateConditionalButton( info, function( self )
        if regColor:GetColor() ~= reg.color or namae:GetValue() ~= tostring( reg.name ) or prefix:GetValue() ~= tostring( reg.abbreviation ) or description:GetValue() ~= reg.description or hiddenSwitch.CurrentSwitchValue ~= reg.hidden then return true end
        return false
    end, 0.325, 0.15, 0.05, 0.79, { text = "SAVE CHANGES", click = function( self )
        local newInfo = {}
        newInfo.newName = namae:GetValue()
        newInfo.newRegColor = regColor:GetColor()
        newInfo.newAbbreviation = prefix:GetValue()
        newInfo.newDescription = description:GetValue()
        newInfo.newHiddenSwitch = tonumber( hiddenSwitch.CurrentSwitchValue )

        net.Start("FALCON:REGIMENTS:SAVEINFO")
            net.WriteUInt( regiment, 32 )
            net.WriteTable( newInfo )
        net.SendToServer()

        local par = info:GetParent():GetParent()
        par:Clear()

        timer.Simple(0.2, function()
            if not par or not par:IsValid() then return end
            f.OpenRegimentEditor( par, regiment )
        end)
    end } )

    local classExisting = {}
    local remainingClasses = {}

    local cl = reg.classes or {}
    for _, class in pairs( cl ) do
        classExisting[class.class] = class 
    end

    for _, cla in pairs( Falcon.Classes ) do
        if classExisting[cla.id] then classExisting[cla.id].className = cla.name continue end
        table.insert( remainingClasses, {
            name = cla.name,
            click = function( pnl )
                f.AddClass( info:GetParent():GetParent(), cla.id, regiment )
            end,
        } )
    end

    curClasses:Clear()
    Falcon.UI.Presets.Buttons.CreateHorizontalButtons( curClasses, {
        w = 1,
        h = 0.2,
        font = "F17",
        dock = TOP,
        fade = true,
        click = function( self )
            self.IsActive = false
        end
    }, remainingClasses, curClasses )


    alrClasses:Clear()
    local cw, ch = alrClasses:GetSize()
    local takenClasses = {}
    for _, cl in pairs( cl ) do
        local pnl = vgui.Create("DPanel", alrClasses)
        pnl:SetSize( cw, ch * 0.45 )
        pnl:Dock( TOP )
        pnl.Paint = function( self, w, h )
            surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 100 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 255 )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end

        local contentMdl, actualMdl = Falcon.UI.Presets.Models.CreatePortfolio( pnl, 0.35, 0.9, 0.05, 0.05, {} )
        actualMdl:SetModel( cl.model )

        local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( pnl, 0.485, 0.2, 0.425, 0.1, { text = cl.className or "" } )

        local mdlString = Falcon.UI.Presets.Entry.CreateBaseEntry( pnl, 0.485, 0.2, 0.425, 0.29, { font = "F8" } )
        mdlString:SetValue( cl.model )
        mdlString:SetUpdateOnType( true )
        mdlString.OnValueChange = function( self, value )
            actualMdl:SetModel( value )
        end
        
        local updateBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( pnl, function( self )
            if mdlString:GetValue() ~= cl.model then
                return true
            end
            return false
        end, 0.485, 0.175, 0.425, 0.525, { text = "SAVE CHANGES", click = function( self )
            net.Start("FALCON:REGIMENT:UPDATECLASS")
                net.WriteUInt( tonumber(cl.regiment), 32 )
                net.WriteUInt( tonumber(cl.class), 32 )
                net.WriteString( mdlString:GetValue() )
            net.SendToServer()

            local par = info:GetParent():GetParent()
            par:Clear()

            timer.Simple(0.2, function()
                if not par or not par:IsValid() then return end
                f.OpenRegimentEditor( par, regiment )
            end)
        end } )

        local removeBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( pnl, function( self )
            return true
        end, 0.485, 0.175, 0.425, 0.725, { text = "REMOVE", click = function( self )
            net.Start("FALCON:REGIMENT:REMOVECLASS")
                net.WriteUInt( tonumber(cl.regiment), 32 )
                net.WriteUInt( tonumber(cl.class), 32 )
            net.SendToServer()

            local par = info:GetParent():GetParent()
            par:Clear()

            timer.Simple(0.2, function()
                if not par or not par:IsValid() then return end
                f.OpenRegimentEditor( par, regiment )
            end)
        end } )
    end


    player:Clear()
    f.LoadPlayerData( player, regiment, 1 )


end

f.OpenRegimentEditor = function( parent, regimentID )
    local regiments, _, banner = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( parent, 0.6, 0.99, 0, 0.01, { text = "ACTIVE REGIMENTS" } )
    local addRegiment = Falcon.UI.Presets.Buttons.TextButton( banner, 0.02, 1, 0.93, 0, { text = "+", font = "F18", 
        click = function( self ) 
            f.CreateNewRegiment( parent )
        end 
    } )
    local bW, bH = regiments:GetWide(), banner:GetTall()
    addRegiment:SetSize( bH, bH )
    addRegiment:SetPos( bW - bH, 0 )

    local basicInfoPnl = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.375, 0.25, 0.625, 0.01, { text = "BASIC INFORMATION" } )
    local curClassesPnl = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.19, 0.34, 0.625, 0.275, { text = "CURRENT CLASSES" } )
    local avaiClassesPnl = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.19, 0.34, 0.82, 0.275, { text = "AVAILABLE CLASSES" } )
    local playerInfoPnl = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.375, 0.37, 0.625, 0.63, { text = "PLAYER INFORMATION" } )

    for id, reg in pairs( Falcon.Regiments ) do
        local b = Falcon.UI.Presets.Buttons.CreateCategoricalButton( regiments, 0.9, 0.075, 0, 0, { text = reg.name .. " [" .. reg.abbreviation .. "]", fade = true, font = "F18", paint = function( self, w, h )
            surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end, click = function( self )
            f.OpenRegimentData( id, basicInfoPnl, curClassesPnl, avaiClassesPnl, playerInfoPnl )
        end } )
        b:Dock( TOP )

        local w, h = b:GetWide(), b:GetTall()
        local removeBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( b, function( self )
            if b:IsHovered() or self:IsHovered() then
                return true
            end
            return false
        end, h / w, 1, 0, 0, { baseAlpha = 0, text = "REMOVE", click = function( self )
            net.Start("FALCON:REGIMENTS:REMOVE")
                net.WriteUInt( tonumber(reg.id), 32 )
            net.SendToServer()

            parent:Clear()
            table.remove(Falcon.Regiments, id)
            f.OpenRegimentEditor( parent )
        end } )
        removeBtn:Dock( RIGHT )

        if regimentID and regimentID == id then
            b.DoClick( b )
        end
    end


end 


