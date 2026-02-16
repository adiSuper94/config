local nvim_set_hl = vim.api.nvim_set_hl

local colors = {
  -- local background = "#181818"
  background = "NONE",
  foreground = "#E4E4E4",
  colour_1 = "#39FF14",
  colour_2 = "#00CC98",
  colour_3 = "#C7F9AC",
  colour_4 = "#9AA999",

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
  StatusLine = { bg = colors.brightblack, fg = colors.foreground },
  StatusLineModeNormal = { bg = colors.colour_1, fg = colors.black, bold = true },
  StatusLineModeInsert = { bg = "#00a1ff", fg = colors.black, bold = true },
  StatusLineModeVisual = { bg = "#FFB86C", fg = colors.black, bold = true },
  StatusLineModeReplace = { bg = colors.white, fg = colors.black, bold = true },
  StatusLineGit = { bg = colors.colour_2, fg = colors.black },
  StatusLineDiff = { bg = colors.colour_3, fg = colors.black },
  StatusLineInfo = { bg = colors.brightblack, fg = colors.colour_4 },
  SpecialComment = { fg = colors.colour_3 },

  Comment = { fg = colors.brown },
  String = { fg = colors.colour_3 },
  Character = { fg = colors.colour_3 },
  Number = { fg = colors.white },
  Boolean = { fg = colors.white },
  Float = { fg = colors.white },
  Constant = { fg = colors.colour_4 },
  Function = { fg = colors.colour_2 },
  PreProc = { fg = colors.colour_2 },
  Keyword = { fg = colors.colour_1 },
  Identifier = { fg = colors.brightwhite },
  Type = { fg = colors.colour_4 },
  Typedef = { fg = colors.colour_1 },
  Todo = { fg = colors.magenta },
  LspInlayHint = { fg = colors.brightblack },

  -- netrwBak = { fg = colors.colour_4 },
  -- Directory = { fg = colors.colour_2 },
  -- netrwDir = { fg = colors.colour_2 },
  -- netrwExe = { fg = colors.colour_3 },
  -- netrwLink = { fg = colors.colour_1 },
}

function hl_links(colors)
  local links = {
    NormalFloat = { link = "Normal" },
    NonText = { link = "Normal" },
    SignColumn = { link = "Normal" },
    Special = { link = "Normal" },
    SpecialChar = { link = "String" },

    Operator = { link = "Normal" },
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

vim.g.colors_name = "evergreen"
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

