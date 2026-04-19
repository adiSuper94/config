-- LSP setup
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(ev)
    local client = vim.lsp.get_client_by_id(ev.data.client_id)
    if not client then
      return
    end
    client.server_capabilities.semanticTokensProvider = nil
    vim.lsp.inlay_hint.enable(true)
    local map = function(keys, func, desc, mode)
      mode = mode or "n"
      vim.keymap.set(mode, keys, func, { buffer = ev.buf, desc = "LSP: " .. desc })
    end
    if client:supports_method("textDocument/foldingRange") then
      local win = vim.api.nvim_get_current_win()
      vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
    end
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
    end

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
    end
    if client:supports_method("textDocument/documentColor") then
      vim.lsp.document_color.enable(true, { bufnr = ev.buf }, { style = "virtual" })
    end
    map("grd", function()
      vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      })
    end, "Toggle diagnostics")
    map("<space>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix list")
  end,
})

vim.lsp.enable({
  "vtsls",
  "denols",
  "oxlint",
  "tailwindcss",
  "cssls",
  "ty",
  "rust_analyzer",
  "gopls",
  "clangd",
  "lua_ls",
  "bashls",
  "jsonls",
  "taplo",
  "yamlls",
})
