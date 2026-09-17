local wezterm = require("wezterm")

local config = wezterm.config_builder()
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
local leader_binds = wezterm.plugin.require("https://gitlab.com/adiSuper94/leader_binds.wezterm")

-- Ported from nvim's sundarban colorscheme (nvim/colors/sundarban.lua)
local sundarban_scheme = {
  foreground = "#E4E4E4",
  background = "#181818",
  cursor_bg = "#39FF14",
  cursor_border = "#39FF14",
  cursor_fg = "#181818",
  selection_bg = "#52494E",
  selection_fg = "#E4E4E4",
  ansi = {
    "#181818", -- black
    "#FC6767", -- red
    "#A3C585", -- green
    "#cc8c3c", -- yellow (brown, matches sundarban's Comment color)
    "#00a1ff", -- blue
    "#9E95C7", -- magenta
    "#00CC98", -- cyan
    "#E4E4E4", -- white
  },
  brights = {
    "#52494E", -- bright black
    "#FC6767", -- bright red
    "#39FF14", -- bright green (sundarban's signature neon)
    "#FFF150", -- bright yellow
    "#00a1ff", -- bright blue
    "#9E95C7", -- bright magenta
    "#C7F9AC", -- bright cyan
    "#F5F5F5", -- bright white
  },
}

config = {
  window_background_opacity = 0.95,
  use_fancy_tab_bar = false,
  tab_bar_at_bottom = true,
  leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 },
  keys = {
    -- workspace switcher
    {
      key = "_",
      mods = "LEADER|SHIFT",
      action = workspace_switcher.switch_workspace(),
    },
    {
      key = "-",
      mods = "LEADER",
      action = workspace_switcher.switch_to_prev_workspace(),
    },
  },
  color_schemes = {
    Sundarban = sundarban_scheme,
  },
  color_scheme = "Sundarban",
  window_padding = { bottom = 0, left = 0, right = 0 },
  max_fps = 120,
}

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
    font_size = 11,
    font = wezterm.font("JetBrainsMono Nerd Font", { weight = "Regular" }),
    window_decorations = "NONE",
    front_end = "WebGpu",
  }
end

for k, v in pairs(os_specific_config) do
  config[k] = v
end

-- This maybe slow, but without this the tab name is too noisy
local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

wezterm.on("format-tab-title", function(tab, tabs, panes, config, hover, max_width)
  local pane = tab.active_pane
  return {
    { Text = " " .. tab.tab_index + 1 .. ": " .. basename(pane.foreground_process_name) .. " " },
  }
end)

wezterm.on("update-right-status", function(window, pane)
  window:set_right_status(window:active_workspace())
end)
leader_binds.apply_to_config(config, {
  navigation = { vim = true },
  split = { vim = true },
  resize = { vim = true },
})

return config
