Falcon = Falcon or {}
Falcon.Planets = {}

local maps = {
    ["rp_geonosis"] = 1,
    ["gm_geonosian_canyons"] = 1,
    ["gm_geonosis_plains_b2"] = 1,
}
Falcon.GetPlanetData = function()
    local map = game.GetMap()

    local id = maps[map]

    if not id then return false end

    return Falcon.Planets[id]
end

Falcon.GetMapData = function()
    local pData = Falcon.GetPlanetData()
    local map = game.GetMap()

    local id

    for _, d in pairs(pData.Dropzones) do
        if d.Map == map then
            id = _
            break
        end
    end
    
    return pData.Dropzones[id] or false
end

Falcon.GetMapPOIs = function()
    local pData = Falcon.GetMapData()

    return pData.POIs or {}
end