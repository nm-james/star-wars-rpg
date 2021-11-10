
include( 'shared.lua' )

Falcon = Falcon or {}
Falcon.Departments = Falcon.Departments or {}
Falcon.Regiments = Falcon.Regiments or {}
Falcon.Classes = Falcon.Classes or {}

function GM:InitPostEntity()
	local ply = LocalPlayer()
	if ply.Loaded then return end

    net.Start("F:SW:Player:Loaded")
    net.SendToServer()

	local maxStamina = ply:GetMaxSprint()
    ply.CurStaminaLeft = maxStamina

	ply.Loaded = true
end

for i = 1, 60 do
	surface.CreateFont( "F" .. tostring(i), {
		font = "Teko",
		size = ScreenScale( i )
	})
end

net.Receive("FALCON:SENDCONTENT", function()
	local newTbl = net.ReadTable()

	SortNewData( newTbl )
	Falcon.Departments = newTbl.Departments
	Falcon.Regiments = newTbl.Regiments
	Falcon.Classes = newTbl.Classes
	Falcon.Items = newTbl.Items

	for id, i in pairs( newTbl.Items ) do
		Falcon.ItemsIdentifier[i.name] = tonumber(id)
	end

	LoadTransportFromPlanets("Venator")
	LocalPlayer().Location = "Venator"
end)



function ThirdPersonCalc( ply, pos, angles, fov )
	local bn = ply:LookupBone( "ValveBiped.Bip01_Head1" )

	if bn then
		pos = ply:GetBonePosition(bn)
	end

	local eye = ply:EyePos()
	local tr = util.TraceLine( {
		start = eye,
		endpos = eye + (angles:Forward() * -100),
		filter = function( ent ) 
			if ent:IsWorld() then 
				return true 
			end 
		end
	} )

	local fPos = tr.HitPos + (angles:Forward() * 12) + ( angles:Up() * 10 )

	if input.IsMouseDown( MOUSE_RIGHT ) then
		fPos = fPos + (angles:Right() * 20) + (angles:Forward() * 45) + ( angles:Up() * -3 )
	end

	local view = {
		origin = fPos,
		angles = angles,
		fov = fov,
		drawviewer = true
	}

	return view
end
-- hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)

function GM:PlayerButtonDown(ply, key)
    if key == KEY_B then
        if ply.ThirdPersonTimer and ply.ThirdPersonTimer > CurTime() then return end
        if ply.ThirdPersonEnabled then
            hook.Remove("CalcView", "FalconsThirdPerson")
            ply.ThirdPersonEnabled = false
        else
            hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
            ply.ThirdPersonEnabled = true
        end
		ply.ThirdPersonTimer = CurTime() + 0.2
	elseif key == KEY_I then
		Falcon.UI.Inventory.OpenFrame()
	elseif key == KEY_P then
		OpenCharacters( true )
	end
end


-- local ply = LocalPlayer()

-- if zombie and zombie:IsValid() then
-- 	zombie:Remove()
-- end
-- zombie = ClientsideModel("models/props_borealis/bluebarrel001.mdl")
-- zombie:SetParent(ply)
-- zombie:AddEffects(EF_BONEMERGE)

-- print( ply:LookupSequence( "wos_l4d_collapse_to_incap" ) )

local hide = {
	["CHudHealth"] = false,
	["CHudAmmo"] = true,
	["CHudSecondaryAmmo"] = true,
	["CHudSquadStatus"] = true,
	["CHudHintDisplay"] = true,
	["CHudDeathNotice"] = true,
	["CHudCrosshair"] = true,
	["CHudBattery"] = true
}
hook.Add( "HUDShouldDraw", "F_HIDE_HUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )

