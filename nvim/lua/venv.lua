local M = {}

---Find the virtual env dir: $VIRTUAL_ENV first, then the nearest .venv/venv upward from `path` (up to $HOME).
---@param path string? directory to search from (project root or buffer dir)
---@return string?
function M.dir(path)
  if vim.env.VIRTUAL_ENV then
    return vim.env.VIRTUAL_ENV
  end
  if not path then
    return nil
  end
  return vim.fs.find(
    { ".venv", "venv" },
    { path = path, upward = true, stop = vim.fs.dirname(vim.uv.os_homedir()), type = "directory", limit = 1 }
  )[1]
end

---Resolve `name` from the venv's bin dir, falling back to PATH.
---@param name string
---@param path string?
---@return string exe
---@return string? venv
function M.bin(name, path)
  local venv = M.dir(path)
  local bin = venv and vim.fs.joinpath(venv, "bin", name)
  if bin and vim.uv.fs_stat(bin) then
    return bin, venv
  end
  return name, venv
end

return M
