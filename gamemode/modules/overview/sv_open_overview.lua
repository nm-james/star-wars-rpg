Falcon = Falcon or {}

util.AddNetworkString("FALCON:OPEN:F4MENU")
function GM:ShowSpare2( ply )
    net.Start("FALCON:OPEN:F4MENU")

    net.Send( ply )
end