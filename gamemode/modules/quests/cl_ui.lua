Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Scening = Falcon.UI.Scening or {}
local scrw, scrh = ScrW(), ScrH()
local fs = Falcon.UI.Scening
fs.CSEnts = {}

local color_black = Color( 0, 0, 0, 255 )
local function SetUpScene( questId )
    for _, ply in pairs( player.GetAll() ) do
        ply:SetNoDraw( true )
    end
    for _, ent in pairs( Falcon.NPCsCE or {} ) do
        if ent and ent:IsValid() then
            ent:SetNoDraw( true )
        end
    end

    local q = Falcon.Quests[questId][fs.Position]
    for _, ent in pairs( q.Participants or {} ) do
        local model = ent.Model
        local ply = LocalPlayer()
        if ent.Name == "PLAYER" then
            model = ply:GetModel()
        end
        local e = Falcon.CreateNPC( model, ent.Pos, ent.Ang )
        fs.CSEnts[ent.Name] = e
    end 
    Falcon.HasNPCSpeaking = true

    -- draw CSEnts
end
local function UpdateQuests( questId, npc )
    local status = Falcon.Player.Quests[questId]
    local q = Falcon.Quests[questId]
    if not status and not Falcon.Player.CompletedQuests[questId] then
        Falcon.Player.Quests[questId] = 1
        Falcon.FocusedQuest = questId
        -- send a message to server to start the quest
        net.Start("FALCON:QUESTS:CREATEQUEST")
            net.WriteUInt( questId, 32 )
        net.SendToServer()
        Falcon.CreateNotification( nil, "[MISSION]", "You have started '" .. q.Name .. "'." )

    else
        if Falcon.Player.Quests[questId] ~= 2 then return end
        Falcon.Player.Quests[questId] = 3
        -- give player awards etc etc
        -- Finish the quest
        net.Start("FALCON:QUESTS:FINISHQUEST")
            net.WriteUInt( questId, 32 )
        net.SendToServer()
        Falcon.CreateNotification( nil, "[MISSION]", "'" .. q.Name .. "' has been completed." )
    end
    local options = npc.Options
    for id, data in pairs( options.Dialogue ) do
        if data.Quest and data.Quest == questId then
            table.remove(options.Dialogue, id)
            break
        end
    end
    npc.Options = options

    SortQuests( Falcon.Player.Quests )
end 
local function ExitScene( questId )
    for _, ply in pairs( player.GetAll() ) do
        ply:SetNoDraw( false )
    end
    for _, ent in pairs( Falcon.NPCsCE or {} ) do
        if ent and ent:IsValid() then
            ent:SetNoDraw( false )
        end
    end
    for _, ent in pairs( fs.CSEnts ) do
        if ent and ent:IsValid() then
            ent:Remove()
        end
    end
    fs.CSEnts = {}

    Falcon.HasNPCSpeaking = false
end

fs.MainTextOptions = function( content, questId )
    local parent = content:GetParent()

    local player = Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue]

    local scenes = player.View
    if scenes and not table.IsEmpty( scenes ) then
        fs.StartVector = scenes.From[1]
        fs.EndVector = scenes.To[1]
        fs.StartAngle = scenes.From[2]
        fs.EndAngle = scenes.To[2]
        fs.Speed = scenes.Speed
    end

    content:Clear()
    content:SetCursor("arrow")
    fs.ChoosingArrow = true

    local ply = LocalPlayer()
    local talkPnl = vgui.Create("DPanel", content)
    talkPnl:SetSize( parent:GetWide() * 0.549, parent:GetTall() * 0.135 )
    talkPnl:SetPos( parent:GetWide() * 0.225, parent:GetTall() * 0.75 )
    talkPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( ply:Nick(), "F23", w * 0.13, h * 0.2, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( "A Very Cool Guy", "F10", w * 0.131, h * 0.55, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
    end

    local optionsPnl = vgui.Create("DScrollPanel", talkPnl)
    optionsPnl:SetSize( talkPnl:GetWide() * 0.55, talkPnl:GetTall() * 0.95 )
    optionsPnl:SetPos( talkPnl:GetWide() * 0.45, talkPnl:GetTall() * 0.025 )

    for dialogueID, d in pairs(player.Text or {}) do
        local opt = vgui.Create("DButton", optionsPnl)
        local col = Color( 140, 140, 140 )
        local t = d.Text

        opt.Color = col
        opt:SetSize( optionsPnl:GetWide() * 0.9, optionsPnl:GetTall() * 0.4 )
        opt:Dock( TOP )
        opt:SetFont("F9")
        opt:SetContentAlignment( 5 )
        opt:SetText(t)
        opt:SetColor( opt.Color )
        opt.Think = function( self )
            if self:IsHovered() then
                self.Color = Color( 255, 175, 0 )
            else
                self.Color = col
            end
            self:SetColor( self.Color )
        end
        opt.Paint = function( self, w, h )
            draw.RoundedBox( 7.5, 0, 0, w, h, opt.Color )
            draw.RoundedBox( 7.5, h * 0.04, h * 0.04, w - (h * 0.08025), h - (h * 0.08025), Color( 17, 17, 17 ) )
        end
        opt.DoClick = function( self )
            Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue].HasResponse = dialogueID
            fs.LoadPlayerText( content, questId )
        end
        if _ == #player.Text then
            opt:DockMargin( optionsPnl:GetWide() * 0.05, optionsPnl:GetTall() * 0.025, optionsPnl:GetWide() * 0.025, optionsPnl:GetTall() * 0.025 )
        else
            opt:DockMargin( optionsPnl:GetWide() * 0.05, optionsPnl:GetTall() * 0.025, optionsPnl:GetWide() * 0.025, 0 )
        end
    end

    local imgPnl = vgui.Create("DPanel", talkPnl)
    imgPnl:SetSize( parent:GetWide() * 0.06, parent:GetWide() * 0.06 )
    imgPnl:SetPos( parent:GetTall() * 0.016, parent:GetTall() * 0.015 )
    imgPnl.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, Color( 255, 255, 255 ) )
        draw.RoundedBox( 7.5, h * 0.02, h * 0.02, w - (h * 0.04), h - (h * 0.04), Color( 42, 42, 42, 255 ) )
        draw.RoundedBox( 7.5, h * 0.1, h * 0.095, w - (h * 0.205), h - (h * 0.2), Color( 55, 55, 55, 255 ) )
    end
end

fs.LoadPlayerText = function( content, questId )
    local q = Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue]
    local scenes = q.View
    if scenes and not table.IsEmpty( scenes ) then
        fs.StartVector = scenes.From[1]
        fs.EndVector = scenes.To[1]
        fs.StartAngle = scenes.From[2]
        fs.EndAngle = scenes.To[2]
        fs.Speed = scenes.Speed
    end
    
    local parent = content:GetParent()
    content:Clear()
    content:SetCursor("hand")
    fs.ChoosingArrow = false

    local ply = LocalPlayer()
    local talkPnl = vgui.Create("DPanel", content)
    talkPnl:SetSize( parent:GetWide() * 0.55, parent:GetTall() * 0.135 )
    talkPnl:SetPos( parent:GetWide() * 0.225, parent:GetTall() * 0.75 )
    talkPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( ply:Nick(), "F23", w * 0.13, h * 0.2, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( "A Pretty cool guy", "F10", w * 0.131, h * 0.55, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
    end

    local imgPnl = vgui.Create("DPanel", talkPnl)
    imgPnl:SetSize( parent:GetWide() * 0.06, parent:GetWide() * 0.06 )
    imgPnl:SetPos( parent:GetTall() * 0.016, parent:GetTall() * 0.015 )
    imgPnl.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, Color( 255, 255, 255 ) )
        draw.RoundedBox( 7.5, h * 0.02, h * 0.02, w - (h * 0.04), h - (h * 0.04), Color( 42, 42, 42, 255 ) )
        draw.RoundedBox( 7.5, h * 0.1, h * 0.095, w - (h * 0.205), h - (h * 0.2), Color( 55, 55, 55, 255 ) )
    end

    local msgPnl = vgui.Create("DLabel", talkPnl)
    msgPnl:SetSize( talkPnl:GetWide() * 0.549, talkPnl:GetTall() * 0.95 )
    msgPnl:SetPos( talkPnl:GetWide() * 0.45, talkPnl:GetTall() * 0.025 )
    msgPnl:SetFont( "F12" )
    msgPnl:SetWrap( true )
    msgPnl:SetText( "" )
    msgPnl.RunningI = 1
    fs.GlobalMessagePanel = msgPnl

    local response = q.Text[q.HasResponse].Text
    local checkPlayerName = string.Split(response, "PLAYER")
    local ply = LocalPlayer()

    if checkPlayerName[2] then
        response = checkPlayerName[1]
        for i = 2, #checkPlayerName do
            response = response .. ply:Nick() .. checkPlayerName[i]
        end
    end
    
    local splitedResponse = string.Split( response, "" )
    msgPnl.MessageData = splitedResponse
    msgPnl.Message = response

    msgPnl.Think = function( self )
        if self.RunningDelay and self.RunningDelay > CurTime() then return end
        if not splitedResponse[self.RunningI] then return end
        self:SetText( self:GetText() .. splitedResponse[self.RunningI] )
        self.RunningI = self.RunningI + 1
        self.RunningDelay = CurTime() + 0.03
    end
end

fs.LoadMainText = function( content, questId )
    local scenes = Falcon.Quests[questId][fs.Position].Dialogue[fs.CurrentDialogue][fs.CurrentWhatTalking].View
    if scenes and not table.IsEmpty( scenes ) then
        fs.StartVector = scenes.From[1]
        fs.EndVector = scenes.To[1]
        fs.StartAngle = scenes.From[2]
        fs.EndAngle = scenes.To[2]
        fs.Speed = scenes.Speed
    end
    
    local parent = content:GetParent()
    content:Clear()
    content:SetCursor("hand")
    fs.ChoosingArrow = false
    
    local q = Falcon.Quests[questId][fs.Position].Dialogue[fs.CurrentDialogue][fs.CurrentWhatTalking]
    q.HasTalked = true

    local questThingIdk = Falcon.Quests[questId][fs.Position].Participants
    local person = questThingIdk[q.Responder or 1]
    local namae = person.Name
    local ent = fs.CSEnts[namae]
    if ent and ent:IsValid() then
        if q.Act then
            ent:SetSequence( q.Act )
        else
            ent:SetSequence( 3 )
        end
    end

    local mainperson = Falcon.Quests[questId][fs.Position].Participants[q.Responder or 1]
    local ent = Falcon.NPCsCE[mainperson.Name]
    local desc = ""
    if ent and ent:IsValid() then
        desc = ent.Desc
    end 
    local talkPnl = vgui.Create("DPanel", content)
    talkPnl:SetSize( parent:GetWide() * 0.55, parent:GetTall() * 0.135 )
    talkPnl:SetPos( parent:GetWide() * 0.225, parent:GetTall() * 0.75 )
    talkPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( mainperson.Name, "F23", w * 0.13, h * 0.2, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( desc, "F10", w * 0.131, h * 0.55, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
    end

    local imgPnl = vgui.Create("DPanel", talkPnl)
    imgPnl:SetSize( parent:GetWide() * 0.06, parent:GetWide() * 0.06 )
    imgPnl:SetPos( parent:GetTall() * 0.016, parent:GetTall() * 0.015 )
    imgPnl.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, Color( 255, 255, 255 ) )
        draw.RoundedBox( 7.5, h * 0.02, h * 0.02, w - (h * 0.04), h - (h * 0.04), Color( 42, 42, 42, 255 ) )
        draw.RoundedBox( 7.5, h * 0.1, h * 0.095, w - (h * 0.205), h - (h * 0.2), Color( 55, 55, 55, 255 ) )
    end

    local msgPnl = vgui.Create("DLabel", talkPnl)
    msgPnl:SetSize( talkPnl:GetWide() * 0.549, talkPnl:GetTall() * 0.95 )
    msgPnl:SetPos( talkPnl:GetWide() * 0.45, talkPnl:GetTall() * 0.025 )
    msgPnl:SetFont( "F12" )
    msgPnl:SetWrap( true )
    msgPnl:SetText( "" )
    msgPnl.RunningI = 1
    fs.GlobalMessagePanel = msgPnl

    local response = q.Text
    local checkPlayerName = string.Split(response, "PLAYER")
    local ply = LocalPlayer()

    if checkPlayerName[2] then
        response = checkPlayerName[1]
        for i = 2, #checkPlayerName do
            response = response .. ply:Nick() .. checkPlayerName[i]
        end
    end

    local splitedResponse = string.Split( response, "" )
    msgPnl.MessageData = splitedResponse
    msgPnl.Message = response

    msgPnl.Think = function( self )
        if self.RunningDelay and self.RunningDelay > CurTime() then return end
        if not splitedResponse[self.RunningI] then return end
        self:SetText( self:GetText() .. splitedResponse[self.RunningI] )
        self.RunningI = self.RunningI + 1
        self.RunningDelay = CurTime() + 0.03
    end
end

fs.LoadRespondingText = function( content, questId )
    local q = Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue]
    local scenes = q.Text[q.HasResponse].Response.View
    fs.StartVector = scenes.From[1]
    fs.EndVector = scenes.To[1]
    fs.StartAngle = scenes.From[2]
    fs.EndAngle = scenes.To[2]
    fs.Speed = scenes.Speed
    
    local parent = content:GetParent()
    content:Clear()
    content:SetCursor("hand")
    fs.ChoosingArrow = false


    local responder = q.Text[q.HasResponse].Response.Responder
    local mainperson = Falcon.Quests[questId][fs.Position].Participants[responder]
    local ent = Falcon.NPCsCE[mainperson.Name]
    local desc = ""
    if ent and ent:IsValid() then
        desc = ent.Desc
    end 

    local talkPnl = vgui.Create("DPanel", content)
    talkPnl:SetSize( parent:GetWide() * 0.55, parent:GetTall() * 0.135 )
    talkPnl:SetPos( parent:GetWide() * 0.225, parent:GetTall() * 0.75 )
    talkPnl.Paint = function( self, w, h )
        surface.SetDrawColor( 0, 0, 0, 205 )
        surface.DrawRect( 0, 0, w, h )

        surface.SetDrawColor( 255, 255, 255, 255 )
        surface.DrawOutlinedRect( 0, 0, w, h )

        draw.DrawText( mainperson.Name, "F23", w * 0.13, h * 0.2, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
        draw.DrawText( desc, "F10", w * 0.131, h * 0.55, Color(0, 240, 240, 255), TEXT_ALIGN_LEFT )
    end

    local imgPnl = vgui.Create("DPanel", talkPnl)
    imgPnl:SetSize( parent:GetWide() * 0.06, parent:GetWide() * 0.06 )
    imgPnl:SetPos( parent:GetTall() * 0.016, parent:GetTall() * 0.015 )
    imgPnl.Paint = function( self, w, h )
        draw.RoundedBox( 7.5, 0, 0, w, h, Color( 255, 255, 255 ) )
        draw.RoundedBox( 7.5, h * 0.02, h * 0.02, w - (h * 0.04), h - (h * 0.04), Color( 42, 42, 42, 255 ) )
        draw.RoundedBox( 7.5, h * 0.1, h * 0.095, w - (h * 0.205), h - (h * 0.2), Color( 55, 55, 55, 255 ) )
    end

    local msgPnl = vgui.Create("DLabel", talkPnl)
    msgPnl:SetSize( talkPnl:GetWide() * 0.549, talkPnl:GetTall() * 0.95 )
    msgPnl:SetPos( talkPnl:GetWide() * 0.45, talkPnl:GetTall() * 0.025 )
    msgPnl:SetFont( "F12" )
    msgPnl:SetWrap( true )
    msgPnl:SetText( "" )
    msgPnl.RunningI = 1
    fs.GlobalMessagePanel = msgPnl

    local response = q.Text[q.HasResponse].Response.Text
    local checkPlayerName = string.Split(response, "PLAYER")
    local ply = LocalPlayer()

    if checkPlayerName[2] then
        response = checkPlayerName[1]
        for i = 2, #checkPlayerName do
            response = response .. ply:Nick() .. checkPlayerName[i]
        end
    end

    local splitedResponse = string.Split( response, "" )
    msgPnl.MessageData = splitedResponse
    msgPnl.Message = response
    msgPnl.Think = function( self )
        if self.RunningDelay and self.RunningDelay > CurTime() then return end
        if not splitedResponse[self.RunningI] then return end
        self:SetText( self:GetText() .. splitedResponse[self.RunningI] )
        self.RunningI = self.RunningI + 1
        self.RunningDelay = CurTime() + 0.03
    end
    q.HasResponded = true
end


fs.OpenFrame = function( questId, npc )
    if fs.Frame and fs.Frame:IsValid() then return end
    if Falcon.Player.Quests[questId] and Falcon.Player.Quests[questId] == 2 then
        fs.Position = "Ending"
    else
        fs.Position = "Start"
    end 

    SetUpScene( questId )
    fs.CurrentDialogue = 1
    fs.CurrentWhatTalking = 1
    local f = vgui.Create("DFrame")
    f:SetSize(scrw, scrh)
    f:Center()
    -- f:MakePopup()
    f.Paint = nil


    local q = Falcon.Quests[questId][fs.Position].Dialogue
    local wF, hF = f:GetWide(), f:GetTall()
    local scenes = q[fs.CurrentDialogue][fs.CurrentWhatTalking].View

    fs.StartVector = scenes.From[1]
    fs.EndVector = scenes.To[1]
    fs.StartAngle = scenes.From[2]
    fs.EndAngle = scenes.To[2]
    fs.Speed = scenes.Speed

    local animP = vgui.Create("DPanel", f)
    animP:SetSize( wF, hF )
    animP:SetPos( 0, 0 )
    animP.SceneMultiplier = 0
    animP.Think = function( self )
        if self.SceneMultiplier == 1 then return end
        local fr = FrameTime()

        self.SceneMultiplier = math.Clamp(self.SceneMultiplier + (fr * fs.Speed), 0, 1)
    end
    animP.Paint = function( self, w, h )
        local x, y = self:GetPos()
        local old = DisableClipping( true )
        render.RenderView( {
            origin = LerpVector(self.SceneMultiplier, fs.StartVector, fs.EndVector),
            angles = LerpAngle(self.SceneMultiplier, fs.StartAngle, fs.EndAngle),
            drawhud = false,
            drawviewmodel = false,
            x = x, y = y,
            w = w, h = h
        } )
        DisableClipping( old )

        surface.SetDrawColor( color_black )
        surface.DrawRect( 0, 0, w, h * 0.09 )
        surface.DrawRect( 0, h * 0.91, w, h * 0.1 )
    end 

    local masifBtn = vgui.Create("DButton", f)
    masifBtn:Dock( FILL )
    masifBtn:SetText("")
    masifBtn.Paint = nil
    masifBtn.DoClick = function( self )
        if fs.GlobalMessagePanel and fs.GlobalMessagePanel:IsValid() and #fs.GlobalMessagePanel.MessageData ~= #fs.GlobalMessagePanel:GetText() then
            fs.GlobalMessagePanel:SetText( fs.GlobalMessagePanel.Message )
            fs.GlobalMessagePanel.RunningI = 999999999
            return
        end 

        if fs.ChoosingArrow then return end
        local textLines = q[fs.CurrentDialogue]
        local text = textLines[fs.CurrentWhatTalking]
        local textCount = table.Count(textLines)
        local peopleCount = table.Count(textLines)

        if fs.CurrentWhatTalking == textCount and text.HasTalked and Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue] and not Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue].HasResponded then
            if not Falcon.Quests[questId][fs.Position].Responses[fs.CurrentDialogue].HasResponse then
                fs.MainTextOptions( self, questId )
            else
                fs.LoadRespondingText( self, questId )
            end
        else
            if fs.CurrentWhatTalking ~= textCount then
                fs.CurrentWhatTalking = fs.CurrentWhatTalking + 1
            else
                fs.CurrentWhatTalking = 1
                if fs.CurrentDialogue == table.Count(q) then
                    FadeFrame( function()
                        UpdateQuests( questId, npc )
                        ExitScene( questId )
                    end, f)
                    return
                else
                    fs.CurrentDialogue = fs.CurrentDialogue + 1
                end
            end
            fs.LoadMainText( self, questId )
        end

        local text = textLines[fs.CurrentWhatTalking]
        if text.View and not table.IsEmpty( text.View ) then
            animP.SceneMultiplier = 0
        end
    end


    fs.LoadMainText( masifBtn, questId )


    local e = Falcon.UI.Presets.Buttons.ExitButton( f )
    e.DoClick = function( self )
        f:Close()
        ExitScene( questId )
    end

    fs.Frame = f

    return f
end

concommand.Add("OPEN_ANIM", function()
    fs.OpenFrame( 1 )
end)