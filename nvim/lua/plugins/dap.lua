return {
  "rcarriga/nvim-dap-ui",
  keys = { "<leader>bb", "<leader>bc" },
  dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
  config = function()
    local dap, dapui = require("dap"), require("dapui")
    dap.adapters.lldb = {
      type = "executable",
      command = "/usr/bin/lldb-vscode-17", -- adjust as needed, must be absolute path
      name = "lldb",
    }
    dap.configurations.cpp = {
      {
        name = "Launch",
        type = "lldb",
        request = "launch",
        program = function()
          return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
        args = {},

        -- 💀
        -- if you change `runInTerminal` to true, you might need to change the yama/ptrace_scope setting:
        --
        --    echo 0 | sudo tee /proc/sys/kernel/yama/ptrace_scope
        --
        -- Otherwise you might get the following error:
        --
        --    Error on launch: Failed to attach to the target process
        --
        -- But you should be aware of the implications:
        -- https://www.kernel.org/doc/html/latest/admin-guide/LSM/Yama.html
        runInTerminal = true,
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

    dapui.setup()
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- Debug shortcuts

    vim.keymap.set("n", "<leader>br", function()
      dap.restart()
    end, { desc = "DAP: Restart" })
    vim.keymap.set("n", "<leader>bc", function()
      dap.continue()
    end, { desc = "DAP: Continue" })
    vim.keymap.set("n", "<leader>bp", function()
      dap.pause()
    end, { desc = "DAP: Pause" })
    vim.keymap.set("n", "<leader>bb", function()
      dap.toggle_breakpoint()
    end, { desc = "DAP: Toggle Breakpoint" })
    vim.keymap.set("n", "<A-j>", function()
      dap.step_over()
    end, { desc = "DAP: Step Over" })
    vim.keymap.set("n", "∆", function()
      dap.step_over()
    end, { desc = "DAP: Step Over(Mac)" }) -- option + j
    vim.keymap.set("n", "<A-l>", function()
      dap.step_into()
    end, { desc = "DAP: Step Into" })
    vim.keymap.set("n", "¬", function()
      dap.step_into()
    end, { desc = "DAP: Step Into(Mac)" }) -- option + l
    vim.keymap.set("n", "<A-h>", function()
      dap.step_out()
    end, { desc = "DAP: Step Out" })
    vim.keymap.set("n", "˙", function()
      dap.step_out()
    end, { desc = "DAP: Step Out(Mac)" }) -- option + h
  end,
}
