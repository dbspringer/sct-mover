local _, ns = ...
local L = ns.L
local Offset = ns.Offset
local SelfText = ns.SelfText

-- Move Mode: the player drags the Marker to set the Self Text Offset, and
-- Sample Text shows the result.
local MoveMode = {}
ns.MoveMode = MoveMode

-- Blizzard's scroll: 225 reference units up in 1.9 seconds.
local SAMPLE_TEXT = "-123"
local SAMPLE_RISE, SAMPLE_SECONDS = 225, 1.9
local SAMPLE_HEIGHT = 25

local marker, sampleFrame, sampleScroll, sampleRise

-- The Marker anchors the way Blizzard anchors Self Text, top centre to the
-- bottom centre of the WorldFrame, so the two agree at any UI scale.
local function PlaceMarker()
    local settings = SelfText.GetSettings()
    local x, y = Offset.ToMarkerPoint(settings.offsetX, settings.offsetY, SelfText.GetScreenScales())
    marker:ClearAllPoints()
    marker:SetPoint("TOP", WorldFrame, "BOTTOM", x, y)
end

-- After a drag the Marker hangs off UIParent. Measure its top centre from the
-- bottom centre of the WorldFrame again, in the Marker's own units.
local function ReadMarker()
    local toMarkerUnits = WorldFrame:GetEffectiveScale() / marker:GetEffectiveScale()
    local x = marker:GetCenter() - WorldFrame:GetCenter() * toMarkerUnits
    local y = marker:GetTop() - WorldFrame:GetBottom() * toMarkerUnits
    return Offset.FromMarkerPoint(x, y, SelfText.GetScreenScales())
end

local function CreateMarker()
    marker = CreateFrame("Frame", nil, UIParent)
    marker:SetSize(170, 40)
    marker:SetFrameStrata("DIALOG")
    marker:SetClampedToScreen(true)
    marker:SetMovable(true)
    marker:EnableMouse(true)
    marker:RegisterForDrag("LeftButton")
    marker:SetScript("OnDragStart", marker.StartMoving)
    marker:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
        SelfText.SetOffset(ReadMarker())
        -- Snap to the whole-number Offset the drag gave.
        PlaceMarker()
    end)
    marker:Hide()

    local background = marker:CreateTexture(nil, "BACKGROUND")
    background:SetAllPoints()
    background:SetColorTexture(0, 0, 0, 0.6)

    local label = marker:CreateFontString(nil, "ARTWORK", "GameFontNormal")
    label:SetPoint("BOTTOM", 0, 6)
    label:SetText(L["Self text starts here"])

    local done = CreateFrame("Button", nil, marker, "UIPanelButtonTemplate")
    done:SetPoint("TOP", marker, "BOTTOM", 0, -4)
    done:SetText(DONE)
    done:SetWidth(done:GetTextWidth() + 40)
    done:SetScript("OnClick", MoveMode.Stop)

    -- The addon draws the Sample Text itself. A message that addon code sends
    -- through CombatText:AddMessage leaves tainted fields on Blizzard's frame,
    -- and the next real combat message then fails on a secret value.
    sampleFrame = CreateFrame("Frame", nil, marker)
    sampleFrame:SetSize(1, 1)
    sampleFrame:SetPoint("TOP")

    local sample = sampleFrame:CreateFontString(nil, "ARTWORK")
    sample:SetFontObject(CombatTextFont)
    sample:SetTextHeight(SAMPLE_HEIGHT)
    sample:SetPoint("TOP")
    sample:SetText(SAMPLE_TEXT)
    sample:SetTextColor(1, 0.1, 0.1)

    sampleScroll = sample:CreateAnimationGroup()
    sampleScroll:SetLooping("REPEAT")
    sampleRise = sampleScroll:CreateAnimation("Translation")
    sampleRise:SetDuration(SAMPLE_SECONDS)
    local fade = sampleScroll:CreateAnimation("Alpha")
    fade:SetFromAlpha(1)
    fade:SetToAlpha(0)
    fade:SetStartDelay(SAMPLE_SECONDS * 0.7)
    fade:SetDuration(SAMPLE_SECONDS * 0.3)
end

function MoveMode.IsActive()
    return marker ~= nil and marker:IsShown()
end

function MoveMode.Start()
    if InCombatLockdown() then
        UIErrorsFrame:AddMessage(ERR_NOT_IN_COMBAT, 1, 0.1, 0.1)
        return
    end
    if not SelfText.IsEnabled() then
        UIErrorsFrame:AddMessage(L["Self text is off in the game options."], 1, 0.1, 0.1)
        return
    end
    if not marker then
        CreateMarker()
    end

    -- The options cover the middle of the screen, where the text starts.
    HideUIPanel(SettingsPanel)

    PlaceMarker()
    local _, scaleY = SelfText.GetScreenScales()
    sampleRise:SetOffset(0, SAMPLE_RISE * scaleY)
    sampleFrame:SetFrameStrata(SelfText.GetStrata())
    marker:Show()
    sampleScroll:Play()
end

function MoveMode.Stop()
    if MoveMode.IsActive() then
        sampleScroll:Stop()
        marker:Hide()
    end
end

function MoveMode.Toggle()
    if MoveMode.IsActive() then
        MoveMode.Stop()
    else
        MoveMode.Start()
    end
end

-- A box in the middle of the screen is a danger in a fight. The Offset is
-- already saved at the end of each drag.
local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_REGEN_DISABLED")
frame:SetScript("OnEvent", MoveMode.Stop)
