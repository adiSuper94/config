local M = {}
M.tmux_bindings = function(act, config)
  local tmux_bindngs = {
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
  }

  if config.keys == nil then
    config.keys = {}
  end
  for _, value in pairs(tmux_bindngs) do
    table.insert(config.keys, value)
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
