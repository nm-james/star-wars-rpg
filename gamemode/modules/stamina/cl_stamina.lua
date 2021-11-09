
hook.Add("Think", "F_HANDLE_SPRINT", function()
	local ply = LocalPlayer()
    local walk = ply:GetWalkSpeed()
	local isSprinting = ply:IsSprinting()
	local maxStamina = ply:GetMaxSprint()
	local curSpr = ply.CurStaminaLeft or maxStamina
	local time = CurTime()
    local vel = ply:GetVelocity()
    local isMoving = false
    if (vel.x > walk or vel.x < -walk) or (vel.y > walk or vel.y < -walk)then
        isMoving = true
    end
    -- ply.CurStaminaLeft = 5
    if isSprinting and curSpr > 0 and isMoving and ply:KeyDown(IN_SPEED) and walk ~= ply:GetRunSpeed() then
        ply.CurStaminaLeft = math.Clamp(curSpr - FrameTime(), 0, maxStamina)
        ply.StaminaIsRegenerating = false
        ply.NextStaminaRegen = time + 3
        ply.StaminaHasUpdated = false
    else
        local amountLost = math.Clamp(maxStamina - curSpr, 0, maxStamina)
        
        if amountLost == 0 then return end

        if not ply.StaminaHasUpdated then
            net.Start("FALCON:SPRINT:UPDATE")
                net.WriteFloat( amountLost )
            net.SendToServer()
            ply.StaminaHasUpdated = true
        end

        if ply.NextStaminaRegen then 
            if ply.NextStaminaRegen > time then return end

            if not ply.StaminaIsRegenerating then
                ply.StaminaIsRegenerating = true
            end

            ply.CurStaminaLeft = math.Clamp(curSpr + FrameTime(), 0, maxStamina)
            local percentageDone = ply.CurStaminaLeft / maxStamina

            if percentageDone >= 1 then
                ply.NextStaminaRegen = false
                ply.StaminaIsRegenerating = false
                net.Start("FALCON:SPRINT:UPDATE")
                    net.WriteFloat( -maxStamina )
                net.SendToServer()
            end
        end

        
    end
end)