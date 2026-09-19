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

-- Blizzard's own text locations, without the Offset. Blizzard builds a new
-- table each time the float mode or the screen size changes.
local baseLocations

-- Every read of the Self Text settings goes through here.
function SelfText.GetSettings()
    return SCTMoverDB.selfText
end

-- False when the player turned Self Text off in the game options.
function SelfText.IsEnabled()
    return C_CVar.GetCVarBool(ENABLED_CVAR)
end

-- Blizzard_CombatText loads on demand, so the frame can be absent.
function SelfText.Apply()
    if not CombatText then
        return
    end
    local settings = SelfText.GetSettings()

    defaultStrata = defaultStrata or CombatText:GetFrameStrata()
    CombatText:SetFrameStrata(settings.raised and RAISED_STRATA or defaultStrata)

    CombatText.textLocations = Offset.ShiftTextLocations(
        baseLocations,
        settings.offsetX,
        settings.offsetY,
        CombatText.textScaleX,
        CombatText.textScaleY
    )
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

-- Runs once, when both the frame and the saved settings exist.
local function Attach()
    -- Nothing has shifted the locations yet, so they are Blizzard's own.
    baseLocations = CombatText.textLocations
    hooksecurefunc(CombatText, "UpdateDisplayedMessages", function(self)
        baseLocations = self.textLocations
        SelfText.Apply()
    end)
    SelfText.Apply()
end

-- The two addons can load in either order, and the saved settings exist only
-- after this addon's own ADDON_LOADED.
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon == addonName then
        SCTMoverDB = SCTMoverDB or {}
        SCTMoverDB.selfText = SCTMoverDB.selfText or {}
        -- A table from an older version lacks the newer keys.
        for key, value in pairs(DEFAULTS) do
            if SCTMoverDB.selfText[key] == nil then
                SCTMoverDB.selfText[key] = value
            end
        end
        if CombatText then
            Attach()
        end
    elseif loadedAddon == "Blizzard_CombatText" and SCTMoverDB then
        Attach()
    end
end)
