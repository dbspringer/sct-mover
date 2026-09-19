local addonName, ns = ...

-- Applies the saved Self Text settings to Blizzard's CombatText frame.
local SelfText = {}
ns.SelfText = SelfText

local ENABLED_CVAR = "enableFloatingCombatText"
local RAISED_STRATA = "HIGH"

-- The strata that Blizzard gave the frame, read before the first change.
local defaultStrata

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
    defaultStrata = defaultStrata or CombatText:GetFrameStrata()
    CombatText:SetFrameStrata(SelfText.GetSettings().raised and RAISED_STRATA or defaultStrata)
end

function SelfText.SetRaised(raised)
    SelfText.GetSettings().raised = raised
    SelfText.Apply()
end

-- The two addons can load in either order, and the saved settings exist only
-- after this addon's own ADDON_LOADED.
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(_, _, loadedAddon)
    if loadedAddon == addonName then
        SCTMoverDB = SCTMoverDB or {}
        SCTMoverDB.selfText = SCTMoverDB.selfText or { raised = false }
        SelfText.Apply()
    elseif loadedAddon == "Blizzard_CombatText" and SCTMoverDB then
        SelfText.Apply()
    end
end)
