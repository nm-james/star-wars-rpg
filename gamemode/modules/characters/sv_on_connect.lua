Falcon = Falcon or {}

util.AddNetworkString("FALCON:SENDCONTENT")
Falcon.GetUserID = function( ply )
    local res = sql.Query("SELECT id FROM Users WHERE steamid = " .. ply:SteamID64())

    if not res[1] or not res[1].id then return end
    return res[1].id
end


-------------- OBJECTIVE TYPES --------------
-- 1 = KILLING NPCS (TOTAL)
-- 2 = KILLING MAIN NPC
-- 3 = MOVE TO POSITION
-- 4 = PICK UP ITEM
-- 5 = HOLD POSITION
-- 6 = REVIVE DEAD/WOUNDED SOLDIER
-- 7 = DESTROY OBJECTIVE
-- 8 = CAPTURE VIP
-- 9 = DEFEND VIP
-- 10 = TRANSPORT ITEM
-- 11 = DEFEND TRANSPORT
local types = {
    [1] = function()
        return 0
    end,
    [2] = function()
        return false
    end,
    [3] = function()
        return false
    end,
}
Falcon.SortQuestStatus = function( ply, quests )
    for _, q in pairs( quests ) do
        local sts = tonumber(q.status)
        local que = tonumber(q.quest)
        if sts == 1 then
            local quest = Falcon.Quests[que]
            if not quest then continue end
            ply.ActiveQuests[que] = {}
            ply.ActiveQuests[que].Objectives = {}
            ply.ActiveQuests[que].ActiveObjective = 1


            for objID, objective in pairs( quest.Objectives or {} ) do
                if ply.ActiveQuests[que].Objectives[objID] then continue end
                ply.ActiveQuests[que].Objectives[objID] = types[objective.Type]()
            end
        end
    end

    PrintTable(ply.ActiveQuests)
end


local function GetPlayerContentData( ply )
    local tbl = {}
    tbl.Departments = Falcon.Departments
    tbl.Regiments = Falcon.Regiments
    tbl.Classes = Falcon.Classes
    tbl.Items = Falcon.Items
    tbl.Locations = Falcon.Locations
    tbl.NPCs = Falcon.NPCs
    tbl.Quests = {}
    local id = Falcon.GetUserID( ply )
    if id then
        tbl.Quests = sql.Query( "SELECT quest, status FROM Users_Quests WHERE user = " .. id ) or {}

        Falcon.SortQuestStatus( ply, tbl.Quests )
    end

    PrintTable(tbl.Quests)

    return tbl
end


Falcon.SyncAllPlayerContent = function()
    net.Start("FALCON:SENDCONTENT")
        -- net.WriteTable( GetPlayerContentData( ply ) )
    net.Broadcast()
end

Falcon.SyncPlayerContent = function( ply )
    net.Start("FALCON:SENDCONTENT")
        net.WriteTable( GetPlayerContentData( ply ) )
    net.Send( ply )
end

util.AddNetworkString("F:SW:Player:Loaded")
net.Receive("F:SW:Player:Loaded", function( len, ply )
    ply.ActiveQuests = {}
    ply.Location = "Venator"
    Falcon.SyncPlayerContent( ply )
end)