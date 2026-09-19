local addonName, ns = ...
local Offset = ns.Offset
local Override = ns.Override

-- Applies the saved Self Text settings to Blizzard's CombatText frame.
local SelfText = {}
ns.SelfText = SelfText

local ENABLED_CVAR = "enableFloatingCombatText"
local RAISED_STRATA = "HIGH"
local DEFAULT_STRATA = "MEDIUM"

local DEFAULTS = { raised = false, offsetX = 0, offsetY = 0 }

-- The strata that Blizzard gave the frame, read before the first change.
local defaultStrata

-- A very long hold, and the group loops, so the shift never runs out.
local HOLD_SECONDS = 1e6

local shiftGroup, shift

-- Every read of the Self Text settings goes through here: the character's
-- own settings with the Character Override on, the account's otherwise.
function SelfText.GetSettings()
    return Override.Select(SCTMoverDB, SCTMoverCharDB)
end

function SelfText.IsOverridden()
    return Override.IsEnabled(SCTMoverCharDB)
end

function SelfText.SetOverridden(overridden)
    Override.SetEnabled(SCTMoverDB, SCTMoverCharDB, overridden)
    SelfText.Apply()
end

-- Blizzard places Self Text on a reference screen and scales it to the
-- WorldFrame. These are the two factors.
function SelfText.GetScreenScales()
    return WorldFrame:GetWidth() / Offset.REFERENCE_WIDTH, WorldFrame:GetHeight() / Offset.REFERENCE_HEIGHT
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
    shift:SetOffset(Offset.ToScreenUnits(offsetX, offsetY, SelfText.GetScreenScales()))
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

-- The strata Self Text draws in, for the Sample Text to match. The frame can
-- be absent, and Blizzard's frame takes its strata from UIParent then.
function SelfText.GetStrata()
    if SelfText.GetSettings().raised then
        return RAISED_STRATA
    end
    return defaultStrata or DEFAULT_STRATA
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
        SCTMoverCharDB = SCTMoverCharDB or {}
        Override.Prepare(SCTMoverDB, SCTMoverCharDB, DEFAULTS)
        SelfText.Apply()
    elseif loadedAddon == "Blizzard_CombatText" and SCTMoverDB then
        SelfText.Apply()
    end
end)
