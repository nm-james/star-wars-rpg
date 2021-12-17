AddCSLuaFile( "shared.lua" )

include('shared.lua')

if CLIENT then return end

ENT.Model = ENT.Model or "models/lightnings_edits/npc_droids/b1_battledroid_assault.mdl"
ENT.HP = ENT.HP or 1500
ENT.RunSpeed = ENT.RunSpeed or 175

ENT.WeaponModel = ENT.WeaponModel or "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"
ENT.WeaponAttackDelay = ENT.WeaponAttackDelay or 0.3
ENT.WeaponDamage = ENT.WeaponDamage or 40
ENT.WeaponMinShot = ENT.WeaponMinShot or 3
ENT.WeaponMaxShot = ENT.WeaponMaxShot or 9
ENT.WeaponTracerAmount = ENT.WeaponTracerAmount or 1
ENT.WeaponSpread = ENT.WeaponSpread or Vector( 20, 20, 10 )
local modifierFunctions = {
	[1] = function( ent )
		local hp = ent:Health()
		ent:SetHealth( hp * 1.5 )
		ent:SetMaxHealth( hp * 1.5 )
	end,
	[2] = function( ent )
		ent.RunSpeed = ent.RunSpeed * 1.4
	end,
	[3] = function( ent )

	end,
	[4] = function( ent )

	end,
	[5] = function( ent )

	end,
	[6] = function( ent )

	end,
	[7] = function( ent )

	end,
	[8] = function( ent )

	end,
	[9] = function( ent )

	end,
	[10] = function( ent )

	end,
}

function ENT:Initialize()
	self:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
	self:SetBloodColor( DONT_BLEED )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetCollisionGroup( COLLISION_GROUP_DEBRIS_TRIGGER )
	self:SetModel( self.Model )

	self.loco:SetStepHeight( 40 )

	-- PreConfig lol
	self.LoseRangeDistance = self.LoseRangeDistance or 9999999999
	self.PassiveNPC = true
	self.IgnoreDistance = self.IgnoreDistance or false

	if self.PassiveNPC then
		self.SpawnLocation = self:GetPos()
		self.LoseRangeDistance = 1500
	end

	self.AtSpawn = true
	self.CurAttackAmount = 0

	self.Level = self.Level or math.random(1, 150)
	self:SetNWInt("Falcon:Level", self.Level)

	-- self:SetHealth( self.HP * self.Level )
	-- self:SetMaxHealth( self.HP * self.Level )
	self:SetHealth( self.HP )
	self:SetMaxHealth( self.HP )

	self:GiveWeapon()

	local mods = {}

	for id, mod in pairs( self.Modifiers ) do
		if #mods >= 5 then break end
		local modifiyTest = math.random(-(#self.Modifiers * 5), #self.Modifiers)
		if modifiyTest <= 0 then continue end
		table.insert(mods, id)
	end

	self.Mods = self.Mods or mods

	for _, mod in pairs( self.Mods ) do
		self:SetNWBool("FALCON:MODIFIERS:" .. tostring(mod), true)
		modifierFunctions[mod]( self )
	end
	
end

function ENT:SetEnemy( enem )
	self.Enemy = enem
end

function ENT:GetEnemy()
	return self.Enemy
end

function ENT:SetNextPos( p )
	self.NextPos = p
end

function ENT:GetNextPos()
	local pos = self.NextPos
	local enem
	if not pos then
		enem = self:GetEnemy()
		if enem and enem:IsValid() and enem:Alive() then
			pos = enem:GetPos()
		else
			self:SetEnemy( false )
		end
	end

	if not self.AtSpawn and self.PassiveNPC and not pos then
		self:SetNextPos( self.SpawnLocation )
		return self.SpawnLocation
	end

	if pos then
		if self.NextPos then
			return pos
		else
			local range = self:GetRangeTo( pos )
			if range > self.LoseRangeDistance then
				self:SetEnemy( false )
			else
				return pos
			end
		end
	end

	return self:FindEnemy()
end

function ENT:SetMaxArmor(ar)
	self:SetNWInt("FALCON:DROID:MAXARMOR", ar)
end

function ENT:SetArmor(ar)
	self:SetNWInt("FALCON:DROID:ARMOR", ar)
end

function ENT:Armor()
	return self:GetNWInt("FALCON:DROID:ARMOR", 0)
end

function ENT:FindEnemy()
	local spawnPos = self.SpawnLocation

	local p = self.Players or player.GetAll()
	if not p or #p == 0 then return false end

	local availableP = {}
	for _, ply in pairs( p ) do
		if self:GetRangeTo( ply:GetPos() ) > self.LoseRangeDistance then continue end
		if not ply:Alive() then continue end
		table.insert(availableP, ply)
	end

	if #availableP == 0 then return false end

	local randomPlayer = availableP[math.random(1, #availableP)]
	self:SetEnemy( randomPlayer )
	self.AtSpawn = false

	return true
end

function ENT:SetTargetedPlayers( players )
	self.TargetPlayers = players
end

function ENT:RunBehaviour()
	while ( true ) do
		self.loco:SetAcceleration( 600 )
		self.loco:SetDesiredSpeed( self.RunSpeed )

		if self:GetNextPos() then
			self:StartActivity( ACT_RUN_AIM_SHOTGUN )
			self:MovePosition( {}, self:GetNextPos() )
		else
			if self:GetActivity() ~= ACT_IDLE_SHOTGUN_RELAXED then
				self:StartActivity( ACT_IDLE_SHOTGUN_RELAXED )
			end
		end

		coroutine.wait(0.1)
	end
end

function ENT:MovePosition( options )
	local options = options or {}
	local path = Path( "Follow" )
	path:SetMinLookAheadDistance( options.lookahead or 500 )
	path:SetGoalTolerance( options.tolerance or 125 )
	path:Compute( self, self:GetNextPos() )

	while ( self:GetNextPos() ) do
		local pos = self:GetNextPos()

		if self.CurAttackAmount == 0 then
			if path:IsValid() then
				path:Update( self )
				if path:GetAge() > 0.1 then
					path:Compute( self, pos )
				end
			else
				self.loco:Approach( pos, 125 )
				self.loco:FaceTowards( pos )
			end
			if self:GetActivity() ~= ACT_RUN_AIM_SHOTGUN then
				self:StartActivity( ACT_RUN_AIM_SHOTGUN )
				print("STUIPD")
			end
		end
		
        local e = self:GetEnemy()
		if path:IsValid() or self.CurAttackAmount ~= 0 then
			if e and e:IsValid() and e:Alive() then
				self.loco:FaceTowards( e:GetPos() )
			end	
		end

		if ( self.loco:IsStuck() ) then
			self:HandleStuck()
			return "stuck"
		end

		coroutine.yield()

	end
end

local doors = {
    ["func_door"] = true,
    ["func_door_rotating"] = true,
    ["prop_door_rotating"] = true,
    ["func_movelinear"] = true,
    ["prop_dynamic"] = true
}
function ENT:OnContact( ent )
	if ent:IsNextBot() then
	elseif doors[ent:GetClass()] then
		ent:Fire("Open")
	end
end

util.AddNetworkString("FALCON:NEXTBOTS:EFFECTS")
function ENT:OnTakeDamage( dmginfo )
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true

		local attacker = dmginfo:GetAttacker()
		
		if attacker:IsPlayer() then
			local aLevel = self.Level
        	local pLevel = attacker:GetLevel()

			local scale = math.Clamp( pLevel / aLevel, 0.2, 999999999 )
			dmginfo:ScaleDamage( scale )
			self:TakeDamageInfo( dmginfo )

			local p = self.Players or player.GetAll()
			for _, ply in pairs( p ) do
				net.Start("FALCON:NEXTBOTS:EFFECTS")
					net.WriteVector( self:GetPos() )
				net.Send( ply )
			end
		end

		self.m_bApplyingDamage = false
	end
end

function ENT:GiveWeapon()
    self.Weapon = ents.Create("falcon_npc_weapon")
    local pos = self:GetAttachment(self:LookupAttachment("anim_attachment_RH")).Pos
    self.Weapon:SetOwner(self)
    up = 0
    forward = 9
    right = 0
    aforward = 0
    aup = 0
	aright = 11
    local AttachmentTab = self:GetAttachment(self:LookupAttachment("anim_attachment_RH"))
    self.Weapon:SetPos(AttachmentTab.Pos + AttachmentTab.Ang:Up()*up + AttachmentTab.Ang:Forward()*forward + AttachmentTab.Ang:Right()*right )
    self.Weapon:Spawn() 
    self.Weapon:SetModel(self.WeaponModel)
    self.Weapon:PhysicsInit(SOLID_NONE)    
    self.Weapon:SetSolid(SOLID_NONE)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Forward(),aforward)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Up(),aup)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Right(),aright)

    self.Weapon:SetAngles( AttachmentTab.Ang )
    self.Weapon:SetParent(self, self:LookupAttachment("anim_attachment_RH")) 
end

function ENT:FireWeapon()
	local enem = self:GetEnemy()
	if not enem or not enem:IsValid() then self.CurAttackAmount = 0 return false end
	if not self.IsAttacking then self.CurAttackAmount = 0 return false end

    local bullet = {}
    bullet.Num = self.WeaponTracerAmount
    bullet.Src = self:GetBonePosition(17)
    bullet.Dir = enem:LocalToWorld(enem:OBBCenter()) - self:GetBonePosition(17)
    bullet.Spread = self.WeaponSpread
    bullet.Tracer = 1
    bullet.TracerName = "f_lfs_laser_red_large"
    bullet.Force = 0
    bullet.Damage = 20
    bullet.AmmoType = "Pistol"
    bullet.Callback = function(att, tr, dmginfo)
      	dmginfo:SetDamageType(DMG_BULLET)
    end
    -- self:EmitSound("f_cigg/npcs/b2/fire_bullet.wav", 150, 100, 1, CHAN_AUTO)
	
    self.Weapon:FireBullets( bullet, true )

	-- self:StartActivity(ACT_GESTURE_RANGE_ATTACK_SHOTGUN)
	self.CurAttackAmount = self.CurAttackAmount - 1
end

function ENT:Attack( attackAmount )
	self.CurAttackAmount = attackAmount
	self:StartActivity( ACT_RANGE_ATTACK_SHOTGUN )
	for i = 1, attackAmount do
		if not self or not self:IsValid() then return end
		timer.Simple((i - 1) * self.WeaponAttackDelay, function()
			if not self or not self:IsValid() then return end
			self:FireWeapon()
		end)
	end
	self.AttackingDelay = CurTime() + ((attackAmount / 4) + 3)
end

function ENT:ReachedDestination()
	local startingPos = self:GetPos()
	local endingPos = self:GetNextPos()
	if not startingPos or not endingPos then return end
	local x = endingPos.x - startingPos.x
	local y = endingPos.y - startingPos.y
	if (x > -40 and x < 40) and (y > -40 and y < 40) then
		return true
	end
end

function ENT:GetAdjacentArea()
	local enem = self:GetEnemy()
	if not enem or not enem:IsValid() then return end
	if self.NextPos then return end
	local pos = enem:GetPos()
	local ang = self:GetAngles()

	local curAngles = math.random(1, 2)
	if curAngles == 1 then
		curAngles = ang:Forward() * math.random(-500, 500)
	elseif curAngles == 2 then
		curAngles = ang:Right() * math.random(-500, 500)
	end

	local tr = util.TraceLine( {
		start = pos,
		endpos = pos + curAngles,
		filter = function( ent ) 
			if ( ent:IsWorld() ) then 
				return true 
			end 
			return false
		end
	} )

	self:SetNextPos( tr.HitPos )
end

function ENT:Think()
	local nextPos = self:GetNextPos()
	if not nextPos then return end
	if self:ReachedDestination() then
		if nextPos == self.SpawnLocation then 
			self.AtSpawn = true
		end

		self:SetNextPos( false )
	else
		local enem = self:GetEnemy()
		if enem and enem:IsValid() then
			local range = self:GetRangeTo( enem:GetPos() )
			if range < 1000 then
				if not self.IsAttacking then
					self.IsAttacking = true
				end
				self:GetAdjacentArea()
			else
				if self.IsAttacking then
					self.IsAttacking = false
				end
			end
		end
	end

	if self.IsAttacking then
		if not self.AttackingDelay or self.AttackingDelay < CurTime() then
			self:Attack( math.random(self.WeaponMinShot, self.WeaponMaxShot) )
		end
	end
end

util.AddNetworkString("FALCON:NEXTBOTS:CREATERAGDOLL")
function ENT:OnKilled( dmginfo )

	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )

	local p = self.Players or player.GetAll()
	for _, ply in pairs( p ) do
		net.Start("FALCON:NEXTBOTS:CREATERAGDOLL")
			net.WriteVector( self:GetPos() )
		net.Send( ply )
	end
	self:Remove()

end

-- function ENT:BodyUpdate()
-- 	self:BodyMoveXY()
-- end
