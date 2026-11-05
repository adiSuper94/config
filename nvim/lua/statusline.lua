local function section(text, hl)
  return "%#" .. (hl or "StatusLine") .. "#" .. text .. "%*"
end

local function get_git_diff(hl)
  local status = vim.b.gitsigns_status_dict
  if not status then
    return nil
  end
  local added = status.added and status.added > 0 and ("+" .. status.added) or ""
  local changed = status.changed and status.changed > 0 and ("~" .. status.changed) or ""
  local removed = status.removed and status.removed > 0 and ("-" .. status.removed) or ""
  if added == "" and changed == "" and removed == "" then
    return nil
  end
  return section(" " .. table.concat({ added, changed, removed }, " ") .. " ", hl)
end

local function get_git_branch(hl)
  local head = vim.b.gitsigns_head
  if not head or head == "" then
    return nil
  end
  return section(" \u{e0a0} " .. head .. " ", hl)
end

local function get_filename()
  return vim.fn.expand("%:~:.")
end

local function get_mode()
  local mode = vim.fn.mode()
  local mode_text = {
    n = "NOR",
    i = "INS",
    v = "VIS",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "CMD",
    t = "TERM",
    R = "REPLACE",
  }

  local mode_hl = "StatusLineModeNormal"
  if mode == "i" or mode == "t" then
    mode_hl = "StatusLineModeInsert"
  elseif mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    mode_hl = "StatusLineModeVisual"
  elseif mode == "R" or mode == "r" then
    mode_hl = "StatusLineModeReplace"
  end

  return section(" " .. (mode_text[mode] or mode) .. " ", mode_hl)
end

local function get_diagnostics()
  local diagnostics = vim.diagnostic.status()
  if diagnostics == "" then
    return nil
  end
  return section(diagnostics)
end

local function get_filetype()
  local ft = vim.opt.filetype:get()
  if ft == "" then
    return nil
  end
  local icon, icon_hl = require("mini.icons").get("filetype", ft)
  return section(icon .. " " .. ft, icon_hl)
end

local function get_encoding()
  local enc = vim.opt.fileencoding:get() ~= "" and vim.opt.fileencoding:get() or vim.opt.encoding:get()
  if enc == "utf-8" then
    return nil
  end
  return section(enc)
end

local function render(parts, layout, drop_order)
  local function join_parts(side, separator)
    local rendered = {}
    for _, name in ipairs(layout[side]) do
      table.insert(rendered, parts[name])
    end
    return table.concat(rendered, separator)
  end

  local function join_sides()
    return "%*" .. join_parts("left", "") .. " %=" .. join_parts("right", " | ") .. " "
  end

  local win_width = vim.api.nvim_win_get_width(0)
  local line = join_sides()
  for _, name in ipairs(drop_order) do
    if vim.api.nvim_eval_statusline(line, { maxwidth = 0 }).width <= win_width then
      return line
    end
    parts[name] = nil
    line = join_sides()
  end
  return line
end

function _G.Statusline()
  local file = " " .. get_filename()
  local position = "%l:%c"

  local function render_focused()
    local parts = {
      mode = get_mode(),
      branch = get_git_branch("StatusLineGit"),
      diff = get_git_diff("StatusLineDiff"),
      file = section(file),
      modified = vim.opt.modified:get() and section(" ●") or nil,
      readonly = vim.bo.readonly and section(" \u{f023}") or nil,
      diagnostics = get_diagnostics(),
      position = section(position),
      percent = section("%p%%"),
      filetype = get_filetype(),
      encoding = get_encoding(),
    }

    local layout = {
      left = { "mode", "branch", "diff", "readonly", "file", "modified" },
      right = { "diagnostics", "position", "percent", "filetype", "encoding" },
    }

    local drop_order = { "percent", "filetype", "branch", "diagnostics", "diff", "position", "mode", "file" }

    return render(parts, layout, drop_order)
  end

  local function render_unfocused()
    local parts = {
      branch = get_git_branch("StatusLineNC"),
      diff = get_git_diff("StatusLineNC"),
      file = section(file, "StatusLineNC"),
      position = section(position, "StatusLineNC"),
    }
    local layout = { left = { "branch", "diff", "file" }, right = { "position" } }
    local drop_order = { "branch", "diff", "position", "file" }

    return render(parts, layout, drop_order)
  end

  if vim.api.nvim_get_current_win() == tonumber(vim.g.actual_curwin) then
    return render_focused()
  end
  return render_unfocused()
end

vim.o.statusline = "%{%v:lua.Statusline()%}"
