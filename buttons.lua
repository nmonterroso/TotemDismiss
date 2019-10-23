function TotemDismiss:CreateButton(totem, anchor)
  local button

  if totem.button ~= nil then
    button = totem.button
  elseif totem.id == self.dismissAllTotem then
    button = self:CreateDismissAllTotemButton(totem)
  else
    button = self:CreateRegularTotemButton(totem)
  end

  if self:IsShowingTotem(totem) then
    if anchor == nil then
      button:SetPoint(self:GetInitialButtonPoint())
    else
      button:SetPoint(self:GetButtonPoint(anchor))
    end

    button:Show()
  else
    button:Hide()
  end

  button:SetFrameStrata("LOW")
  button:SetWidth(self:GetButtonWidth())
  button:SetHeight(self:GetButtonHeight())

  button.texture = self:CreateButtonTexture(button)
  button.overlay = self:CreateButtonOverlay(button)
  button.cooldown = self:CreateButtonCooldown(button)

  button:SetNormalTexture(button.texture)

  return button
end

function TotemDismiss:CreateDismissAllTotemButton(totem)
  local macroText = [[
    /click TotemDismissButton_earth
    /click TotemDismissButton_fire
    /click TotemDismissButton_water
    /click TotemDismissButton_air
  ]]
  local button = CreateFrame("Button", "TotemDismissButton_"..totem.name, self.container, "SecureActionButtonTemplate")
  button:SetAttribute("type1", "macro")
  button:SetAttribute("macrotext", macroText:trim():gsub("%s+", " "):gsub(" /", "\n/"))

  return button
end

function TotemDismiss:CreateRegularTotemButton(totem)
  local button = CreateFrame("Button", "TotemDismissButton_"..totem.name, self.container, "SecureActionButtonTemplate")
  button:SetAttribute("type1", "destroytotem")
  button:SetAttribute("*totem-slot*", totem.id)

  return button
end

function TotemDismiss:CreateButtonOverlay(button)
  local overlay = button.overlay
  if button.overlay == nil then
    overlay = button:CreateTexture(nil, "OVERLAY")
  end

  overlay:SetPoint("TOPLEFT", 1, -1)
  overlay:SetPoint("BOTTOMRIGHT", -1, 1)
  overlay:SetColorTexture(0, 0, 0, .55)

  return overlay
end

function TotemDismiss:CreateButtonTexture(button)
  local texture = button.texture
  if texture == nil then
    texture = button:CreateTexture()
  end

  texture:SetAllPoints()
  return texture
end

function TotemDismiss:CreateButtonCooldown(button)
  local cooldown = button.cooldown
  if cooldown == nil then
    cooldown = CreateFrame("Cooldown", nil, button, "CooldownFrameTemplate")
  end

  cooldown:SetReverse(true)
  cooldown:SetDrawEdge(false)
  cooldown:SetPoint("TOPLEFT", 1, -1)
  cooldown:SetPoint("BOTTOMRIGHT", -1, 1)
  cooldown.text = cooldown:GetRegions()
  cooldown.text:SetFont(self.config.font.path, self.config.font.size, self:GetFontFlags())

  return cooldown
end

function TotemDismiss:SetButtonTexture(totem, icon)
  if totem.button == nil then
    return
  end

  if icon == nil then
    icon = totem.icon
  end

  totem.button.texture:SetTexture(icon)
end

function TotemDismiss:EnableButton(totem)
  if totem.button ~= nil then
    totem.button.overlay:Hide()
  end
end

function TotemDismiss:DisableButton(totem)
  if totem.button ~= nil then
    totem.button.overlay:Show()
    totem.button.cooldown:Clear()
  end
end

function TotemDismiss:EnableButton(totem)
  if totem.button ~= nil then
    totem.button.overlay:Hide()
  end
end

function TotemDismiss:EnableOrDisableDismissAll()
  local dismissAllTotem = self.totems[self.dismissAllTotem]

  for id, _ in pairs(self.totems) do
    if id ~= self.dismissAllTotem then
      local haveTotem, _, startTime, _, _ = GetTotemInfo(id)
      if haveTotem and startTime > 0 then
        self:EnableButton(dismissAllTotem)
        return
      end
    end
  end

  self:DisableButton(dismissAllTotem)
end
