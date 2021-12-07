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
        wallpaper = "pa/navigation/venator.png"
    },
    Dropzones = {
        {
            Name = "Main Hangar",
            Pos = Vector(2539.986572, -5481.141113, 12891.934570),
            Ang = Angle(0, 90, 0),
            Wallpaper = "pa/navigation/venator_1.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = {}
            },
            Recommendation = 1,
        },
    }
}

Falcon.Transports["Naboo"] = {
    Name = "Naboo",
    Description = "Where the queen MILF lies.",
    Requirement = function( ply )
        if (Falcon.Player.Quests[1] and Falcon.Player.Quests[1] >= 1) or Falcon.Player.CompletedQuests[1] then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 1,
        Quests = { "A New Hope [1]" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.125,
        y = 0.075,
        skin = 8,
        wallpaper = "pa/navigation/naboo.jpg"
    },
    Dropzones = {
        {
            Name = "Theed Hangar",
            Pos = Vector( 2074, -7947, 8325 ),
            Ang = Angle(0, 90, 0),
            Wallpaper = "pa/navigation/naboo_1.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 1,
                Quests = {}
            },
            Recommendation = 1,
        },
        {
            Name = "Plains",
            Pos = Vector( -12408, 10238, 8201 ),
            Ang = Angle(0, 45, 0),
            Wallpaper = "pa/navigation/naboo_2.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 5 and (Falcon.Player.Quests[4] and Falcon.Player.Quests[4] >= 1 or Falcon.Player.CompletedQuests[4]) then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 5,
                Quests = { "The Beginning of the Clone Wars" }
            },
            Recommendation = 5,
        },
    }
}


Falcon.Transports["Tatooine"] = {
    Name = "Tatooine",
    Description = "Jabba the hut? More like, Jabba fat fuck?",
    Requirement = function( ply )
        if ply:GetLevel() >= 15 then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 15,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.225,
        y = 0.3,
        skin = 13,
        wallpaper = "pa/navigation/tatooine.jpg"
    },
    Dropzones = {
        {
            Name = "Mos Eisley",
            Pos = Vector( -7575, 10586, 1037 ),
            Ang = Angle(0, 90, 0),
            Wallpaper = "pa/navigation/tatooine_1.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 15,
                Quests = {}
            },
            Recommendation = 15,
        },
        {
            Name = "Hut Palace",
            Pos = Vector( -10167, -9832, 2491 ),
            Ang = Angle(0, -91, 0),
            Wallpaper = "pa/navigation/tatooine_2.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 25,
                Quests = {}
            },
            Recommendation = 25,
        },
        {
            Name = "Canyons",
            Pos = Vector( 8006, 10820, 8 ),
            Ang = Angle(0, -129, 0),
            Wallpaper = "pa/navigation/tatooine_3.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 35,
                Quests = {}
            },
            Recommendation = 35,
        },
        {
            Name = "'Bushes of Love'",
            Pos = Vector( 11953, -10594, 1027 ),
            Ang = Angle(0, 88, 0),
            Wallpaper = "pa/navigation/tatooine_4.jpg",
            Requirement = function( ply )
                return true
            end,
            Requirements = {
                Level = 40,
                Quests = {}
            },
            Recommendation = 40,
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
        wallpaper = "pa/navigation/kashyyyk.jpg"
    },
    Dropzones = {
        {
            Name = "Wookie Village",
            Pos = Vector( 5420, -6096, -5628 ),
            Ang = Angle( 0, 154, 0 ),
            Wallpaper = "pa/navigation/kashyyyk_1.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 55 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 55,
                Quests = {}
            },
            Recommendation = 55,
        },
        {
            Name = "Beach Head",
            Pos = Vector( -9355, -2597, -5628 ),
            Ang = Angle( 0, 137, 0 ),
            Wallpaper = "pa/navigation/kashyyyk_2.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 65 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 65,
                Quests = {}
            },
            Recommendation = 65,
        },
        {
            Name = "Recon Outpost",
            Pos = Vector( 13797, 12146, -4092 ),
            Ang = Angle( 0, -80, 0 ),
            Wallpaper = "pa/navigation/kashyyyk_3.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 70 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 70,
                Quests = {}
            },
            Recommendation = 70,
        },
        {
            Name = "Wilderness",
            Pos = Vector( -11434, 10711, -5117  ),
            Ang = Angle( 0, -142, 0 ),
            Wallpaper = "pa/navigation/kashyyyk_4.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 70 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 75,
                Quests = {}
            },
            Recommendation = 75,
        },
    }
}

Falcon.Transports["Geonosis"] = {
    Name = "Geonosis",
    Description = "A planet full of 'sadgsdghsdh' creatures",
    Requirement = function( ply )
        if ply:GetLevel() > 80 then
            return true
        end
        return false
    end,
    Requirements = {
        Level = 80,
        Quests = { "FIGGER", "LIGMA" },
    },
    VGUI = {
        w = 0.175,
        h = 0.175,
        x = 0.7,
        y = 0.075,
        skin = 5,
        wallpaper = "pa/navigation/geonosis.jpg"
    },
    Dropzones = {
        {
            Name = "Side Hangar",
            Pos = Vector( 11076.782227, -5317.667480, -13302.860352 ),
            Ang = Angle( 0, -163, 0 ),
            Wallpaper = "pa/navigation/geonosis_1.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 80 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 80,
                Quests = {}
            },
            Recommendation = 80,
        },
        {
            Name = "Geonosian Arena",
            Pos = Vector( 2292.819824, 12280.424805, -13312.297852 ),
            Ang = Angle( 0, 10, 0 ),
            Wallpaper = "pa/navigation/geonosis_2.jpg",
            Requirement = function( ply )
                if ply:GetLevel() > 85 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 85,
                Quests = {}
            },
            Recommendation = 85,
        },
        {
            Name = "Point Rain",
            Pos = Vector( -11631.810547, -6640.806641, -13408.952148 ),
            Ang = Angle( 0, -109, 0 ),
            Wallpaper = "pa/navigation/geonosis_3.png",
            Requirement = function( ply )
                if ply:GetLevel() > 85 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 90,
                Quests = {}
            },
            Recommendation = 90,
        },
        {
            Name = "Droid Factory",
            Pos = Vector( -7775.733398, 12190.423828, -15231.632813 ),
            Ang = Angle( 0, 10, 0 ),
            Wallpaper = "pa/navigation/geonosis_4.jpg",
            Spawn = Vector(-8017.041504, 12161.426758, -15151.968750),
            Requirement = function( ply )
                if ply:GetLevel() > 100 then
                    return true
                end
                return false
            end,
            Requirements = {
                Level = 100,
                Quests = {}
            },
            Recommendation = 100,
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
            clientModel.InteractDistance = 50000
            clientModel.Next = function()
                FadeFrame( function()
                    return OpenNavigation( clientModel )
                end )
            end
            table.insert(Falcon.TransportEntities, clientModel)
        end
    end
else
end

