Falcon = Falcon or {}
Falcon.ActiveQuests = Falcon.ActiveQuests or {}
Falcon.FocusedQuest = Falcon.FocusedQuest or 0

hook.Add("Think", "F_THINK_HANDLE_QUEST_2", function()
    for quest, _ in pairs( Falcon.ActiveQuests ) do

    end
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
            Falcon.CreateNotification( nil, "[MISSION]", questData.Name .. " has been completed. Return to " .. ent.Name .. " to finish the mission." )
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
}
net.Receive("FALCON:QUESTS:OBJECTIVE:TOCLIENT", function()
    local quest = net.ReadUInt( 32 )
    local objectiveType = net.ReadUInt( 32 )
    local objectiveID = net.ReadUInt( 32 )
    local newValue = types[objectiveType]()

    Falcon.Quests[quest].Objectives[objectiveID].Value = newValue
    CheckQuestProgress( quest )
end)