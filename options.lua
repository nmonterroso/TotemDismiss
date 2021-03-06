local fonts = LibStub("LibSharedMedia-3.0"):HashTable("font")
local macroName = 'TotemDismissAll'
local macroAction = '/click TotemDismissButton_dismissAll'
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
          TotemDismiss:LockContainer()
        else
          TotemDismiss:UnlockContainer()
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
      name = "Font",
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
        flags = {
          name = "Other",
          desc = "other modifications to the cooldown font",
          type = "multiselect",
          values = {
            outline = "Outline",
            thickoutline = "Thick Outline",
            monochrome = "Monochrome",
          },
          set = function(info, key, val)
            TotemDismiss.config.font.flags[key] = val
            TotemDismiss:Draw()
          end,
          get = function(info, key)
            return TotemDismiss.config.font.flags[key]
          end,
        },
      },
    },
    advanced = {
      name = "Advanced",
      type = "group",
      order = -1,
      args = {
        showDismissAll = {
          name = "Show Dismiss All Button",
          type = "select",
          desc = "Whether or not to show button to dismiss all totems",
          values = {
            [TotemDismiss.dismissAllOrdering.never] = 'Never',
            [TotemDismiss.dismissAllOrdering.before] = 'Before Regular Totems',
            [TotemDismiss.dismissAllOrdering.after] = 'After Regular Totems',
          },
          set = function(info, val)
            TotemDismiss.config.displayTotems.dismissAll = val
            TotemDismiss:Draw()
          end,
          get = function(info)
            return TotemDismiss.config.displayTotems.dismissAll
          end,
        },
        showRegular = {
          name = "Show Regular",
          type = "toggle",
          desc = "Whether or not to show buttons to dismiss regular totems",
          set = function(info, val)
            TotemDismiss.config.displayTotems.regular = val
            TotemDismiss:Draw()
          end,
          get = function(info)
            return TotemDismiss.config.displayTotems.regular
          end,
        },
        createMacroHeader = {
          name = "Macro-based dismiss",
          type = "header",
          order = -3,
        },
        createMacroDesc = {
          name = "It's possible to create a macro to dismiss all totems. This is recommended if hiding both the dismiss all button and the regular totem buttons. The macro for this is '"..macroAction.."'. Click the button below to have the character specific macro created with the name '"..macroName.."'",
          type = "description",
          order = -2,
        },
        createMacro = {
          name = "Create Macro",
          type = "execute",
          order = -1,
          func = function()
            TotemDismiss:CreateMacro()
          end
        }
      },
    }
  }
}

function TotemDismiss:SetupOptions()
  LibStub("AceConfig-3.0"):RegisterOptionsTable("TotemDismiss", options, {"totemdismiss"})
  local optionFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TotemDismiss", "Totem Dismiss")
  return optionFrame
end

function TotemDismiss:CreateMacro()
  if UnitAffectingCombat("player") then
    self:Print("Can't create macro when in combat")
    return
  end

  local name = GetMacroInfo(macroName)
  if name ~= nil then
    DeleteMacro(macroName)
  end

  CreateMacro(macroName, 'Spell_Totem_WardOfDraining', macroAction, 1, 1)
  self:Print("Macro created! Make sure to add it to your action bar")
end
