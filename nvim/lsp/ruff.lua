local ruff = require("venv").bin("ruff", vim.fn.getcwd())

---@type vim.lsp.Config
return {
  cmd = { ruff, "server" },
  filetypes = { "python" },
  root_markers = { "ruff.toml", ".ruff.toml", "pyproject.toml", ".git" },
}
