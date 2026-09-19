-- A missing translation shows English with no error, and a stale key does
-- nothing at all, so neither would ever be noticed in the game.

local SOURCES = { "SCTMover.lua", "src/MoveMode.lua", "src/SelfText.lua" }
local LOCALES = { "deDE", "frFR", "esES", "ptBR", "ruRU", "koKR", "zhCN", "zhTW" }

local function KeysUsedInCode()
    local keys = {}
    for _, path in ipairs(SOURCES) do
        local source = assert(io.open(path)):read("*a")
        for key in source:gmatch('L%["(.-)"%]') do
            keys[key] = true
        end
    end
    return keys
end

-- The strings a locale file gives on a client that runs clientLocale.
local function KeysTranslated(file, clientLocale)
    _G.GetLocale = function()
        return clientLocale
    end
    local ns = { L = {} }
    assert(loadfile("locales/" .. file .. ".lua"))("SCTMover", ns)
    local keys = {}
    for key in pairs(ns.L) do
        keys[key] = true
    end
    return keys
end

describe("Translations", function()
    local used = KeysUsedInCode()

    for _, locale in ipairs(LOCALES) do
        it(locale .. " has exactly the strings the code shows", function()
            assert.are.same(used, KeysTranslated(locale, locale))
        end)
    end

    it("stay out of the way on a client with another language", function()
        assert.are.same({}, KeysTranslated("deDE", "enUS"))
    end)

    it("esES also serves Latin American Spanish clients", function()
        assert.are.same(used, KeysTranslated("esES", "esMX"))
    end)
end)
