return {
  cmd = { "deno", "lsp" },
  root_dir = function(_, callback)
    local root_dir = vim.fs.root(0, { "deno.json", "deno.jsonc" })
    if root_dir then
      callback(root_dir)
    end
  end,
  filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact" },
  single_file_support = false,
  settings = {
    deno = {
      inlayHints = {
        parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = true },
        parameterTypes = { enabled = true },
        variableTypes = { enabled = true, suppressWhenTypeMatchesName = true },
        propertyDeclarationTypes = { enabled = true },
        functionLikeReturnTypes = { enable = true },
        enumMemberValues = { enabled = true },
      },
    },
  },
}
