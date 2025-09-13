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
    if client:supports_method("textDocument/declaration") then
      map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    end
    -- if client:supports_method("textDocument/completion") then
    --   vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = false })
    -- end
    map("<space>e", function()
      vim.diagnostic.config({
        virtual_lines = not vim.diagnostic.config().virtual_lines,
      })
    end, "Show diagnostics")
    map("<space>q", vim.diagnostic.setloclist, "Open Diagnostic [Q]uickfix list")
  end,
})

vim.lsp.enable({ "denols", "ts_ls", "rust_analyzer", "gopls", "lua_ls", "clangd", "bashls", "jsonls", "pyright" })
