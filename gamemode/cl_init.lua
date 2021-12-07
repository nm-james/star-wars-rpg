
include( 'shared.lua' )

Falcon = Falcon or {}
Falcon.Player = Falcon.Player or {}
Falcon.Player.Quests = Falcon.Player.Quests or {}
Falcon.Player.CompletedQuests = Falcon.Player.CompletedQuests or {}

Falcon.Departments = Falcon.Departments or {}
Falcon.Regiments = Falcon.Regiments or {}
Falcon.Classes = Falcon.Classes or {}
Falcon.Locations = Falcon.Locations or {}
Falcon.NPCs = Falcon.NPCs or {}
Falcon.NPCsCE = Falcon.NPCsCE or {}


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

function SortQuests( questsStarted )
	local ply = LocalPlayer()

	for questID, quest in pairs( Falcon.Quests ) do
		if questsStarted[questID] then
			local status = questsStarted[questID]
			if status == 1 then
				Falcon.ActiveQuests[questID] = true
				if Falcon.FocusedQuest == 0 then
					Falcon.FocusedQuest = questID
				end
				-- add to inprogress
			elseif status == 2 then
				local questData = Falcon.Quests[questID]
				local ent = Falcon.NPCsCE[questData.QuestHolder]
				if ent and ent:IsValid() then 
					local dia = {
						Text = questData.Name,
						Quest = questID,
						Next = function()
							FadeFrame( function() 
								return Falcon.UI.Scening.OpenFrame( questID, ent )
							end )
						end
					}
		
					local options = ent.Options
					table.insert(options.Dialogue, dia)
					ent.Options = options
				end
			else
				-- add in completed
				Falcon.Player.CompletedQuests[questID] = true
			end
		else
			local canDoQuest = quest.Requirement( ply )
			if not canDoQuest then continue end
			local ent = Falcon.NPCsCE[quest.QuestHolder]
			if not ent or not ent:IsValid() then continue end
			-- find entity responsible and add the quest
			local dia = {
				Text = quest.Name,
				Quest = questID,
				Next = function()
					FadeFrame( function() 
						return Falcon.UI.Scening.OpenFrame( questID, ent )
					end )
				end
			}

			local options = ent.Options
			if not options then continue end
			table.insert(options.Dialogue, dia)
			ent.Options = options
		end
	end
end

net.Receive("FALCON:SENDCONTENT", function()
	local newTbl = net.ReadTable()

	SortNewData( newTbl )
	Falcon.Departments = newTbl.Departments
	Falcon.Regiments = newTbl.Regiments
	Falcon.Classes = newTbl.Classes
	Falcon.Items = newTbl.Items
	Falcon.Locations = newTbl.Locations
	Falcon.NPCs = newTbl.NPCs
	local sortedTbl = {}
	for _, data in pairs( newTbl.Quests ) do
		sortedTbl[data.quest] = data.status
	end
	Falcon.Player.Quests = sortedTbl
	SortQuests( sortedTbl )

	for id, i in pairs( newTbl.Items ) do
		Falcon.ItemsIdentifier[i.name] = tonumber(id)
	end

	LoadTransportFromPlanets("Venator")
	LoadNPCsFromPlanets("Venator")
	
	LocalPlayer().Location = "Venator"
end)
LoadTransportFromPlanets("Venator")
LoadNPCsFromPlanets("Venator")
SortQuests( Falcon.Player.Quests )
-- SortQuests( {} )


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
	elseif key == KEY_O then
		Falcon.UI.Quests.OpenFrame()
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
	["CHudBattery"] = false
}
hook.Add( "HUDShouldDraw", "F_HIDE_HUD", function( name )
	if ( hide[ name ] ) then
		return false
	end
end )
