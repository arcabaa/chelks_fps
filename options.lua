-- Create a frame for the options panel
ChelksFps.options = CreateFrame("Frame", "ChelksFPSOptionsPanel", UIParent)
ChelksFps.options.name = "Chelks FPS" -- This is the name that will appear in the Interface Options menu

-- title
local title = ChelksFps.options:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
title:SetPoint("TOPLEFT", 16, -16)
title:SetText("chelk's FPS")

-- description
local description = ChelksFps.options:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
description:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
description:SetText("Configure settings for chelk's FPS")

-- enable/disable checkbox
local enableCheckbox = CreateFrame("CheckButton", "ChelksFPSEnableCheckbox", ChelksFps.options, "InterfaceOptionsCheckButtonTemplate")
enableCheckbox:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -16)
enableCheckbox.Text:SetText("Enable FPS/Ping Display")
enableCheckbox:SetChecked(true)

-- checkbox functionality
enableCheckbox:SetScript("OnClick", function(self)
    local isChecked = self:GetChecked()
    if isChecked then
        ChelksFpsDB.enabled = true
        ChelksFps.fpsFrame:Show()
    else
        ChelksFpsDB.enabled = false
        ChelksFps.fpsFrame:Hide()
    end
end)

-- Function to initialize the slider after ChelksFpsDB is loaded
local function InitializeFontSizeSlider()
    -- Add a slider for font size
    local fontSizeSlider = CreateFrame("Slider", "ChelksFPSFontSizeSlider", ChelksFps.options, "OptionsSliderTemplate")
    fontSizeSlider:SetPoint("TOPLEFT", description, "BOTTOMLEFT", 0, -60)
    fontSizeSlider:SetMinMaxValues(10, 24)
    fontSizeSlider:SetValueStep(1)
    fontSizeSlider:SetObeyStepOnDrag(true)
    fontSizeSlider:SetWidth(200)
    fontSizeSlider:SetValue(ChelksFpsDB.fontSize or 13) -- Default to 13 if not set

    -- Update font size dynamically and save to SavedVariables
    fontSizeSlider:SetScript("OnValueChanged", function(self, value)
        value = math.floor(value) -- Ensure the value is an integer
        ChelksFpsDB.fontSize = value
        ChelksFps.fpsFrame.fps:SetFont("Fonts\\FRIZQT__.TTF", value, "THICKOUTLINE")
        fontSizeSlider.Text:SetText("Font Size: " .. value)
    end)

    -- Add labels for the slider
    fontSizeSlider.Low:SetText("10")
    fontSizeSlider.High:SetText("24")
    fontSizeSlider.Text:SetText("Font Size: " .. (ChelksFpsDB.fontSize or 13))
end

-- Register the options panel with the SettingsPanel API after ADDON_LOADED
local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName == "chelks_fps" then
        -- Ensure ChelksFpsDB is initialized
        ChelksFpsDB = ChelksFpsDB or {}
        ChelksFpsDB.fontSize = ChelksFpsDB.fontSize or 13 -- Default font size

        -- Initialize the slider
        InitializeFontSizeSlider()

        -- Register the options panel
        local category = Settings.RegisterCanvasLayoutCategory(ChelksFps.options, "Chelks FPS")
        Settings.RegisterAddOnCategory(category)

        -- Unregister the event to avoid duplicate calls
        self:UnregisterEvent("ADDON_LOADED")
    end
end)