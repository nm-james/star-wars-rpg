AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')


function ENT:Initialize( )
	local ent = self.ParentEntity
	if not ent then return end

	local pos = ent:GetAttachment(ent:LookupAttachment("centerposit")).Pos
	self:SetModel("models/hunter/misc/sphere2x2.mdl")
	self:SetModelScale( 1.075 )
	self:SetOwner(ent)
	up = 10
	forward = 0
	right = 0
	aforward = 0 
	aup = 0
	local AttachmentTab = ent:GetAttachment(ent:LookupAttachment("centerposit"))
	self:SetPos(AttachmentTab.Pos + AttachmentTab.Ang:Up()*up + AttachmentTab.Ang:Forward()*forward + AttachmentTab.Ang:Right()*right )
	self:PhysicsInit(SOLID_VPHYSICS)	
	self:SetSolid(SOLID_VPHYSICS)
	self:SetMaterial("models/debug/debugwhite")
	self:SetRenderMode( 2 )
	self:SetColor( Color( 0, 225, 255, 85 ) )
    self:DrawShadow( false )

	AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Forward(),aforward)
	AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Up(),aup)
	self:SetAngles( AttachmentTab.Ang )
	self:SetParent(ent, ent:LookupAttachment("centerposit")) 

end

function ENT:OnTakeDamage( dmginfo )
	if self:GetModelScale() < 1.075 then return end
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		local ent = self.ParentEntity
		local attacker = dmginfo:GetAttacker()
		local aLevel = ent.Level
		local pLevel = attacker:GetLevel()

		local scale = math.Clamp( pLevel / aLevel, 0.2, 999999999 )
		dmginfo:ScaleDamage( scale )

		local newArmor = math.Clamp( math.Round( ent:Armor() - dmginfo:GetDamage(), 0 ), 0, ent:GetMaxArmor())
		if newArmor == 0 then
			ent.ShieldA = nil
			self:Remove()

		end

		ent:SetArmor( newArmor )

		self.m_bApplyingDamage = false
	end
end 

function ENT:Think()
	self:RemoveAllDecals()
end

