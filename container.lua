function TotemDismiss:CreateContainer()
  local container = self.container
  if self.container == nil then
    container = CreateFrame("Frame", nil, mainFrame)
  end

  container:SetClampedToScreen(true)
  container:SetPoint(self:GetContainerPoint())
  container:SetHeight(self:GetButtonHeight())
  container:SetWidth(self:GetContainerWidth())
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

function TotemDismiss:UnlockContainer()
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

function TotemDismiss:LockContainer()
  if self.container == nil then
    return
  end

  self.container.dragTexture:Hide()
  self.container:SetMovable(false)
  self.container:EnableMouse(false)
  self.container:RegisterForDrag("LeftButton")
end