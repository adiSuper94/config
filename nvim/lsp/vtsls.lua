--- npm install -g @vtsls/language-server

---@type vim.lsp.Config
return {
  cmd = { "vtsls", "--stdio" },
  init_options = {
    hostInfo = "neovim",
  },
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  root_dir = function(bufnr, on_dir)
    local deno_root = vim.fs.root(bufnr, { "deno.json", "deno.jsonc" })
    local project_root = vim.fs.root(bufnr, { "package.json", { ".git" } })
    if deno_root and not project_root then
      return
    end
    on_dir(project_root or vim.fn.getcwd())
  end,
  settings = {
    vtsls = {
      autoUseWorkspaceTsdk = true,
      enableMoveToFileCodeAction = true,
    },
    typescript = {
      updateImportsOnFileMove = "prompt",
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
        enumMemberValues = { enabled = true },
      },
    },
    javascript = {
      updateImportsOnFileMove = "prompt",
      inlayHints = {
        parameterNames = { enabled = "literals" },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enabled = true },
      },
    },
  },
}
