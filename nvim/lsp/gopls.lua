---@type vim.lsp.Config
return {
  cmd = { "gopls" },
  root_markers = { "go.mod" },
  filetypes = { "go", "gomod", "gosum" },
  settings = {
    gopls = {
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      staticcheck = true,
      usePlaceholders = true,
    },
  },
}
