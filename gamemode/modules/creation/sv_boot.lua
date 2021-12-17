Falcon = Falcon or {}

local function SQLInitialize()
    sql.Query([[CREATE TABLE IF NOT EXISTS Users
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            steamid TEXT,
            inventory TEXT
        ) 
    ]])
    print("Users: ", sql.TableExists("Users"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Departments
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            ranks TEXT
        ) 
    ]])
    print("Departments: ", sql.TableExists("Departments"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Regiments
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            abbreviation TEXT,
            model TEXT,
            color TEXT,
            loadouts TEXT,
            description TEXT,
            department NUMBER,
            hidden BOOLEAN,
            faction NUMBER
        ) 
    ]])
    print("Regiments: ", sql.TableExists("Regiments"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Classes
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            weapons TEXT,
            health NUMBER,
            armor NUMBER,
            run NUMBER,
            engineer BOOLEAN,
            medic BOOLEAN,
            hidden BOOLEAN,
            description TEXT
        ) 
    ]])
    print("Classes: ", sql.TableExists("Classes"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Items
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT,
            type NUMBER,
            health NUMBER,
            armor NUMBER,
            stamina NUMBER,
            bulletprotection NUMBER,
            fireprotection NUMBER,
            fallprotection NUMBER,
            blastprotection NUMBER,
            poisonprotection NUMBER,
            damage NUMBER,
            firerate NUMBER,
            function TEXT,
            minrarity NUMBER,
            maxrarity NUMBER
        ) 
    ]])
    print("Items: ", sql.TableExists("Items"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Classes_Regiments
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            class NUMBER,
            regiment NUMBER,
            model TEXT
        ) 
    ]])
    print("Class Regiments: ", sql.TableExists("Classes_Regiments"))

    sql.Query([[CREATE TABLE IF NOT EXISTS Users_Quests
        (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            quest NUMBER,
            status NUMBER,
            user NUMBER
        ) 
    ]])
    print("User Quests: ", sql.TableExists("Users_Quests"))

    print("SWRP Database has been connected!")

    -- Ranks
    Falcon.Departments = sql.Query("SELECT * FROM Departments") or {}
    SortNewData( Falcon.Departments )
    
    Falcon.Regiments = sql.Query("SELECT * FROM Regiments") or {}
    for id, reg in pairs( Falcon.Regiments ) do
        local c = sql.Query("SELECT * FROM Classes_Regiments WHERE regiment = " .. reg.id ) or {}
        reg.classes = c
        team.SetUp( id, reg.Name, util.JSONToTable(reg.color) )
    end 
    SortNewData( Falcon.Regiments )

    Falcon.Classes = sql.Query("SELECT * FROM Classes") or {}
    SortNewData( Falcon.Classes )

    Falcon.Items = sql.Query("SELECT * FROM Items") or {}
    SortNewData( Falcon.Items )
end

-- sql.Query("DROP TABLE Users")
-- PrintTable(sql.Query( "SELECT * FROM Users_Quests"))
-- SQLInitialize()

-- sql.Query("DELETE FROM Classes_Regiments")
-- sql.Query("DROP TABLE Items")

hook.Add("Initialize", "F_SQL_INIT", SQLInitialize)
