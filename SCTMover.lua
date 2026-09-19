local addonName, ns = ...
local L = ns.L

-- The engine draws the numbers above the target, so these CVars are the only
-- control. The unit is a fraction of screen height.
local HIT_CVAR = "WorldTextScreenY_v2"
local CRIT_CVAR = "WorldTextCritScreenY_v2"

-- The slider works in percent, so the step count is exact.
local MIN_PERCENT, MAX_PERCENT, STEP_PERCENT = -20, 20, 0.5

local function GetHeightPercent()
    return (tonumber(C_CVar.GetCVar(HIT_CVAR)) or 0) * 100
end

-- Nameplates hide crits the same way as normal hits, so both move together.
local function SetHeightPercent(percent)
    local fraction = percent / 100
    C_CVar.SetCVar(HIT_CVAR, fraction)
    C_CVar.SetCVar(CRIT_CVAR, fraction)
end

local function RegisterSettings()
    local title = C_AddOns.GetAddOnMetadata(addonName, "Title")
    local category = Settings.RegisterVerticalLayoutCategory(title)

    -- The CVar is the source of truth: the addon saves nothing, and the
    -- panel's Defaults button restores the default that the client reports.
    local defaultPercent = (tonumber(C_CVar.GetCVarDefault(HIT_CVAR)) or 0) * 100
    local setting = Settings.RegisterProxySetting(
        category,
        "SCTMOVER_TARGET_NUMBER_HEIGHT",
        Settings.VarType.Number,
        L["Target number height"],
        defaultPercent,
        GetHeightPercent,
        SetHeightPercent
    )

    local options = Settings.CreateSliderOptions(MIN_PERCENT, MAX_PERCENT, STEP_PERCENT)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return L["%.1f%%"]:format(value)
    end)
    Settings.CreateSlider(
        category,
        setting,
        options,
        L["Moves the damage and healing numbers above your target up or down. Use it when nameplates hide the numbers."]
    )

    Settings.RegisterAddOnCategory(category)
    return category
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    -- Blizzard renamed these CVars once already (the _v2 suffix).
    if C_CVar.GetCVar(HIT_CVAR) == nil or C_CVar.GetCVar(CRIT_CVAR) == nil then
        print(L["SCT Mover: this game client does not have the settings that move target numbers."])
        return
    end

    local category = RegisterSettings()

    SLASH_SCTMOVER1 = "/sctmover"
    SlashCmdList.SCTMOVER = function()
        Settings.OpenToCategory(category:GetID())
    end
end)
