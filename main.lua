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
      iconTexture = nil,
      cooldown = nil,
      isReady = false,
    },
    [earth] = {
      id = 2,
      icon = 'Interface/ICONS/INV_Stone_16',
      button = nil,
      overlay = nil,
      iconTexture = nil,
      cooldown = nil,
      isReady = false,
    },
    [water] = {
      id = 3,
      icon = 'Interface/ICONS/INV_Stone_02',
      button = nil,
      overlay = nil,
      iconTexture = nil,
      cooldown = nil,
      isReady = false,
    },
    [air] = {
      id = 4,
      icon = 'Interface/AddOns/TotemDismiss/air',
      button = nil,
      overlay = nil,
      iconTexture = nil,
      cooldown = nil,
      isReady = false,
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

      local totem = self:getTotem(def.id)
      if totem.isReady then
        anchor = totem.button
      end
    end
  end
end

function TotemDismiss:onTotemUpdate(id)
  local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(id)
  local totem = self:getTotem(id)
  if not totem.isReady then
    return
  end

  if haveTotem and startTime > 0 then
    self:enable(id)
    self:setTexture(id, icon)
    local timeLeft = GetTotemTimeLeft(id)
    totem.cooldown:SetCooldown(startTime, duration)
  else
    self:disable(id)
    self:setTexture(id)
  end
end

function TotemDismiss:initTotem(type, anchor, id, icon)
  local button = createButton(type, anchor, id)
  local iconTexture = createIconTexture(button)
  local overlay = createOverlay(button)
  local cooldown = createCooldown(button)

  button:SetNormalTexture(iconTexture)
  button:Show()

  self.totems[type].button = button
  self.totems[type].overlay = overlay
  self.totems[type].iconTexture = iconTexture
  self.totems[type].cooldown = cooldown
  self.totems[type].isReady = true

  self:setTexture(id)
  self:disable(id)
end

function TotemDismiss:setTexture(id, icon)
  local totem = self:getTotem(id)
  if not totem.isReady then
    return
  end

  if icon == nil then
    icon = totem.icon
  end

  totem.iconTexture:SetTexture(icon)
end

function TotemDismiss:getTotem(id)
  if id == 1 then
    return self.totems[fire]
  elseif id == 2 then
    return self.totems[earth]
  elseif id == 3 then
    return self.totems[water]
  end

  return self.totems[air]
end

function TotemDismiss:disable(id)
  local totem = self:getTotem(id)
  if totem.isReady then
    totem.button:Disable()
    totem.overlay:Show()
    totem.cooldown:Clear()
  end
end

function TotemDismiss:enable(id)
  local totem = self:getTotem(id)
  if totem.isReady then
    totem.button:Enable()
    totem.overlay:Hide()
  end
end

function createCooldown(button)
  local cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
  cooldown:SetReverse(true)
  cooldown:SetDrawEdge(false)
  cooldown:SetPoint("TOPLEFT", 1, -1)
  cooldown:SetPoint("BOTTOMRIGHT", -1, 1)

  return cooldown
end

function createButton(type, anchor, id)
  local button = CreateFrame("Button", "TotemDismissButton_"..type, UIParent, "SecureActionButtonTemplate")

  if anchor == nil then
    button:SetPoint("LEFT", mainframe, "CENTER", -2*width, 0)
  else
    button:SetPoint("LEFT", anchor, "RIGHT")
  end

  -- TODO: set strata?
  button:SetWidth(width)
  button:SetHeight(height)
  button:SetAttribute("*type1", "destroytotem")
  button:SetAttribute("*totem-slot*", id)

  return button
end

function createIconTexture(button)
  local texture = button:CreateTexture()
  texture:SetAllPoints()

  return texture
end

function createOverlay(button)
  local overlay = button:CreateTexture(nil, "OVERLAY")
  overlay:SetPoint("TOPLEFT", 1, -1)
  overlay:SetPoint("BOTTOMRIGHT", -1, 1)
  overlay:SetColorTexture(0, 0, 0, .55)
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
    TotemDismiss:onTotemUpdate(totemId)
  end
end)
