local nvim_set_hl = vim.api.nvim_set_hl

local colors = {
  -- local background = "#181818"
  background = "NONE",
  foreground = "#E4E4E4",
  color_1 = "#39FF14",
  color_2 = "#00CC98",
  color_3 = "#C7F9AC",
  color_4 = "#9AA999",
  color_5 = "#A3C585",

  magenta = "#9E95C7",
  white = "#E4E4E4",
  black = "#181818",
  brown = "#cc8c3c",
  red = "#FC6767",
  green = "#C7F9AC",
  yellow = "#FFF150",
  brightblack = "#52494E",
  brightwhite = "#F5F5F5",
}

local highlights = {
  Normal = { bg = colors.background, fg = colors.foreground },
  StatusLineModeInsert = { bg = "#00a1ff", fg = colors.black, bold = true },
  StatusLineModeVisual = { bg = "#FFB86C", fg = colors.black, bold = true },
  StatusLine = { bg = colors.brightblack, fg = colors.foreground },
  StatusLineModeNormal = { bg = colors.color_1, fg = colors.black, bold = true },
  StatusLineModeReplace = { bg = colors.white, fg = colors.black, bold = true },
  StatusLineGit = { bg = colors.color_2, fg = colors.black },
  StatusLineDiff = { bg = colors.color_3, fg = colors.black },
  StatusLineInfo = { bg = colors.brightblack, fg = colors.color_4 },
  SpecialComment = { fg = colors.color_3 },

  Comment = { fg = colors.brown },
  String = { fg = colors.color_3 },
  Character = { fg = colors.color_3 },
  Number = { fg = colors.white },
  Boolean = { fg = colors.white },
  Float = { fg = colors.white },
  Constant = { fg = colors.color_4 },
  Function = { fg = colors.color_2 },
  PreProc = { fg = colors.color_2 },
  Keyword = { fg = colors.color_1 },
  Identifier = { fg = colors.color_5 },
  Type = { fg = colors.color_4 },
  Typedef = { fg = colors.color_1 },
  Todo = { fg = colors.magenta },
  LspInlayHint = { fg = colors.brightblack },
}

function hl_links(colors)
  local links = {
    NormalFloat = { link = "Normal" },
    NonText = { link = "Normal" },
    SignColumn = { link = "Normal" },
    SpecialChar = { link = "String" },

    -- Operator = { link = "Normal" },
    DiffText = { link = "Normal" },
    DiffDelete = { fg = colors.red },
    DiffAdd = { fg = colors.green },
    DiffChange = { fg = colors.yellow },

    DiagnosticError = { fg = colors.red },
    DiagnosticWarn = { fg = colors.yellow },
    DiagnosticInfo = { fg = colors.green },

    Include = { link = "PreProc" },
    Define = { link = "PreProc" },
    Macro = { link = "PreProc" },
    Precondit = { link = "PreProc" },
  }
  return links
end

highlights = vim.tbl_extend("error", hl_links(colors), highlights)

vim.g.colors_name = "sundarban"
vim.o.termguicolors = true
vim.o.background = "dark"

for group, opts in pairs(highlights) do
  nvim_set_hl(0, group, opts)
end
vim.api.nvim_set_hl(0, "MiniIconsRed", { fg = "#FF5555" })
vim.api.nvim_set_hl(0, "MiniIconsGreen", { fg = "#50fa7b" })
vim.api.nvim_set_hl(0, "MiniIconsYellow", { fg = "#FFF150" })
vim.api.nvim_set_hl(0, "MiniIconsBlue", { fg = "#00a1ff" })
vim.api.nvim_set_hl(0, "MiniIconsPurple", { fg = "#BD93F9" })
vim.api.nvim_set_hl(0, "MiniIconsCyan", { fg = "#8BE9FD" })
vim.api.nvim_set_hl(0, "MiniIconsOrange", { fg = "#FFB86C" })
vim.api.nvim_set_hl(0, "MiniIconsGrey", { fg = "#6272A4" })
vim.api.nvim_set_hl(0, "MiniIconsAzure", { fg = "#5d88C6" })

