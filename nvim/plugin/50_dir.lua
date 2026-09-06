local ns = vim.api.nvim_create_namespace("dir_icons")

local function decorate_dir_listing(buf, start_row, end_row)
  vim.api.nvim_buf_clear_namespace(buf, ns, start_row, end_row)
  local dir = vim.api.nvim_buf_get_name(buf)
  local MiniIcons = require("mini.icons")
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, start_row, end_row, false)) do
    if line ~= "" then
      local row = start_row + i - 1
      local is_dir = line:sub(-1) == "/"
      local name = is_dir and line:sub(1, -2) or line
      local path = dir .. "/" .. name

      local icon, hl = MiniIcons.get(is_dir and "directory" or "file", path)
      vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
        virt_text = { { icon .. " ", hl } },
        virt_text_pos = "inline",
      })
      local target = vim.uv.fs_readlink(path)
      if target then
        vim.api.nvim_buf_set_extmark(buf, ns, row, 0, {
          virt_text = { { " -> " .. target, "Comment" } },
          virt_text_pos = "eol",
        })
      end
    end
  end
end

vim.api.nvim_create_autocmd("User", {
  pattern = "DirReadPost",
  callback = function(a)
    decorate_dir_listing(a.buf, 0, -1)
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "directory",
  callback = function(a)
    vim.wo.signcolumn = "no"
    vim.keymap.set("n", "dd", function()
      local name = vim.api.nvim_get_current_line()
      vim.api.nvim_feedkeys(":!rm -rf " .. name .. " ", "n", true)
    end, { buffer = a.buf, silent = true })

    vim.keymap.set("n", "%", function()
      vim.api.nvim_feedkeys(":!touch ", "n", true)
    end, { buffer = a.buf, silent = true })
  end,
})
