Falcon = Falcon or {}

function GM:PlayerSpawn(ply, transition)
    print(ply, transition)
    ply:SetPos( Vector( 4097, -5771, 12905 ) )
    ply:SetAngles( Angle( 0, 180, 0 ) )
    ply:SetModel("models/jajoff/sps/alpha/tc13j/coloured_regular01.mdl")
    ply:SetPlayerColor( Color( 255, 255, 255 ) )
end