local fire = 'fire'
local earth = 'earth'
local water = 'water'
local air = 'air'

TotemDismiss = {
  totems = {
    [fire] = {
      id = 1,
      icon = 'Interface/ICONS/Spell_Fire_Fire',
    },
    [earth] = {
      id = 2,
      icon = 'Interface/ICONS/INV_Ore_Iron_01',
    },
    [water] = {
      id = 3,
      icon = 'Interface/ICONS/INV_Stone_02',
    },
    [air] = {
      id = 4,
      icon = 'Interface/ICONS/Spell_Nature_EarthBind',
    }
  },
  order = {earth, fire, water, air},
}

-- TODO: read from config?
local width = 32
local height = 32

function TotemDismiss:onLogin()
  local _, classFilename = UnitClass("player")
  local prevButton

  if classFilename == "SHAMAN" then
    for _, totemId in ipairs(self.order) do
      local totemDef = self.totems[totemId]
      prevButton = createButton(totemId, totemDef, prevButton)
    end
  end
end

function createButton(name, def, prevButton)
  local button = CreateFrame("Button", "TotemDismissButton_"..name, UIParent, "SecureActionButtonTemplate")

  if prevButton == nil then
    button:SetPoint("CENTER", mainframe, "CENTER", -1.5*width, 0)
  else
    button:SetPoint("LEFT", prevButton, "RIGHT")
  end

  -- TODO: set strata?
  button:SetWidth(width)
  button:SetHeight(height)

  local ntex = button:CreateTexture()
  ntex:SetTexture(def.icon)
  ntex:SetAllPoints()
  button:SetNormalTexture(ntex)

--  local htex = frame:CreateTexture()
--  htex:SetTexture("Interface/Buttons/UI-Panel-Button-Highlight")
--  htex:SetTexCoord(0, 0.625, 0, 0.6875)
--  htex:SetAllPoints()
--  frame:SetHighlightTexture(htex)
--
--  local ptex = frame:CreateTexture()
--  ptex:SetTexture("Interface/Buttons/UI-Panel-Button-Down")
--  ptex:SetTexCoord(0, 0.625, 0, 0.6875)
--  ptex:SetAllPoints()
--  frame:SetPushedTexture(ptex)

  button:SetAttribute("*type1", "destroytotem")
  button:SetAttribute("*totem-slot*", def.id)

  button:Show()

  return button
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:SetScript("OnEvent", function(self, event, addon)
  if event == "PLAYER_LOGIN" then
    TotemDismiss:onLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
  end
end)
