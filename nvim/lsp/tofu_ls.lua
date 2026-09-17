---@type vim.lsp.Config
return {
  cmd = { "tofu-ls", "serve" },
  filetypes = { "terraform", "terraform-vars" },
  root_markers = { ".terraform", ".git" },
}
