Falcon = Falcon or {}
Falcon.Stamina = Falcon.Stamina or {}
Falcon.Stamina.HUDAlpha = 0
Falcon.Stamina.ActiveText = ""
Falcon.Stamina.ActiveTextAlpha = 0
local scrw, scrh = ScrW(), ScrH()
local color_white = Color( 255, 255, 255 )
local color_red_cool = Color( 255, 87, 77, 170 )
local color_orange = Color( 255, 188, 5, 170 )
local color_black = Color( 0, 0, 0 )
Falcon.Stamina.EnergyBarColor = color_orange

hook.Add("Think", "F_STAMINA_CHANGETEXT", function()
    local ply = LocalPlayer()
	local maxStamina = ply:GetMaxSprint()
    local stam = ply.CurStaminaLeft or maxStamina
    if stam < (maxStamina / 1.5) then
        Falcon.Stamina.HUDAlpha = math.Clamp(Falcon.Stamina.HUDAlpha + ((FrameTime() * 4) * 255), 0, 255)
        if stam == 0 or ply:GetRunSpeed() == ply:GetWalkSpeed() then
            Falcon.Stamina.ActiveText = "DEATHSTICK LEVELS DEPLETED"
            Falcon.Stamina.ActiveTextAlpha = 255
            Falcon.Stamina.EnergyBarColor = color_red_cool
        elseif stam < (maxStamina / 2.5) then
            if not Falcon.Stamina.TextNextDelay or Falcon.Stamina.TextNextDelay < CurTime() then 
                if Falcon.Stamina.ActiveTextAlpha == 0 then
                    Falcon.Stamina.ActiveTextAlpha = 255
                    Falcon.Stamina.EnergyBarColor = color_red_cool
                elseif Falcon.Stamina.ActiveTextAlpha == 255 then
                    Falcon.Stamina.ActiveTextAlpha = 0
                    Falcon.Stamina.EnergyBarColor = color_orange
                end
                Falcon.Stamina.ActiveText = "DEATHSTICK LEVELS EXTREMELY LOW"
                Falcon.Stamina.TextNextDelay = CurTime() + 0.25
            end
        else
            Falcon.Stamina.EnergyBarColor = color_orange
            Falcon.Stamina.ActiveText = ""
        end
    else
        if stam >= (maxStamina * 0.95) then
            Falcon.Stamina.ActiveText = ""
            Falcon.Stamina.ActiveTextAlpha = 0
            Falcon.Stamina.HUDAlpha = math.Clamp(Falcon.Stamina.HUDAlpha - ((FrameTime() * 4) * 255), 0, 255)
        end
    end
end)


hook.Add("HUDPaint", "F_STAMINA_HUD", function()
    local ply = LocalPlayer()
	local maxStamina = ply:GetMaxSprint()
	local curSpr = ply.CurStaminaLeft or maxStamina
    local alpha = Falcon.Stamina.HUDAlpha

    surface.SetDrawColor( color_white.r, color_white.g, color_white.b, Falcon.Stamina.HUDAlpha )
    surface.DrawOutlinedRect( scrw * 0.29675, scrh * 0.85, scrw * 0.4065, scrh * 0.017)

    surface.SetDrawColor( color_black.r, color_black.g, color_black.b, (130 / 255) * Falcon.Stamina.HUDAlpha )
    surface.DrawRect( scrw * 0.2975, scrh * 0.852, scrw * 0.405, scrh * 0.014)


    local col = Falcon.Stamina.EnergyBarColor
    surface.SetDrawColor( col.r, col.g, col.b, (col.a / 255) * Falcon.Stamina.HUDAlpha )
    surface.DrawRect( scrw * 0.2975, scrh * 0.852, (scrw * 0.405) * (curSpr / maxStamina), scrh * 0.014)

    draw.DrawText( Falcon.Stamina.ActiveText, "F10", scrw * 0.5, scrh * 0.825, Color( color_red_cool.r, color_red_cool.g, color_red_cool.b, Falcon.Stamina.ActiveTextAlpha ), TEXT_ALIGN_CENTER )

end)