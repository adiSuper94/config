vim.pack.add({
  "https://github.com/hiphish/rainbow-delimiters.nvim",
  "https://github.com/stevearc/dressing.nvim",
  -- "https://github.com/github/copilot.vim",
  { src = "https://github.com/felpafel/inlay-hint.nvim", version = "nightly" },
})

-- vim.api.nvim_set_keymap("i", "<C-;>", 'copilot#Accept("<CR>")', { silent = true, expr = true })
-- vim.g.copilot_no_tab_map = true
-- vim.g.copilot_assume_mapped = true
-- vim.g.copilot_tab_fallback = ""

-- have to wait for https://github.com/neovim/neovim/issues/28261 to be resolved
require("inlay-hint").setup()

-- I hate this. But this is an AI fix. I don't understand this, but it works.
do
  local inlay_hint_capability = require("vim.lsp._capability").all.inlay_hint
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("InlayHintCapabilityFix", { clear = true }),
    callback = function()
      require("vim.lsp._capability").all.inlay_hint = inlay_hint_capability
    end,
  })
end
