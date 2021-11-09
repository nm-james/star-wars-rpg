Falcon = Falcon or {}

Falcon.Planets[2] = {}
local pln = Falcon.Planets[2]

pln.Name = "Coruscant"
pln.Description = "A Fictional New York"

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
    x = 0.6,
    y = 0.31,
    skin = 14,
}

pln.Dropzones = {}