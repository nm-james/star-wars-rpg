Falcon = Falcon or {}
Falcon.UI = Falcon.UI or {}
Falcon.UI.Presets = Falcon.UI.Presets or {}
Falcon.UI.Presets.Entry = Falcon.UI.Presets.Entry or {}

-- COLORS
local f = Falcon.UI.Presets.Entry
f.CreateUpdatedOnTypeEntry = function( parent, onType, w, h, x, y, extras )
    local e = f.CreateBaseEntry( parent, w, h, x, y, extras )
    e:SetUpdateOnType( true )
    e.OnValueChange = function( self )
        onType( self )
    end
    return e
end