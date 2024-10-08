local wezterm = require("wezterm")

local mux = wezterm.mux
wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  window:gui_window():maximize()
end)

local config = wezterm.config_builder()

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.underline_thickness = 3
config.underline_position = -4

config.enable_tab_bar = false

config.window_decorations = "NONE"

config.enable_wayland = true

config.color_scheme = 'tokyonight_night'
-- use os for opacity
-- config.window_background_opacity = 0.9

return config
