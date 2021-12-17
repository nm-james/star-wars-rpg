Falcon = Falcon or {}
Falcon.StartInteractionTime = 0
Falcon.HasNPCSpeaking = false
Falcon.InteractionActiveEntities = {}

local diagonal = Material("f_coop/identifier.png")
local function DrawNPCsInteractions()
    if Falcon.HasNPCSpeaking then return end
    local ply = LocalPlayer()
    local w, h = ScrW(), ScrH()

    for _, ent in pairs( Falcon.InteractionActiveEntities ) do
        if not ent.Interaction then continue end
        if ent.Name and ent.Name == "JIMMY! [NO NAME]" then continue end
        if ent.Options and table.IsEmpty(ent.Options.Dialogue) then continue end

        local s = ((ent.OriginalPos or ent:GetPos()) + Vector( 0, 0, 40 )):ToScreen()
        
        draw.NoTexture()
        surface.SetDrawColor( Color( 255, 255, 255 ) )
        surface.SetMaterial(diagonal)
        surface.DrawTexturedRect( s.x - (w * 0.05 / 2), s.y - (w * 0.05 / 2), w * 0.05, w * 0.05 )

        if s.x > (w * 0.475) and s.x < (w * 0.525) and s.y > ((h * 0.5) - (w * 0.05 / 2)) and s.y < ((h * 0.5) + (w * 0.05 / 2)) and ply:GetPos():DistToSqr( ent:GetPos() ) < (ent.InteractDistance or 7500) then
            if Falcon.StartInteractionTime ~= 0 then
                local nextI = (ent.InteractionTime or 1)
                local percentageInteracted = ((CurTime() - Falcon.StartInteractionTime) / nextI)

                if percentageInteracted < 1 then
                    surface.DrawRect( s.x - (w * 0.049), s.y + (h * 0.0515), (w * 0.09825) * percentageInteracted, w * 0.0065 )
                else
                    Falcon.StartInteractionTime = 0

                    ent.Next()
                end
            end
            surface.DrawOutlinedRect( s.x - (w * 0.05), s.y + (h * 0.05), w * 0.1, w * 0.00815 )
            draw.SimpleTextOutlined("Hold <E> to " .. ent.Interaction, "F6", s.x, s.y + (h * 0.0485), Color( 255, 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0, 255 ) )
        else
            Falcon.StartInteractionTime = 0
        end
    end
end
local function DrawNPCNames()
    if Falcon.HasNPCSpeaking then return end
    local ply = LocalPlayer()
    local w, h = ScrW(), ScrH()

    for _, npc in pairs( Falcon.InteractionActiveEntities ) do
        if ply:GetPos():DistToSqr( npc:GetPos() ) > 20000 then continue end
        cam.Start3D2D( npc:GetPos() + Vector( 0, 0, 100 ), Angle( 0, ply:GetAngles().y - 90, 90 ), 0.1 )
            draw.DrawText(npc.Name or "", "F20", 0, 132, Color(125,125,125,255), TEXT_ALIGN_CENTER)
            -- draw.DrawText(npc.Occupation, "F15_CAMERA", 0, 197, Color(75,75,75,255), TEXT_ALIGN_CENTER)
            -- draw.DrawText(sides[npc.Allegience], "F11_CAMERA", 0, 225, GetOccupationColor(npc.Allegience), TEXT_ALIGN_CENTER)
        cam.End3D2D()
    end
end


local function InteractHandler()
    if Falcon.HasNPCSpeaking then return end
    local ply = LocalPlayer()
    Falcon.InteractionActiveEntities = {}
    local cone = ents.FindInCone( ply:EyePos(), ply:GetAimVector(), 400, math.cos( math.rad( 50 ) ) )
    for _, ent in pairs( cone ) do
        if not ent.FalconClient then continue end
        table.insert(Falcon.InteractionActiveEntities, ent)
    end

    for _, ent in pairs( Falcon.ItemsEntities ) do
        if not ent.FalconClient then continue end
        if not ent.Interaction then continue end
        if ply:GetPos():DistToSqr( ent:GetPos() ) > 7500 then continue end
        table.insert(Falcon.InteractionActiveEntities, ent)
    end

    if input.IsKeyDown( KEY_E ) then
        if Falcon.StartInteractionTime == 0 then
            Falcon.StartInteractionTime = CurTime()
        end
    else
        Falcon.StartInteractionTime = 0
    end
end

hook.Add("Think", "InteractHandler", InteractHandler)
hook.Add("HUDPaint", "DrawNPCsInteractions", DrawNPCsInteractions)
hook.Add("PostDrawOpaqueRenderables", "DrawNPCsOverhead", DrawNPCNames)
