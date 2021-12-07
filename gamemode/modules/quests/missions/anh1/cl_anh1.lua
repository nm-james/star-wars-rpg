Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}
Falcon.Quests[1] = {}

Falcon.Quests[1].Name = "A New Hope [1]"
Falcon.Quests[1].QuestHolder = "Civil Worker 'Deez'"
Falcon.Quests[1].Requirement = function( ply )
    return true
end

Falcon.Quests[1].Objectives = {
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Value = 0, Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Value = 0, Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Value = 0, Needed = 5, Class = "npc_crow", },
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Value = 0, Needed = 5, Class = "npc_crow", },
    -- { Type = 2, Text = "Kill a Droideka!", Value = false, Needed = true, Class = "falcon_hostile_cis_droideka", },
    -- { Type = 3, Text = "Move to XYZ", Value = false, Needed = true, Distance = 500, Position = Vector(3086.245117, -4240.182617, 8197.87695), },
}


Falcon.Quests[1].Start = {}
Falcon.Quests[1].Start.Participants = {
    {
        Name = "Civil Worker 'Deez'",
        Model = "models/jajoff/sps/republic/tc13j/rsb03_female.mdl",
        Pos = Vector(3834.445313, -6037.992676, 12897.518555),
        Ang = Angle(0, 90, 0),
    },
    {
        Name = "PLAYER",
        Pos = Vector(3829.944824, -5958.208008, 12898.490234),
        Ang = Angle(0, -90, 0),
    }
}
Falcon.Quests[1].Start.Dialogue = {
    {
        {
            Text="Welcome trooper! My name is 'Deez'. Nice to meet ya! I'm a Civil Worker, but I will be guiding you through this corrupt and evil universe we live in.", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(3833.606445, -6001.706543, 12961.226563),Angle(11, -89.793549, 0)}, 
                To={Vector(3833.606445, -6001.706543, 12961.226563),Angle(11, -89.793549, 0)},
                Speed=1
            }
        },
        {
            Text="For starters, have you undergone any battle experience? (Have you been trained before?)", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(2367.992188, -5675.25195, -5548.742188),Angle(5, 63, 0)}, 
                To={Vector(-1575.550293, -5053.660645, -3624.685547),Angle(30, 141, 0)},
                Speed=0.2
            }
        },
    },
    {
        {
            Text="Regardless, just know that you will be seeing alot of action and combat, so I suggest you keep up to scratch with your physical abilities.", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(-6395.968262, -1228.012817, -9311.992188),Angle(36.173794, 70.995239, 0.000000)}, 
                To={Vector(6117.527832, -1793.009277, -9311.992188),Angle(31.255602, 98.710899, 0.000000)},
                Speed=0.1
            }
        },
        {
            Text="This universe is still filled with harmful things, no matter how much training you go through.", 
            Act=3, 
            Responder = 1,
        },
        {
            Text="Actually, I want you to go to Naboo and fight off the wild beasts there. Although you look like a soldier, I want you to prove it.", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(3807.968750, -6040.958984, 12960.031250),Angle(4.281681, 33.674706, 0.000000)}, 
                To={Vector(3807.968750, -6040.958984, 12960.031250),Angle(4.281681, 33.674706, 0.000000)},
                Speed=1
            }
        },
    },
}
Falcon.Quests[1].Start.Responses = {
    {
        View={
            From={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)}, 
            To={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)},
            Speed=1,
        },
        Text = {
            {
                Text = "I am a pro in Climb Swep 2, Faces, and many techniques that are definitely applicable.",
                Response = {
                    Text = "Amazing! You'll need to teach me some time!",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Um... No.. uwu",
                Response = {
                    Text = "Well, that's concerning. I'm surprised that you made it to regimental ARC...",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Wait, weren't clones meant to be girls? Since when did you become such a hottie?",
                Response = {
                    Text = "Huh... Well, I'm actually apart of the Regional Government for Tatooine. I'm here because my presence was requested.",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
        },
    },
    {
        View={
            From={Vector(3830.409668, -5969.564941, 12965.132813),Angle(0.462919, 93.907143, 0.000000)}, 
            To={Vector(3830.409668, -5969.564941, 12965.132813),Angle(0.462919, 93.907143, 0.000000)},
            Speed=1,
        },
        Text = {
            {
                Text = "Yes maam!",
                Response = {
                    Text = "I like your spirit!",
                    Responder = 1,
                    View={
                        From={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)}, 
                        To={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Ogei Shawty Bae.",
                Response = {
                    Text = "I'd prefer if you would call me by my actual name...",
                    Responder = 1,
                    View={
                        From={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)}, 
                        To={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Righto. I do what I want.",
                Response = {
                    Text = "It's your decision in the end, but I warned you.",
                    Responder = 1,
                    View={
                        From={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)}, 
                        To={Vector(3834.476563, -6026.368164, 12960.031250),Angle(2.082995, -92.402550, 0.000000)},
                        Speed=1
                    },
                },
            },
        },
    },
}

Falcon.Quests[1].Ending = {}
Falcon.Quests[1].Ending.Participants = {
    {
        Name = "Civil Worker 'Deez'",
        Model = "models/jajoff/sps/republic/tc13j/rsb03_female.mdl",
        Pos = Vector(3834.445313, -6037.992676, 12897.518555),
        Ang = Angle(0, 90, 0),
    },
    {
        Name = "PLAYER",
        Pos = Vector(3829.944824, -5958.208008, 12898.490234),
        Ang = Angle(0, -90, 0),
    }
}
Falcon.Quests[1].Ending.Dialogue = {
    {
        {
            Text="Well, welcome back! How was your expedition?", 
            Act=5, 
            Responder = 1,
            View={
                From={Vector(3833.606445, -6001.706543, 12961.226563),Angle(11, -89.793549, 0)}, 
                To={Vector(3833.606445, -6001.706543, 12961.226563),Angle(11, -89.793549, 0)},
                Speed=1
            }
        },
    },
    {
        {
            Text="It's good to see that you are atleast capable of doing that. But as you progress through the worlds, things wont be so forgiving to you.", 
            Act=6, 
            Responder = 1,
            View={
                From={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)}, 
                To={Vector(4057.382813,-5672.753418,13014.581055),Angle(7,35,0)},
                Speed=0.3
            }
        },
        {
            Text="Be sure gain new experiences in various planets, upgrade your equipment, and slaughter all kinds of enemies as you go! Good luck!", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)}, 
                To={Vector(4057.382813,-5672.753418,13014.581055),Angle(7,35,0)},
                Speed=0.3
            }
        },
    },
}
Falcon.Quests[1].Ending.Responses = {
    {
        View={
            From={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)}, 
            To={Vector(3844.621338,-5956.872070,12966.178711),Angle(7.840069,-117.166443,0)},
            Speed=1,
        },
        Text = {
            {
                Text = "Good! I found out alot about this world!",
                Response = {
                    Text = "Wooooow! I didn't think you'd like such a rotte- I mean beautiful universe!",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Well, It was interesting.",
                Response = {
                    Text = "Oh, well thats good! I hope you atleast found it fun too!",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
            {
                Text = "If you count a Clone being surrounded by massive devilish droids, then sure it was fun.",
                Response = {
                    Text = "... That sounds awful...",
                    Responder = 1,
                    View={
                        From={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)}, 
                        To={Vector(3878.642822, -6001.149902, 12960.031250),Angle(5, -180, 0)},
                        Speed=1
                    },
                },
            },
        },
    },
}

