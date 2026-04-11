local function get_formatprg()
  local js_formatter = { "oxfmt", "deno_fmt", "prettier" }
  local formatters_by_ft = {
    javascript = js_formatter,
    typescript = js_formatter,
    javascriptreact = js_formatter,
    typescriptreact = js_formatter,
    json = { "oxfmt", "prettier" },
    jsonc = { "oxfmt", "prettier" },
    css = { "oxfmt", "prettier" },
    lua = { "stylua" },
    python = { "ruff_format" },
  }
  local formatter_config = {
    oxfmt = { ".oxfmtrc.json" },
    deno_fmt = { "deno.json", "deno.jsonc" },
    prettier = {
      "prettier.config.js",
      ".prettierrc",
      ".prettierrc.json",
      ".prettierrc.yaml",
      ".prettierrc.yml",
    },
    stylua = { "stylua.toml", ".luarc.json" },
    ruff_format = { "pyproject.toml" },
  }
  local formatprgs = {
    oxfmt = "oxfmt --stdin-filepath=%",
    deno_fmt = "deno fmt -",
    prettier = "prettier",
    stylua = "stylua -",
    ruff_format = "ruff format -",
  }
  local ft = vim.bo.filetype
  local formatters = formatters_by_ft[ft] or {}
  for _, formatter in ipairs(formatters) do
    local config_files = formatter_config[formatter] or {}
    for _, config_file in ipairs(config_files) do
      local path = vim.fs.dirname(vim.api.nvim_buf_get_name(0))
      local stop = vim.fn.getcwd() .. "/.."
      if vim.fs.find(config_file, { path = path, stop = stop, upward = true, limit = 1 })[1] then
        return formatprgs[formatter]
      end
    end
  end
  return nil
end

function Fmt()
  local formatprg = vim.bo.formatprg ~= "" and vim.bo.formatprg or nil
  if formatprg and formatprg ~= "" then
    local v = vim.fn.winsaveview()
    vim.cmd.normal({ "gggqG", bang = true, mods = { silent = true } })
    vim.fn.winrestview(v);
  else
    vim.lsp.buf.format({ async = true })
  end
end

local formatprg_ag = vim.api.nvim_create_augroup("set_formatprg", { clear = true })
vim.api.nvim_create_autocmd("BufNew", {
  pattern = "*",
  group = formatprg_ag,
  callback = function()
    local formatprg = get_formatprg()
    if formatprg then
      vim.bo.formatprg = formatprg
    end
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function()
    Fmt()
  end,
})

vim.keymap.set("n", "<leader>f", Fmt, { desc = "Format file" })
