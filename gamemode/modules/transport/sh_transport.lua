Falcon = Falcon or {}
Falcon.TransportEntities = Falcon.TransportEntities or {}

Falcon.Transports = {}
Falcon.Transports["Venator"] = {
    Name = "Venator 'Yeeteus'",
    Description = "Yes Commander! I am gay! -Tyza",
    Requirement = function( ply )
        return true
    end,
    Requirements = {
        Level = 1,
        Quests = {},
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.4125,
        y = 0.15,
        skin = 6,
        wallpaper = "f_coop/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Main Hangar",
            Pos = Vector(2539.986572, -5481.141113, 12891.934570),
            Ang = Angle(0, 90, 0),
            Wallpaper = "f_coop/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = { "FIGGER", "LIGMA", "SIGMA" }
            },
            Recommendation = 1,
        },
    }
}

Falcon.Transports["Naboo"] = {
    Name = "Naboo",
    Description = "Where the queen MILF lies.",
    Requirement = function( ply )
        return true
    end,
    Requirements = {
        Level = 1,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.125,
        y = 0.075,
        skin = 8,
        wallpaper = "f_coop/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Theed Hangar",
            Pos = Vector( 2074, -7947, 8325 ),
            Ang = Angle(0, 90, 0),
            Wallpaper = "f_coop/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = { "FIGGER", "LIGMA", "SIGMA" }
            },
            Recommendation = 6,
        },
    }
}

Falcon.Transports["Tatooine"] = {
    Name = "Tatooine",
    Description = "Jabba the hut? More like, Jabba fat fuck?",
    Requirement = function( ply )
        if ply:GetLevel() > 25 then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 25,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.225,
        y = 0.3,
        skin = 13,
        wallpaper = "f_coop/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Main Hangar",
            Pos = Vector(2539.986572, -5481.141113, 12891.934570),
            Ang = Angle(0, 90, 0),
            Wallpaper = "f_coop/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = { "FIGGER", "LIGMA", "SIGMA" }
            },
            Recommendation = 6,
        },
    }
}

Falcon.Transports["Kashyyyk"] = {
    Name = "Kashyyyk",
    Description = "A planet housing teenagers who like to not shave",
    Requirement = function( ply )
        if ply:GetLevel() > 50 then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 50,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.6,
        y = 0.3,
        skin = 7,
        wallpaper = "f_coop/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Main Hangar",
            Pos = Vector(2539.986572, -5481.141113, 12891.934570),
            Ang = Angle(0, 90, 0),
            Wallpaper = "f_coop/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = { "FIGGER", "LIGMA", "SIGMA" }
            },
            Recommendation = 6,
        },
    }
}

Falcon.Transports["Geonosis"] = {
    Name = "Geonosis",
    Description = "A planet full of 'sadgsdghsdh' creatures",
    Requirement = function( ply )
        if ply:GetLevel() > 75 then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 75,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.7,
        y = 0.075,
        skin = 5,
        wallpaper = "f_coop/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Main Hangar",
            Pos = Vector(2539.986572, -5481.141113, 12891.934570),
            Ang = Angle(0, 90, 0),
            Wallpaper = "f_coop/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = { "FIGGER", "LIGMA", "SIGMA" }
            },
            Recommendation = 6,
        },
    }
}
if CLIENT then
    local function RemoveExistingTransports()
        for _, ent in pairs( Falcon.TransportEntities ) do
            if ent and ent:IsValid() then
                ent:Remove()
            end
        end
        Falcon.TransportEntities = {}
    end
    function LoadTransportFromPlanets( planet )
        RemoveExistingTransports()
        local tr = Falcon.Transports[planet].Dropzones
        for _, d in pairs( tr ) do
            local clientModel = ents.CreateClientProp()
            clientModel:SetModel( d.Model or "models/fisher/laat/laat.mdl" )
            clientModel:Spawn()
            clientModel:Activate()
            clientModel:SetPos( d.Pos )
            clientModel:SetAngles( d.Ang )
            clientModel.Interaction = "Use Transport"
            clientModel.FalconClient = true
            clientModel.Dropzone = _
            clientModel.Next = function()
                FadeFrame( function()
                    return OpenNavigation( clientModel )
                end )
            end
    
            table.insert(Falcon.TransportEntities, clientModel)
        end
    end
    LoadTransportFromPlanets("Venator")
else
end

