Falcon = Falcon or {}

util.AddNetworkString("FALCON:SENDCONTENT")
local function CreateUserID( ply )
    sql.Query("INSERT INTO Users(`steamid`, `inventory`) VALUES('" .. ply:SteamID64() .. "', '" .. util.TableToJSON({equipped = {
        [1] = "DC-15A [LEGENDARY]",
    },
    backpack = {
        {
            pos = { x = 2, y = 5 },
            item = "DC-15A [RARE]",
        },
        {
            pos = { x = 6, y = 2 },
            item = "DC-15S [EPIC]",
        }
    },}) .. "')")
    return Falcon.GetUserID( ply )
end
Falcon.GetUserID = function( ply )
    local res = sql.Query("SELECT id FROM Users WHERE steamid = " .. ply:SteamID64()) or {}

    if not res[1] or not res[1].id then 
        sql.Query("INSERT INTO Users(`steamid`) VALUES('" .. ply:SteamID64() .. "')")
        return Falcon.GetUserID( ply )
    end
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
    [1] = 0,
    [2] = false,
    [3] = false,
    [4] = false,
    [5] = 0,
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
                ply.ActiveQuests[que].Objectives[objID] = types[objective.Type]
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
        tbl.Inventory = Falcon.GetUserInventory( ply )
        local inv = tbl.Inventory.equipped
        if inv[1] then
            local invPrimary = Falcon.Items[Falcon.ItemsIdentifier[inv[1]]]
            ply:SetNWString("FALCON:PRIMARY:WEAPON", invPrimary.swep)
        end
        if inv[2] then
            local invSecondary = Falcon.Items[Falcon.ItemsIdentifier[inv[2]]]
            ply:SetNWString("FALCON:PRIMARY:SECONDARY", invSecondary.swep)
        end

        Falcon.SortQuestStatus( ply, tbl.Quests )
    end

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