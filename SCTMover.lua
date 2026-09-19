local addonName, ns = ...
local L = ns.L
local Offset = ns.Offset

-- The engine draws the numbers above the target, so these CVars are the only
-- control. The unit is a fraction of screen height.
local HIT_CVAR = "WorldTextScreenY_v2"
local CRIT_CVAR = "WorldTextCritScreenY_v2"

-- A fraction of screen height means little to a player, so the slider shows
-- plain steps away from the game default. Whole steps also keep the step
-- count exact.
local MIN_STEPS, MAX_STEPS = -40, 40

local function GetDefaultFraction(cvar)
    return tonumber(C_CVar.GetCVarDefault(cvar)) or 0
end

local function GetHeightSteps()
    local fraction = tonumber(C_CVar.GetCVar(HIT_CVAR)) or 0
    return Offset.FractionToSteps(fraction, GetDefaultFraction(HIT_CVAR))
end

-- Nameplates hide crits the same way as normal hits, so both move together.
-- The CVar is the source of truth: the addon saves nothing.
local function SetHeightSteps(steps)
    local hit, crit = Offset.StepsToFractions(steps, GetDefaultFraction(HIT_CVAR), GetDefaultFraction(CRIT_CVAR))
    C_CVar.SetCVar(HIT_CVAR, hit)
    C_CVar.SetCVar(CRIT_CVAR, crit)
end

-- A canvas category, because the panel's list view comes with a Defaults
-- button that also offers to reset every game setting. The canvas view has no
-- such button, so the panel carries its own reset for this one slider.
local function RegisterSettings()
    local title = C_AddOns.GetAddOnMetadata(addonName, "Title")
    local panel = CreateFrame("Frame")

    local header = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
    header:SetPoint("TOPLEFT", 7, -22)
    header:SetText(title)

    local description = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    description:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -16)
    description:SetPoint("RIGHT", -20, 0)
    description:SetJustifyH("LEFT")
    description:SetText(
        L["Moves the damage and healing numbers above your target up or down. Use it when nameplates hide the numbers."]
    )

    local label = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -40)
    label:SetText(L["Target height"])

    local Label = MinimalSliderWithSteppersMixin.Label
    local slider = CreateFrame("Frame", nil, panel, "MinimalSliderWithSteppersTemplate")
    slider:SetPoint("LEFT", label, "RIGHT", 40, 0)
    slider:SetWidth(250)
    slider:Init(GetHeightSteps(), MIN_STEPS, MAX_STEPS, MAX_STEPS - MIN_STEPS, {
        [Label.Right] = CreateMinimalSliderFormatter(Label.Right),
        [Label.Min] = CreateMinimalSliderFormatter(Label.Min, L["Lower"]),
        [Label.Max] = CreateMinimalSliderFormatter(Label.Max, L["Higher"]),
    })
    slider:RegisterCallback("OnValueChanged", function(_, steps)
        -- A refresh also lands here. Skip the write then, so a CVar value
        -- between two steps stays as it is until the player moves the slider.
        if steps ~= GetHeightSteps() then
            SetHeightSteps(steps)
        end
    end, panel)

    local reset = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    reset:SetPoint("TOPLEFT", label, "BOTTOMLEFT", 0, -30)
    reset:SetText(RESET_TO_DEFAULT)
    reset:SetWidth(reset:GetTextWidth() + 40)
    reset:SetScript("OnClick", function()
        -- Write first. A slider that already shows 0 fires no change, and the
        -- CVars can still hold a value between two steps.
        SetHeightSteps(0)
        slider:SetValue(0)
    end)

    -- The CVar is the source of truth, and another addon or /console can
    -- change it, so read it again each time the panel shows the category.
    panel.OnRefresh = function()
        slider:SetValue(GetHeightSteps())
    end

    local category = Settings.RegisterCanvasLayoutCategory(panel, title)
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
