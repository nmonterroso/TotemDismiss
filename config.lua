TotemDismiss.defaultVariables = {
  global = {
    buttonWidth = 32,
    buttonHeight = 32,
    locked = true,
    scale = 1.0,
    margin = 0,
    font = {
      name = "Friz Quadrata TT",
      path = "Fonts\\FRIZQT__.TTF",
      size = 16,
      flags = {
        outline = false,
        thickoutline = false,
        monochrome = false,
      },
    },
    anchor = {
      point = "LEFT",
      relativePoint = "CENTER",
      offsetX = nil,
      offsetY = nil,
    },
    displayTotems = {
      dismissAll = TotemDismiss.dismissAllOrdering.before,
      regular = true,
    },
  }
}

function TotemDismiss:GetContainerPoint()
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

function TotemDismiss:GetInitialButtonPoint()
  return "LEFT", self.container, "LEFT"
end

function TotemDismiss:GetButtonPoint(anchor)
  return "LEFT", anchor, "RIGHT", self.config.margin
end

function TotemDismiss:GetButtonWidth()
  return self.config.buttonWidth*self.config.scale
end

function TotemDismiss:GetButtonHeight()
  return self.config.buttonHeight*self.config.scale
end

function TotemDismiss:GetContainerWidth()
  if not self:IsShowingContainer() then
    return 0
  end

  local numButtons = 0
  if self.config.displayTotems.dismissAll ~= 'never' then
    numButtons = numButtons + 1
  end

  if self.config.displayTotems.regular then
    numButtons = numButtons + 4
  end

  return self:GetButtonWidth()*numButtons + self.config.margin*(numButtons - 1)
end

function TotemDismiss:GetFontFlags()
  local flags = {}
  if self.config.font.flags.outline then
    table.insert(flags, "OUTLINE")
  end
  if self.config.font.flags.thickoutline then
    table.insert(flags, "THICKOUTLINE")
  end
  if self.config.font.flags.monochrome then
    table.insert(flags, "MONOCHROME")
  end

  if table.getn(flags) == 0 then
    return nil
  end

  return table.concat(flags, ", ")
end

function TotemDismiss:IsShowingContainer()
  return self.config.displayTotems.dismissAll ~= self.dismissAllOrdering.never or
      self.config.displayTotems.regular
end

function TotemDismiss:IsShowingTotem(totem)
  if totem.id == self.dismissAllTotem then
    return self.config.displayTotems.dismissAll ~= self.dismissAllOrdering.never
  end

  return self.config.displayTotems.regular
end

function TotemDismiss:GetTotemOrder()
  local order = {}
  if self.config.displayTotems.dismissAll ~= self.dismissAllOrdering.after then
    table.insert(order, TotemDismiss.dismissAllTotem)
  end

  table.insert(order, TotemDismiss.earthTotem)
  table.insert(order, TotemDismiss.fireTotem)
  table.insert(order, TotemDismiss.waterTotem)
  table.insert(order, TotemDismiss.airTotem)

  if self.config.displayTotems.dismissAll == self.dismissAllOrdering.after then
    table.insert(order, TotemDismiss.dismissAllTotem)
  end

  return order
end
