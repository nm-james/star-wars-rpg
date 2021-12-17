Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}
Falcon.Quests[4] = {}

Falcon.Quests[4].Requirement = function( ply )
    return true
end

Falcon.Quests[4].Objectives = {
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    -- { Type = 2, Text = "Kill a Droideka!", Class = "falcon_hostile_cis_droideka", },
    { Type = 3, Text = "Move to XYZ", Distance = 500, Position = Vector(5212.966309, -7011.267090, 8302.141602), Planet = "Naboo" },
}

