
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
Falcon = Falcon or {}
Falcon.CanCreate = {
    ["superadmin"] = true
}


hook.Add("PlayerSay", "TESTINGTEXT", function( ply, text )

    if text == "/bone" then
        Falcon.GetUserID( ply )
    end

    if text == "/model" then
        ply:SetNoDraw( false )
    end
end)

function GM:PlayerDisconnected( ply )
    file.Write("te.txt", "")
end

