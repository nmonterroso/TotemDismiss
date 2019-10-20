TotemDismissDefaultVariables = {
  global = {
    buttonWidth = 32,
    buttonHeight = 32,
    locked = true,
    scale = 1.0,
    padding = 0,
    anchor = {
      point = "LEFT",
      relativeTo = nil,
      relativePoint = "CENTER",
      offsetX = nil,
      offsetY = nil,
    },
  }
}

TotemDismissConfigHelper = {
  config = nil,
}

function TotemDismissConfigHelper:init(config)
  self.config = config
  return self
end

function TotemDismissConfigHelper:GetInitialButtonPoint()
  local relativeTo = self.config.anchor.relativeTo or mainFrame
  local offsetX = -2*self.config.buttonWidth
  if self.config.anchor.offsetX ~= nil then
    offsetX = self.config.anchor.offsetX
  end
  local offsetY = 0
  if self.config.anchor.offsetY ~= nil then
    offsetY = self.config.anchor.offsetY
  end

  return self.config.anchor.point, relativeTo, self.config.anchor.relativePoint, offsetX, offsetY
end

function TotemDismissConfigHelper:GetButtonPoint(anchor)
  return "LEFT", anchor, "RIGHT", self.config.padding
end
