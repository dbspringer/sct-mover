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

-- The Self Text Offset is in Blizzard's reference units (a 1024 by 768 screen).
-- The two scales turn it into the units of the real screen, so the text holds
-- its place at another resolution.
function Offset.ToScreenUnits(offsetX, offsetY, scaleX, scaleY)
    return offsetX * scaleX, offsetY * scaleY
end

-- Blizzard starts Self Text at the centre of its reference screen. The ranges
-- put every point of that screen in reach, and the sliders use them too.
Offset.REFERENCE_WIDTH, Offset.REFERENCE_HEIGHT = 1024, 768
Offset.MAX_X, Offset.MAX_Y = 512, 384
local START_Y = 384

-- Where the Marker goes for an Offset: a point in screen units, measured from
-- the bottom centre of the WorldFrame, the way Blizzard anchors Self Text.
function Offset.ToMarkerPoint(offsetX, offsetY, scaleX, scaleY)
    return offsetX * scaleX, (START_Y + offsetY) * scaleY
end

local function RoundAndClamp(value, max)
    return math.max(-max, math.min(max, math.floor(value + 0.5)))
end

-- The Offset for a point the player dragged the Marker to.
function Offset.FromMarkerPoint(x, y, scaleX, scaleY)
    return RoundAndClamp(x / scaleX, Offset.MAX_X), RoundAndClamp(y / scaleY - START_Y, Offset.MAX_Y)
end
