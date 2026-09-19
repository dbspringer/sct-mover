local addonName, ns = ...
local L = ns.L

-- The engine draws the numbers above the target, so these CVars are the only
-- control. The unit is a fraction of screen height.
local HIT_CVAR = "WorldTextScreenY_v2"
local CRIT_CVAR = "WorldTextCritScreenY_v2"

-- A fraction of screen height means little to a player, so the slider shows
-- plain steps with 0 as the game default. Whole steps also keep the step
-- count exact.
local MIN_STEPS, MAX_STEPS = -40, 40
local FRACTION_PER_STEP = 0.005

local function FractionToSteps(fraction)
    return math.floor((tonumber(fraction) or 0) / FRACTION_PER_STEP + 0.5)
end

local function GetHeightSteps()
    return FractionToSteps(C_CVar.GetCVar(HIT_CVAR))
end

-- Nameplates hide crits the same way as normal hits, so both move together.
local function SetHeightSteps(steps)
    local fraction = steps * FRACTION_PER_STEP
    C_CVar.SetCVar(HIT_CVAR, fraction)
    C_CVar.SetCVar(CRIT_CVAR, fraction)
end

local function RegisterSettings()
    local title = C_AddOns.GetAddOnMetadata(addonName, "Title")
    local category, layout = Settings.RegisterVerticalLayoutCategory(title)

    -- The CVar is the source of truth: the addon saves nothing, and a reset
    -- restores the default that the client reports.
    local defaultSteps = FractionToSteps(C_CVar.GetCVarDefault(HIT_CVAR))
    local setting = Settings.RegisterProxySetting(
        category,
        "SCTMOVER_TARGET_NUMBER_HEIGHT",
        Settings.VarType.Number,
        L["Target height"],
        defaultSteps,
        GetHeightSteps,
        SetHeightSteps
    )

    local options = Settings.CreateSliderOptions(MIN_STEPS, MAX_STEPS, 1)
    local Label = MinimalSliderWithSteppersMixin.Label
    options:SetLabelFormatter(Label.Right)
    options:SetLabelFormatter(Label.Min, L["Lower"])
    options:SetLabelFormatter(Label.Max, L["Higher"])
    Settings.CreateSlider(
        category,
        setting,
        options,
        L["Moves the damage and healing numbers above your target up or down. Use it when nameplates hide the numbers."]
    )

    -- The panel's own Defaults button also offers to reset every game
    -- setting, so the category has a reset that touches only this slider.
    local addSearchTags = false
    layout:AddInitializer(CreateSettingsButtonInitializer("", RESET_TO_DEFAULT, function()
        setting:SetValueToDefault()
    end, nil, addSearchTags))

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
    SLASH_SCTMOVER2 = "/sctm"
    SlashCmdList.SCTMOVER = function()
        Settings.OpenToCategory(category:GetID())
    end
end)
