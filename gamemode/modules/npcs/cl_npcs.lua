Falcon = Falcon or {}
-- Falcon.NPCs = Falcon.NPCs or {}
Falcon.NPCsCE = Falcon.NPCsCE or {}

Falcon.NPCs = {}

Falcon.NPCs["Venator"] = {
    { Pos = Vector(3834.445313, -6037.992676, 12897.518555), Ang = Angle( 0, 90, 0 ), Name = "Civil Worker 'Deez'", Desc = "Tatooine Representative", Menus = 1, ACT = 1, Model = "models/jajoff/sps/republic/tc13j/rsb03_female.mdl", Options = {
            Response = {"Hello! How many I help you?Hello! How many I help you?Hello! How many I help you?", "iojhdgiohgsdgihdghhdhod/.iojhdgiohgsdgihdghhdhod.iojhdgiohgsdgihdghhdhod.", "alpalsfosafoldgsggh?alpalsfosafoldgsggh?alpalsfosafoldgsggh?"},
            Dialogue = {
                {
                    Text = "Can I please redo the tutorial?",
                },
                {
                    Text = "This server is odd.",
                    Options = {
                        Response = "Well, it is odd. It's most likely not the same as what you'd expect from a Star Wars Roleplaying server. Can I answer any questions you might have?",
                        Font = "F9",
                        Dialogue = {
                            {
                                Text = "So why are we on a Jedi vs Sith map?",
                                Options = {
                                    Response = "For starters, we aren't following the old procedure of having a 'base' or 'ship' map where players can do passive rp on. We feel that its unneccessary to have such a system. So in its place, we have set up an open world environment for players like you to explore. This also means you may go killing droids and enemies, leveling up, completing missions, gaining better equipment, and discover new and unique features on our server. If you have any further questions, feel free to message the management team of our network.",
                                    Font = "F8",
                                    Dialogue = {
                                        {
                                            Text = "What planets are available?",
                                            Options = {
                                                Response = "This map has 4 planets in total. Some might look familiar. Here is a list:\n - Naboo\n - Tatooine\n - Kashyyyk\n - Geonosis\n We are hoping to get a custom map in soon.",
                                                Font = "F8",
                                                Dialogue = {
                                                    {
                                                        Text = "K...",
                                                        Options = {},
                                                    },
                                                },
                                            },
                                        },
                                        {
                                            Text = "What passive RP is there on this map?",
                                            Font = "F8",
                                            Options = {
                                                Response = "Well, the server features things most servers dont have. For example, we plan to implement as 'War Effort' script which entails whether players gain more xp or credits when they kill a droid or complete an object. We also have an open world simulated environment, which involves npcs and other additional entities to make your experience a one of a kind.",
                                                Font = "F8",
                                                Dialogue = {
                                                    {
                                                        Text = "Huh.",
                                                        Options = {},
                                                    },
                                                },
                                            },
                                        },
                                        {
                                            Text = "Man, I can't wait to explore!",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "What features are unique to this server only?",
                                Font = "F7",
                                Options = {
                                    Response = "Whilst some of these features aren't completely unique, they are in the sense that I personally haven't seen other servers do these. A brief list of them:\n - Custom Hostile NPCs [Levelling, Perks]\n - 'Boss' NPCs [General Grevious, etc]\n - Open World Simulation\n We believe most of these features haven't really been implemented in this standard.",
                                    Font = "F8",
                                    Dialogue = {
                                        {
                                            Text = "Okay.....",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "You've said enough!",
                                Options = {},
                            },
                        },
                    },
                },
                {
                    Text = "The regiments seem odd on this server. Care to explain?",
                    Options = {
                        Response = "Most certainly! Our server has regiment's based on what the community wants. However, the models we currently use are ARC models which are easier to work with from a coding side of things. Is there anything more specific you'd like to know?",
                        Font = "F9",
                        Dialogue = {
                            {
                                Text = "So what regiments are available?",
                                Options = {
                                    Response = "The regiments available on our server currently is:\n - 501st Legion\n - 212th Attack Battalion\n - 177th Shock Battalion\n - Regional Government \n These may change in time, but bare in mind, none of these are going to be permanent.",
                                    Font = "F8",
                                    Dialogue = {
                                        {
                                            Text = "Damn! None of these regiments are what I want!",
                                            Options = {},
                                        },
                                        {
                                            Text = "Frick yeah! This server has my favourite regiment!",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "Is there a unique feature of each regiment?",
                                Options = {
                                    Response = "Haha... No. All the regiments on the server serve to merely to set your allegience to a certain group. In other words, it's only to get your armor 'dirty' and to get your 'colours'.",
                                    Font = "F8",
                                    Dialogue = {
                                        {
                                            Text = "Ooooorah!",
                                            Options = {},
                                        },
                                        {
                                            Text = "Well this sucks. My favourite regiment isn't even on the server...",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "Alrighty.",
                                Options = {},
                            },
                        },
                    },
                    
                },
                {
                    Text = "How about you tell me about donations.",
                    Options = {
                        Response = "What would you like to know?",
                        Dialogue = {
                            {
                                Text = "How may I donate?",
                                Options = {
                                    Response = "You may donate on our communities page (projectresurrect.net), or you may contact one of our management. We are in the midst of implementing prometheus, so in the near future, donations will become automated and you will no longer have to talk to management unless an issue arises.",
                                    Font = "F10",
                                    Dialogue = {
                                        {
                                            Text = "Thanks!",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "What is available to donate for?",
                                Options = {
                                    Response = "Currently, we are still looking into things players like you could buy. At the moment, the following is available for donating:\n - Premium Classes [$5 AUD/MONTHLY]\n - Permanent Squads [$10 AUD]\n - Second Life [$15 AUD]",
                                    Font = "F10",
                                    Dialogue = {
                                        {
                                            Text = "Take my money!",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "Where do the donations received go into?",
                                Options = {
                                    Response = "Donations that are provided by the lovely people of our community goes straight to our server funds. The money given goes into the development of content (such as models, scripts etc) or goes into keeping the server running. Additionally, funds might get used for other purposes such as giveaways.",
                                    Font = "F10",
                                    Dialogue = {
                                        {
                                            Text = "My wallet is empty though...",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "Nevermind, I don't think I'll need to ask a question.",
                                Options = {},
                            },
                        },
                    },
                },
                {
                    Text = "I saw a Captain with a medic model recently. What's up with that?",
                    Options = {
                        Response = "Well, this server doesn't use colours, pauldrons, or anything like that to signify what rank a person is. Instead, we just simply have their signia ontop of their head, in chat, or anywhere where their rank is on display. Although this makes it harder for players to identify superiors, it does allow for officers to gain the same experience as everyone else. Anymore questions?",
                        Font = "F9",
                        Dialogue = {
                            {
                                Text = "How do I gain a class?",
                                Options = {
                                    Response = "In order to gain a class, you must get all 4 armor pieces of a set (i.e the 'Heavy' set gives the Heavy class and his features) equipped in your inventory. Even if 1 item is not equipped, you will no longer have access to features of a certain class, and default back to 'Trooper'.",
                                    Font = "F10",
                                    Dialogue = {
                                        {
                                            Text = "Man, time to start grinding!",
                                            Options = {},
                                        },
                                        {
                                            Text = "Ugh, more work to do...",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "People have these unique features that they can 'activate'. What are those?",
                                Options = {
                                    Response = "Those are called 'abilities'. These are features of a class which can be activated when a condition has been reached. These activations also invoke a cooldown, meaning you cannot just simply spam it. In order to use it again, the player needs to wait a certain amount of time (depending on the class) to reactivate it again.",
                                    Font = "F9",
                                    Dialogue = {
                                        {
                                            Text = "Sheeeeesh!",
                                            Options = {},
                                        },
                                        {
                                            Text = "Thanks!",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "What class should I become?",
                                Options = {
                                    Response = "Well, there isn't really a class that is 100% going to be everyone's favourite. Instead, we believe you should strive for which class intrigues you the most. As they say, never judge a book by its cover, as whatever is inside of it, maybe significantly more interesting that its outside (model).",
                                    Font = "F10",
                                    Dialogue = {
                                        {
                                            Text = "Thanks Dad!",
                                            Options = {},
                                        },
                                        {
                                            Text = "Kinda cringe not gonna lie.",
                                            Options = {},
                                        },
                                    },
                                },
                            },
                            {
                                Text = "I'll take your word for it!",
                                Options = {},
                            },
                        },
                    },
                },
            },
        }, 
    },
    { Pos = Vector(4509.722656, -5691.733887, 15041.513672), Ang = Angle( 0, -112.134590, 0.000000 ), Name = "General 'Cards'", Model = "models/jajoff/sps/republic/tc13j/rsb01.mdl" },
    { Pos = Vector(4400.279297, -5693.362793, 15041.513672), Ang = Angle( 0, -76.781563, 0.000000 ), Name = "Ki Adi Mundi", Model = "models/tfa/comm/gg/pm_sw_mundi.mdl" },
    { Pos = Vector(4509.360352, -5936.659668, 15041.513672), Ang = Angle( 0, 116.701843, 0.000000 ), Name = "Captain 'Tarkin'", Model = "models/jajoff/sps/republic/tc13j/tarkin.mdl" },
    { Pos = Vector(4387.604492, -5937.890137, 15041.513672), Ang = Angle( 0, 63.528580, 0.000000 ), Name = "Marshal Commander 'Bacara'", Model = "models/jajoff/sps/cgi21s/tc13j/marine.mdl" },
    { Pos = Vector(2738.622070, -5636.681641, 12887.294922), Ang = Angle( 0, 61, 0 ) },
    { Pos = Vector(2731.171143, -5585.593750, 12887.294922), Ang = Angle( 0, -53, 0 ) },
}
Falcon.NPCs["Naboo"] = {}
Falcon.NPCs["Tatooine"] = {}
Falcon.NPCs["Kashyyyk"] = {}
Falcon.NPCs["Geonosis"] = {}

Falcon.CreateNPC = function( model, pos, ang )
    local clientModel = ents.CreateClientProp()
    clientModel:SetModel( model or "models/jajoff/sps/alpha/tc13j/coloured_regular05.mdl" )
    clientModel:Spawn()
    clientModel:SetPos( pos )
    clientModel:SetAngles( ang )
    clientModel:SetupBones()
    clientModel:ResetSequence( 0 )
    clientModel:SetSequence( 3 )
    clientModel:SetCollisionGroup( 0 )
    clientModel:SetRenderMode( RENDERMODE_TRANSCOLOR )
    local seqTbl = clientModel:GetSequenceList()
    for i = 0, 999 do
        print(i, seqTbl[i])
    end 
    return clientModel
end

local function RemoveCurrentNPCEnts()
    for _, ent in pairs( Falcon.NPCsCE ) do
        if ent and ent:IsValid() then
            ent:Remove()
        end
    end
    Falcon.NPCsCE = {}
end

local router = {}
function LoadNPCsFromPlanets( planet )
    if not Falcon.NPCs[planet] then return end
    RemoveCurrentNPCEnts()

    local npcs = Falcon.NPCs[planet]

    for id, n in pairs( npcs ) do
        local clientModel = Falcon.CreateNPC( n.Model, n.Pos, n.Ang )
        clientModel:SetSequence( n.Sequence or 3 )
        clientModel.Occupation = n.Occupation or "Unemployed"
        clientModel.Name = n.Name or "JIMMY! [NO NAME]"
        clientModel.Desc = n.Desc or ""
        clientModel.Allegience = n.Allegience or 5
        clientModel.FalconClient = true
        clientModel.Personality = n.Personality
        clientModel.Options = n.Options or {
            Response = "Hello trooper. How may I help you?",
            Dialogue = {}
        }
        clientModel.Interaction = "Speak with " .. clientModel.Name
        clientModel.Next = function()
            OpenNPCTalk( clientModel )
        end

        Falcon.NPCsCE[clientModel.Name] = clientModel
    end

end
