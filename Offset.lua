local _, ns = ...

-- Pure calculations, with no WoW API calls, so the specs can load this file
-- outside the game.
local Offset = {}
ns.Offset = Offset

Offset.FRACTION_PER_STEP = 0.005

-- Each CVar gets the offset on top of its own default. The defaults are equal
-- in 16001, but retail has had a gap between them, and an equal value for
-- both would then pull crits down while normal hits go up.
function Offset.StepsToFractions(steps, hitDefault, critDefault)
    local offset = steps * Offset.FRACTION_PER_STEP
    return hitDefault + offset, critDefault + offset
end

function Offset.FractionToSteps(fraction, default)
    return math.floor((fraction - default) / Offset.FRACTION_PER_STEP + 0.5)
end

-- The Self Text Offset is in Blizzard's reference units (a 1024 by 768 screen),
-- and Blizzard's two scales turn it into the units of the real screen. The
-- start and the end move together, so the float mode keeps the path's shape.
-- Returns a new table: the caller keeps Blizzard's own locations as the base,
-- and a second shift can't stack on the first.
function Offset.ShiftTextLocations(base, offsetX, offsetY, scaleX, scaleY)
    local shiftX, shiftY = offsetX * scaleX, offsetY * scaleY
    return {
        startX = base.startX + shiftX,
        startY = base.startY + shiftY,
        endX = base.endX + shiftX,
        endY = base.endY + shiftY,
    }
end
