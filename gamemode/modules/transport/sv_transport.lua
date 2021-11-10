Falcon = Falcon or {}

util.AddNetworkString("FALCON:TRANSPORT:TELEPORT")
net.Receive("FALCON:TRANSPORT:TELEPORT", function( len, ply )
    local id = net.ReadUInt( 32 )

    local place = Falcon.Transports[ply.Location].Dropzones[id].Pos
    if ply:GetPos():DistToSqr( place ) < 55000 then
        local nextLocation = net.ReadString()
        local nextDropzone = net.ReadUInt( 32 )

        local newLoc = Falcon.Transports[nextLocation].Dropzones[nextDropzone]
        ply.Location = nextLocation
        ply:SetPos( newLoc.Pos )
    end
end)