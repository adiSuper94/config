---@type vim.lsp.Config
return {
  cmd = function(dispatchers, config)
    local cmd = "oxlint"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/oxlint"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "--lsp" }, dispatchers)
  end,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "vue",
    "svelte",
    "astro",
  },
  root_markers = { ".oxlintrc.json", "oxlint.config.ts" },
  workspace_required = true,
  settings = {
    -- run = 'onType',
    -- configPath = nil,
    -- tsConfigPath = './tsconfig.json',
    -- unusedDisableDirectives = 'allow',
    typeAware = true,
    -- disableNestedConfig = false,
    fixKind = "safe_fix_or_suggestion",
  }
}
