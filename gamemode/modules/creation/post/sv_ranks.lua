Falcon = Falcon or {}
Falcon.Departments = Falcon.Departments or {}

Falcon.CreateNewDepartment = function( name )
    sql.Query("INSERT INTO Departments(`name`, `ranks`) VALUES(" .. sql.SQLStr(name) .. ", " .. sql.SQLStr("[]") .. ")")
    Falcon.Departments = sql.Query("SELECT * FROM Departments") or {}
end

Falcon.GetConvertedRanks = function( department )
    local curRanks = Falcon.Departments[department].ranks
    return curRanks
end

Falcon.SaveDepartmentRanks = function( department, tableOfRanks )
    sql.Query("UPDATE Departments SET ranks = " .. sql.SQLStr(util.TableToJSON(tableOfRanks) or {}) .. " WHERE id = " .. tostring(Falcon.Departments[department].id) )
    Falcon.Departments[department].ranks = util.TableToJSON(tableOfRanks)
    SortNewData( Falcon.Departments )

    Falcon.SyncAllPlayerContent()
end

Falcon.AddRankToDepartment = function( department, newRank )
    local convertedRanks = Falcon.GetConvertedRanks( department )
    local count = table.Count( convertedRanks )

    convertedRanks[count + 1] = newRank
    Falcon.SaveDepartmentRanks( department, convertedRanks )
end

Falcon.ShiftRankStructure = function( department, curRank, otherRank )
    local convertedRanks = Falcon.GetConvertedRanks( department )

    local curR = convertedRanks[curRank]
    local otherR = convertedRanks[otherRank]

    convertedRanks[curRank] = otherR
    convertedRanks[otherRank] = curR

    Falcon.SaveDepartmentRanks( department, convertedRanks )
end

Falcon.DeleteRank = function( department, rankToBeDeleted )
    local convertedRanks = Falcon.GetConvertedRanks( department )
    table.remove(convertedRanks, rankToBeDeleted)
    Falcon.SaveDepartmentRanks( department, convertedRanks )
end

Falcon.DeleteDepartment = function( department )
    sql.Query( "DELETE FROM Departments WHERE id = " .. tostring(Falcon.Departments[department].id) )
    table.remove(Falcon.Departments, department)
    Falcon.SyncAllPlayerContent()
end

util.AddNetworkString("FALCON:DEPARTMENTS:CREATE")
net.Receive("FALCON:DEPARTMENTS:CREATE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local namae = net.ReadString()
    Falcon.CreateNewDepartment( namae )
    SortNewData( Falcon.Departments )
    Falcon.SyncAllPlayerContent()
end)

util.AddNetworkString("FALCON:DEPARTMENTS:DELETE")
net.Receive("FALCON:DEPARTMENTS:DELETE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local department = net.ReadUInt( 32 )
    Falcon.DeleteDepartment( department )
end)

util.AddNetworkString("FALCON:DEPARTMENTS:ADDRANK")
net.Receive("FALCON:DEPARTMENTS:ADDRANK", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local department = net.ReadUInt( 32 )
    local newRank = net.ReadTable()
    Falcon.AddRankToDepartment( department, newRank )
end)


util.AddNetworkString("FALCON:DEPARTMENTS:DELETERANK")
net.Receive("FALCON:DEPARTMENTS:DELETERANK", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local department = net.ReadUInt( 32 )
    local rank = net.ReadUInt( 32 )
    Falcon.DeleteRank( department, rank )
end)


util.AddNetworkString("FALCON:DEPARTMENTS:UPRANK")
net.Receive("FALCON:DEPARTMENTS:UPRANK", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local department = net.ReadUInt( 32 )
    local curRank = net.ReadUInt( 32 )
    Falcon.ShiftRankStructure( department, curRank, curRank + 1 )
end)

util.AddNetworkString("FALCON:DEPARTMENTS:DOWNRANK")
net.Receive("FALCON:DEPARTMENTS:DOWNRANK", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local department = net.ReadUInt( 32 )
    local curRank = net.ReadUInt( 32 )
    Falcon.ShiftRankStructure( department, curRank, curRank - 1 )
end)

