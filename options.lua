local fonts = LibStub("LibSharedMedia-3.0"):HashTable("font")
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
    },
    font = {
      name = "Font Options",
      type = "group",
      args = {
        face = {
          type = "select",
          dialogControl = "LSM30_Font",
          name = "Font Face",
          desc = "Sets the font of the cooldown timer when a totem is active",
          values = LibStub("LibSharedMedia-3.0"):HashTable("font"),
          set = function(info, val)
            TotemDismiss.config.font.name = val
            TotemDismiss.config.font.path = fonts[val]
            TotemDismiss:Draw()
          end,
          get = function(info)
            return TotemDismiss.config.font.name
          end,
        },
        size = {
          name = "Font Size",
          desc = "Size of the cooldown timer when a totem is active",
          type = "range",
          softMin = 1,
          softMax = 32,
          step = 1,
          set = function(info, val)
            if val < 1 then
              val = 1
            elseif val > 32 then
              val = 32
            end

            TotemDismiss.config.font.size = val
            TotemDismiss:Draw()
          end,
          get = function(info)
            return TotemDismiss.config.font.size
          end,
        },
      },
    },
  }
}

TotemDismissOptions = {}
function TotemDismissOptions:setup()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("TotemDismiss", options, {"totemdismiss"})
  local optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TotemDismiss", "Totem Dismiss")
  return optionFrame
end