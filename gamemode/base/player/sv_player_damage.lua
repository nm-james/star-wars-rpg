Falcon = Falcon or {}

function GM:PlayerShouldTakeDamage( ply, attacker )
    return true
end

function GM:ScalePlayerDamage( ply, hitgroup, dmginfo )
    local attacker = dmginfo:GetAttacker()
    if attacker.Level then
        local aLevel = attacker.Level
        local pLevel = ply:GetLevel()
        print("DAMAGE CALC")
        dmginfo:ScaleDamage( math.Clamp( aLevel / pLevel, 0.2, 999999999 ) )
    end
end