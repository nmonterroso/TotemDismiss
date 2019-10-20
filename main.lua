TotemDismiss = {}

function TotemDismiss:onLogin()
  local _, classFilename = UnitClass("player")
  if classFilename == "SHAMAN" then
    print("creating frame")
    local frame = CreateFrame("Button", "TotemDismissButton", UIParent, "SecureActionButtonTemplate")

    print("frame created, setting basics")
    frame:SetPoint("CENTER", mainframe, "CENTER", 0, 0)
    frame:SetWidth(128)
    frame:SetHeight(128)

    print("setting font")
    frame:SetText("test")
    frame:SetNormalFontObject("GameFontNormal")

    print("setting texture")
    local ntex = frame:CreateTexture()
    ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
    ntex:SetTexCoord(0, 0.625, 0, 0.6875)
    ntex:SetAllPoints()
    frame:SetNormalTexture(ntex)

    print("setting highlight texture")
    local htex = frame:CreateTexture()
    htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
    htex:SetTexCoord(0, 0.625, 0, 0.6875)
    htex:SetAllPoints()
    frame:SetHighlightTexture(htex)

    print("setting pushed texture")
    local ptex = frame:CreateTexture()
    ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
    ptex:SetTexCoord(0, 0.625, 0, 0.6875)
    ptex:SetAllPoints()
    frame:SetPushedTexture(ptex)

    print("the magic")
    frame:SetAttribute("type", "destroytotem")
    frame:SetAttribute("*totem-slot*", 2)
    print("attributes set, about to show")

    frame:Show()
    print("should show?")
  end
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addon)
  if event == "PLAYER_LOGIN" then
    TotemDismiss:onLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)
