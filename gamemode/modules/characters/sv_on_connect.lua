Falcon = Falcon or {}

util.AddNetworkString("FALCON:SENDCONTENT")
local function GetPlayerContentData()
    local tbl = {}
    tbl.Departments = Falcon.Departments
    tbl.Regiments = Falcon.Regiments
    tbl.Classes = Falcon.Classes
    tbl.Items = Falcon.Items

    return tbl
end
Falcon.SyncAllPlayerContent = function()
    net.Start("FALCON:SENDCONTENT")
        net.WriteTable( GetPlayerContentData() )
    net.Broadcast()
end

Falcon.SyncPlayerContent = function( ply )
    net.Start("FALCON:SENDCONTENT")
        net.WriteTable( GetPlayerContentData() )
    net.Send( ply )
end

util.AddNetworkString("F:SW:Player:Loaded")
net.Receive("F:SW:Player:Loaded", function( len, ply )
    Falcon.SyncPlayerContent( ply )
    ply.Location = "Venator"
end)
