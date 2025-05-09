ChelksFps = ChelksFps or {}
ChelksFps.fpsFrame = CreateFrame("Frame", "fpsFrame", UIParent)
ChelksFps.fpsFrame:SetSize(100, 40)

local defaultDB = {
    point = "CENTER",
    relativeTo = "UIParent",
    relativePoint = "CENTER",
    x = 0,
    y = 0,
    locked = false,
    enabled = true,
    fontSize = 13
}

-- Create FontString
ChelksFps.fpsFrame.fps = ChelksFps.fpsFrame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
ChelksFps.fpsFrame.fps:SetPoint("TOPLEFT", ChelksFps.fpsFrame, "TOPLEFT", 0, 0)
ChelksFps.fpsFrame.fps:SetJustifyH("LEFT")

local function UpdatePerformance()
    local fps = floor(GetFramerate())
    local home = select(3, GetNetStats()) or 0
    ChelksFps.fpsFrame.fps:SetText(string.format("|cff3FC7EBFPS|r: %4d\n|cff3FC7EBPing|r: %4d", fps, home))
end

local function ApplyLockState()
    ChelksFps.fpsFrame:ClearAllPoints()

    local anchor = _G[ChelksFpsDB.relativeTo] or UIParent
    ChelksFps.fpsFrame:SetPoint(
        ChelksFpsDB.point,
        anchor,
        ChelksFpsDB.relativePoint,
        ChelksFpsDB.x,
        ChelksFpsDB.y
    )

    local locked = ChelksFpsDB.locked
    ChelksFps.fpsFrame:SetMovable(not locked)
    ChelksFps.fpsFrame:EnableMouse(not locked)
    ChelksFps.fpsFrame:RegisterForDrag(locked and nil or "LeftButton")
end

SLASH_CHELKSFPS1 = "/cfps"
SlashCmdList["CHELKSFPS"] = function(input)
    if not ChelksFpsDB then
        print("|cff3FC7EBchelk's fps|r: Saved variables not loaded yet.")
        return
    end

    local action = (input and strtrim(input):lower()) or ""

    if action == "lock" then
        local point, _, relativePoint, x, y = ChelksFps.fpsFrame:GetPoint()
        ChelksFpsDB.point = point
        ChelksFpsDB.relativeTo = "UIParent"
        ChelksFpsDB.relativePoint = relativePoint
        ChelksFpsDB.x = x
        ChelksFpsDB.y = y
        ChelksFpsDB.locked = true
        ApplyLockState()
        print("|cff3FC7EBchelk's fps|r: Position Locked")
    elseif action == "unlock" then
        ChelksFpsDB.locked = false
        ApplyLockState()
        print("|cff3FC7EBchelk's fps|r: Position Unlocked")
    else
        ChelksFps:Menu()
    end
end

ChelksFps.fpsFrame:SetScript("OnUpdate", function(self, delta)
    self.elapsed = (self.elapsed or 0) + delta
    if self.elapsed >= 1 then
        UpdatePerformance()
        self.elapsed = 0
    end
end)

ChelksFps.fpsFrame:SetScript("OnDragStart", function(self)
    if ChelksFpsDB and not ChelksFpsDB.locked then
        self:StartMoving()
    end
end)

ChelksFps.fpsFrame:SetScript("OnDragStop", function(self)
    if ChelksFpsDB and not ChelksFpsDB.locked then
        self:StopMovingOrSizing()
        local point, _, relativePoint, x, y = self:GetPoint()
        ChelksFpsDB.point = point
        ChelksFpsDB.relativeTo = "UIParent"
        ChelksFpsDB.relativePoint = relativePoint
        ChelksFpsDB.x = x
        ChelksFpsDB.y = y
    end
end)

local eventFrame = CreateFrame("Frame")
eventFrame:RegisterEvent("ADDON_LOADED")
eventFrame:SetScript("OnEvent", function(self, event, addonName)
    if addonName ~= "chelks_fps" then return end -- THIS IS THE FOLDER NAME, NOT THE NAME IN THE .TOC
    ChelksFpsDB = ChelksFpsDB or {}
    for k, v in pairs(defaultDB) do
        if ChelksFpsDB[k] == nil then
            ChelksFpsDB[k] = v
        end
    end

    ChelksFps.fpsFrame.fps:SetFont("Fonts\\FRIZQT__.TTF", ChelksFpsDB.fontSize, "THICKOUTLINE")

    ApplyLockState()
    UpdatePerformance()
end)