Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}
Falcon.Quests[1] = {}

Falcon.Quests[1].Requirement = function( ply )
    return true
end

Falcon.Quests[1].Objectives = {
    -- { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    -- { Type = 3, Text = "Move to XYZ", Distance = 7500, Position = Vector(3086.245117, -4240.182617, 8197.87695), },
    { Type = 4, Text = "Collect Test", Needed = true, Position = Vector(2526.759521, -6045.755371, 12891.031250) },
    { Type = 5, Text = "Move to XYZ", Distance = 25000, Needed = 30, Position = Vector(2734.254639, -5604.281250, 12950.031250), },

    -- { Type = 2, Text = "Kill a Droideka!", Class = "falcon_hostile_cis_droideka", },
}

