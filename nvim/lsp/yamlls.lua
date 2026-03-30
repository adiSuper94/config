---@type vim.lsp.Config
return {
  cmd = { "yaml-language-server", "--stdio" },
  filetypes = { "yaml" },
  settings = {
    yaml = {
      redhat = { telemetry = { enabled = false } },
      schemastore = { enable = true },
      format = { enable = true },
    },
  },
}
