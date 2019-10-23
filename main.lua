TotemDismiss = LibStub("AceAddon-3.0"):NewAddon("TotemDismiss", "AceConsole-3.0", "AceEvent-3.0")
TotemDismiss.dismissAllTotem = 0
TotemDismiss.fireTotem = 1
TotemDismiss.earthTotem = 2
TotemDismiss.waterTotem = 3
TotemDismiss.airTotem = 4

function TotemDismiss:OnInitialize()
  if not self:PlayerIsShaman() then
    return
  end

  self.db = LibStub("AceDB-3.0"):New("TotemDismissDB", self.defaultVariables)
  self.optionFrame = TotemDismissOptions:setup()
  self.config = nil
  self.container = nil
  self.totems = {
    [self.dismissAllTotem] = {
      id = self.dismissAllTotem,
      name = "dismissAll",
      icon = 'Interface/ICONS/Spell_Totem_WardOfDraining',
      button = nil,
    },
    [self.fireTotem] = {
      id = self.fireTotem,
      name = "fire",
      icon = 'Interface/ICONS/Spell_Fire_Fire',
      button = nil,
    },
    [self.earthTotem] = {
      id = self.earthTotem,
      name = "earth",
      icon = 'Interface/ICONS/INV_Stone_16',
      button = nil,
    },
    [self.waterTotem] = {
      id = self.waterTotem,
      name = "water",
      icon = 'Interface/ICONS/INV_Stone_02',
      button = nil,
    },
    [self.airTotem] = {
      id = self.airTotem,
      name = "air",
      icon = 'Interface/AddOns/TotemDismiss/air',
      button = nil,
    },
  }
end

function TotemDismiss:OnEnable()
  if not self:PlayerIsShaman() then
    return
  end

  self.config = self.db.global
  self:Draw()
  self:RegisterEvent("PLAYER_TOTEM_UPDATE", function(event, id)
    self:OnTotemUpdate(id)
    self:EnableOrDisableDismissAll()
  end)
  self:RegisterEvent("PLAYER_LOGOUT", function()
    self.config.locked = true
  end)
end

function TotemDismiss:Draw()
  self.container = self:CreateContainer()
  self:CreateTotems()
  self:EnableOrDisableDismissAll()
end

function TotemDismiss:OnTotemUpdate(id)
  local haveTotem, totemName, startTime, duration, icon = GetTotemInfo(id)
  local totem = self.totems[id]
  if totem.button == nil then
    return
  end

  if haveTotem and startTime > 0 then
    self:EnableButton(totem)
    self:SetButtonTexture(totem, icon)
    totem.button.cooldown:SetCooldown(startTime, duration)
  else
    self:DisableButton(totem)
    self:SetButtonTexture(totem)
  end
end

function TotemDismiss:CreateTotems()
  local lastAnchor
  for _, id in ipairs(self.config.totemOrder) do
    local totem = self.totems[id]

    lastAnchor = self:InitTotem(totem, lastAnchor)
    self:OnTotemUpdate(totem.id)
  end
end

function TotemDismiss:InitTotem(totem, anchor)
  totem.button = self:CreateButton(totem, anchor)

  self:SetButtonTexture(totem)
  self:DisableButton(totem)

  if self:IsShowingTotem(totem) then
    return totem.button
  end

  return nil
end

function TotemDismiss:PlayerIsShaman()
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
