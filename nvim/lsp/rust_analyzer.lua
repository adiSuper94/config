---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml" },
  filetypes = { "rust", "toml.Cargo" },
  setting = {
    ["rust-analyzer"] = {
      procMacro = { enable = true },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro", "missing-unsafe" },
      },
    },
  },
}
