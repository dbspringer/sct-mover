local ns = {}
assert(loadfile("Offset.lua"))("SCTMover", ns)
local Offset = ns.Offset

describe("Target Numbers offset", function()
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
