Falcon = Falcon or {}
Falcon.Regiments = Falcon.Regiments or {}

Falcon.GetRegimentDepartmentKey = function( darpartmentName )
    for id, d in pairs( Falcon.Departments ) do
        if string.lower(d.Name) == string.lower(darpartmentName) then
            return id
        end
    end
end
Falcon.GetRegimentDepartmentID = function( darpartmentName )
    for _, d in pairs( Falcon.Departments ) do
        if string.lower(d.name) == string.lower(darpartmentName) then
            return tonumber( d.id )
        end
    end
end
Falcon.ResetRegimentsSync = function()
    Falcon.Regiments = sql.Query("SELECT * FROM Regiments") or {}
    for id, reg in pairs( Falcon.Regiments ) do
        local c = sql.Query("SELECT * FROM Classes_Regiments WHERE regiment = " .. reg.id ) or {}
        reg.classes = c
        team.SetUp( id, reg.Name, util.JSONToTable(reg.color) )
    end 
    SortNewData( Falcon.Regiments )

    Falcon.SyncAllPlayerContent()
end

local function ICS( string )
    return sql.SQLStr(string) .. ", "
end

Falcon.CreateRegiment = function( name, abbreviation, department )
    local dep = tonumber(Falcon.Departments[department].id)
    local niggas = "`name`, `abbreviation`, `model`, `color`, `loadouts`, `description`, `department`, `hidden`, `faction`"

    local loadouts = {
        [1] = {
            run = 200,
            health = 100,
            armor = 0,
            model = "models/player/Group03/male_01.mdl",
            weapons = {},
        },
        [2] = {
            run = 200,
            health = 100,
            armor = 0,
            model = "models/player/Group03/male_01.mdl",
            weapons = {},
        },
        [3] = {
            run = 200,
            health = 100,
            armor = 0,
            model = "models/player/Group03/male_01.mdl",
            weapons = {},
        },
        [4] = {
            run = 200,
            health = 100,
            armor = 0,
            model = "models/player/Group03/male_01.mdl",
            weapons = {},
        },
        [5] = {
            run = 200,
            health = 100,
            armor = 0,
            model = "models/player/Group03/male_01.mdl",
            weapons = {},
        },
    }

    local chinks = ICS(name) .. ICS(abbreviation) .. ICS("models/player/Group03/male_01.mdl") .. ICS(util.TableToJSON(Color(255, 255, 255))) .. ICS(util.TableToJSON(loadouts)) ..  ICS("DESCRIPTION! : " .. name) .. ICS(dep) .. ICS(0) .. sql.SQLStr(tostring(1))
    local str = "INSERT INTO Regiments( " .. niggas .. " ) VALUES( " .. chinks .. " )"
    sql.Query(str)


    Falcon.ResetRegimentsSync()
end

-- sql.Query("DELETE FROM Regiments")
-- sql.Query("DROP TABLE Regiments")
-- Falcon.CreateRegiment( "TEST", "T", "Airforce" ) 
util.AddNetworkString("FALCON:REGIMENTS:CREATE")
net.Receive("FALCON:REGIMENTS:CREATE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local namae = net.ReadString()
    local abr = net.ReadString()
    local department = net.ReadUInt( 32 )

    Falcon.CreateRegiment( namae, abr, department )
end)

util.AddNetworkString("FALCON:REGIMENTS:REMOVE")
net.Receive("FALCON:REGIMENTS:REMOVE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local id = net.ReadUInt( 32 )
    sql.Query( "DELETE FROM Regiments WHERE id = " .. sql.SQLStr(id) )
    Falcon.ResetRegimentsSync()
end)

util.AddNetworkString("FALCON:REGIMENTS:SAVEINFO")
net.Receive("FALCON:REGIMENTS:SAVEINFO", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local regiment = net.ReadUInt( 32 )
    local newInfo = net.ReadTable()

    local regId = tonumber( Falcon.Regiments[regiment].id ) or 1

    local valuesChangable = "`name`, `abbreviation`, `color`, `description`, `hidden`"

    local nextName = "name = " .. ICS(newInfo.newName) .. "abbreviation = " .. ICS(newInfo.newAbbreviation) .. "color = " .. ICS(util.TableToJSON(newInfo.newRegColor)) .. "description = " .. ICS(newInfo.newDescription) .. "hidden = " .. sql.SQLStr(newInfo.newHiddenSwitch)

    sql.Query( "UPDATE Regiments SET " .. nextName .. " WHERE id = " .. sql.SQLStr(regId) )
    Falcon.ResetRegimentsSync()
end)

util.AddNetworkString("FALCON:REGIMENTS:SAVECLEARANCE")
net.Receive("FALCON:REGIMENTS:SAVECLEARANCE", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local regiment = net.ReadUInt( 32 )
    local clearance = net.ReadUInt( 32 )
    local clearanceLoadout = net.ReadTable()

    local reg = Falcon.Regiments[regiment]
    local regId = tonumber( reg.id ) or 1
    local loadouts = reg.loadouts
    local loadout = loadouts[clearance]
    loadout.run = clearanceLoadout.newRunspeed
    loadout.health = clearanceLoadout.newHealth
    loadout.model = clearanceLoadout.newModel
    loadout.armor = clearanceLoadout.newArmor
    loadout.weapons = clearanceLoadout.newWeapons

    local updatedLoadout = util.TableToJSON( loadouts )


    sql.Query( "UPDATE Regiments SET loadouts = '" .. updatedLoadout .. "' WHERE id = " .. sql.SQLStr(regId) )
    if clearance == 1 then
        sql.Query( "UPDATE Regiments SET model = '" .. clearanceLoadout.newModel .. "' WHERE id = " .. sql.SQLStr(regId) )
    end

    Falcon.ResetRegimentsSync()
end)

util.AddNetworkString("FALCON:REGIMENT:ADDCLASS")
net.Receive("FALCON:REGIMENT:ADDCLASS", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local regiment = net.ReadUInt( 32 )
    local class = net.ReadUInt( 32 )
    local model = net.ReadString()

    sql.Query("INSERT INTO Classes_Regiments(`class`, `regiment`, `model`) VALUES(" .. tostring(class) .. ", " .. tostring(regiment) .. ", '" .. model .. "')")
    Falcon.ResetRegimentsSync()
end)

util.AddNetworkString("FALCON:REGIMENT:UPDATECLASS")
net.Receive("FALCON:REGIMENT:UPDATECLASS", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local regiment = net.ReadUInt( 32 )
    local class = net.ReadUInt( 32 )
    local model = net.ReadString()

    sql.Query("UPDATE Classes_Regiments SET model = '" .. model .. "' WHERE regiment = " .. tostring(regiment) .. " AND class = " .. tostring(class))
    Falcon.ResetRegimentsSync()
end)

util.AddNetworkString("FALCON:REGIMENT:REMOVECLASS")
net.Receive("FALCON:REGIMENT:REMOVECLASS", function( len, ply )
    if not Falcon.CanCreate[ply:GetUserGroup()] then return end
    local regiment = net.ReadUInt( 32 )
    local class = net.ReadUInt( 32 )

    sql.Query("DELETE FROM Classes_Regiments WHERE regiment = " .. tostring(regiment) .. " AND class = " .. tostring(class))
    Falcon.ResetRegimentsSync()
end)