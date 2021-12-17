
AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include( 'shared.lua' )
Falcon = Falcon or {}
Falcon.CanCreate = {
    ["superadmin"] = true
}


hook.Add("PlayerSay", "TESTINGTEXT", function( ply, text )

    if text == "/bone" then
        Falcon.GetUserID( ply )
    end

    if text == "/model" then
        ply:SetNoDraw( false )
    end

    if text == "/ball" then
        local ent = ents.Create("falcon_npc_weapon")
        ent:SetPos( ply:GetPos() )
        ent:Spawn()
    end
end)

function GM:PlayerDisconnected( ply )
    file.Write("te.txt", "")
end

hook.Add( "ShouldCollide", "CustomCollisions", function( stationary, collider )
    if stationary:IsPlayer() and (collider:IsNextBot()) then 
        -- stationary:SetCollisionGroup( COLLISION_GROUP_DEBRIS )

        if not stationary._IsBeingReset then
            stationary._IsBeingReset = true
            timer.Simple(0.3, function()
                stationary:SetCollisionGroup( COLLISION_GROUP_IN_VEHICLE )
                stationary._IsBeingReset = false
            end )
        end
        return true 
    end
    return true
end )

function GM:PlayerSwitchWeapon( ply, old, new )
	print(old, new:GetModel())
end