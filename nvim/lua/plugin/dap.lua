vim.pack.add({
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/igorlfs/nvim-dap-view",
})

local dap = require("dap")
local dap_view = require("dap-view").setup({
  winbar = {
    default_section = "scopes",
    show_keymap_hints = false,
  },
  auto_toggle = true,
})

dap.adapters.gdb = {
  type = "executable",
  name = "gdb",
  command = "gdb",
  args = { "--interpreter=dap" },
}
local last_args = ""

dap.configurations.cpp = {
  {
    name = "Launch",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
    end,
    cwd = function()
      return vim.fn.input("Path to cwd: ", vim.fn.getcwd() .. "/", "file")
    end,
    args = function()
      last_args = vim.fn.input("Args: ", last_args)
      return vim.split(last_args, " ", { trimempty = true })
    end,
  },
}
dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

dap.adapters.delve = {
  type = "server",
  port = "${port}",
  executable = {
    command = "dlv",
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}

-- https://github.com/go-delve/delve/blob/master/Documentation/usage/dlv_dap.md
dap.configurations.go = {
  {
    type = "delve",
    name = "Debug",
    request = "launch",
    program = "${file}",
  },
  {
    type = "delve",
    name = "Debug test", -- configuration for debugging test files
    request = "launch",
    mode = "test",
    program = "${file}",
  },
  -- works with go.mod packages and sub packages
  {
    type = "delve",
    name = "Debug test (go.mod)",
    request = "launch",
    mode = "test",
    program = "./${relativeFileDirname}",
  },
}
dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = "${port}",
  executable = {
    command = "node",
    args = {
      os.getenv("HOME") .. "/nutter-tools/js-debug/src/dapDebugServer.js",
      "${port}",
    },
  },
}
dap.configurations.javascript = {
  {
    type = "pwa-node",
    request = "launch",
    name = "Launch Program",
    program = "${file}",
    cwd = vim.fn.getcwd(),
    skipFiles = { "<node_internals>/**" },
  },
  {
    type = "pwa-node",
    request = "attach",
    name = "Attach to process",
    processId = require("dap.utils").pick_process,
    cwd = vim.fn.getcwd(),
    skipFiles = { "<node_internals>/**" },
  },
}
dap.configurations.typescript = dap.configurations.javascript

-- Debug shortcuts

vim.keymap.set("n", "<leader>br", dap.restart, { desc = "DAP: Restart" })
vim.keymap.set("n", "<leader>bc", dap.continue, { desc = "DAP: Continue" })
vim.keymap.set("n", "<leader>bp", dap.pause, { desc = "DAP: Pause" })
vim.keymap.set("n", "<leader>bb", dap.toggle_breakpoint, { desc = "DAP: Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", dap.step_over, { desc = "DAP: Step Over" })
vim.keymap.set("n", "<F11>", dap.step_into, { desc = "DAP: Step Into" })
vim.keymap.set("n", "<F23>", dap.step_out, { desc = "DAP: Step Out" })
vim.keymap.set({ "n", "v" }, "<C-k>", "<cmd>DapViewHover<cr>", { desc = "DAP: Hover" })
