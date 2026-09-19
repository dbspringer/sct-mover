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
