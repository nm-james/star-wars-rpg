Falcon = Falcon or {}

local plyMeta = FindMetaTable("Player")
function plyMeta:SetRemainingSprint( num )
    self:SetNWFloat( "FALCON:GETREMAININGSPRINT", num or 5 )
end

util.AddNetworkString("FALCON:SPRINT:UPDATE")

net.Receive("FALCON:SPRINT:UPDATE", function( len, ply )
    local consumedStamina = net.ReadFloat()
    local maxStamina = ply:GetMaxSprint()

    local remainingSpr = math.Clamp( maxStamina - consumedStamina, 0, maxStamina )
    ply:SetRemainingSprint( remainingSpr )

    if consumedStamina == -maxStamina then
        if not ply.ResetRunSpeed then return end
        ply:SetRunSpeed( ply.ResetRunSpeed )
        ply.ResetRunSpeed = false
    elseif remainingSpr == 0 then
        if ply.ResetRunSpeed then return end
        local run = ply:GetRunSpeed()
        local walk = ply:GetWalkSpeed()
        ply:SetRunSpeed(walk)

        local obj = ply:GetPhysicsObject()
        local speed = math.Clamp(run - walk, walk, run)
        obj:SetVelocity( Vector(speed, speed, 0) )
        ply.ResetRunSpeed = run
    end
end)
