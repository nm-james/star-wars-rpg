AddCSLuaFile()

ENT.Type = "anim"
ENT.Base = "base_gmodentity"
 
ENT.PrintName		= "Glowball"
ENT.Author			= "Ricky26"
ENT.Contact			= "Don't"
ENT.Purpose			= "Exemplar material"
ENT.Instructions	= "Use with care. Always handle with gloves."

if SERVER then
	function ENT:Initialize()
		self:PhysicsInit( SOLID_VPHYSICS )
		self:SetMoveType( MOVETYPE_VPHYSICS ) 
		self:SetSolid( SOLID_VPHYSICS )
		self:SetModel( "models/props_borealis/bluebarrel001.mdl" )
	
		local phys = self:GetPhysicsObject()
		if phys:IsValid() then
			phys:Wake()
		end
	end
	util.AddNetworkString("FALCON:ADDIMPACT")
	function ENT:DoImpactEffect()
		return true
	end	
else
 	function ENT:Draw()
		self:DrawModel()
	end
	
end
