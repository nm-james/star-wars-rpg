Falcon = Falcon or {}

local plyMeta = FindMetaTable("Player")
function plyMeta:GetLevel()
    return self:GetNWInt("Falcon:Level", 100000000)
end