local ns = {}
assert(loadfile("src/Override.lua"))("SCTMover", ns)
local Override = ns.Override

local DEFAULTS = { raised = false, offsetX = 0, offsetY = 0 }

describe("Character Override", function()
    local account, character

    before_each(function()
        account = { selfText = { raised = true, offsetX = -250, offsetY = 40 } }
        character = {}
        Override.Prepare(account, character, DEFAULTS)
    end)

    it("uses the account settings until the player turns it on", function()
        assert.are.equal(account.selfText, Override.Select(account, character))
    end)

    it("starts from the account settings, so turning it on changes nothing on screen", function()
        Override.SetEnabled(account, character, true)
        assert.are.same(account.selfText, Override.Select(account, character))
    end)

    it("keeps this character's changes away from the account", function()
        Override.SetEnabled(account, character, true)
        Override.Select(account, character).offsetX = 300
        assert.are.equal(-250, account.selfText.offsetX)
    end)

    it("goes back to the account settings when the player turns it off", function()
        Override.SetEnabled(account, character, true)
        Override.Select(account, character).offsetX = 300
        Override.SetEnabled(account, character, false)
        assert.are.equal(-250, Override.Select(account, character).offsetX)
    end)

    it("keeps this character's settings for the next time it's turned on", function()
        Override.SetEnabled(account, character, true)
        Override.Select(account, character).offsetX = 300
        Override.SetEnabled(account, character, false)
        Override.SetEnabled(account, character, true)
        assert.are.equal(300, Override.Select(account, character).offsetX)
    end)

    it("fills in settings that a table saved by an older version lacks", function()
        local oldAccount = { selfText = { raised = true } }
        Override.Prepare(oldAccount, {}, DEFAULTS)
        assert.are.same({ raised = true, offsetX = 0, offsetY = 0 }, oldAccount.selfText)
    end)
end)
