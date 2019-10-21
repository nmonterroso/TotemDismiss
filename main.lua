local fire = 'fire'
local earth = 'earth'
local water = 'water'
local air = 'air'

TotemDismiss = LibStub("AceAddon-3.0"):NewAddon("TotemDismiss", "AceConsole-3.0", "AceEvent-3.0")

function TotemDismiss:OnInitialize()
  if not self:canUse() then
    return
  end

  self.db = LibStub("AceDB-3.0"):New("TotemDismissDB", TotemDismissDefaultVariables)
  self.config = nil
  self.optionFrame = TotemDismissOptions:setup()
  self.totemOrder = {earth, fire, water, air}
  self.container = nil
  self.totems = {
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
    },
  }
end

function TotemDismiss:OnEnable()
  if not self:canUse() then
    return
  end

  self.config = self.db.global
  self.configHelper = TotemDismissConfigHelper:init(self.config)
  self:Draw()
  self:RegisterEvent("PLAYER_TOTEM_UPDATE", function(event, id)
    self:onTotemUpdate(id)
  end)
end

function TotemDismiss:Draw()
  self.container = self:createContainer()
  self:createTotems()
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
    totem.cooldown:SetCooldown(startTime, duration)
  else
    self:disable(id)
    self:setTexture(id)
  end
end

function TotemDismiss:createTotems()
  local lastAnchor
  for _, type in ipairs(self.totemOrder) do
    local totem = self.totems[type]

    self:initTotem(totem.id, type, lastAnchor)

    if totem.isReady then
      lastAnchor = totem.button
    end
  end
end

function TotemDismiss:initTotem(id, type, anchor)
  local button = self:createButton(id, type, anchor)
  local iconTexture = self:createIconTexture(id, button)
  local overlay = self:createOverlay(id, button)
  local cooldown = self:createCooldown(id, button)

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

function TotemDismiss:unlock()
  if self.container == nil then
    return
  end
end

function TotemDismiss:createContainer()
  local container = self.container
  if self.container == nil then
    container = CreateFrame("Frame", nil, mainFrame)
  end

  container:SetFrameStrata("MEDIUM")
  container:SetMovable(true)
  container:EnableMouse(false)
  container:RegisterForDrag("LeftButton")
  container:SetClampedToScreen(true)
  container:SetPoint(self.configHelper:GetContainerPoint())
  container:SetHeight(self.configHelper:GetHeight())
  container:SetWidth(self.configHelper:GetTotalWidth())
  container:Show()

  return container
end

function TotemDismiss:createButton(id, type, anchor)
  local totem = self:getTotem(id)
  local button
  if totem.isReady then
    button = totem.button
  else
    button = CreateFrame("Button", "TotemDismissButton_"..type, UIParent, "SecureActionButtonTemplate")
  end

  if anchor == nil then
    button:SetPoint(self.configHelper:GetInitialButtonPoint())
  else
    button:SetPoint(self.configHelper:GetButtonPoint(anchor))
  end

  button:SetWidth(self.configHelper:GetWidth())
  button:SetHeight(self.configHelper:GetHeight())
  button:SetAttribute("*type1", "destroytotem")
  button:SetAttribute("*totem-slot*", id)

  return button
end

function TotemDismiss:createCooldown(id, button)
  local totem = self:getTotem(id)
  local cooldown = totem.cooldown
  if not totem.isReady then
    cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
  end

  cooldown:SetReverse(true)
  cooldown:SetDrawEdge(false)
  cooldown:SetPoint("TOPLEFT", 1, -1)
  cooldown:SetPoint("BOTTOMRIGHT", -1, 1)

  return cooldown
end

function TotemDismiss:createIconTexture(id, button)
  local totem = self:getTotem(id)
  local texture
  if totem.isReady then
    texture = totem.iconTexture
  else
    texture = button:CreateTexture()
  end

  texture:SetAllPoints()
  return texture
end

function TotemDismiss:createOverlay(id, button)
  local totem = self:getTotem(id)
  local overlay
  if totem.isReady then
    overlay = totem.overlay
  else
    overlay = button:CreateTexture(nil, "OVERLAY")
  end

  overlay:SetPoint("TOPLEFT", 1, -1)
  overlay:SetPoint("BOTTOMRIGHT", -1, 1)
  overlay:SetColorTexture(0, 0, 0, .55)

  return overlay
end

function TotemDismiss:canUse()
  local _, classFilename = UnitClass("player")
  return classFilename == "SHAMAN"
end
