Falcon = Falcon or {}
Falcon.ActiveQuests = Falcon.ActiveQuests or {}
Falcon.FocusedQuest = Falcon.FocusedQuest or 0
local objCheck = {
    [3] = function( questID, objData )
        local ply = LocalPlayer()
        if objData.Planet and objData.Planet ~= ply.Location then return false end
        if ply:GetPos():DistToSqr( objData.Position ) <= (objData.Distance or 25000) then return true end
        return false
    end,
    [5] = function( questID, objData )
        local ply = LocalPlayer()
        if objData.Value == 0 then
            if objData.Planet and objData.Planet ~= ply.Location then return false end
            if ply:GetPos():DistToSqr( objData.Position ) <= (objData.Distance or 25000) then return true end
            return false
        else
            local time = CurTime()
            if time > objData.Needed then return true end
            return false
        end
    end
}
local objUpdate = {
    [3] = function( questID )
        net.Start("FALCON:QUESTS:OBJECTIVE:3")
            net.WriteInt( questID, 32 )
        net.SendToServer()
    end,
    [5] = function( questID, objData )
        if objData.Value == 0 then
            net.Start("FALCON:QUESTS:OBJECTIVE:3")
                net.WriteInt( questID, 32 )
            net.SendToServer()
            objData.Value = CurTime()
            objData.Needed = CurTime() + objData.Needed
        else
            net.Start("FALCON:QUESTS:OBJECTIVE:5")
                net.WriteInt( questID, 32 )
            net.SendToServer()
        end
    end
}
local initObj = {
    [4] = function( questID, obj )
        local e = Falcon.CreateItemEntity( obj.Name, obj.Model, obj.Position )
        e.FalconClient = true
        e.Interaction = "Pick up " .. obj.Name
        e.Next = function()
            e.ShouldStopAnimating = true
            e.Interaction = nil
            timer.Simple(0.1, function()
                e:Remove()
                net.Start('FALCON:QUESTS:OBJECTIVE:3')
                    net.WriteInt( questID, 32 )
                net.SendToServer()
            end)
        end
    end
}

hook.Add("Think", "F_THINK_HANDLE_QUEST_2", function()
    if Falcon.NextHandleQuest and Falcon.NextHandleQuest > CurTime() then return end
    for quest, _ in pairs( Falcon.ActiveQuests ) do
        local objs = Falcon.Quests[quest].Objectives
        for id, t in pairs( objs ) do
            if t.Value == t.Needed then continue end
            if not t.HasInit then 
                if initObj[t.Type] then
                    initObj[t.Type]( quest, t )
                end
                t.HasInit = true
            end
           
            if objCheck[t.Type] then
                local metRequirement = objCheck[t.Type]( quest, t )
                if metRequirement then
                    objUpdate[t.Type]( quest, t )
                end
                print(metRequirement, t.Value, CurTime())

            end
            break
        end
    end
    Falcon.NextHandleQuest = CurTime() + 1
end)

-- handling data
local function CheckQuestProgress( quest )
    local questData = Falcon.Quests[quest]

    local questObjectives = questData.Objectives

    local completedObjective = true
    for _, obj in pairs( questObjectives ) do
        if obj.Value == obj.Needed then continue end
        completedObjective = false
    end

    if completedObjective then
        if questData.Ending then
            net.Start("FALCON:QUESTS:FINALDIALOGUE")
                net.WriteUInt( quest, 32 )
            net.SendToServer()
            Falcon.Player.Quests[quest] = 2

            local ent = Falcon.NPCsCE[questData.QuestHolder]
			if ent and ent:IsValid() then 
                local dia = {
                    Text = questData.Name,
                    Quest = quest,
                    Next = function()
                        FadeFrame( function() 
                            return Falcon.UI.Scening.OpenFrame( quest, ent )
                        end )
                    end
                }
    
                local options = ent.Options
                table.insert(options.Dialogue, dia)
                ent.Options = options
            end
            Falcon.CreateNotification( nil, "[MISSION]", questData.Name .. " has been completed. Return to " .. questData.QuestHolder .. " to finish the mission." )
        else
            net.Start("FALCON:QUESTS:FINISHQUEST")
                net.WriteUInt( quest, 32 )
            net.SendToServer()
            Falcon.Player.Quests[quest] = 3

            -- Add "YOU HAVE FINISHE QUEST" thingy
            Falcon.CreateNotification( nil, "[MISSION]", questData.Name .. " has been completed." )
        end
    end
end 

local types = {
    [1] = function()
        return net.ReadUInt( 32 )
    end,
    [2] = function()
        return net.ReadBool()
    end,
    [3] = function()
        return net.ReadBool()
    end,
    [4] = function()
        return net.ReadBool()
    end,
    [5] = function()
        return false
    end,
}
net.Receive("FALCON:QUESTS:OBJECTIVE:TOCLIENT", function()
    local quest = net.ReadUInt( 32 )
    local objectiveType = net.ReadUInt( 32 )
    local objectiveID = net.ReadUInt( 32 )
    local newValue = types[objectiveType]()

    if newValue then
        Falcon.Quests[quest].Objectives[objectiveID].Value = newValue
    else
        Falcon.Quests[quest].Objectives[objectiveID].Value = Falcon.Quests[quest].Objectives[objectiveID].Needed
    end
    CheckQuestProgress( quest )
end)