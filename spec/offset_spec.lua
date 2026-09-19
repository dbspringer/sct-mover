local ns = {}
assert(loadfile("Offset.lua"))("SCTMover", ns)
local Offset = ns.Offset

describe("Target Text offset", function()
    -- 16001 has 0 for both defaults, so the game can't show this. Retail has
    -- used a gap between them.
    local HIT_DEFAULT, CRIT_DEFAULT = 0.015, 0.0275

    it("lifts crits when it lifts normal hits", function()
        local hit, crit = Offset.StepsToFractions(1, HIT_DEFAULT, CRIT_DEFAULT)
        assert.is_true(hit > HIT_DEFAULT)
        assert.is_true(crit > CRIT_DEFAULT)
    end)

    it("restores each default at zero steps", function()
        local hit, crit = Offset.StepsToFractions(0, HIT_DEFAULT, CRIT_DEFAULT)
        assert.are.equal(HIT_DEFAULT, hit)
        assert.are.equal(CRIT_DEFAULT, crit)
    end)

    it("reads back the steps it wrote", function()
        for _, steps in ipairs({ -40, -7, 0, 10, 40 }) do
            local hit = Offset.StepsToFractions(steps, HIT_DEFAULT, CRIT_DEFAULT)
            assert.are.equal(steps, Offset.FractionToSteps(hit, HIT_DEFAULT))
        end
    end)
end)

describe("Self Text offset", function()
    -- Blizzard's start and end for the three float modes, on a 1024 by 768
    -- screen: up and fountain end high, down ends low.
    local UP = { startX = 0, startY = 384, endX = 0, endY = 609 }
    local DOWN = { startX = 0, startY = 384, endX = 0, endY = 159 }

    it("moves the start and the end by the same amount, so the path keeps its shape", function()
        for _, base in ipairs({ UP, DOWN }) do
            local shifted = Offset.ShiftTextLocations(base, -250, 40, 1, 1)
            assert.are.same({
                startX = base.startX - 250,
                startY = base.startY + 40,
                endX = base.endX - 250,
                endY = base.endY + 40,
            }, shifted)
        end
    end)

    it("scales the offset to the screen, so it holds its place at another resolution", function()
        -- A 2048 by 1536 screen doubles both of Blizzard's scales.
        local base = { startX = 0, startY = 768, endX = 0, endY = 1218 }
        local shifted = Offset.ShiftTextLocations(base, 100, -50, 2, 2)
        assert.are.equal(200, shifted.startX)
        assert.are.equal(668, shifted.startY)
    end)

    it("leaves Blizzard's table alone, so a second shift can't stack on the first", function()
        Offset.ShiftTextLocations(UP, 100, 100, 1, 1)
        assert.are.same({ startX = 0, startY = 384, endX = 0, endY = 609 }, UP)
    end)
end)
