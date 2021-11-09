Falcon = Falcon or {}
Falcon.Classes = Falcon.Classes or {}
Falcon.ResetClassesSync = function()
    Falcon.Classes = sql.Query("SELECT * FROM Classes") or {}
    PrintTable(Falcon.Classes)
    SortNewData( Falcon.Classes )

    Falcon.SyncAllPlayerContent()
end

local function ICS( string )
    return sql.SQLStr(string) .. ", "
end

util.AddNetworkString("FALCON:CLASSES:UPDATE")
net.Receive("FALCON:CLASSES:UPDATE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local class = net.ReadUInt( 32 )
    local t = net.ReadTable()

    local set = "name = " .. ICS(t.newNamae) .. "weapons = " .. ICS( util.TableToJSON( t.newWeapons ) ) .. "health = " .. tostring( t.newHealth ) .. ", armor = " .. tostring( t.newArmor ) .. ", run = " .. tostring( t.newRunspeed ) .. ", engineer = " .. tostring( t.newEngineer ) .. ", medic = " .. tostring( t.newMedic ) .. ", hidden = " .. tostring( t.newHidden ) .. ", description = " .. sql.SQLStr( t.newDescription )
    
    sql.Query( "UPDATE Classes SET " .. set .. " WHERE id = " .. tostring(class) )
    Falcon.ResetClassesSync()
end)

util.AddNetworkString("FALCON:CLASSES:CREATE")
net.Receive("FALCON:CLASSES:CREATE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local name = net.ReadString()

    local classVar = "`name`, `weapons`, `health`, `armor`, `run`, `engineer`, `medic`, `hidden`, `description`"
    local classVals = sql.SQLStr( name ) .. ", '[]', 25, 25, 0, 0, 0, 0, 'Im blue if i turn green i will die'"
    sql.Query("INSERT INTO Classes(" .. classVar .. ") VALUES(" .. classVals .. ")")

    Falcon.ResetClassesSync()
end)

util.AddNetworkString("FALCON:CLASSES:REMOVE")
net.Receive("FALCON:CLASSES:REMOVE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local class = net.ReadUInt( 32 )

    sql.Query("DELETE FROM Classes WHERE id = " .. tostring(class))
    sql.Query("DELETE FROM Classes_Regiments WHERE class = " .. tostring(class))

    Falcon.ResetClassesSync()
    Falcon.ResetRegimentsSync()
end)