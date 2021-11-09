
local plyMeta = FindMetaTable("Player")
function plyMeta:GetMaxSprint()
	return self:GetNWFloat("FALCON:GETMAXSPRINT", 5)
end
function plyMeta:GetSprintRemaining()
	return self:GetNWFloat("FALCON:GETREMAININGSPRINT", 5)
end