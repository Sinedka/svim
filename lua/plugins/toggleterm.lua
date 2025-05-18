return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    config = function()
      require("toggleterm").setup {
        size = 15,
        open_mapping = "<C-t>",
        hide_numbers = true,
        shade_filetypes = {},
        shade_terminals = true,
        shading_factor = 2,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        direction = "horizontal", -- можно 'vertical' | 'float' | 'tab'
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
      }
    end,
  },
}
