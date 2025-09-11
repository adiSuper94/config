local wezterm = require("wezterm")

local config = wezterm.config_builder()
local act = wezterm.action
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local smart_splits = wezterm.plugin.require("https://github.com/mrjones2014/smart-splits.nvim")
config = {
  window_background_opacity = 0.95,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    {
      key = "w",
      mods = "CTRL|SHIFT",
      action = act.CloseCurrentPane({ confirm = true }),
    },
    -- Wezterm default bindings,
    {
      key = "z",
      mods = "LEADER",
      action = act.TogglePaneZoomState,
    },
    {
      key = "w",
      mods = "LEADER",
      action = act.CloseCurrentPane({ confirm = true }),
    },
    {
      key = "t",
      mods = "LEADER",
      action = act.SpawnTab("CurrentPaneDomain"),
    },
    {
      key = "s",
      mods = "LEADER",
      action = workspace_switcher.switch_workspace(),
    },
    {
      key = "S",
      mods = "LEADER",
      action = workspace_switcher.switch_to_prev_workspace(),
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

local os_specific_config = {}
if is_darwin then
  os_specific_config = {
    font_size = 15,
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Medium" }),
    window_decorations = "RESIZE",
  }
elseif is_linux then
  os_specific_config = {
    font_size = 12,
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
    window_decorations = "NONE",
    front_end = "WebGpu",
  }
  workspace_switcher.zoxide_path = "$HOME/.local/bin/zoxide"
end

for k, v in pairs(os_specific_config) do
  config[k] = v
end

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)
smart_splits.apply_to_config(config)

return config
