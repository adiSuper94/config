function _G.LightlineGitDiff()
  if vim.b.gitsigns_status_dict then
    local status = vim.b.gitsigns_status_dict
    local added = status.added and status.added > 0 and ("+" .. status.added) or ""
    local changed = status.changed and status.changed > 0 and ("~" .. status.changed) or ""
    local removed = status.removed and status.removed > 0 and ("-" .. status.removed) or ""
    if added == "" and changed == "" and removed == "" then
      return ""
    end
    return table.concat({ added, changed, removed }, " ")
  else
    return ""
  end
end

function _G.LightlineGitBranch()
  if vim.b.gitsigns_head and vim.b.gitsigns_head ~= "" then
    return " " .. vim.b.gitsigns_head
  else
    return ""
  end
end

function _G.LightlineFilename()
  local git_root = vim.b.rootDir
  local path = vim.fn.expand("%:p")
  if git_root and path:sub(1, #git_root) == git_root then
    return path:sub(#git_root + 2)
  end
  return vim.fn.expand("%")
end

function _G.LightlineStatusline()
  local mode = vim.fn.mode()
  local mode_text = {
    n = "NORMAL",
    i = "INSERT",
    v = "VISUAL",
    V = "V-LINE",
    ["\22"] = "V-BLOCK",
    c = "COMMAND",
    t = "TERMINAL",
    R = "REPLACE",
  }
  local mode_display = mode_text[mode] or mode

  local mode_hl = "StatusLineModeNormal"
  if mode == "i" or mode == "t" then
    mode_hl = "StatusLineModeInsert"
  elseif mode == "v" or mode == "V" or mode == "\22" or mode == "s" or mode == "S" or mode == "\19" then
    mode_hl = "StatusLineModeVisual"
  elseif mode == "R" or mode == "r" then
    mode_hl = "StatusLineModeReplace"
  end

  local gitbranch = LightlineGitBranch()
  local gitdiff = LightlineGitDiff()
  local filename = LightlineFilename()
  local modified = vim.opt.modified:get() and " ●" or ""

  local left = {}
  table.insert(left, "%#" .. mode_hl .. "# " .. mode_display .. " %*")
  if gitbranch ~= "" then
    table.insert(left, "%#StatusLineGit# " .. gitbranch .. " %*")
  end
  if gitdiff ~= "" then
    table.insert(left, "%#StatusLineDiff# " .. gitdiff .. " %*")
  end
  table.insert(left, " " .. filename .. modified)

  local right = {}
  table.insert(right, "%l:%c%*")
  table.insert(right, "| %p%%%*")
  local ft = vim.opt.filetype:get()
  if ft ~= "" then
    local icon, icon_hl = require("mini.icons").get("filetype", ft)
    if icon then
      table.insert(right, "| %#" .. icon_hl .. "#" .. icon .. " " .. ft .. "%*")
    else
      table.insert(right, "| " .. ft .. "%*")
    end
  end
  local enc = vim.opt.fileencoding:get() ~= "" and vim.opt.fileencoding:get() or vim.opt.encoding:get()
  if enc ~= "" then table.insert(right, "| " .. enc .. " %*") end

  return table.concat(left, "") .. "%=" .. table.concat(right, " ")
end

vim.o.statusline = "%{%v:lua.LightlineStatusline()%}"
