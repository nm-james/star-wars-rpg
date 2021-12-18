AddCSLuaFile()
SWEP.Type                  = "anim"
SWEP.Base                  = "weapon_base"

SWEP.PrintName          = "Z6"
SWEP.Slot               = 4
SWEP.SlotPos            = 1
SWEP.ViewModelFlip      = false
SWEP.ViewModelFOV       = 90
SWEP.Category           = "Falcon's SWEPs"

SWEP.Primary.Damage = 50 --The amount of damage will the weapon do
SWEP.Primary.TakeAmmo = 1 -- How much ammo will be taken per shot
SWEP.Primary.ClipSize = 200  -- How much bullets are in the mag
SWEP.Primary.Ammo = "AR2" --The ammo type will it use
SWEP.Primary.DefaultClip = 200 -- How much bullets preloaded when spawned
SWEP.Primary.Spread = 0.7 -- The spread when shot
SWEP.Primary.NumberofShots = 1 -- Number of bullets when shot
SWEP.Primary.Automatic = true -- Is it automatic
SWEP.Primary.Recoil = 0.2 -- The amount of recoil
SWEP.Primary.Force = 1
SWEP.Spawnable             = true
SWEP.UseHands              = true
SWEP.WorldModel            = "models/sw_battlefront/weapons/z6_rotary_cannon.mdl"

Falcon = Falcon or {}

function SWEP:Initialize()
   if CLIENT then
      Falcon.HasFalconWeapon = true
      hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
   end
   self:SetHoldType( "shotgun" )
end

function SWEP:Deploy()
   if CLIENT then
      Falcon.HasFalconWeapon = true
      hook.Add("CalcView", "FalconsThirdPerson", ThirdPersonCalc)
   else

   end
end

function SWEP:Holster()
   if CLIENT then
      Falcon.HasFalconWeapon = false

      local ply = self:GetOwner()
      if not ply.ThirdPersonEnabled then
         hook.Remove("CalcView", "FalconsThirdPerson")
      end
   else

   end

   return true 
end

local pew = Sound('pa/weapons/z6.wav')
function SWEP:PrimaryAttack()
    if ( self:Clip1() <= 0 ) then return end
    if self:GetNextPrimaryFire() >= CurTime() then return end
    local bullet = {} 
    bullet.Num = self.Primary.NumberofShots 
    bullet.Src = self.Owner:GetAttachment(1).Pos
    bullet.Dir = self.Owner:GetAimVector() 
    bullet.Spread = Vector( self.Primary.Spread * 0.1 , self.Primary.Spread * 0.1, 0)
    bullet.Tracer = 1
    bullet.TracerName = "f_lfs_laser_blue"
    bullet.Force = self.Primary.Force 
    bullet.Damage = self.Primary.Damage 
    bullet.AmmoType = self.Primary.Ammo 
    self.Owner:FireBullets( bullet )
    self.Owner:SetAnimation( PLAYER_ATTACK1 )

    self:EmitSound( pew, 75, 100, 0.5, CHAN_WEAPON  )

    self:SetClip1( math.Clamp(self:Clip1() - self.Primary.TakeAmmo, 0, self.Primary.ClipSize) )

    self:SetNextPrimaryFire( CurTime() + 0.08 )
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
	if ( self:Clip1() == self.Primary.ClipSize or self:GetOwner():GetAmmoCount( self.Primary.Ammo ) <= 0 ) then return end
   self:DefaultReload( ACT_VM_RELOAD )
end

function SWEP:DoImpactEffect()
   return true
end

if CLIENT then
   local WorldModel = ClientsideModel(SWEP.WorldModel)
   WorldModel:SetNoDraw(true)

   function SWEP:DrawWorldModel()
      local _Owner = self:GetOwner()
   
      if _Owner and _Owner:IsValid() and not _Owner:GetNoDraw() then
         if _Owner:IsValid() and _Owner:Alive() then
               -- Specify a good position
            local offsetVec = Vector(2, -1.25, -0)
            local offsetAng = Angle(175, 182, 0)
            
            local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
            if !boneid then return end
      
            local matrix = _Owner:GetBoneMatrix(boneid)
            if !matrix then return end
      
            local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())
      
            WorldModel:SetPos(newPos)
            WorldModel:SetAngles(newAng)
      
            WorldModel:SetupBones()
         else
            WorldModel:SetPos(self:GetPos())
            WorldModel:SetAngles(self:GetAngles())
         end
      
         WorldModel:DrawModel()
      end
   end

   local diagonal = Material("f_coop/identifier.png")
   local w, h = ScrW(), ScrH()
   local color_white = Color( 255, 255, 255 )
   local color_red = Color( 255, 30, 30 )
   function SWEP:DrawHUD()
      local ply = LocalPlayer()
      local tr = util.TraceLine( util.GetPlayerTrace( ply, ply:GetAimVector() ) )

      if tr.HitPos then
         local trOnScreen = tr.HitPos:ToScreen()
         local color = color_white

         if tr.Entity then
            if string.find(tr.Entity:GetClass(), "falcon_hostile") then
               color = color_red
            end
         end
         surface.SetDrawColor( color )

         surface.SetMaterial(diagonal)
         surface.DrawTexturedRect( trOnScreen.x - (w * 0.01), trOnScreen.y, w * 0.02, w * 0.02 )
      end
   end
end
