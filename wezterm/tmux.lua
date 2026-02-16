local M = {}
M.tmux_bindings = function(act, config)
  if config.keys == nil then
    config.keys = {}
  end
  local tmux_bindngs = {}
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
