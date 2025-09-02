local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action

config = {
  window_background_opacity = 0.90,
  font_size = 12,
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
  window_padding = { bottom = 0, left = 0, right = 0},
  max_fps = 120,
}
local tmux = false
if tmux then
  require("tmux").tmux_bindings(act, config)
end

return config
