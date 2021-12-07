
local animatedModels = {}
local function AnimateModel( ply, nick, color )
	if animatedModels[nick] then return animatedModels[nick].animation end
	local mdlLol = ClientsideModel( ply:GetModel() )
	mdlLol:SetParent( ply )
	local bones = mdlLol:GetBoneCount()
	for i = 0, bones - 1 do
		mdlLol:ManipulateBoneScale( i, Vector( 1.075, 1.075, 1.075 ) )
	end
	mdlLol:AddEffects( EF_BONEMERGE )
	mdlLol:SetMaterial( "Models/effects/comball_sphere" )
	mdlLol:SetRenderMode( RENDERMODE_TRANSCOLOR )
	mdlLol:SetColor( color )
	mdlLol.CurColor = color

	return mdlLol
end
local function Hurt( ply, nick, color )
	local mdl = AnimateModel( ply, nick, color )

	local curTime = CurTime()
	mdl.ShouldLowerModel = curTime + 0.4

	local oldColor = mdl:GetColor()
	mdl:SetColor( Color( color.r, color.g, color.b, oldColor.a ) )
	animatedModels[nick] = { animation = mdl, owner = ply }
end
local function Heal( ply, color )
	if ply.CurHP == ply:Health() then return end

	AnimateModel( ply, color )

	ply.CurHP = ply:Health()

	local curTime = CurTime()
	ply.NextHeal = nil
	ply.ShouldLowerModel = curTime + 1.25
end


hook.Add( "Think", "F_ANIMATE_HEALTH", function()
	for id, data in pairs( animatedModels ) do
		local ply = data.owner
		local mdl = data.animation
		if not ply:Alive() then
			mdl:Remove()
			animatedModels[id] = nil
			continue
		end
		if not mdl.ShouldLowerModel then continue end
		local col = mdl:GetColor()
		if mdl.ShouldLowerModel > CurTime() then
			local newAlpha = math.Clamp(col.a + ((FrameTime() * 6) * 255), 0, 255)
			col.a = newAlpha
			mdl:SetColor( col )
		else
			local newAlpha = math.Clamp(col.a - ((FrameTime() * 6) * 255), 0, 255)
			col.a = newAlpha
			mdl:SetColor( col )
			if newAlpha == 0 then
				mdl:Remove()
				animatedModels[id] = nil
			end
		end
	end
end)

net.Receive("FALCON:PLAYER:DAMAGE", function()
	local name = net.ReadString()
	for _, ply in pairs( player.GetAll() ) do
		if ply:Nick() == name then
			if ply:GetPos():Distance( LocalPlayer():GetPos() ) > 5000 then break end
			if ply:Armor() > 0 then
				Hurt( ply, name, Color( 20, 155, 255, 0 ) )
			else
				Hurt( ply, name, Color( 255, 0, 0, 0 ) )
			end
			break
		end
	end
end)