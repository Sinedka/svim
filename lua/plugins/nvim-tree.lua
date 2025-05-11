return {
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
     dependencies = {
    {
      'b0o/nvim-tree-preview.lua',
      dependencies = {
        'nvim-lua/plenary.nvim',
        -- '3rd/image.nvim', -- Optional, for previewing images
      },
    },
    'nvim-tree/nvim-web-devicons',
  },
  
    config = function(_, opts)
      require("nvim-tree").setup(opts)
    end,
    opts = { -- BEGIN_DEFAULT_OPTS
      on_attach = function(bufnr)
    local api = require('nvim-tree.api')

    api.config.mappings.default_on_attach(bufnr)

    local function opts(desc)
      return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    local preview = require('nvim-tree-preview')

    -- Default config:
require('nvim-tree-preview').setup {
  -- Keymaps for the preview window (does not apply to the tree window).
  -- Keymaps can be a string (vimscript command), a function, or a table.
  --
  -- If a function is provided:
  --   When the keymap is invoked, the function is called.
  --   It will be passed a single argument, which is a table of the following form:
  --     {
  --       node: NvimTreeNode|NvimTreeRootNode, -- The tree node under the cursor
  --     }
  --   See the type definitions in `lua/nvim-tree-preview/types.lua` for a description
  --   of the fields in the table.
  --
  -- If a table, it must contain either an 'action' or 'open' key:
  --   Actions:
  --     { action = 'close', unwatch? = false, focus_tree? = true }
  --     { action = 'toggle_focus' }
  --     { action = 'select_node', target: 'next'|'prev' }
  --
  --   Open modes:
  --     { open = 'edit' }
  --     { open = 'tab' }
  --     { open = 'vertical' }
  --     { open = 'horizontal' }
  --
  -- To disable a default keymap, set it to false.
  -- All keymaps are set in normal mode. Other modes are not currently supported.
  keymaps = {
    ['<Esc>'] = { action = 'close', unwatch = true },
    ['<Tab>'] = { action = 'toggle_focus' },
    ['<CR>'] = { open = 'edit' },
    ['<C-t>'] = { open = 'tab' },
    ['<C-v>'] = { open = 'vertical' },
    ['<C-x>'] = { open = 'horizontal' },
    ['<C-n>'] = { action = 'select_node', target = 'next' },
    ['<C-p>'] = { action = 'select_node', target = 'prev' },
  },
  min_width = 100,
  min_height = 5,
  max_width = 100,
  max_height = 120,
  wrap = true, -- Whether to wrap lines in the preview window
  border = 'rounded', -- Border style for the preview window
  zindex = 100, -- Stacking order. Increase if the preview window is shown below other windows.
  show_title = true, -- Whether to show the file name as the title of the preview window
  title_pos = 'top-left', -- top-left|top-center|top-right|bottom-left|bottom-center|bottom-right
  title_format = ' %s ',
  follow_links = true, -- Whether to follow symlinks when previewing files
  image_preview = {
    enable = true, -- Whether to preview images (for more info see Previewing Images section in README)
    patterns = { -- List of Lua patterns matching image file names
      '.*%.png$',
      '.*%.jpg$',
      '.*%.jpeg$',
      '.*%.gif$',
      '.*%.webp$',
      '.*%.avif$',
      -- Additional patterns:
      -- '.*%.svg$',
      -- '.*%.bmp$',
      -- '.*%.pdf$', (known to have issues)
    },
  },
  on_open = nil, -- fun(win: number, buf: number) called when the preview window is opened
  on_close = nil, -- fun() called when the preview window is closed
}

    -- Автоматическое превью при движении курсора
    vim.api.nvim_create_autocmd("CursorMoved", {
      buffer = bufnr,
      callback = function()
        local node = api.tree.get_node_under_cursor()
        if node and node.type ~= 'directory' then
          preview.node(node)
        end
      end,
    })

    -- vim.keymap.set('n', 'P', preview.watch, opts 'Preview (Watch)')
    vim.keymap.set('n', '<Esc>', api.tree.close, opts('Close'))
    vim.keymap.set('n', '<C-f>', function() return preview.scroll(4) end, opts 'Scroll Down')
    vim.keymap.set('n', '<C-b>', function() return preview.scroll(-4) end, opts 'Scroll Up')

    -- Option A: Smart tab behavior: Only preview files, expand/collapse directories (recommended)
    vim.keymap.set('n', '<Tab>', function()
      local ok, node = pcall(api.tree.get_node_under_cursor)
      if ok and node then
        if node.type == 'directory' then
          api.node.open.edit()
        else
          preview.node(node, { toggle_focus = true })
        end
      end
    end, opts 'Preview')

    -- Option B: Simple tab behavior: Always preview
    -- vim.keymap.set('n', '<Tab>', preview.node_under_cursor, opts 'Preview')
  end,
      hijack_cursor = true,
      auto_reload_on_write = true,
      disable_netrw = true,
      hijack_netrw = true,
      hijack_unnamed_buffer_when_opening = false,
      root_dirs = {},
      prefer_startup_root = false,
      sync_root_with_cwd = true,
      reload_on_bufenter = false,
      respect_buf_cwd = false,
      select_prompts = false,
      sort = {
        sorter = "name",
        folders_first = true,
        files_first = false,
      },
      view = {
        centralize_selection = false,
        cursorline = true,
        debounce_delay = 15,
        side = "left",
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes",
        width = 30,
        float = {
          enable = true,
          quit_on_focus_loss = true,
          open_win_config = {
            relative = "editor",
            border = "rounded",
            width = 90,
            height = vim.o.lines - 6,
            row = 2,
            col = 8,
          },
        },
      },
      renderer = {
        add_trailing = false,
        group_empty = false,
        full_name = false,
        root_folder_label = ":~:s?$??",
        indent_width = 2,
        special_files = { "Cargo.toml", "Makefile", "README.md", "readme.md" },
        hidden_display = "none",
        symlink_destination = true,
        decorators = { "Git", "Open", "Hidden", "Modified", "Bookmark", "Diagnostics", "Copied", "Cut" },
        highlight_git = true,
        highlight_diagnostics = true,
        highlight_opened_files = "none",
        highlight_modified = "none",
        highlight_hidden = "none",
        highlight_bookmarks = "none",
        highlight_clipboard = "name",
        indent_markers = {
          enable = true,
          inline_arrows = false,
          icons = {
            corner = "└",
            edge = "│",
            item = "│",
            bottom = "─",
            none = " ",
          },
        },
        icons = {
          web_devicons = {
            file = {
              enable = true,
              color = true,
            },
            folder = {
              enable = false,
              color = true,
            },
          },
          git_placement = "before",
          modified_placement = "after",
          hidden_placement = "after",
          diagnostics_placement = "signcolumn",
          bookmarks_placement = "signcolumn",
          padding = {
            icon = " ",
            folder_arrow = "",
          },
          symlink_arrow = " ➛ ",
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = true,
            modified = true,
            hidden = false,
            diagnostics = true,
            bookmarks = true,
          },
          glyphs = {
            default = "",
            symlink = "",
            bookmark = "󰆤",
            modified = "●",
            hidden = "󰜌",
            folder = {
              arrow_closed = "",
              arrow_open = "",
              default = "",
              open = "",
              empty = "",
              empty_open = "",
              symlink = "",
              symlink_open = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
      },
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
      update_focused_file = {
        enable = false,
        update_root = {
          enable = false,
          ignore_list = {},
        },
        exclude = false,
      },
      system_open = {
        cmd = "",
        args = {},
      },
      git = {
        enable = true,
        show_on_dirs = true,
        show_on_open_dirs = true,
        disable_for_dirs = {},
        timeout = 400,
        cygwin_support = false,
      },
      diagnostics = {
        enable = true,
        show_on_dirs = false,
        show_on_open_dirs = true,
        debounce_delay = 500,
        severity = {
          min = vim.diagnostic.severity.HINT,
          max = vim.diagnostic.severity.ERROR,
        },
        icons = {
          hint = "",
          info = "",
          warning = "",
          error = "",
        },
      },
      modified = {
        enable = false,
        show_on_dirs = true,
        show_on_open_dirs = true,
      },
      filters = {
        enable = true,
        git_ignored = false,
        dotfiles = false,
        git_clean = false,
        no_buffer = false,
        no_bookmark = false,
        custom = {},
        exclude = {},
      },
      live_filter = {
        prefix = "[FILTER]: ",
        always_show_folders = true,
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
        ignore_dirs = {
          "/.ccls-cache",
          "/build",
          "/node_modules",
          "/target",
        },
      },
      actions = {
        use_system_clipboard = true,
        change_dir = {
          enable = true,
          global = false,
          restrict_above_cwd = false,
        },
        expand_all = {
          max_folder_discovery = 300,
          exclude = {},
        },
        file_popup = {
          open_win_config = {
            col = 1,
            row = 1,
            relative = "cursor",
            border = "shadow",
            style = "minimal",
          },
        },
        open_file = {
          quit_on_open = false,
          eject = true,
          resize_window = true,
          relative_path = true,
          window_picker = {
            enable = true,
            picker = "default",
            chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
            exclude = {
              filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
              buftype = { "nofile", "terminal", "help" },
            },
          },
        },
        remove_file = {
          close_window = true,
        },
      },
      trash = {
        cmd = "gio trash",
      },
      tab = {
        sync = {
          open = false,
          close = false,
          ignore = {},
        },
      },
      notify = {
        threshold = vim.log.levels.INFO,
        absolute_path = true,
      },
      help = {
        sort_by = "key",
      },
      ui = {
        confirm = {
          remove = true,
          trash = true,
          default_yes = false,
        },
      },
      experimental = {},
      log = {
        enable = false,
        truncate = false,
        types = {
          all = false,
          config = false,
          copy_paste = false,
          dev = false,
          diagnostics = false,
          git = false,
          profile = false,
          watcher = false,
        },
      },
    },
  },
}