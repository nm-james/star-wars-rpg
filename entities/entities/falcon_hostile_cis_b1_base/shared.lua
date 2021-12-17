AddCSLuaFile()
ENT.Base 			= "base_nextbot"

ENT.Spawnable		= false
ENT.PrintName 		= "B1 Base"
ENT.Name = "B1 Battledroid [BASE]"
ENT.Modifiers = {
	[1] = {
		text = "TANK",
	},
    [2] = {
		text = "HASTE",
	},
    [3] = {
		text = "AMMO",
	},
    [4] = {
		text = "LEADER",
	},
    [5] = {
		text = "COMMS",
	},
    [6] = {
		text = "MEDIC",
	},
    [7] = {
		text = "ANCHOR",
	},
}


if SERVER then return end

local color_black = Color( 0, 0, 0, 195 )
local color_white = Color( 255, 255, 255, 255 )
local color_red = Color( 75, 0, 0, 255 )
local color_green = Color( 0, 125, 0, 255 )
local color_grey = Color( 135, 135, 135, 255 )

function ENT:Initialize()
    self.ThinkRemove = CurTime() + 0.25
    self.Mods = {}
end 

function ENT:SortModifiers()
    local mods = {}
    for id, mod in pairs( self.Modifiers ) do
        if not self:GetNWBool("FALCON:MODIFIERS:" .. tostring(id), false) then continue end
        table.insert(mods, id)
    end
    self.Mods = mods
end

function ENT:Think()
    if self.ThinkRemove and self.ThinkRemove < CurTime() then 
        self:SortModifiers()
        self.Think = nil 
        return 
    end
end

function ENT:GetLevelColor( ply )
    local level = ply:GetLevel()
    local entLevel = self:GetNWInt("Falcon:Level", 0)
    local difference = level - entLevel

    local req = 15

    if difference > req then
        return color_green
    elseif difference <= req and difference >= -req then
        return color_grey
    elseif difference < -req then
        return color_red
    end
end

function ENT:Draw()
    self:DrawModel()
    local ply = LocalPlayer()

    if ply:GetPos():Distance( self:GetPos() ) > 2000 then return end

    local mins, maxs = self:GetCollisionBounds()
    local pos = self:GetPos()

    local ang = ply:EyeAngles()
	ang:RotateAroundAxis( ang:Forward(), 90 )
	ang:RotateAroundAxis( ang:Right(), 90 )

    local hp = self:Health()
    local maxHp = self:GetMaxHealth()
    local plyCol = self:GetLevelColor( ply )

    cam.Start3D2D( Vector( pos.x, pos.y, pos.z + maxs.z + 7 ), ang, 0.1 )
        draw.RoundedBox( 0, -170, -20, 100, 100, plyCol )
        surface.SetDrawColor( color_white )
        surface.DrawOutlinedRect( -170, -20, 100, 100 )

        draw.RoundedBox( 0, -69, 18, 230, 30, color_black )
        surface.SetDrawColor( color_white )
        surface.DrawOutlinedRect( -69, 18, 230, 30 )
        draw.RoundedBox( 0, -64, 23, 220 * (hp / maxHp), 20, plyCol )

        draw.DrawText( tostring(hp) .. "/" .. tostring(maxHp), "F11", 51, 13, color_white, TEXT_ALIGN_CENTER )
        draw.DrawText( self:GetNWInt("Falcon:Level", 0), "F27", -121, -18, color_white, TEXT_ALIGN_CENTER )
        draw.SimpleTextOutlined( self.Name, "F12", -68, -18, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_TOP, 2, color_black )
        for id, m in pairs( self.Mods ) do
            draw.RoundedBox( 0, -69 + ((id - 1) * 27), 49, 27, 27, color_black )
            surface.SetDrawColor( color_white )
            surface.DrawOutlinedRect( -69 + ((id - 1) * 27), 49, 27, 27 )
        end
    cam.End3D2D()
end

net.Receive("FALCON:NEXTBOTS:CREATERAGDOLL", function()
    local pos = net.ReadVector()

    local effectdataspk = EffectData()
	effectdataspk:SetOrigin( pos )
	effectdataspk:SetScale( 90 )
	util.Effect( "ManhackSparks", effectdataspk )

    local effectdataexp = EffectData()
    effectdataexp:SetOrigin( pos )
    effectdataexp:SetScale(90)
    util.Effect( "Explosion", effectdataexp )
end)

net.Receive("FALCON:NEXTBOTS:EFFECTS", function()
    local pos = net.ReadVector()

    local effectdataspk = EffectData()
	effectdataspk:SetOrigin( pos + Vector( 0, 0, 50 ) )
	effectdataspk:SetScale( 900 )
	util.Effect( "ManhackSparks", effectdataspk )
end)