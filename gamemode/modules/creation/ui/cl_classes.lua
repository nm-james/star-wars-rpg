Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Creation = Falcon.UI.Creation or {}
local f = Falcon.UI.Creation

f.CreateCreateClass = function( parent )
    local fr, ex = Falcon.UI.Presets.Frames.CreateOverlayFrame( 0.2, 0.15, 0.4, 0.425, parent:GetParent(), { text = "CREATE A NEW CLASS", shouldAnimate = true, animSpeed = 10 } )
    local newClassName = Falcon.UI.Presets.Entry.CreateBaseEntry( fr, 0.9, 0.3, 0.05, 0.175 )
    local create = Falcon.UI.Presets.Buttons.CreateConditionalButton( fr, function( self )
        if not newClassName or newClassName:GetValue() == "" then return false end 
        return true
    end, 0.9, 0.3, 0.05, 0.525, { text = "CREATE", click = function( self )
        local namae = newClassName:GetValue()
        net.Start("FALCON:CLASSES:CREATE")
            net.WriteString( namae )
        net.SendToServer()

        ex.DoClick( ex )

        parent:Clear()

        timer.Simple(0.2, function()
            f.OpenClassesEditor( parent )
        end)
    end } )
end

f.GetClassRegiments = function( cl )
    local classes = {}

    for i, reg in pairs( Falcon.Regiments ) do
        for _, class in pairs( reg.classes or {} ) do
            if tonumber(class.class) == cl then
                table.insert( classes, { namae = reg.name .. " [" .. reg.abbreviation .. "]", model = class.model, color = reg.color, regimentArray = i } )
            end
        end
    end


    return classes
end

local color_white = Color( 255, 255, 255 )
local color_black = Color( 0, 0, 0 )
f.LoadPreview = function( parent, class )
    local regClasses = f.GetClassRegiments( class )

    if table.Count( regClasses ) == 0 then return end
    parent:Clear()

    local w, h = parent:GetSize()
    local butoons = vgui.Create("DScrollPanel", parent)
    butoons:SetSize( w * 0.45, h )

    local content, mdl = Falcon.UI.Presets.Models.CreateFullModel( parent, 0.55, 1, 0.45, 0, {} )
    mdl:SetModel( regClasses[1].model )

    local w, h = butoons:GetSize()
    for _, stuff in pairs( regClasses ) do
        local btn = vgui.Create( "DButton", butoons )
        btn:SetSize( w, h * 0.125 )
        btn:Dock( TOP )
        btn:SetFont( "F13" )
        btn:SetText( stuff.namae )
        btn:SetColor( stuff.color or color_white )
        btn.Paint = function( self, w, h )
            surface.SetDrawColor( color_black.r, color_black.g, color_black.b, 200 )
            surface.DrawRect( 0, 0, w, h )
        end

        btn:SetAlpha( 175 )
        btn.Think = function( self )
            local alpha = self:GetAlpha()
            if self:IsHovered() then
                mdl:SetModel( stuff.model )

                if alpha < 255 then
                    self:SetAlpha( math.Clamp(alpha + ((FrameTime() * 6) * 255), 175, 255) )
                end
            else
                if alpha > 175 then 
                    self:SetAlpha( math.Clamp(alpha - ((FrameTime() * 6) * 255), 175, 255) )
                end
            end
        end
        -- btn.DoClick = function( self )
        --     parent:GetParent():GetParent():Clear()
        --     f.OpenRegimentEditor( parent:GetParent():GetParent(), tonumber(stuff.regimentArray) )
        -- end
    end
end

f.LoadClassInfo = function( parent, class )
    parent:Clear()
    local cl = Falcon.Classes[class]

    local namae = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.9, 0.1, 0.05, 0.06 )
    namae:SetValue( cl.name )


    
    local desc = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.9, 0.3, 0.05, 0.17 )
    desc:SetValue( cl.description )
    desc:SetMultiline( true )



    local health = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.4, 0.1, 0.05, 0.48 )
    health:SetValue( cl.health )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.455, 0.48, { text = "HEALTH" } )



    local armor = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.4, 0.1, 0.05, 0.59 )
    armor:SetValue( cl.armor )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.455, 0.59, { text = "ARMOR" } )



    local run = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.4, 0.1, 0.05, 0.7 )
    run:SetValue( cl.run )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.455, 0.7, { text = "RUNSPEED" } )


    local weaponString = ""
    for _, wep in pairs( cl.weapons ) do
        weaponString = weaponString .. wep

        if _ ~= #cl.weapons then
            weaponString = weaponString .. ", "
        end
    end

    local weps = Falcon.UI.Presets.Entry.CreateBaseEntry( parent, 0.4, 0.1, 0.05, 0.81 )
    weps:SetValue( weaponString )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.455, 0.81, { text = "WEAPONS" } )

    local isH = false
    if cl.hidden == 1 then
        isH = true
    end
    local isHidden = Falcon.UI.Presets.Buttons.CreateTrueFalseSwitch( parent, isH, 0.125, 0.1, 0.7, 0.48 )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.8325, 0.48, { text = "HIDDEN" } )

    local isE = false
    if cl.engineer == 1 then
        isE = true
    end
    local isEngineer = Falcon.UI.Presets.Buttons.CreateTrueFalseSwitch( parent, isE, 0.125, 0.1, 0.7, 0.59 )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.8325, 0.59, { text = "ENGINEER" } )

    local isM = false
    if cl.medic == 1 then
        isM = true
    end
    local isMedic = Falcon.UI.Presets.Buttons.CreateTrueFalseSwitch( parent, isM, 0.125, 0.1, 0.7, 0.7 )
    local lbl = Falcon.UI.Presets.Other.CreateBaseLabel( parent, 0.125, 0.1, 0.8325, 0.7, { text = "MEDIC" } )

    local saveChanges = Falcon.UI.Presets.Buttons.CreateConditionalButton( parent, function( self )
        if namae:GetValue() ~= cl.name or desc:GetValue() ~= cl.description or tonumber( health:GetValue() ) ~= cl.health or tonumber( armor:GetValue() ) ~= cl.armor or tonumber( run:GetValue() ) ~= cl.run or weps:GetValue() ~= weaponString then return true end
        if isHidden.CurrentSwitchValue ~= cl.hidden or isEngineer.CurrentSwitchValue ~= cl.engineer or isMedic.CurrentSwitchValue ~= cl.medic then return true end
        return false
    end, 0.25, 0.1, 0.7, 0.81, { text = "SAVE CHANGES", click = function( self )
        local ww = string.Explode( ", ", weps:GetValue() )
        if #ww == 1 and ww[1] == "" then
            ww = {}
        end

        local t = {}
        t.newNamae = namae:GetValue()
        t.newDescription = desc:GetValue()
        t.newHealth = tonumber( health:GetValue() )
        t.newArmor = tonumber( armor:GetValue() )
        t.newRunspeed = tonumber( run:GetValue() )
        t.newWeapons = ww
        t.newHidden = isHidden.CurrentSwitchValue
        t.newEngineer = isEngineer.CurrentSwitchValue
        t.newMedic = isMedic.CurrentSwitchValue


        net.Start("FALCON:CLASSES:UPDATE")
            net.WriteUInt( tonumber( cl.id ), 32 )
            net.WriteTable( t )
        net.SendToServer()

        local par = parent:GetParent():GetParent()
        par:Clear()

        timer.Simple(0.2, function()
            if not par or not par:IsValid() then return end
            f.OpenClassesEditor( par, class )
        end)
    end } )
end

f.OpenClassesEditor = function( parent, classID )
    local classes, _, banner = Falcon.UI.Presets.Panel.CreateBanneredScrollPanel( parent, 0.6, 0.99, 0, 0.01, { text = "ACTIVE CLASSES"} )
    local addClases = Falcon.UI.Presets.Buttons.TextButton( banner, 0.02, 1, 0.93, 0, { text = "+", font = "F18", 
        click = function( self ) 
            f.CreateCreateClass( parent )
        end 
    } )
    local bW, bH = classes:GetWide(), banner:GetTall()
    addClases:SetSize( bH, bH )
    addClases:SetPos( bW - bH, 0 )

    local basicInfoPnl = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.375, 0.4, 0.625, 0.01, { text = "BASIC INFORMATION" } )
    local preview = Falcon.UI.Presets.Panel.CreateBanneredPanel( parent, 0.375, 0.58, 0.625, 0.42, { text = "REGIMENT PREVIEW" } )
    for id, clss in pairs( Falcon.Classes ) do
        local b = Falcon.UI.Presets.Buttons.CreateCategoricalButton( classes, 0.9, 0.075, 0, 0, { text = clss.name, fade = true, font = "F18", paint = function( self, w, h )
            surface.SetDrawColor( self.CurColor.r, self.CurColor.g, self.CurColor.b, 200 )
            surface.DrawRect( 0, 0, w, h )
            surface.SetDrawColor( color_white )
            surface.DrawLine( 0, h * 0.99, w, h * 0.99 )
        end, click = function( self )
            f.LoadPreview( preview, tonumber(clss.id) )
            f.LoadClassInfo( basicInfoPnl, id )
        end } )
        b:Dock( TOP )

        local w, h = b:GetWide(), b:GetTall()
        local removeBtn = Falcon.UI.Presets.Buttons.CreateConditionalButton( b, function( self )
            if b:IsHovered() or self:IsHovered() then
                return true
            end
            return false
        end, h / w, 1, 0, 0, { baseAlpha = 0, text = "REMOVE", click = function( self )
            net.Start("FALCON:CLASSES:REMOVE")
                net.WriteUInt( tonumber( clss.id ), 32 )
            net.SendToServer()

            parent:Clear()

            timer.Simple(0.2, function()
                if not parent or not parent:IsValid() then return end
                f.OpenClassesEditor( parent )
            end)
        end } )
        removeBtn:Dock( RIGHT )

        if classID and classID == id then
            b.DoClick( b )
        end
    end

end 