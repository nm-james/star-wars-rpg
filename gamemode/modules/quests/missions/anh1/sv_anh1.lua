Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}
Falcon.Quests[1] = {}

Falcon.Quests[1].Requirement = function( ply )
    return true
end

Falcon.Quests[1].Objectives = {
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Needed = 5, Class = "npc_crow", },
    -- { Type = 2, Text = "Kill a Droideka!", Class = "falcon_hostile_cis_droideka", },
    -- { Type = 3, Text = "Move to XYZ", Distance = 500, Position = Vector(3086.245117, -4240.182617, 8197.87695), },
}

