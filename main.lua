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
  self:RegisterEvent("PLAYER_LOGOUT", function()
    self.config.locked = true
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
      self:onTotemUpdate(totem.id)
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
    totem.overlay:Show()
    totem.cooldown:Clear()
  end
end

function TotemDismiss:enable(id)
  local totem = self:getTotem(id)
  if totem.isReady then
    totem.overlay:Hide()
  end
end

function TotemDismiss:Unlock()
  if self.container == nil then
    return
  end

  self.container:SetMovable(true)
  self.container:EnableMouse(true)
  self.container:RegisterForDrag("LeftButton")
  self.container.dragTexture:Show()

  self.container:SetScript("OnDragStart", function()
    self.container:StartMoving()
  end)
  self.container:SetScript("OnDragStop", function()
    self.config.anchor.offsetX = self.container:GetLeft()
    self.config.anchor.offsetY = self.container:GetBottom()
    self.config.anchor.point = "BOTTOMLEFT"
    self.config.anchor.relativePoint = "BOTTOMLEFT"
    self.container:StopMovingOrSizing()
  end)
end

function TotemDismiss:Lock()
  if self.container == nil then
    return
  end

  self.container.dragTexture:Hide()
  self.container:SetMovable(false)
  self.container:EnableMouse(false)
  self.container:RegisterForDrag("LeftButton")
end

function TotemDismiss:createContainer()
  local container = self.container
  if self.container == nil then
    container = CreateFrame("Frame", nil, mainFrame)
  end

  container:SetClampedToScreen(true)
  container:SetPoint(self.configHelper:GetContainerPoint())
  container:SetHeight(self.configHelper:GetHeight())
  container:SetWidth(self.configHelper:GetTotalWidth())
  container:Show()

  if container.dragTexture == nil then
    local dragTexture = container:CreateTexture()
    dragTexture:SetColorTexture(0, .8, 0, .55)
    dragTexture:SetAllPoints()
    dragTexture:Hide()

    container.dragTexture = dragTexture
  end

  return container
end

function TotemDismiss:createButton(id, type, anchor)
  local totem = self:getTotem(id)
  local button
  if totem.isReady then
    button = totem.button
  else
    button = CreateFrame("Button", "TotemDismissButton_"..type, self.container, "SecureActionButtonTemplate")
  end

  if anchor == nil then
    button:SetPoint(self.configHelper:GetInitialButtonPoint())
  else
    button:SetPoint(self.configHelper:GetButtonPoint(anchor))
  end

  button:SetFrameStrata("LOW")
  button:SetWidth(self.configHelper:GetWidth())
  button:SetHeight(self.configHelper:GetHeight())
  button:SetAttribute("type1", "destroytotem")
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
  cooldown.text = cooldown:GetRegions()
  cooldown.text:SetFont(self.config.font.path, self.config.font.size, self.configHelper:GetFontFlags())

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

function TotemDismiss:serializeTable(val, name, skipnewlines, depth)
  skipnewlines = skipnewlines or false
  depth = depth or 0

  local tmp = string.rep(" ", depth)

  if name then tmp = tmp .. name .. " = " end

  if type(val) == "table" then
    tmp = tmp .. "{" .. (not skipnewlines and "\n" or "")

    for k, v in pairs(val) do
      tmp =  tmp .. self:serializeTable(v, k, skipnewlines, depth + 1) .. "," .. (not skipnewlines and "\n" or "")
    end

    tmp = tmp .. string.rep(" ", depth) .. "}"
  elseif type(val) == "number" then
    tmp = tmp .. tostring(val)
  elseif type(val) == "string" then
    tmp = tmp .. string.format("%q", val)
  elseif type(val) == "boolean" then
    tmp = tmp .. (val and "true" or "false")
  else
    tmp = tmp .. "\"[inserializeable datatype:" .. type(val) .. "]\""
  end

  return tmp
end
