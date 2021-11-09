AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Model = "models/lightnings_edits/npc_droids/b1_battledroid_specialist.mdl"
ENT.HP = 500
ENT.RunSpeed = 175

ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5s_blaster.mdl"
ENT.WeaponAttackDelay = 1
ENT.WeaponDamage = 80
ENT.WeaponMinShot = 2
ENT.WeaponMaxShot = 3
ENT.WeaponTracerAmount = 1
ENT.WeaponSpread = Vector( 28, 28, 18 )