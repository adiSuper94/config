--- npm install -g @tailwindcss/language-server
---@type vim.lsp.Config
return {
  cmd = { "tailwindcss-language-server", "--stdio" },
  filetypes = {
    -- html
    "html",
    "markdown",
    -- css
    "css",
    "less",
    "postcss",
    "sass",
    "scss",
    -- js
    "javascript",
    "javascriptreact",
    "rescript",
    "typescript",
    "typescriptreact",
    "svelte",
    "vue",
  },
  capabilities = {
    workspace = {
      didChangeWatchedFiles = {
        dynamicRegistration = true,
      },
    },
  },
  settings = {
    tailwindCSS = {
      validate = true,
      lint = {
        cssConflict = "warning",
        invalidApply = "error",
        invalidScreen = "error",
        invalidVariant = "error",
        invalidConfigPath = "error",
        invalidTailwindDirective = "error",
        recommendedVariantOrder = "warning",
      },
      classAttributes = {
        "class",
        "className",
        "class:list",
        "classList",
        "ngClass",
      },
    },
  },
  workspace_required = true,
  root_dir = function(bufnr, on_dir)
    local root_files = {
      ".git",
    }
    local fname = vim.api.nvim_buf_get_name(bufnr)
    on_dir(vim.fs.dirname(vim.fs.find(root_files, { path = fname, upward = true })[1]))
  end,
}
