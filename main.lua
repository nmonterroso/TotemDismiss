local earth = 'earth'
local fire = 'fire'
local water = 'water'
local air = 'air'

TotemDismiss = {
  totems = {
    [fire] = {
      id = 1
    },
    [earth] = {
      id = 2
    },
    [water] = {
      id = 3
    },
    [air] = {
      id = 4
    }
  },
  order = {earth, fire, water, air}
}

-- TODO: read from config?
local width = 64
local height = 64

function TotemDismiss:onLogin()
  local _, classFilename = UnitClass("player")
  local nextAnchor

  if classFilename == "SHAMAN" then
    for _, totemId in ipairs(self.order) do
      local totemDef = self.totems[totemId]
      nextAnchor = createButton(totemId, totemDef, nextAnchor, width, height)
    end
  end
end

function createButton(name, def, prevFrame, width, height)
  local frame = CreateFrame("Button", "TotemDismissButton"..name, UIParent, "SecureActionButtonTemplate")

  if prevFrame == nil then
    print('frame before '..name..' is nil!')
    frame:SetPoint("CENTER", mainframe, "CENTER", 0, 0)
  else
    print('not nil! positioning relative...')
    frame:SetPoint("LEFT", prevFrame, "RIGHT")
  end

  frame:SetWidth(width)
  frame:SetHeight(height)

  frame:SetText(name)
  frame:SetNormalFontObject("GameFontNormal")

  local ntex = frame:CreateTexture()
  ntex:SetTexture("Interface/Buttons/UI-Panel-Button-Up")
  ntex:SetTexCoord(0, 0.625, 0, 0.6875)
  ntex:SetAllPoints()
  frame:SetNormalTexture(ntex)

  local htex = frame:CreateTexture()
  htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
  htex:SetTexCoord(0, 0.625, 0, 0.6875)
  htex:SetAllPoints()
  frame:SetHighlightTexture(htex)

  local ptex = frame:CreateTexture()
  ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
  ptex:SetTexCoord(0, 0.625, 0, 0.6875)
  ptex:SetAllPoints()
  frame:SetPushedTexture(ptex)

  frame:SetAttribute("*type1", "destroytotem")
  frame:SetAttribute("*totem-slot*", def.id)

  frame:Show()

  return frame
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addon)
  if event == "PLAYER_LOGIN" then
    TotemDismiss:onLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)
