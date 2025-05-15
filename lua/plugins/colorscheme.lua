return {
  -- NOTE :
  -- ╭────────────╮
  -- │ tokyonight │
  -- ╰────────────╯
  {
    "sinedka/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("tokyonight").setup {
        style = "moon", -- The theme comes in three styles, `storm`, a darker variant `night` and `day`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = true, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
        styles = {
          -- Style to be applied to different syntax groups
          -- Value is any valid attr-list value for `:help nvim_set_hl`
          comments = { italic = true },
          keywords = { italic = true },
          functions = {},
          variables = {},
          -- Background styles. Can be "dark", "transparent" or "normal"
          sidebars = "transparent", -- style for sidebars, see below
          floats = "transparent", -- style for floating windows
        },
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        dim_inactive = false, -- dims inactive windows
        lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

        --- You can override specific color groups to use other groups or a hex color
        --- function will be called with a ColorScheme table
        on_colors = function(colors)
          -- colors.hint = colors.orange
          colors.comment = "#6c78d0"
        end,

        --- You can override specific highlights to use other groups or a hex color
        --- function will be called with a Highlights and ColorScheme table
        -- on_highlights = function(highlights, colors) end,

        cache = true, -- When set to true, the theme will be cached for better performance

        ---@type table<string, boolean|{enabled:boolean}>
        plugins = {
          all = package.loaded.lazy == nil,
          auto = true,
        },
      }
      vim.cmd [[colorscheme tokyonight]]
      -- local c = require("tokyonight.colors").setup()

      local highlights = {
        -- Ecovim Colors
        EcovimPrimary = { fg = "#488dff" },
        EcovimSecondary = { fg = "#FFA630" },
        EcovimPrimaryBold = { bold = true, fg = "#488DFF" },
        EcovimSecondaryBold = { bold = true, fg = "#FFA630" },
        EcovimHeader = { bold = true, fg = "#488DFF" },
        EcovimHeaderInfo = { bold = true, fg = "#FFA630" },
        EcovimFooter = { bold = true, fg = "#FFA630" },
        EcovimNvimTreeTitle = { bold = true, fg = "#FFA630", bg = "#16161e" },
      }

      for group, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, hl)
      end
    end,
  },
}
