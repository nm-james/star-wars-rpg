Falcon = Falcon or {}

function GM:PlayerSpawn(ply, transition)
    ply:SetPos( Vector( 4097, -5771, 12905 ) )
    ply:SetAngles( Angle( 0, 180, 0 ) )
    ply:SetModel("models/jajoff/sps/alpha/tc13j/coloured_regular02.mdl")
    ply:SetPlayerColor( Vector( 1, 1, 1 ) )
    ply:SetArmor( 750 )
    ply:SetHealth( 500 )
    ply:SetMaxHealth( 500 )
end

function GM:PlayerDeath( ply )
    ply.Location = "Venator"
end