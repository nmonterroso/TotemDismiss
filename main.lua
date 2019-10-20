local fire = 'fire'
local earth = 'earth'
local water = 'water'
local air = 'air'

TotemDismiss = {
  totems = {
    [fire] = {
      id = 1,
      icon = 'Interface/ICONS/Spell_Fire_Fire',
      button = nil,
      overlay = nil,
    },
    [earth] = {
      id = 2,
      icon = 'Interface/ICONS/INV_Stone_16',
      button = nil,
      overlay = nil,
    },
    [water] = {
      id = 3,
      icon = 'Interface/ICONS/INV_Stone_02',
      button = nil,
      overlay = nil,
    },
    [air] = {
      id = 4,
      icon = 'Interface/ICONS/Spell_Nature_EarthBind',
      button = nil,
      overlay = nil,
    }
  },
  order = {earth, fire, water, air},
}

-- TODO: read from config?
local width = 32
local height = 32

function TotemDismiss:onLogin()
  local _, classFilename = UnitClass("player")
  local anchor

  if classFilename == "SHAMAN" then
    for _, type in ipairs(self.order) do
      local def = self.totems[type]

      if self.totems[type].button == nil then
        self:initTotem(type, anchor, def.id, def.icon)
      end

      local totem = self:getTotemFromId(def.id)
      if totem ~= nil then
        anchor = totem.button
      end
    end
  end
end

function TotemDismiss:initTotem(type, anchor, id, icon)
  local button = createButton(type, anchor, id, icon)
  local overlay = createOverlay(button)

  self.totems[type].button = button
  self.totems[type].overlay = overlay

  self:disable(id)
end

function TotemDismiss:getTotemFromId(id)
  if id == 1 then
    return self.totems[fire]
  elseif id == 2 then
    return self.totems[earth]
  elseif id == 3 then
    return self.totems[water]
  elseif id == 4 then
    return self.totems[air]
  end

  return nil
end

function TotemDismiss:disable(id)
  local totem = self:getTotemFromId(id)
  if totem ~= nil then
    totem.button:Disable()
    totem.overlay:Show()
  end
end

function TotemDismiss:enable(id)
  local totem = self:getTotemFromId(id)
  if totem ~= nil then
    totem.button:Enable()
    totem.overlay:Hide()
  end
end

function createButton(type, anchor, id, icon)
  local button = CreateFrame("Button", "TotemDismissButton_"..type, UIParent, "SecureActionButtonTemplate")

  if anchor == nil then
    button:SetPoint("CENTER", mainframe, "CENTER", -1.5*width, 0)
  else
    button:SetPoint("LEFT", anchor, "RIGHT")
  end

  -- TODO: set strata?
  button:SetWidth(width)
  button:SetHeight(height)

  local ntex = button:CreateTexture()
  ntex:SetTexture(icon)
  ntex:SetAllPoints()
  button:SetNormalTexture(ntex)

  button:SetAttribute("*type1", "destroytotem")
  button:SetAttribute("*totem-slot*", id)

  button:Show()

  return button
end

function createOverlay(button)
  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetPoint("TOPLEFT", 1, -1)
  overlay:SetPoint("BOTTOMRIGHT", -1, 1)
  overlay:SetColorTexture(0, 0, 0, .65)
  overlay:Show()

  return overlay
end

local frame = CreateFrame("Frame")
frame:RegisterEvent("PLAYER_LOGIN")
frame:RegisterEvent("PLAYER_TOTEM_UPDATE")
frame:SetScript("OnEvent", function(self, event, ...)
  if event == "PLAYER_LOGIN" then
    TotemDismiss:onLogin()
    self:UnregisterEvent("PLAYER_LOGIN")
  elseif event == "PLAYER_TOTEM_UPDATE" then
    local totemId = select(1, ...)
    TotemDismiss:enable(totemId)
  end
end)
