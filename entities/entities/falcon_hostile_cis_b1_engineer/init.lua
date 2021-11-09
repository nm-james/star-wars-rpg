AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Model = "models/lightnings_edits/npc_droids/b1_battledroid_aat.mdl"
ENT.HP = 1000
ENT.RunSpeed = 190

ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"
ENT.WeaponAttackDelay = 0.3
ENT.WeaponDamage = 100
ENT.WeaponMinShot = 2
ENT.WeaponMaxShot = 4
ENT.WeaponTracerAmount = 6
ENT.WeaponSpread = Vector( 85, 85, 65 )

