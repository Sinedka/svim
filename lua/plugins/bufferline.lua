return {
  'akinsho/bufferline.nvim',
  event = 'VimEnter',
  dependencies = {
    'nvim-tree/nvim-web-devicons',
    'moll/vim-bbye',
  },
  opts = {
    options = {
      offsets = {
        {
          filetype = 'NvimTree',
          text = 'File Explorer',
          highlight = 'Directory',
          separator = true,
        },
      },
      diagnostics = 'nvim_lsp',
      close_command = 'Bdelete! %d',
      right_mouse_command = 'Bdelete! %d',
      left_mouse_command = 'buffer %d',
      middle_mouse_command = nil,
    },
  },
}