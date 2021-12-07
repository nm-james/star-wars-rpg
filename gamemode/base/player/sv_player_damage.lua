Falcon = Falcon or {}

function GM:PlayerShouldTakeDamage( ply, attacker )
    return true
end
util.AddNetworkString("FALCON:PLAYER:DAMAGE")
function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
    local attacker = dmginfo:GetAttacker()
    net.Start("FALCON:PLAYER:DAMAGE")
        net.WriteString( ply:Nick() )
    net.Broadcast()
    if attacker.Level then
        local aLevel = attacker.Level
        local pLevel = ply:GetLevel()
        local rate = math.Clamp( aLevel / pLevel, 0, 999999999 )

        if ply:Armor() > 0 then
            local newDamage = dmginfo:GetDamage() * rate

            local bleed = ply:Armor() - newDamage
            if bleed < 0 then
                ply:SetArmor( 0 )
                dmginfo:SetDamage( bleed * -1 )
            else
                ply:SetArmor( bleed )
                dmginfo:SetDamage( 0 )
            end
        else
            dmginfo:ScaleDamage( rate )
        end
    end
end

