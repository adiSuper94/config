local M = {}
M.tmux_bindings = function(act, config)
  config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
  local tmux_bindngs = {
    {
      key = "h",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Left"),
    },
    {
      key = "l",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Right"),
    },
    {
      key = "k",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Up"),
    },
    {
      key = "j",
      mods = "LEADER",
      action = act.ActivatePaneDirection("Down"),
    },
    {
      key = "g",
      mods = "LEADER",
      action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "v",
      mods = "LEADER",
      action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
    },
    {
      key = "z",
      mods = "LEADER",
      action = act.TogglePaneZoomState,
    },
    {
      key = "x",
      mods = "LEADER",
      action = act.CloseCurrentPane({ confirm = true }),
    },
  }

  if config.keys == nil then
    config.keys = {}
  end
  for key, value in pairs(tmux_bindngs) do
    config.keys[key] = value
  end
  for i = 1, 9 do
    table.insert(config.keys, {
      key = tostring(i),
      mods = "LEADER",
      action = act.ActivateTab(i - 1),
    })
    table.insert(config.keys, {
      key = tostring(0),
      mods = "LEADER",
      action = act.ActivateTab(9),
    })
  end
  return config
end

return M
