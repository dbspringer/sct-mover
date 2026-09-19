local _, ns = ...

-- Pure logic for the Character Override, with no WoW API calls, so the specs
-- can load this file outside the game.
local Override = {}
ns.Override = Override

local function FillDefaults(settings, defaults)
    for key, value in pairs(defaults) do
        if settings[key] == nil then
            settings[key] = value
        end
    end
end

-- Runs once the saved tables exist. A table saved by an older version lacks
-- the newer settings.
function Override.Prepare(account, character, defaults)
    account.selfText = account.selfText or {}
    FillDefaults(account.selfText, defaults)
    if character.selfText then
        FillDefaults(character.selfText, defaults)
    end
end

-- Every read of the Self Text settings goes through here.
function Override.Select(account, character)
    if character.enabled then
        return character.selfText
    end
    return account.selfText
end

function Override.IsEnabled(character)
    return character.enabled == true
end

-- The first time, the character starts from a copy of the account settings,
-- so nothing moves on screen. Later the character keeps its own settings, on
-- or off, so the player can switch back and forth without loss.
function Override.SetEnabled(account, character, enabled)
    if enabled and not character.selfText then
        character.selfText = {}
        FillDefaults(character.selfText, account.selfText)
    end
    character.enabled = enabled
end
