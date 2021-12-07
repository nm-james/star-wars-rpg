Falcon = Falcon or {}

local delay = 0
hook.Add("Think", "RemovePlayersWhoArentNear", function()
    if delay > CurTime() then return end
    local p = player.GetAll()

    for place, location in pairs( Falcon.Locations ) do
        for placeID, ply in pairs( location.players or {} ) do
            if ply:GetPos():Distance( location.pos ) > 3100 then
                table.remove( location.players, placeID )
                if #location.players <= 0 then
                    -- Remove NPCs
                    location.cache = location.cache or {}
                    local cache = location.cache or {}

                    location.npcEnts = location.npcEnts or {}
                    local npcs = location.npcEnts or {}

                    for _, npc in pairs( npcs ) do
                        if not npc or not IsValid( npc ) then continue end
                        local t = {
                            pos = npc:GetPos(),
                            ang = npc:GetAngles(),
                            hp = npc:Health(),
                            level = npc.Level,
                            mods = npc.Mods,
                            class = npc:GetClass()
                        }
                        table.insert(location.cache, t)
                        npc:Remove()
                    end

                end
            end
        end
    end

    print("CHECKING LOCATIONS")

    delay = CurTime() + 10
end)

util.AddNetworkString("FALCON:OPENWORLDSIM:ACTIVATEPASSIVE")
util.AddNetworkString("FALCON:OPENWORLDSIM:DEACTIVATEPASSIVE")

net.Receive("FALCON:OPENWORLDSIM:ACTIVATEPASSIVE", function( len, ply )
    local l = Falcon.Locations[ply.Location]
    if not l then return end
    local passivePlaceID = net.ReadUInt( 32 )
    
    local newLocation = l[passivePlaceID]
    if newLocation.pos:Distance( ply:GetPos() ) > 3100 then return end
    
    newLocation.players = newLocation.players or {}

    if table.HasValue(newLocation.players, ply) then return end

    table.insert( newLocation.players, ply )
    PrintTable(newLocation.players)

    if newLocation.isactive then return end
    newLocation.cache = newLocation.cache or {}
    local cache = newLocation.cache or {}

    newLocation.npcEnts = newLocation.npcEnts or {}
    local npcs = newLocation.npcEnts or {}
    -- Spawn Passive NPCs

    if #cache == 0 then
        if not newLocation.delay or newLocation.delay < CurTime() then
            local amountofNPCs = math.random( newLocation.npcs.spawns.min, newLocation.npcs.spawns.max )
            for i = 1, amountofNPCs do
                local npcClass = newLocation.npcs.classes[math.random(1, #newLocation.npcs.classes)]
                local ent = ents.Create( npcClass )
                ent:SetPos( newLocation.pos + (Vector( math.random(-600, 600), math.random(-600, 600), 0 )) )
                ent:SetAngles( Angle( 0, math.random(-180, 180), 0 ) )
                ent.Level = math.random( newLocation.npcs.levels.min, newLocation.npcs.levels.max )
                ent.Location = ply.Location
                ent.LocationIndex = passivePlaceID
                ent:Spawn()
                table.insert(newLocation.npcEnts, ent)
            end
        end
    else
        for _, npcData in pairs( cache ) do
            local en = ents.Create(npcData.class)
            en:SetPos( npcData.pos )
            en:SetAngles( npcData.ang )
            en.Level = npcData.level
            en.Mods = npcData.mods
            en.Location = ply.Location
            en.LocationIndex = passivePlaceID
            en:Spawn()
            en:SetHealth( npcData.hp )
            table.insert( newLocation.npcEnts, en )
        end
        newLocation.cache = {}
    end


    newLocation.isactive = true
end)

net.Receive("FALCON:OPENWORLDSIM:DEACTIVATEPASSIVE", function( len, ply )
    local l = Falcon.Locations[ply.Location]
    if not l then return end
    local passivePlaceID = net.ReadUInt( 32 )
    
    local newLocation = l[passivePlaceID]
    if newLocation.pos:Distance( ply:GetPos() ) <= 2900 then return end

    newLocation.players = newLocation.players or {}
    if not table.HasValue(newLocation.players, ply) then return end
    PrintTable(newLocation.players)

    table.RemoveByValue( newLocation.players, ply )

    if #newLocation.players > 0 then return end

    for _, npc in pairs( newLocation.npcEnts ) do
        if not npc or not IsValid( npc ) then continue end
        local t = {
            pos = npc:GetPos(),
            ang = npc:GetAngles(),
            hp = npc:Health(),
            level = npc.Level,
            mods = npc.Mods,
            class = npc:GetClass()
        }
        table.insert(newLocation.cache, t)
        npc:Remove()
    end

    newLocation.npcEnts = {}
    newLocation.isactive = false
end)