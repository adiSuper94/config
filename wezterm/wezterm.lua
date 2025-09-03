local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

config = {
  font_size = 12,
  font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
  window_background_opacity = 0.95,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  keys = {
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.CloseCurrentPane({ confirm = true }),
    },
  },
  color_scheme = "Gruber (base16)",
  window_padding = { bottom = 0, left = 0, right = 0 },
  max_fps = 120,
}
local tmux = true
if tmux then
  require("tmux").tmux_bindings(act, config)
end

local is_darwin = string.find(wezterm.target_triple, "darwin")
local is_linux = string.find(wezterm.target_triple, "linux")

if is_darwin then
  config.window_decorations = "RESIZE"
elseif is_linux then
  config.window_decorations = "NONE"
  config.front_end = "WebGpu"
end
return config
