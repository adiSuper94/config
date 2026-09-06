local ns = vim.api.nvim_create_namespace("dir_icons")

local function place_icons(buf)
  vim.api.nvim_buf_clear_namespace(buf, ns, 0, -1)
  local dir = vim.api.nvim_buf_get_name(buf)
  local MiniIcons = require("mini.icons")
  for i, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
    if line ~= "" then
      local is_dir = line:sub(-1) == "/"
      local name = is_dir and line:sub(1, -2) or line
      local icon, hl = MiniIcons.get(is_dir and "directory" or "file", dir .. "/" .. name)
      vim.api.nvim_buf_set_extmark(buf, ns, i - 1, 0, {
        virt_text = { { icon .. " ", hl } },
        virt_text_pos = "inline",
      })
    end
  end
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "directory",
  callback = function(a)
    vim.wo.signcolumn = "no"
    place_icons(a.buf)
    vim.api.nvim_buf_attach(a.buf, false, {
      on_lines = function()
        vim.schedule(function()
          place_icons(a.buf)
        end)
      end,
    })

    vim.keymap.set("n", "dd", function()
      local name = vim.api.nvim_get_current_line()
      vim.api.nvim_feedkeys(":!rm -rf " .. name .. " ", "n", true)
    end, { buffer = a.buf, silent = true })

    vim.keymap.set("n", "%", function()
      vim.api.nvim_feedkeys(":!touch ", "n", true)
    end, { buffer = a.buf, silent = true })
  end,
})
