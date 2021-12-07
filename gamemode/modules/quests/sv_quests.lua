Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}

util.AddNetworkString("FALCON:QUESTS:CREATEQUEST")
net.Receive("FALCON:QUESTS:CREATEQUEST", function( len, ply )
    local questRequesting = net.ReadUInt( 32 )
    local uId = Falcon.GetUserID( ply )

    local hasCompleted = sql.Query("SELECT status FROM Users_Quests WHERE user = " .. uId .. " AND quest = " .. questRequesting) or {}
    if not table.IsEmpty(hasCompleted) then return end
    sql.Query("INSERT INTO Users_Quests(user, quest, status) VALUES('" .. uId .. "', '" .. questRequesting .. "', '1')")


    local newTbl = sql.Query( "SELECT quest, status FROM Users_Quests WHERE user = " .. uId ) or {}
    Falcon.SortQuestStatus( ply, newTbl )
end)
util.AddNetworkString("FALCON:QUESTS:FINALDIALOGUE")
net.Receive("FALCON:QUESTS:FINALDIALOGUE", function( len, ply )
    local questRequesting = net.ReadUInt( 32 )
    local uId = Falcon.GetUserID( ply )

    local hasCompleted = sql.Query("SELECT status FROM Users_Quests WHERE user = " .. uId .. " AND quest = " .. questRequesting) or {}
    if not table.IsEmpty(hasCompleted) and hasCompleted[1] and tonumber( hasCompleted[1].status ) == 1 then
        sql.Query("UPDATE Users_Quests SET status = 2 WHERE user = " .. uId .. " AND quest = " .. questRequesting)
    end
end)


util.AddNetworkString("FALCON:QUESTS:FINISHQUEST")
net.Receive("FALCON:QUESTS:FINISHQUEST", function( len, ply )
    local questRequesting = net.ReadUInt( 32 )
    local uId = Falcon.GetUserID( ply )

    local hasCompleted = sql.Query("SELECT status FROM Users_Quests WHERE user = " .. uId .. " AND quest = " .. questRequesting) or {}
    if not table.IsEmpty(hasCompleted) and hasCompleted[1] and tonumber( hasCompleted[1].status ) == 2 then
        sql.Query("UPDATE Users_Quests SET status = 3 WHERE user = " .. uId .. " AND quest = " .. questRequesting)
    end

    ply.ActiveQuests[questRequesting] = nil
end)

util.AddNetworkString("FALCON:QUESTS:OBJECTIVE:TOCLIENT")
-- Objective Type 1
function FOBJ_KillUpdate( ply, class )
    -- Loop through Quests
    for questID, data in pairs( ply.ActiveQuests or {} ) do
        local currentObject = ply.ActiveQuests[questID].ActiveObjective
        local obj = Falcon.Quests[questID].Objectives[currentObject]
        local value = ply.ActiveQuests[questID].Objectives[currentObject]
        if obj.Type == 1 then 
            if obj.Class ~= class then continue end
            local newVal = math.Clamp(value + 1, 0, obj.Needed)

            if newVal == obj.Needed then
                ply.ActiveQuests[questID].ActiveObjective = math.Clamp(ply.ActiveQuests[questID].ActiveObjective + 1, 0, #ply.ActiveQuests[questID].Objectives)
            end 

            ply.ActiveQuests[questID].Objectives[currentObject] = newVal

            net.Start("FALCON:QUESTS:OBJECTIVE:TOCLIENT")
                net.WriteUInt( questID, 32 )
                net.WriteUInt( obj.Type, 32 )
                net.WriteUInt( currentObject, 32 )

                -- actual value
                net.WriteUInt( newVal, 32 )
            net.Send( ply )
        elseif obj.Type == 2 then

            continue 
        end
    end
end 


hook.Add("OnNPCKilled", "OBJECTIVE_CHECK_1", function( npc, attacker )
    if not attacker:IsPlayer() then return end
    FOBJ_KillUpdate( attacker, npc:GetClass() )
end)