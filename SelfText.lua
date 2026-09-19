local addonName, ns = ...
local Offset = ns.Offset

-- Applies the saved Self Text settings to Blizzard's CombatText frame.
local SelfText = {}
ns.SelfText = SelfText

local ENABLED_CVAR = "enableFloatingCombatText"
local RAISED_STRATA = "HIGH"

local DEFAULTS = { raised = false, offsetX = 0, offsetY = 0 }

-- The strata that Blizzard gave the frame, read before the first change.
local defaultStrata

-- Blizzard places Self Text on a 1024 by 768 reference screen and scales it to
-- the WorldFrame. The Offset uses the same reference units.
local REFERENCE_WIDTH, REFERENCE_HEIGHT = 1024, 768

-- A very long hold, and the group loops, so the shift never runs out.
local HOLD_SECONDS = 1e6

local shiftGroup, shift

-- Every read of the Self Text settings goes through here.
function SelfText.GetSettings()
    return SCTMoverDB.selfText
end

-- False when the player turned Self Text off in the game options.
function SelfText.IsEnabled()
    return C_CVar.GetCVarBool(ENABLED_CVAR)
end

-- In this client, combat amounts are secret values, and tainted code can't
-- compare them. Any Lua field an addon writes on CombatText (textLocations,
-- for one) taints Blizzard's AddMessage, and every combat message then fails
-- with an error. A Translation animation moves how the frame draws, and it
-- writes no Lua field, so Blizzard's code stays clean.
local function ApplyOffset(offsetX, offsetY)
    if not shiftGroup then
        shiftGroup = CombatText:CreateAnimationGroup()
        shiftGroup:SetLooping("REPEAT")
        shift = shiftGroup:CreateAnimation("Translation")
        shift:SetDuration(0)
        shift:SetEndDelay(HOLD_SECONDS)
    end

    -- A running group keeps its old offset.
    shiftGroup:Stop()
    if offsetX == 0 and offsetY == 0 then
        return
    end
    shift:SetOffset(Offset.ToScreenUnits(
        offsetX, offsetY, WorldFrame:GetWidth() / REFERENCE_WIDTH, WorldFrame:GetHeight() / REFERENCE_HEIGHT
    ))
    shiftGroup:Play()
end

-- Blizzard_CombatText loads on demand, so the frame can be absent.
function SelfText.Apply()
    if not CombatText then
        return
    end
    local settings = SelfText.GetSettings()

    defaultStrata = defaultStrata or CombatText:GetFrameStrata()
    CombatText:SetFrameStrata(settings.raised and RAISED_STRATA or defaultStrata)

    ApplyOffset(settings.offsetX, settings.offsetY)
end

function SelfText.SetRaised(raised)
    SelfText.GetSettings().raised = raised
    SelfText.Apply()
end

function SelfText.SetOffset(offsetX, offsetY)
    local settings = SelfText.GetSettings()
    settings.offsetX, settings.offsetY = offsetX, offsetY
    SelfText.Apply()
end

-- The two addons can load in either order, and the saved settings exist only
-- after this addon's own ADDON_LOADED.
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
-- The shift is in screen units, so a new screen size needs a new shift.
frame:RegisterEvent("DISPLAY_SIZE_CHANGED")
frame:RegisterEvent("UI_SCALE_CHANGED")
frame:SetScript("OnEvent", function(_, event, loadedAddon)
    if event ~= "ADDON_LOADED" then
        if SCTMoverDB then
            SelfText.Apply()
        end
    elseif loadedAddon == addonName then
        SCTMoverDB = SCTMoverDB or {}
        SCTMoverDB.selfText = SCTMoverDB.selfText or {}
        -- A table from an older version lacks the newer keys.
        for key, value in pairs(DEFAULTS) do
            if SCTMoverDB.selfText[key] == nil then
                SCTMoverDB.selfText[key] = value
            end
        end
        SelfText.Apply()
    elseif loadedAddon == "Blizzard_CombatText" and SCTMoverDB then
        SelfText.Apply()
    end
end)
