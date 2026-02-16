local nvim_set_hl = vim.api.nvim_set_hl

local colors = {
  -- local background = "#181818"
  background = "NONE",
  foreground = "#E4E4E4",
  black = "#181818",
  red = "#F43841",
  green = "#73D936",
  yellow = "#FFDD33",
  blue = "#96A6C8",
  magenta = "#9E95C7",
  cyan = "#95A99F",
  white = "#E4E4E4",
  brown = "#cc8c3c",
  brightblack = "#52494E",
  brightred = "#FF4F58",
  brightgreen = "#73D936",
  brightyellow = "#FFDD33",
  brightblue = "#96A6C8",
  brightmagenta = "#AFAFD7",
  brightcyan = "#95A99F",
  brightwhite = "#F5F5F5",
}

local highlights = {
  Normal = { bg = colors.background, fg = colors.foreground },

  StatusLine = { bg = colors.brightblack, fg = colors.foreground },
  StatusLineModeNormal = { bg = colors.green, fg = colors.black, bold = true },
  StatusLineModeInsert = { bg = "#00a1ff", fg = colors.black, bold = true },
  StatusLineModeVisual = { bg = "#FFB86C", fg = colors.black, bold = true },
  StatusLineModeReplace = { bg = colors.white, fg = colors.black, bold = true },
  StatusLineGit = { bg = colors.yellow, fg = colors.black },
  StatusLineDiff = { bg = colors.brightcyan, fg = colors.black },
  StatusLineInfo = { bg = colors.brightblack, fg = colors.colour_4 },
  SpecialComment = { fg = colors.green },

  Comment = { fg = colors.brown },
  String = { fg = colors.green },
  Character = { fg = colors.green },
  Number = { fg = colors.white },
  Boolean = { fg = colors.white },
  Float = { fg = colors.white },
  Constant = { fg = colors.cyan },
  Function = { fg = colors.blue },
  PreProc = { fg = colors.blue },
  Keyword = { fg = colors.yellow },
  Identifier = { fg = colors.brightwhite },
  Type = { fg = colors.cyan },
  Typedef = { fg = colors.yellow },
  Todo = { fg = colors.magenta },
  netrwBak = { fg = colors.cyan },
  LspInlayHint = { fg = colors.brightblack },

  Directory = { fg = colors.blue },
  netrwDir = { fg = colors.blue },
  netrwExe = { fg = colors.green },
  netrwLink = { fg = colors.yellow },
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

vim.g.colors_name = "gruber-darker-wip"
vim.o.termguicolors = true
vim.o.background = "dark"

for group, opts in pairs(highlights) do
  nvim_set_hl(0, group, opts)
end
