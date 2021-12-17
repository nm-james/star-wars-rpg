Falcon = Falcon or {}
Falcon.Quests = Falcon.Quests or {}
Falcon.Quests[4] = {}

Falcon.Quests[4].Name = "The Beginning of the Clone Wars [1]"
Falcon.Quests[4].QuestHolder = "Ki Adi Mundi"
Falcon.Quests[4].Requirement = function( ply )
    return true
end

Falcon.Quests[4].Objectives = {
    { Type = 1, Text = "Kill 5 B1 Battledroids!", Value = 0, Needed = 5, Class = "npc_crow", },
    -- { Type = 2, Text = "Kill a Droideka!", Value = false, Needed = true, Class = "falcon_hostile_cis_droideka", },
    { Type = 3, Text = "Move to XYZ", Value = false, Needed = true, Distance = 500, Position = Vector(5212.966309, -7011.267090, 8302.141602), },
}


Falcon.Quests[4].Start = {}
Falcon.Quests[4].Start.Participants = {
    {
        Name = "GEN 'Cards'",
        Model = "models/jajoff/sps/republic/tc13j/rsb01.mdl",
        Pos = Vector(4509.722656, -5691.733887, 15041.513672),
        Ang = Angle( 0, -112.134590, 0.000000 ),
    },
    {
        Name = "MCMDR 'Bacara'",
        Model = "models/jajoff/sps/cgi21s/tc13j/marine.mdl",
        Pos = Vector(4387.604492, -5937.890137, 15041.513672),
        Ang = Angle( 0, 63.528580, 0.000000 ),
    },
    {
        Name = "CAPT Tarkin",
        Model = "models/jajoff/sps/republic/tc13j/tarkin.mdl",
        Pos = Vector(4509.360352, -5936.659668, 15041.513672),
        Ang = Angle( 0, 116.701843, 0.000000 ),
    },
    {
        Name = "Ki Adi Mundi",
        Model = "models/tfa/comm/gg/pm_sw_mundi.mdl",
        Pos = Vector(4400.279297, -5693.362793, 15041.513672),
        Ang = Angle( 0, -76.781563, 0.000000 ),
    },
    {
        Name = "PLAYER",
        Pos = Vector(4614.001465, -5823.768555, 15041.213867),
        Ang = Angle( 0, -180, 0.000000 ),
    }
}

Falcon.Quests[4].Start.Dialogue = {
    {
        {
            Text="We have received word from the Jedi Council and the Galactic Senate that the Trade Union and a collective of other parties have joint forces to oppose us.", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)}, 
                To={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)},
                Speed=1
            }
        },
        {
            Text="We don't know their exact intentions, but there is rising tensions between both the Galactic Senate and the newly formed Confederacy of Independant Systems.", 
            Act=3,
            Responder = 1,
            View={
                From={Vector(4537.195313, -5688.138184, 15107.776367),Angle(5.207463, -133.950745, 0.000000)}, 
                To={Vector(4537.195313, -5688.138184, 15107.776367),Angle(5.207463, -133.950745, 0.000000)},
                Speed=1
            }
        },
        {
            Text="Hmm. The situation isn't looking promising. With the mass production of the Republic, there might be a costly war awaiting us.", 
            Act=3, 
            Responder = 2,
            View={
                From={Vector(3573.983643, -5661.023438, 9031.829102),Angle(12.971974, -132.678040, 0.000000)}, 
                To={Vector(-1298.314941, -5199.285156, 9375.997070),Angle(27.784147, 140.416138, 0.000000)},
                Speed=0.03
            }
        }, 
        {
            Text="Indeed. We have sent a fleet to secure a nearby position in order to keep an eye on Naboo. We suspect an inpending invasion by the CIS.", 
            Act=3, 
            Responder = 3,
        }, 
        {
            Text="Master Qui-Gon Jinn and Padawan Obi-Wan Kenobi has been sent as ambassadors of the Galactic Senate. Hopefully they can relieve rising tensions on the planet and between the politicians.", 
            Act=3, 
            Responder = 4,
            View={
                From={Vector(-2601.244385, -6540.686523, 8408.036133),Angle(8.979637, -91.486389, 0.000000)}, 
                To={Vector(-2601.244385, -6540.686523, 8408.036133),Angle(8.979637, -91.486389, 0.000000)},
                Speed=1
            }
        }, 
        {
            Text="What do you think, PLAYER?", 
            Act=3, 
            Responder = 4,
            
        }, 
    },
    {
        {
            Text="Despite the situation at hand, I don't believe Qui-Gon and Obi-Wan will be able to handle the situation smoothly.", 
            Act=3, 
            Responder = 1,
            View={
                From={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)}, 
                To={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)},
                Speed=1
            }
        },
        {
            Text="They are more than capable men. I'm not exactly pleased on your attitude towards their efforts.", 
            Act=4,
            Responder = 4,
            View={
                From={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)}, 
                To={Vector(4643.721680, -5818.821777, 15127.131836),Angle(8.852558, 178.845383, 0.000000)},
                Speed=1
            }
        },
        {
            Text="I'm sure they're more than capable, but I think we should send a few 'behind the scene' forces in will help if things turn sour.", 
            Act=3, 
            Responder = 3,
            View={
                From={Vector(4536.591309, -5868.425293, 15108.699219),Angle(9.257551, -136.390808, 0.00000)}, 
                To={Vector(4536.591309, -5868.425293, 15108.699219),Angle(9.257551, -136.390808, 0.00000)},
                Speed=1
            }
        }, 
        {
            Text="Hmm. I agree. Let's send in Commandos to assess the situation... PLAYER, meet with CT-411 near the Theed Hangar and report in the situation and likelihood of a war.", 
            Act=3, 
            Responder = 2,
            View={
                From={Vector(2969.182617, 8293.769531, 8793.911133),Angle(16.895063, 47.367550, 0.00000)}, 
                To={Vector(2969.182617, 8293.769531, 8793.911133),Angle(16.895063, 47.36755, 0.00000)},
                Speed=1
            }
        }, 
        
    },
}
Falcon.Quests[4].Start.Responses = {
    {
        View={
            From={Vector(4552.947754, -5826.995117, 15115.402344),Angle(11, 0, 0)}, 
            To={Vector(4552.947754, -5826.995117, 15115.402344),Angle(11, 0, 0)},
            Speed=1
        },
        Text = {
            {
                Text = "I hope they do a good job. The last thing I want is to be sent guns blazing on an open surface.",
                Response = {
                    Text = "Our intentions are not to throw forces like you carelessly. So be at ease with that thought.",
                    Responder = 1,
                    View={
                        From={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)}, 
                        To={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "Man, I can't wait to produce some scrap metal!",
                Response = {
                    Text = "I'm sure you are excited about situation at Naboo, but others such as myself are not. Many lives are at risk here.",
                    Responder = 4,
                    View={
                        From={Vector(4414.406250, -5739.756348, 15106.111328),Angle(3.830046, 105.768295, 0.0000)}, 
                        To={Vector(4414.406250, -5739.756348, 15106.111328),Angle(3.830046, 105.768295, 0.0000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "...",
                Response = {
                    Text = "Well, I assume you are on the same page as what we are talking about.",
                    Responder = 1,
                    View={
                        From={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)}, 
                        To={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)},
                        Speed=1
                    },
                },
            },
        },
    },
    {
        View={
            From={Vector(4552.947754, -5826.995117, 15115.402344),Angle(11, 0, 0)}, 
            To={Vector(4552.947754, -5826.995117, 15115.402344),Angle(11, 0, 0)},
            Speed=1
        },
        Text = {
            {
                Text = "Understood.",
                Response = {
                    Text = "Good luck PLAYER.",
                    Responder = 1,
                    View={
                        From={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)}, 
                        To={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "I'll prepare my equipment when I'm ready.",
                Response = {
                    Text = "Be sure to do it with haste. We don't exactly know how much time we have.",
                    Responder = 4,
                    View={
                        From={Vector(4414.406250, -5739.756348, 15106.111328),Angle(3.830046, 105.768295, 0.0000)}, 
                        To={Vector(4414.406250, -5739.756348, 15106.111328),Angle(3.830046, 105.768295, 0.0000)},
                        Speed=1
                    },
                },
            },
            {
                Text = "No. No Sussy Baka.",
                Response = {
                    Text = "I swear, I didn't vent!",
                    Responder = 1,
                    View={
                        From={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)}, 
                        To={Vector(4497.642578, -5721.842285, 15105.151367),Angle(6.491608, 67.349045, 0.000000)},
                        Speed=1
                    },
                },
            },
        },
    },
}

Falcon.Quests[4].Ending = {}
Falcon.Quests[4].Ending.Participants = {
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
Falcon.Quests[4].Ending.Dialogue = {
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
Falcon.Quests[4].Ending.Responses = {
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

