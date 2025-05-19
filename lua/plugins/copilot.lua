return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  event = "InsertEnter",
  config = function()
    require("copilot").setup {
      require("copilot").setup {
        suggestion = {
          enabled = true,
          auto_trigger = true, -- автоматически предлагать варианты
          keymap = {
            accept_line = "<C-y>", -- принять строку
            next = "<M-]>", -- следующее предложение
            prev = "<M-[>", -- предыдущее предложение
            dismiss = "<C-b>", -- отклонить
          },
        },
        panel = {
          enabled = false,
          keymap = {
            open = "<leader>i", -- открыть панель Copilot
            next = "<M-n>",
            prev = "<M-p>",
            accept = "<CR>",
            refresh = "gr",
            close = "<Esc>",
          },
        },
      },
    }
  end,
}
