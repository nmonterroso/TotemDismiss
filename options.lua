local options = {
  name = 'TotemDismiss',
  type = "group",
  args = {
    locked = {
      name = "Locked",
      desc = "Prevents the bar from being moved",
      type = "toggle",
      set = function(info, val)
        TotemDismiss.config.locked = val
        if val then
          TotemDismiss:Lock()
        else
          TotemDismiss:Unlock()
        end
      end,
      get = function(info) return TotemDismiss.config.locked end
    },
    scale = {
      name = "Scale",
      desc = "Button scale",
      type = "range",
      softMin = 0.1,
      softMax = 1.9,
      set = function(info, val)
        if val < 0.1 then
          val = 0.1
        elseif val > 1.9 then
          val = 1.9
        end

        TotemDismiss.config.scale = val
        TotemDismiss:Draw()
      end,
      get = function(info) return TotemDismiss.config.scale end
    }
  }
}

TotemDismissOptions = {}
function TotemDismissOptions:setup()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("TotemDismiss", options, {"totemdismiss"})
  local optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TotemDismiss", "Totem Dismiss")
  return optionFrame
end