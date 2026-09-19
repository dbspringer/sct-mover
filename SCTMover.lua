local addonName, ns = ...
local L = ns.L
local Offset = ns.Offset
local SelfText = ns.SelfText

-- The engine draws the Target Text, so these CVars are the only
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

local function HasTargetTextCVars()
    -- Blizzard renamed these CVars once already (the _v2 suffix).
    return C_CVar.GetCVar(HIT_CVAR) ~= nil and C_CVar.GetCVar(CRIT_CVAR) ~= nil
end

local TARGET_TEXT_MISSING = L["This game client does not have the settings that move target text."]

local function AddSectionHeader(panel, anchor, text)
    local header = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
    header:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -30)
    header:SetText(text)
    return header
end

local function AddBodyText(panel, anchor, text)
    local body = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    body:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -10)
    body:SetPoint("RIGHT", -20, 0)
    body:SetJustifyH("LEFT")
    body:SetText(text)
    return body
end

-- A label with a slider at a fixed distance, so the sliders of all rows line
-- up. The slider shows its value, and a word at each end says what it does.
local SLIDER_LEFT = 160

local function AddSliderRow(panel, anchor, gap, text, min, max, minText, maxText, value)
    local label = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("TOPLEFT", anchor, "BOTTOMLEFT", 0, -gap)
    label:SetText(text)

    local Label = MinimalSliderWithSteppersMixin.Label
    local slider = CreateFrame("Frame", nil, panel, "MinimalSliderWithSteppersTemplate")
    slider:SetPoint("LEFT", label, "LEFT", SLIDER_LEFT, 0)
    slider:SetWidth(250)
    slider:Init(value, min, max, max - min, {
        [Label.Right] = CreateMinimalSliderFormatter(Label.Right),
        [Label.Min] = CreateMinimalSliderFormatter(Label.Min, minText),
        [Label.Max] = CreateMinimalSliderFormatter(Label.Max, maxText),
    })
    return label, slider
end

-- Returns the lowest region of the section and a function that reads the
-- game state into the controls again.
local function AddTargetTextSection(panel, anchor)
    local header = AddSectionHeader(panel, anchor, L["Target text"])
    if not HasTargetTextCVars() then
        return AddBodyText(panel, header, TARGET_TEXT_MISSING), nop
    end

    local description = AddBodyText(
        panel,
        header,
        L["The text above your target: damage you deal, heals, misses, and similar. Lift it when nameplates hide it."]
    )

    local label, slider = AddSliderRow(
        panel, description, 30, L["Target height"], MIN_STEPS, MAX_STEPS, L["Lower"], L["Higher"], GetHeightSteps()
    )
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
    -- change it.
    return reset, function()
        slider:SetValue(GetHeightSteps())
    end
end

local function AddSelfTextSection(panel, anchor)
    local header = AddSectionHeader(panel, anchor, L["Self text"])
    local description = AddBodyText(
        panel,
        header,
        L["The text that scrolls near your character: damage you take, heals you receive, and similar."]
    )

    -- The note sits above the controls, so the player reads the reason
    -- before the grey checkbox. It takes no room while it's hidden.
    -- The addon leaves the game's own Self Text switch alone.
    local disabledNote = AddBodyText(panel, description, L["Self text is off in the game options."])
    disabledNote:SetFontObject("GameFontRed")

    local raised = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
    raised:SetScript("OnClick", function(self)
        SelfText.SetRaised(self:GetChecked())
    end)

    local raisedLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
    raisedLabel:SetPoint("LEFT", raised, "RIGHT", 4, 0)
    raisedLabel:SetText(L["Show self text above other UI elements"])

    -- The Offset is in Blizzard's reference units, a 1024 by 768 screen with
    -- the default start point at its centre, so these ranges cover the screen.
    local settings = SelfText.GetSettings()
    local horizontalLabel, horizontal = AddSliderRow(
        panel, raised, 24, L["Horizontal"], -512, 512, L["Left"], L["Right"], settings.offsetX
    )
    local verticalLabel, vertical = AddSliderRow(
        panel, horizontalLabel, 40, L["Vertical"], -384, 384, L["Lower"], L["Higher"], settings.offsetY
    )
    -- The checkbox sits 4 to the left of the text column.
    horizontalLabel:SetPoint("TOPLEFT", raised, "BOTTOMLEFT", 4, -24)

    local function OnOffsetChanged()
        SelfText.SetOffset(horizontal.Slider:GetValue(), vertical.Slider:GetValue())
    end
    horizontal:RegisterCallback("OnValueChanged", OnOffsetChanged, panel)
    vertical:RegisterCallback("OnValueChanged", OnOffsetChanged, panel)

    local reset = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
    reset:SetPoint("TOPLEFT", verticalLabel, "BOTTOMLEFT", 0, -30)
    reset:SetText(L["Reset position"])
    reset:SetWidth(reset:GetTextWidth() + 40)
    reset:SetScript("OnClick", function()
        horizontal:SetValue(0)
        vertical:SetValue(0)
    end)

    return reset, function()
        local enabled = SelfText.IsEnabled()
        local current = SelfText.GetSettings()
        horizontal:SetValue(current.offsetX)
        vertical:SetValue(current.offsetY)
        horizontal:SetEnabled(enabled)
        vertical:SetEnabled(enabled)
        reset:SetEnabled(enabled)
        local labelFont = enabled and "GameFontNormal" or "GameFontDisable"
        horizontalLabel:SetFontObject(labelFont)
        verticalLabel:SetFontObject(labelFont)
        raised:ClearAllPoints()
        raised:SetPoint("TOPLEFT", enabled and description or disabledNote, "BOTTOMLEFT", -4, -16)
        raised:SetChecked(current.raised)
        raised:SetEnabled(enabled)
        raisedLabel:SetFontObject(enabled and "GameFontHighlight" or "GameFontDisable")
        disabledNote:SetShown(not enabled)
    end
end

-- A canvas category, because the panel's list view comes with a Defaults
-- button that also offers to reset every game setting. The canvas view has no
-- such button, so each section carries its own reset where it needs one.
local function RegisterSettings()
    local title = C_AddOns.GetAddOnMetadata(addonName, "Title")
    local panel = CreateFrame("Frame")

    local header = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightHuge")
    header:SetPoint("TOPLEFT", 7, -22)
    header:SetText(title)

    local targetBottom, refreshTargetText = AddTargetTextSection(panel, header)
    local _, refreshSelfText = AddSelfTextSection(panel, targetBottom)

    -- The panel calls this each time it shows the category.
    panel.OnRefresh = function()
        refreshTargetText()
        refreshSelfText()
    end

    local category = Settings.RegisterCanvasLayoutCategory(panel, title)
    Settings.RegisterAddOnCategory(category)
    return category, title
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function()
    local category, title = RegisterSettings()

    if not HasTargetTextCVars() then
        print(("%s: %s"):format(title, TARGET_TEXT_MISSING))
    end

    SLASH_SCTMOVER1 = "/sctmover"
    SLASH_SCTMOVER2 = "/sctm"
    SlashCmdList.SCTMOVER = function()
        -- The game blocks addons from opening the options in combat.
        if InCombatLockdown() then
            UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1)
            return
        end
        Settings.OpenToCategory(category:GetID())
    end
end)
