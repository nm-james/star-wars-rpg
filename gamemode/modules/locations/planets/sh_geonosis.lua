Falcon = Falcon or {}

Falcon.Planets[1] = {}
local pln = Falcon.Planets[1]

pln.Name = "Geonosis"
pln.Description = "A Planet Full of 'sadgsdghsdh' Creatures"

pln.Requirement = function( ply )
    return true
end

pln.Requirements = {
    Level = 1,
    Quests = { "FIGGER", "LIGMA" }
}

pln.VGUI = {
    w = 0.175,
    h = 0.175,
    x = 0.225,
    y = 0.31,
    skin = 5,
    wallpaper = "f_coop/navigation/geonosis.jpg"
}

pln.Dropzones = {}

pln.Dropzones[1] = {
    Map = "rp_geonosis",
    Name = "Arena",
    POIs = {
        {
            Name = "Battlefield",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
        {
            Name = "Yeet",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
        {
            Name = "Geets",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
    }, 
    Wallpaper = "f_coop/navigation/geonosis_1.png",
    Requirement = function( ply )
        return false
    end,
    Requirements = {
        Level = 1,
        Quests = { "FIGGER", "LIGMA" }
    },
    Recommendation = 6,
}

pln.Dropzones[2] = {
    Map = "gm_geonosian_canyons",
    Name = "Canyons",
    POIs = {
        {
            Name = "Battlefield",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
        {
            Name = "Battlefield",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
        {
            Name = "Battlefield",
            Distance = 2000,
            Position = Vector( 0, 0, 0 ),
        },
    }, 
    Wallpaper = "f_coop/navigation/geonosis_2.jpg",
    Requirement = function( ply )
        return true
    end,
    Requirements = {
        Level = 1,
        Quests = { "FIGGER", "LIGMA", "SIGMA" }
    },
    Recommendation = 6,
}

pln.Dropzones[3] = {
    Map = "gm_geonosis_plains_b2",
    Name = "Plains",
    Wallpaper = "f_coop/navigation/geonosis_3.jpg",
    Requirement = function( ply )
        return true
    end,
    Recommendation = 6,
}

pln.Dropzones[4] = {
    Map = "geonosis",
    Name = "Unknown (RENAME)",
    Wallpaper = "f_coop/navigation/geonosis_4.jpg",
    Requirement = function( ply )
        return true
    end,
    Requirements = {
        Level = 690,
        Quests = { "FIGGER", "LIGMA", "SIGMA"  }
    },
    Recommendation = 6,
}


