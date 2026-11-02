---@type vim.lsp.Config
return {
  cmd = { "rust-analyzer" },
  root_markers = { "Cargo.toml" },
  filetypes = { "rust" },
  -- rust-analyzer sizes its thread pools at startup, so pass settings as init options too
  before_init = function(params, config)
    params.initializationOptions = config.settings["rust-analyzer"]
  end,
  settings = {
    ["rust-analyzer"] = {
      cachePriming = { numThreads = 8 },
      cargo = { extraArgs = { "--jobs", "8" } },
      procMacro = { enable = true },
      diagnostics = {
        enable = true,
        disabled = { "unresolved-proc-macro", "missing-unsafe" },
      },
    },
  },
}
