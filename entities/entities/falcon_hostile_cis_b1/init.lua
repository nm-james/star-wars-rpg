AddCSLuaFile( "shared.lua" )

include('shared.lua')

ENT.Model = "models/lightnings_edits/npc_droids/b1_battledroid_assault.mdl"
ENT.HP = 1500
ENT.RunSpeed = 175

ENT.WeaponModel = "models/kuro/sw_battlefront/weapons/e5_blaster.mdl"
ENT.WeaponAttackDelay = 0.25
ENT.WeaponDamage = 25
ENT.WeaponMinShot = 4
ENT.WeaponMaxShot = 10
ENT.WeaponTracerAmount = 1
ENT.WeaponSpread = Vector( 38, 38, 28 )