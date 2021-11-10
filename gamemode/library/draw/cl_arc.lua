Falcon = Falcon or {}

function draw.DrawARC(x, y, r, startAng, endAng, step, cache)
    local positions = {}

    positions[1] = {
        x = x,
        y = y
    }

    for i = startAng - 90, endAng - 90, step do
        table.insert(positions, {
            x = x + math.cos(math.rad(i)) * r,
            y = y + math.sin(math.rad(i)) * r
        })

    end


    return (cache and positions) or surface.DrawPoly(positions)
end