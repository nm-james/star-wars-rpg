Falcon = Falcon or {}
Falcon.ItemsIdentifier = {}
Falcon.ItemsEntities = Falcon.ItemsEntities or {}
Falcon.Items = {}
Falcon.ItemsRarities = {}
Falcon.ItemsRarities.Text = {
    [1] = "COMMON",
    [2] = "UNCOMMON",
    [3] = "RARE",
    [4] = "EPIC",
    [5] = "LEGENDARY",
}
Falcon.ItemsRarities.Colors = {
    [1] = Color( 185, 185, 185 ),
    [2] = Color( 25, 175, 25 ),
    [3] = Color( 0, 100, 210 ),
    [4] = Color( 155, 15, 155 ),
    [5] = Color( 255, 255, 15 ),
}

local f = Falcon
f.CreateItem = function( name, tbl )
    tbl.rarities = tbl.rarities or {}
    local minRarity = tbl.rarities.min or 1
    local maxRarity = tbl.rarities.max or 3
    for i = minRarity, maxRarity do
        local newTbl = table.Copy( tbl )
        newTbl.name = name .. ' [' .. Falcon.ItemsRarities.Text[i] .. ']'
        newTbl.rarity = i
        newTbl.rarities = nil
        local c = table.Count( Falcon.Items ) + 1
        Falcon.Items[c] = newTbl
        Falcon.ItemsIdentifier[newTbl.name] = c
        
    end
end

f.CreateItem( "DC-15A", {
    size = { x = 4, y = 3 },
    category = 1,
    rarities = {min = 1, max = 5},
    swep = "falcon_dc15a",
    model = {
        string = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        inventory = {
            pos = Vector(0, -20, 0),
            ang = Angle(5, 90, 0),
            fov = 75,
        },
    },
} )

f.CreateItem( "Z6", {
    size = { x = 3, y = 2 },
    category = 2,
    rarities = {min = 4, max = 5},
    swep = "falcon_z6",
    model = {
        string = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl",
        inventory = {
            pos = Vector(0, -20, 0),
            ang = Angle(5, 90, 0),
            fov = 75,
        },
        
    },
} )

f.CreateItem( "DC-15A [SHOTGUN]", {
    size = { x = 4, y = 3 },
    category = 2,
    rarities = {min = 1, max = 5},
    swep = "falcon_dc15a_shotgun",
    model = {
        string = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        inventory = {
            pos = Vector(0, -20, 0),
            ang = Angle(5, 90, 0),
            fov = 75,
        },
    },
} )

f.CreateItem( "DC-15S", {
    size = { x = 3, y = 2 },
    category = 2,
    rarities = {min = 1, max = 5},
    swep = "falcon_dc15s",
    model = {
        string = "models/sw_battlefront/weapons/dc15s_carbine.mdl",
        inventory = {
            pos = Vector(0, -20, 0),
            ang = Angle(5, 90, 0),
            fov = 75,
        },
        
    },
} )




PrintTable(Falcon.ItemsIdentifier)

if CLIENT then
    Falcon.CreateItemEntity = function( name, model, pos )
        local clientModel = ents.CreateClientProp()
        clientModel:SetModel( model or "models/jellyton/bf2/misc/props/command_post.mdl" )
        clientModel:Spawn()
        clientModel:SetPos( pos )
        clientModel:SetAngles( Angle( 0, 0, 0 ) )
        clientModel:SetRenderMode( RENDERMODE_TRANSCOLOR )
        clientModel.OriginalPos = pos

        Falcon.ItemsEntities[table.Count(Falcon.ItemsEntities) + 1] = clientModel
        return clientModel
    end

    hook.Add("Think", "F_ANIMATE_ITEMS", function()
        local curTime = CurTime()
        local newAngle = (curTime * 90) % 360
        local newHeight = math.sin(curTime * 3) * 5
        for _, ent in pairs( Falcon.ItemsEntities ) do
            if not ent or not ent:IsValid() then 
                table.remove(Falcon.ItemsEntities, _)
            continue end
            if ent.ShouldStopAnimating then continue end
            ent:SetPos( ent.OriginalPos + Vector( 0, 0, newHeight + 35 ) )
            ent:SetAngles( Angle( 0, newAngle, 0 ) )
        end
    end)
end
