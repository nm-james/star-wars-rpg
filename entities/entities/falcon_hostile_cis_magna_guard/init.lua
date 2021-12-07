AddCSLuaFile( "shared.lua" )

include('shared.lua')

if CLIENT then return end

ENT.Model = ENT.Model or "models/npcs/hc/droids/rcgg.mdl"
ENT.HP = ENT.HP or 5000
ENT.RunSpeed = ENT.RunSpeed or 210

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

util.AddNetworkString("FALCON:NBBASE:MODIFIER:SYNC")
function ENT:Initialize()
	self:SetMoveCollide( MOVECOLLIDE_FLY_BOUNCE )
	self:SetBloodColor( BLOOD_COLOR_MECH )
	self:PhysicsInit( SOLID_VPHYSICS )

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

	self.Level = self.Level or math.random(1, 150)
	self:SetNWInt("Falcon:Level", self.Level)

    PrintTable(self:GetSequenceList())

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
	
    self.NextAttackSeq = 21
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

function ENT:FindEnemy()
	local f = Falcon or {}
	local spawnPos = self.SpawnLocation

	local p = f.Players or player.GetAll()
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
			self:StartActivity( ACT_RUN )
			self:MovePosition( {}, self:GetNextPos() )
		else
			if self:GetActivity() ~= ACT_IDLE then
				self:StartActivity( ACT_IDLE )
			end
		end

		coroutine.wait(0.1)
	end
end

function ENT:HurtPlayer()
    local e = self:GetEnemy()
    if not e or not e:IsValid() or not e:Alive() then return end
    if self:GetRangeTo( e:GetPos() ) < 80 then
        local d = DamageInfo()
        d:SetDamage( math.Clamp((self.Level / e:GetLevel()), 0.2, 999999999) * math.random(25, 50) )
        d:SetAttacker( self )
        d:SetDamageType( DMG_SLASH ) 

        e:TakeDamageInfo( d )
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

        if path:IsValid() then
            path:Update( self )
            if path:GetAge() > 0.1 then
                path:Compute( self, pos )
            end
        else
            self.loco:Approach( pos, 125 )

            local lookAtPos = pos
            local e = self:GetEnemy()
            if e and e:IsValid() and e:Alive() then
                lookAtPos = e:GetPos()
            end
            self.loco:FaceTowards( lookAtPos )
			if self:GetActivity() ~= ACT_RUN then
                self:StartActivity( ACT_RUN )
            end
        end
        if not self.ShouldAttack then
            if self:GetActivity() ~= ACT_RUN then
                self:StartActivity( ACT_RUN )
            end
        else
            if self.loco:IsOnGround() then
                self.ShouldAttack = false
                local seqLen = self:SequenceDuration( self:LookupSequence(self.NextAttackSeq) )
                local t = (seqLen / 2) * 0.75
                timer.Simple(t, function()
                    self:HurtPlayer()
                    timer.Simple(t, function()
                        self:HurtPlayer()
                    end)
                end)
                self:PlaySequenceAndWait(self.NextAttackSeq)
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

function ENT:Explode()
	local effectdataspk = EffectData()
	effectdataspk:SetOrigin(self:GetPos())
	effectdataspk:SetScale( 90 )
	util.Effect( "ManhackSparks", effectdataspk )

    local effectdataexp = EffectData()
    effectdataexp:SetOrigin(self:GetPos())
    effectdataexp:SetScale(7)
    util.Effect( "Explosion", effectdataexp )
end
function ENT:OnKilled( dmginfo )
	hook.Call( "OnNPCKilled", GAMEMODE, self, dmginfo:GetAttacker(), dmginfo:GetInflictor() )
	
	self:Remove()

    self:Explode()
end

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

            if self:Health() > 0 then
                local shouldLeap = math.random(1, 3)
                if shouldLeap == 1 then
                    self.loco:JumpAcrossGap( self:GetNextPos(), Vector( 0, 0, 0 ) )
                end
            end
		end

		self.m_bApplyingDamage = false
	end
end

function ENT:GiveWeapon()
    self.Weapon = ents.Create("prop_physics")
    local pos = self:GetAttachment(self:LookupAttachment("hand_staff")).Pos
    self.Weapon:SetOwner(self)
    up = 0
    forward = 9
    right = 0
    aforward = 0
    aup = 0
	aright = 30
    local AttachmentTab = self:GetAttachment(self:LookupAttachment("hand_staff"))
    self.Weapon:SetPos(AttachmentTab.Pos + AttachmentTab.Ang:Up()*up + AttachmentTab.Ang:Forward()*forward + AttachmentTab.Ang:Right()*right )
    self.Weapon:SetModel("models/npcs/hc/droids/rcggstaff.mdl")
    self.Weapon:Spawn() 
    self.Weapon:PhysicsInit(SOLID_NONE)    
    self.Weapon:SetSolid(SOLID_NONE)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Forward(),aforward)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Up(),aup)
    AttachmentTab.Ang:RotateAroundAxis(AttachmentTab.Ang:Right(),aright)

    self.Weapon:SetAngles( AttachmentTab.Ang )
    self.Weapon:SetParent(self, self:LookupAttachment("hand_staff")) 
end

function ENT:Attack()
    self.IsAttacking = true
    local seq = self.NextAttackSeq
    if seq == "MeleeHit" then
        self.NextAttackSeq = "MeleeHitTwo"
    else
        self.NextAttackSeq = "MeleeHit"
    end
    self.ShouldAttack = true
    self.IsAttacking = false
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

    local shouldLeap = math.random(1, 3)
    if shouldLeap == 1 then
        local shouldLeapToPlayer = math.random(1, 2)

        if shouldLeapToPlayer == 1 then
            self.loco:JumpAcrossGap( pos, Vector( 0, 0, 0 ) )
        else
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
            self.loco:JumpAcrossGap( tr.HitPos, Vector( 0, 0, 0 ) )
        end
    end
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
                if range < 80 then
                    if not self.ShouldAttack then
                        self:Attack()
                    end
                else
                    self:GetAdjacentArea()
                end
			end
		end
	end
end

-- function ENT:BodyUpdate()
-- 	self:BodyMoveXY()
-- end



