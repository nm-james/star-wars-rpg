AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Model = "models/lightnings_edits/npc_droids/b1_battledroid_heavy.mdl"
ENT.HP = 2000
ENT.RunSpeed = 175

ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5c_blaster.mdl"
ENT.WeaponAttackDelay = 0.125
ENT.WeaponDamage = 15
ENT.WeaponMinShot = 5
ENT.WeaponMaxShot = 15
ENT.WeaponTracerAmount = 1
ENT.WeaponSpread = Vector( 55, 55, 35 )