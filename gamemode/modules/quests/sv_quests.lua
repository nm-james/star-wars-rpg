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


-- Objective Type 3/4/5INIT
util.AddNetworkString("FALCON:QUESTS:OBJECTIVE:3")
net.Receive("FALCON:QUESTS:OBJECTIVE:3", function( len, ply )
    local quest = net.ReadInt( 32 )
    local currentObject = ply.ActiveQuests[quest].ActiveObjective
    ply.ActiveQuests[quest].Objectives[currentObject] = true
    local value = ply.ActiveQuests[quest].Objectives[currentObject]
    local objData = Falcon.Quests[quest].Objectives[currentObject]
    if objData.Planet and objData.Planet ~= ply.Location then return false end
    if objData.Type == 3 and ply:GetPos():DistToSqr( objData.Position ) > (objData.Distance or 25000) or objData.Type == 4 and ply:GetPos():DistToSqr( objData.Position ) > 15000 then return false end
    if objData.Type == 5 and ply:GetPos():DistToSqr( objData.Position ) <= (objData.Distance or 25000) then
        ply.ActiveQuests[quest].Objectives[currentObject] = CurTime() + objData.Needed
        return
    end
    ply.ActiveQuests[quest].ActiveObjective = math.Clamp(ply.ActiveQuests[quest].ActiveObjective + 1, 0, #ply.ActiveQuests[quest].Objectives)

    net.Start("FALCON:QUESTS:OBJECTIVE:TOCLIENT")
        net.WriteUInt( quest, 32 )
        net.WriteUInt( objData.Type, 32 )
        net.WriteUInt( currentObject, 32 )
        net.WriteBool( true )
    net.Send( ply )
end)

-- Objective Type 5POST
util.AddNetworkString("FALCON:QUESTS:OBJECTIVE:5")
net.Receive("FALCON:QUESTS:OBJECTIVE:5", function( len, ply )
    local quest = net.ReadInt( 32 )
    local currentObject = ply.ActiveQuests[quest].ActiveObjective
    local value = ply.ActiveQuests[quest].Objectives[currentObject]
    local objData = Falcon.Quests[quest].Objectives[currentObject]
    
    -- CHECK WHETHER OBJ HAS BEEN SECURED OR HELD
    if value > CurTime() then return end

    ply.ActiveQuests[quest].ActiveObjective = math.Clamp(ply.ActiveQuests[quest].ActiveObjective + 1, 0, #ply.ActiveQuests[quest].Objectives)
    
    net.Start("FALCON:QUESTS:OBJECTIVE:TOCLIENT")
        net.WriteUInt( quest, 32 )
        net.WriteUInt( objData.Type, 32 )
        net.WriteUInt( currentObject, 32 )
    net.Send( ply )
end)
-- add a player death hook to reset