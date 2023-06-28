-- dofile("/home/adisuper/.config/nvim/lua/lsp/rust.lua")
-- dofile("/home/adisuper/.config/nvim/lua/lsp/dap.lua")
local nvim_lsp = require'lspconfig'
require("mason").setup()
-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  -- snippet = {
  --   expand = function(args)
  --       vim.fn["vsnip#anonymous"](args.body)
  --   end,
  -- },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    -- { name = 'vsnip' },
    { name = 'path' },
--    { name = 'buffer' },
  },
})

sig_cfg = { bind = true}  -- add you config here
require "lsp_signature".setup(sig_cfg)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
local servers = {'jsonls', 'clangd', 'pyright', 'tsserver', 'rust_analyzer'}
for _, lsp in pairs(servers) do
  nvim_lsp[lsp].setup {
    capabilites = capabilities,
  }
end

-- require("lsp-inlayhints").setup()
-- vim.api.nvim_create_augroup("LspAttach_inlayhints", {})
-- vim.api.nvim_create_autocmd("LspAttach", {
--   group = "LspAttach_inlayhints",
--   callback = function(args)
--     if not (args.data and args.data.client_id) then
--       return
--     end
--     local bufnr = args.buf
--     local client = vim.lsp.get_client_by_id(args.data.client_id)
--     require("lsp-inlayhints").on_attach(client, bufnr)
--   end,
-- })
