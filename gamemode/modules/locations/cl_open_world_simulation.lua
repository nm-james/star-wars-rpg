Falcon = Falcon or {}
Falcon.ActiveSectors = Falcon.ActiveSectors or {}

hook.Add("Think", "F_CWRP_OPEN_WORLD_SIMULATION", function()
    local ply = LocalPlayer()

    if not ply:Alive() and ply:Health() <= 0 then
        ply.Location = "Venator"
        ply.ShouldResetSurroundings = true
        return
    end

    if ply.ShouldResetSurroundings and ply:Alive() then
        LoadTransportFromPlanets("Venator")
        ply.ShouldResetSurroundings = false
        return
    end

    local t = Falcon.Locations[ply.Location] or {}
    if table.IsEmpty( t ) then return end

    for placeID, place in pairs( t ) do
        local dist = place.pos:Distance( ply:GetPos() )
        if place.isactive then
            if dist <= 3000 then continue end
            print("NOT ACTIVE!")
            net.Start("FALCON:OPENWORLDSIM:DEACTIVATEPASSIVE")
                net.WriteUInt( placeID, 32 )
            net.SendToServer()
            Falcon.ActiveSectors[placeID] = nil
            place.isactive = false
        else
            if dist > 3000 then continue end
            print("ACTIVE!")
            net.Start("FALCON:OPENWORLDSIM:ACTIVATEPASSIVE")
                net.WriteUInt( placeID, 32 )
            net.SendToServer()
            Falcon.ActiveSectors[placeID] = true
            place.isactive = true
        end
    end 
end)