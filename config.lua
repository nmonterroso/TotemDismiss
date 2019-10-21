TotemDismissDefaultVariables = {
  global = {
    buttonWidth = 32,
    buttonHeight = 32,
    locked = true,
    scale = 1.0,
    margin = 0,
    anchor = {
      point = "LEFT",
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

function TotemDismissConfigHelper:GetContainerPoint()
  local offsetX = -2*self.config.buttonWidth
  if self.config.anchor.offsetX ~= nil then
    offsetX = self.config.anchor.offsetX
  end

  local offsetY = 0
  if self.config.anchor.offsetY ~= nil then
    offsetY = self.config.anchor.offsetY
  end

  return self.config.anchor.point, UIParent, self.config.anchor.relativePoint, offsetX, offsetY
end

function TotemDismissConfigHelper:GetInitialButtonPoint()
  return "LEFT", TotemDismiss.container, "LEFT"
end

function TotemDismissConfigHelper:GetButtonPoint(anchor)
  return "LEFT", anchor, "RIGHT", self.config.margin
end

function TotemDismissConfigHelper:GetHeight()
  return self.config.buttonHeight*self.config.scale
end

function TotemDismissConfigHelper:GetWidth()
  return self.config.buttonWidth*self.config.scale
end

function TotemDismissConfigHelper:GetTotalWidth()
  return self:GetWidth()*4 + self.config.margin*3
end
