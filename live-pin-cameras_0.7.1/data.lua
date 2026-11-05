data:extend({
  {
    type = "custom-input",
    name = "live-pin-cameras-manage",
    key_sequence = "CONTROL + SHIFT + L",
    consuming = "none",
    action = "lua"
  },
  {
    type = "custom-input",
    name = "live-pin-cameras-create",
    key_sequence = "CONTROL + SHIFT + C",
    consuming = "none",
    action = "lua"
  },
  {
    type = "custom-input",
    name = "live-pin-cameras-pan-shift",
    key_sequence = "SHIFT + mouse-button-2",
    consuming = "none",
    action = "lua"
  },
  {
    type = "custom-input",
    name = "live-pin-cameras-interact",
    key_sequence = "mouse-button-1",
    consuming = "none",
    action = "lua"
  },
  {
    type = "custom-input",
    name = "live-pin-cameras-zoom-in",
    key_sequence = "mouse-wheel-up",
    consuming = "game-only",
    action = "lua"
  },
  {
    type = "custom-input",
    name = "live-pin-cameras-zoom-out",
    key_sequence = "mouse-wheel-down",
    consuming = "game-only",
    action = "lua"
  },
  {
    type = "shortcut",
    name = "live-pin-cameras-toggle",
    order = "a[modded]-a[live-pin-cameras]",
    action = "lua",
    associated_control_input = "live-pin-cameras-create",
    icon = "__core__/graphics/icons/mip/pin.png",
    icon_size = 32,
    small_icon = "__core__/graphics/icons/mip/pin.png",
    small_icon_size = 32
  }
})

data.raw["gui-style"].default.live_pin_cameras_camera_overlay = {
  type = "button_style",
  padding = 0,
  minimal_width = 0,
  minimal_height = 0,
  default_graphical_set = {},
  hovered_graphical_set = {},
  clicked_graphical_set = {},
  disabled_graphical_set = {},
  selected_graphical_set = {},
  selected_hovered_graphical_set = {},
  selected_clicked_graphical_set = {}
}

data.raw["gui-style"].default.live_pin_cameras_camera_overlay_grid = {
  type = "table_style",
  padding = 0,
  horizontal_spacing = 0,
  vertical_spacing = 0
}
