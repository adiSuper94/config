vim.pack.add({
  "https://github.com/stevearc/conform.nvim",
})

local function get_formatter()
  local js_formatter = { "oxfmt", "deno_fmt", "prettierd", "prettier" }
  local formatters_by_ft = {
    javascript = js_formatter,
    typescript = js_formatter,
    javascriptreact = js_formatter,
    typescriptreact = js_formatter,
    json = { "prettierd", "prettier" },
    css = { "prettierd", "prettier" },
    lua = { "stylua" },
    python = { "ruff_format" },
  }
  local formatter_config = {
    oxfmt = { ".oxfmtrc.json" },
    deno_fmt = { "deno.json", "deno.jsonc" },
    prettierd = { "prettier.config.js", ".prettierrc", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml", "package.json" },
    prettier = { "prettier.config.js", ".prettierrc", ".prettierrc.json", ".prettierrc.yaml", ".prettierrc.yml", "package.json" },
    stylua = { "stylua.toml" },
    ruff_format = { "pyproject.toml" },
  }
  local ft = vim.bo.filetype
  local formatters = formatters_by_ft[ft] or {}
  for _, formatter in ipairs(formatters) do
    local config_files = formatter_config[formatter] or {}
    for _, config_file in ipairs(config_files) do
      local path = vim.api.nvim_buf_get_name(0);
      local stop = vim.fn.getcwd() .. "../"
      if vim.fs.find(config_file, { path, stop, upward = true })[1] then
        return formatter
      end
    end
  end
  return nil
end

local formatter_cache = {}
local cache_size = 0;
function Format()
  local filepath = vim.api.nvim_buf_get_name(0);
  local formatter = nil;
  if formatter_cache[filepath] then
    formatter = formatter_cache[filepath]
  else
    formatter = get_formatter()
    if formatter and cache_size >= 20 then
      formatter_cache = {}
      cache_size = 0
    elseif formatter then
      cache_size = cache_size + 1
    end
  end
  if formatter then
    require("conform").format({ async = true, formatters = { formatter } })
    formatter_cache[filepath] = formatter
  else
    require("conform").format({ async = true })
  end
end

require("conform").setup({
  formatters_by_ft = {
    javascript = { "prettierd", "prettier", stop_after_first = true },
    typescript = { "prettierd", "prettier", stop_after_first = true },
    javascriptreact = { "prettierd", "prettier", stop_after_first = true },
    typescriptreact = { "prettierd", "prettier", stop_after_first = true },
    json = { "prettierd", "prettier", stop_after_first = true },
    css = { "prettierd", "prettier", stop_after_first = true },
    lua = { "stylua" },
    python = { "ruff_format" },
  },

  default_format_opts = { lsp_format = "fallback" },
})

vim.keymap.set("n", "<leader>f", Format, { desc = "Format file" })
