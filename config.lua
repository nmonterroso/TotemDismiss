TotemDismissConfig = {
  defaults = {
    buttonWidth = 32,
    buttonHeight = 32,
    locked = true,
    scale = 1.0,
    padding = 0,
    anchorPoint = "LEFT",
    anchorRelativeTo = nil,
    anchorRelativePoint = "CENTER",
    anchorOffsetX = nil,
    anchorOffsetY = nil,
  }
}

function TotemDismissConfig:GetButtonWidth()
  return TotemDismissVariables.buttonWidth or self.defaults.buttonWidth
end

function TotemDismissConfig:GetButtonHeight()
  return TotemDismissVariables.buttonHeight or self.defaults.buttonHeight
end

function TotemDismissConfig:IsLocked()
  return TotemDismissVariables.locked or self.defaults.locked;
end

function TotemDismissConfig:GetScale()
  return TotemDismissVariables.scale or self.defaults.scale
end

function TotemDismissConfig:GetPadding()
  return TotemDismissVariables.padding or self.defaults.padding
end

function TotemDismissConfig:GetInitialButtonPoint()
  local anchorRelativeTo = TotemDismissVariables.anchorRelativeTo or mainFrame
  local anchorOffsetX = -2*self.defaults.buttonWidth
  if TotemDismissVariables.anchorOffsetX ~= nil then
    anchorOffsetX = TotemDismissVariables.anchorOffsetX
  end
  local anchorOffsetY = 0
  if TotemDismissVariables.anchorOffsetY ~= nil then
    anchorOffsetY = TotemDismissVariables.anchorOffsetX
  end

  return TotemDismissVariables.anchorPoint, anchorRelativeTo, TotemDismissVariables.anchorRelativePoint, anchorOffsetX, anchorOffsetY
end

function TotemDismissConfig:GetButtonPoint(anchor)
  return "LEFT", anchor, "RIGHT", TotemDismissVariables.padding
end

function TotemDismissConfig:LoadVariables()
  if TotemDismissVariables == nil then
    TotemDismissVariables = {}
  end

  TotemDismissVariables = {
    buttonWidth = TotemDismissVariables.buttonWidth or self.defaults.buttonWidth,
    buttonHeight = TotemDismissVariables.buttonHeight or self.defaults.buttonHeight,
    locked = TotemDismissVariables.locked or self.defaults.locked,
    scale = TotemDismissVariables.scale or self.defaults.scale,
    padding = TotemDismissVariables.padding or self.defaults.padding,
    anchorPoint = TotemDismissVariables.anchorPoint or self.defaults.anchorPoint,
    anchorRelativeTo = TotemDismissVariables.anchorRelativeTo or self.defaults.anchorRelativeTo,
    anchorRelativePoint = TotemDismissVariables.anchorRelativePoint or self.defaults.anchorRelativePoint,
    anchorOffsetX = TotemDismissVariables.anchorOffsetX or self.defaults.anchorOffsetX,
    anchorOffsetY = TotemDismissVariables.anchorOffsetY or self.defaults.anchorOffsetY,
  }

  return TotemDismissVariables
end
