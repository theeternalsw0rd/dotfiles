-- on Windows use https://github.com/flyingpie/windows-terminal-quake for quake mode 
-- a copy of the configuration is in this dotfiles repository at wtq.jsonc set sizing as appropriate
local wezterm = require("wezterm")

local is_linux = function()
	return wezterm.target_triple:find("linux") ~= nil
end

local is_darwin = function()
	return wezterm.target_triple:find("darwin") ~= nil
end

local is_windows = function()
  return wezterm.target_triple:find("windows") ~=nil
end

local mux = wezterm.mux

wezterm.on("gui-startup", function(cmd)
  local tab, pane, window = mux.spawn_window(cmd or {})
  if not is_windows() then
    window:gui_window():maximize()
  end
  if is_windows() then
    tab:set_title 'pwsh.exe'
    local wsl_tab, wsl_pane, wsl_window = window:spawn_tab { args = { 'wsl.exe' } }
    wsl_tab:set_title 'Linux'
  end
end)

local config = wezterm.config_builder()
config.launch_menu = {}

if is_windows() then
  table.insert(config.launch_menu, {
    label = 'PowerShell',
    args = { 'pwsh.exe' },
  })
  table.insert(config.launch_menu, {
    label = 'WSL',
    args = { 'wsl.exe' },
  })
end

config.font = wezterm.font("MesloLGS Nerd Font Mono")
config.font_size = 14
config.underline_thickness = 3
config.underline_position = -4

config.enable_tab_bar = is_windows()
config.tab_bar_at_bottom = is_windows()

if is_windows() then
  wezterm.gui.enumerate_gpus()
  config.webgpu_preferred_adapter = gpu
  config.window_background_opacity = 0.9
  config.default_prog = { 'pwsh.exe' }
end

config.window_decorations = "NONE"

config.enable_wayland = is_linux()

config.color_scheme = 'tokyonight_night'
-- use os for opacity
-- config.window_background_opacity = 0.9

return config