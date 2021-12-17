Falcon = Falcon or {}
Falcon.ItemsIdentifier = {}
Falcon.ItemsEntities = Falcon.ItemsEntities or {}
Falcon.Items = {}

local f = Falcon
f.CreateItem = function( name, tbl )
    local newTbl = tbl
    newTbl.name = name

    local c = table.Count( Falcon.Items ) + 1
    Falcon.Items[c] = newTbl
    Falcon.ItemsIdentifier[name] = c
end

f.CreateItem( "ENHANCED WEAPON", {
    size = { x = 2, y = 2 },
    model = {
        string = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
        inventory = {
            pos = Vector(0, -20, 0),
            ang = Angle(5, 90, 0),
            fov = 75,
        },
        
    },
} )

f.CreateItem( "ENHANCED WEAPONS", {
    size = { x = 4, y = 3 },
    model = {
        string = "models/sw_battlefront/weapons/dc15a_rifle.mdl",
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