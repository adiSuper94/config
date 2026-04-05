--- `tsgo` can be installed via npm `npm install @typescript/native-preview`.

---@type vim.lsp.Config
return {
  settings = {
    typescript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      inlayHints = {
        parameterNames = {
          enabled = "literals",
          suppressWhenArgumentMatchesName = true,
        },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
  cmd = function(dispatchers, config)
    local cmd = "tsgo"
    local local_cmd = (config or {}).root_dir and config.root_dir .. "/node_modules/.bin/tsgo"
    if local_cmd and vim.fn.executable(local_cmd) == 1 then
      cmd = local_cmd
    end
    return vim.lsp.rpc.start({ cmd, "--lsp", "--stdio" }, dispatchers)
  end,
  filetypes = {
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
  },
  root_dir = function(bufnr, on_dir)
    local root_markers = { "package-lock.json", "yarn.lock", "pnpm-lock.yaml", "bun.lockb", "bun.lock", { ".git" } }
    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local project_root = vim.fs.root(bufnr, root_markers)
    if deno_root and (not project_root or #deno_root >= #project_root) then
      return
    end
    on_dir(project_root or vim.fn.getcwd())
  end,
}
