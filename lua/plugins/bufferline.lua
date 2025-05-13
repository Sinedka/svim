return {
  "akinsho/bufferline.nvim",
  event = "VimEnter",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "moll/vim-bbye",
  },
  config = function()
    require("bufferline").setup {
      options = {
        offsets = {
          {
            filetype = "NvimTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
          },
        },
        diagnostics = "nvim_lsp",
        close_command = "Bdelete! %d",
        right_mouse_command = "Bdelete! %d",
        left_mouse_command = "buffer %d",
        middle_mouse_command = nil,
      },
    }

    -- vim.cmd [[
    --     highlight BufferLineFill guibg=NONE
    --     highlight BufferLineBackground guibg=NONE
    --     highlight BufferLineTab guibg=NONE
    --     highlight BufferLineTabSelected guibg=NONE
    --     highlight BufferLineTabClose guibg=NONE
    --     highlight BufferLineSeparator guibg=NONE
    --     highlight BufferLineSeparatorSelected guibg=NONE
    --     highlight BufferLineSeparatorVisible guibg=NONE
    --   ]]
  end,
}
