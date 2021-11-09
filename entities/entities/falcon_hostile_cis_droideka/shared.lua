AddCSLuaFile()

ENT.Base 			= "base_nextbot"
ENT.Spawnable		= true
ENT.PrintName 		= "Droideka"
ENT.Name = "Droideka [MAIN]"

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

function ENT:Armor()
	return self:GetNWInt("FALCON:DROID:ARMOR", 0)
end

function ENT:GetMaxArmor()
	return self:GetNWInt("FALCON:DROID:MAXARMOR", 0)
end

if SERVER then return end

local color_black = Color( 0, 0, 0, 195 )
local color_white = Color( 255, 255, 255, 255 )
local color_red = Color( 75, 0, 0, 255 )
local color_green = Color( 0, 125, 0, 255 )
local color_grey = Color( 135, 135, 135, 255 )
local color_cyan = Color( 0, 255, 255, 255 )

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
    local seq = self:GetSequenceList()
    for i = 1001, 2000 do
        print(i, seq[i])
    end

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
        draw.RoundedBox( 0, -75, -12, 200, 35, color_black )
        surface.SetDrawColor( color_white )
        draw.RoundedBox( 0, -150, -20, 75, 75, plyCol )
        surface.SetDrawColor( color_white )
        surface.DrawOutlinedRect( -150, -20, 75, 75 )

        surface.DrawOutlinedRect( -75, -12, 200, 35 )
        draw.RoundedBox( 0, -70, -7, 190 * (hp / maxHp), 25, plyCol )

        local text = tostring(hp) .. "/" .. tostring(maxHp)
        if self:Armor() > 0 then
            local ar = self:Armor()
            local maxAr = self:GetMaxArmor()
            surface.DrawOutlinedRect( -75, -12, 200, 35 )
            draw.RoundedBox( 0, -70, -7, 190 * (ar / maxAr), 12.5, color_cyan )
            text = tostring(hp) .. " + " .. tostring(self:Armor())
        end

        
        draw.DrawText( text, "F12", 25, -17, color_white, TEXT_ALIGN_CENTER )
        draw.DrawText( self:GetNWInt("Falcon:Level", 0), "F24", -114, -25, color_white, TEXT_ALIGN_CENTER )

        for id, m in pairs( self.Mods ) do
            draw.RoundedBox( 0, -75 + ((id - 1) * 27), 22, 27, 27, color_black )
            surface.SetDrawColor( color_white )
            surface.DrawOutlinedRect( -75 + ((id - 1) * 27), 22, 27, 27 )
        end
    cam.End3D2D()
end