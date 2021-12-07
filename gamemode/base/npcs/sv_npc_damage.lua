Falcon = Falcon or {}
function GM:OnNPCKilled( self, att )
    if self.PassiveNPC then
        if self.LocationIndex then
            local l = Falcon.Locations[self.Location][self.LocationIndex]
            table.RemoveByValue( l.npcEnts, self )

            if #l.npcEnts <= 0 then
                l.delay = CurTime() + 60
            end
        end
    end 
end