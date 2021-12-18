Falcon = Falcon or {}
Falcon.GetUserInventory = function( ply )
    local res = sql.Query("SELECT inventory FROM Users WHERE steamid = " .. ply:SteamID64()) or {}
    if not res[1] or not res[1].inventory then return Falcon.GetUserID( ply ) end
    local inv = util.JSONToTable( res[1].inventory )
    SortNewData( inv )
    return inv
end

Falcon.SaveUserInventory = function( ply, inv )
    local userID = Falcon.GetUserID( ply )
    if not userID then return end
    sql.Query("UPDATE Users SET inventory = '" .. util.TableToJSON(inv) .. "' WHERE id = " .. tostring(userID))
end

local itemHandler = {
    [1] = function( ply, itemData )
        ply:Give(itemData.swep)
        ply:SetNWString("FALCON:PRIMARY:WEAPON", itemData.swep)
    end,
    [2] = function( ply, itemData )

    end,
}
local itemRemover = {
    [1] = function( ply, itemData )
        ply:StripWeapon(itemData.swep)
        ply:SetNWString("FALCON:PRIMARY:WEAPON", "")
    end,
    [2] = function( ply, itemData )

    end,
}
util.AddNetworkString("FALCON:INVENTORY:REMOVEFROMEQUIP")
net.Receive("FALCON:INVENTORY:REMOVEFROMEQUIP", function( len, ply )
    local inv = Falcon.GetUserInventory( ply )
    local itemMoving = net.ReadInt( 32 )
    local equip = inv.equipped
    if not equip[itemMoving] then return end
    local item = Falcon.Items[Falcon.ItemsIdentifier[equip[itemMoving]]]
    itemRemover[item.category]( ply, item )

    equip[itemMoving] = nil
    Falcon.SaveUserInventory( ply, inv )
end)

util.AddNetworkString("FALCON:INVENTORY:REMOVEFROMBACKPACK")
net.Receive("FALCON:INVENTORY:REMOVEFROMBACKPACK", function( len, ply )
    local inv = Falcon.GetUserInventory( ply )

end)

util.AddNetworkString("FALCON:INVENTORY:ADDTOEQUIP")
net.Receive("FALCON:INVENTORY:ADDTOEQUIP", function( len, ply )
    local backpackItemEquiping = net.ReadInt( 32 )
    local equippedSlot = net.ReadInt( 32 )

    local inv = Falcon.GetUserInventory( ply )
    local backPack = inv.backpack
    if not backPack[backpackItemEquiping] then return end

    local item = backPack[backpackItemEquiping].item
    inv.equipped[equippedSlot] = item

    local item = Falcon.Items[Falcon.ItemsIdentifier[item]]
    itemHandler[item.category]( ply, item )

    table.remove( backPack, backpackItemEquiping )
    Falcon.SaveUserInventory( ply, inv )
end)

util.AddNetworkString("FALCON:INVENTORY:ADDTOBACKPACK")
net.Receive("FALCON:INVENTORY:ADDTOBACKPACK", function( len, ply )
    local itemMoving = net.ReadInt( 32 )
    local newX = net.ReadInt( 32 )
    local newY = net.ReadInt( 32 )

    local inv = Falcon.GetUserInventory( ply )
    local backPack = inv.backpack
    local equip = inv.equipped
    
    local item = equip[itemMoving]

    local newItem = {
        pos = { x = newX, y = newY },
        item = item
    }
    table.insert(backPack, newItem)
    Falcon.SaveUserInventory( ply, inv )
end)


util.AddNetworkString("FALCON:INVENTORY:MOVEINBACKPACK")
net.Receive("FALCON:INVENTORY:MOVEINBACKPACK", function( len, ply )
    local itemMoving = net.ReadInt( 32 )
    local newX = net.ReadInt( 32 )
    local newY = net.ReadInt( 32 )

    local inv = Falcon.GetUserInventory( ply )
    local backPack = inv.backpack
    backPack[itemMoving].pos.x = newX
    backPack[itemMoving].pos.y = newY
    Falcon.SaveUserInventory( ply, inv )
end)