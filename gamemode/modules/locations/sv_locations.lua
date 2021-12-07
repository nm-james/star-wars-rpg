Falcon = Falcon or {}
Falcon.Locations = {}

Falcon.Locations["Venator"] = {}
Falcon.Locations["Naboo"] = {}
Falcon.Locations["Tatooine"] = {}
Falcon.Locations["Kashyyyk"] = {}
Falcon.Locations["Geonosis"] = {}

Falcon.RegisterNPCLocation = function( planet, name, details )
    local cD = details
    cD.name = name

    local c = table.Count(Falcon.Locations[planet]) + 1
    Falcon.Locations[planet][c] = cD
end

local l = Falcon.RegisterNPCLocation

-- TATOOINE LOOOOL IF YOURE READING THIS, FUCK OFF <3
-- CANYONS
l( "Tatooine", "Canyons 1", {
    pos = Vector( 12017, 8950, 2 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy"},
        spawns = { min = 3, max = 8 },
        levels = { max = 40, min = 60 },
    },
} )
l( "Tatooine", "Canyons 2", {
    pos = Vector( 11759, 2291, 8 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard"},
        spawns = { min = 4, max = 4 },
        levels = { max = 50, min = 75 },
    },
} )
l( "Tatooine", "Canyons 3", {
    pos = Vector( 10274, 5615, 1023 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 2, max = 4 },
        levels = { max = 40, min = 75 },
    },
} )
l( "Tatooine", "Canyons 4", {
    pos = Vector( 4233, 2099, 1293 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 3, max = 6 },
        levels = { max = 35, min = 65 },
    },
} )
l( "Tatooine", "Canyons 5", {
    pos = Vector( 4153.179688, 8095.271973, 1450.54846 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 6 },
        levels = { max = 35, min = 70 },
    },
} )




-- BUSHES OF LOVE
l( "Tatooine", "BOL 1", {
    pos = Vector( 4895.153320, -3777.198730, 1027.607422 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_heavy", "falcon_hostile_cis_b1_engineer"},
        spawns = { min = 3, max = 6 },
        levels = { max = 45, min = 65 },
    },
} )
l( "Tatooine", "BOL 2", {
    pos = Vector( 5063.757324, -10999.504883, 1042.814941 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard", "falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 6 },
        levels = { max = 55, min = 75 },
    },
} )
l( "Tatooine", "BOL 3", {
    pos = Vector( 9086.458984, -8696.251953, 1034.814209 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard"},
        spawns = { min = 2, max = 4 },
        levels = { max = 55, min = 75 },
    },
} )
l( "Tatooine", "BOL 4", {
    pos = Vector( 11165.947266, -4467.182617, 1026.702148 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 4 },
        levels = { max = 40, min = 65 },
    },
} )
l( "Tatooine", "BOL 5", {
    pos = Vector( 13231.144531, -5946.216797, 2125.778076 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_sniper"},
        spawns = { min = 3, max = 3 },
        levels = { max = 40, min = 65 },
    },
} )



-- HUTT PALACE
l( "Tatooine", "Hutt Palace 1", {
    pos = Vector( -4196.868652, -10939.186523, 2065.612305 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard", "falcon_hostile_cis_b1"},
        spawns = { min = 6, max = 6 },
        levels = { max = 25, min = 45 },
    },
} )
l( "Tatooine", "Hutt Palace 2", {
    pos = Vector( -11368.685547, -5538.133789, 2382.177002 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_engineer", "falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 9 },
        levels = { max = 25, min = 40 },
    },
} )
l( "Tatooine", "Hutt Palace 3", {
    pos = Vector( -6811.781250, -11315.818359, 3519.021484 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_sniper"},
        spawns = { min = 1, max = 2 },
        levels = { max = 30, min = 55 },
    },
} )
l( "Tatooine", "Hutt Palace 4", {
    pos = Vector( -2878.897705, -4900.929199, 1913.109375 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 5, max = 8 },
        levels = { max = 25, min = 35 },
    },
} )
l( "Tatooine", "Hutt Palace 5", {
    pos = Vector( -10234.046875, -2075.154541, 2743.951172 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_sniper"},
        spawns = { min = 1, max = 2 },
        levels = { max = 30, min = 55 },
    },
} )

l( "Tatooine", "Wilderness 1", {
    pos = Vector( -2145.521240, -815.464478, 1268.851807 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 1, max = 6 },
        levels = { max = 30, min = 55 },
    },
} )
l( "Tatooine", "Wilderness 2", {
    pos = Vector( -7309.622070, 1277.829956, 1265.901245 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy"},
        spawns = { min = 1, max = 6 },
        levels = { max = 30, min = 55 },
    },
} )
l( "Tatooine", "Wilderness 3", {
    pos = Vector( -11844.552734, 2572.627930, 1088.031250 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_engineer"},
        spawns = { min = 1, max = 6 },
        levels = { max = 30, min = 55 },
    },
} )


-- WHALECUM TO THE JUNGLE BISH
l( "Kashyyyk", "Beach Head 1", {
    pos = Vector( -12910.498047, 1469.332764, -5092.982422 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 6, max = 8 },
        levels = { max = 65, min = 90 },
    },
} )
l( "Kashyyyk", "Beach Head 2", {
    pos = Vector( -7848.226074, 227.413818, -5625.096680 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy"},
        spawns = { min = 4, max = 6 },
        levels = { max = 65, min = 100 },
    },
} )
l( "Kashyyyk", "Beach Head 3", {
    pos = Vector( -8717.287109, 4688.720703, -5594.726563 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1","falcon_hostile_cis_droideka"},
        spawns = { min = 2, max = 4 },
        levels = { max = 75, min = 95 },
    },
} )




l( "Kashyyyk", "Forest 1", {
    pos = Vector( -6719.610840, 8406.721680, -5521.832520 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1","falcon_hostile_cis_droideka"},
        spawns = { min = 2, max = 4 },
        levels = { max = 80, min = 110 },
    },
} )
l( "Kashyyyk", "Forest 2", {
    pos = Vector( -4229.903809, 11134.888672, -5577.457031 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_engineer", "falcon_hostile_cis_b1_heavy"},
        spawns = { min = 6, max = 10 },
        levels = { max = 85, min = 105 },
    },
} )
l( "Kashyyyk", "Forest 3", {
    pos = Vector( -13385.079102, 6612.369629, -5435.924805 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard"},
        spawns = { min = 2, max = 3 },
        levels = { max = 90, min = 115 },
    },
} )
l( "Kashyyyk", "Forest 4", {
    pos = Vector( -4338.983887, -2144.060791, -5621.089355 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_sniper"},
        spawns = { min = 2, max = 3 },
        levels = { max = 70, min = 85 },
    },
} )
l( "Kashyyyk", "Forest 5", {
    pos = Vector( -4790.575684, -100.867279, -5592.292480 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_engineer", "falcon_hostile_cis_b1_heavy", "falcon_hostile_cis_b2"},
        spawns = { min = 2, max = 4 },
        levels = { max = 70, min = 90 },
    },
} )
l( "Kashyyyk", "Forest 6", {
    pos = Vector( 541.801453, 10619.078125, -5398.210938 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b2"},
        spawns = { min = 1, max = 2 },
        levels = { max = 75, min = 150 },
    },
} )
l( "Kashyyyk", "Forest 7", {
    pos = Vector( 3209.460449, 12658.174805, -5109.153809 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1_engineer"},
        spawns = { min = 1, max = 4 },
        levels = { max = 75, min = 90 },
    },
} )


l( "Kashyyyk", "Wookie Village 1", {
    pos = Vector( 4083.014160, -2211.315430, -5475.384277 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b2"},
        spawns = { min = 2, max = 4 },
        levels = { max = 55, min = 80 },
    },
} )
l( "Kashyyyk", "Wookie Village 2", {
    pos = Vector( 1857.767578, -4214.435059, -5626.120117 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy", "falcon_hostile_cis_b1_engineer"},
        spawns = { min = 5, max = 6 },
        levels = { max = 55, min = 65 },
    },
} )
l( "Kashyyyk", "Wookie Village 3", {
    pos = Vector( 13090.884766, -7657.992188, -5383.674805 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard", "falcon_hostile_cis_droideka"},
        spawns = { min = 1, max = 2 },
        levels = { max = 65, min = 75 },
    },
} )
l( "Kashyyyk", "Wookie Village 4", {
    pos = Vector( 1213.949219, 3148.560791, -5174.323730 ),
    npcs = { 
        classes = {"falcon_hostile_cis_magna_guard", "falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 4 },
        levels = { max = 60, min = 70 },
    },
} )
l( "Kashyyyk", "Wookie Village 5", {
    pos = Vector( -2761.506592, 5527.596191, -5611.278809 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 4 },
        levels = { max = 70, min = 85 },
    },
} )

l( "Kashyyyk", "Recon Outpost 1", {
    pos = Vector( 10240.472656, 10074.618164, -4068.654297 ),
    npcs = { 
        classes = {"falcon_hostile_cis_droideka"},
        spawns = { min = 1, max = 3 },
        levels = { max = 70, min = 95 },
    },
} )
l( "Kashyyyk", "Recon Outpost 2", {
    pos = Vector( 13471.408203, 8828.329102, -4074.027344 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy", "falcon_hostile_cis_b1_sniper"},
        spawns = { min = 4, max = 4 },
        levels = { max = 65, min = 85 },
    },
} )

l( "Kashyyyk", "Outpost 1", {
    pos = Vector( 11126.456055, 4593.889648, -4031.978760 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b2", "falcon_hostile_cis_b1_sniper"},
        spawns = { min = 4, max = 4 },
        levels = { max = 80, min = 105 },
    },
} )
l( "Kashyyyk", "Outpost 2", {
    pos = Vector( 13526.792969, 195.544769, -4031.098389 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1"},
        spawns = { min = 4, max = 6 },
        levels = { max = 75, min = 110 },
    },
} )
l( "Kashyyyk", "Outpost 3", {
    pos = Vector( 10420.906250, -1365.886230, -4031.968750 ),
    npcs = { 
        classes = {"falcon_hostile_cis_b1", "falcon_hostile_cis_b1_heavy"},
        spawns = { min = 4, max = 6 },
        levels = { max = 75, min = 100 },
    },
} )
