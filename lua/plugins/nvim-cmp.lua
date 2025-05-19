return {
  "hrsh7th/nvim-cmp",
  -- event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer", -- source for text in buffer
    "hrsh7th/cmp-path", -- source for file system paths
    {
      "L3MON4D3/LuaSnip",
      -- follow latest release.
      version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
      -- install jsregexp (optional!).
      build = "make install_jsregexp",
    },
    "saadparwaiz1/cmp_luasnip", -- autocompletion
    "rafamadriz/friendly-snippets", -- snippets
    "nvim-treesitter/nvim-treesitter",
    "onsails/lspkind.nvim", -- vs-code pictograms
    -- "roobert/tailwindcss-colorizer-cmp.nvim",
  },
  config = function()
    -- Setup nvim-cmp
    local cmp = require "cmp"
    local luasnip = require "luasnip"

    -- Load VSCode-style snippets from friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- Optional: Better visuals with lspkind
    -- local lspkind = require "lspkind"

    -- -- Optional: Tailwind CSS color highlighting
    -- require("tailwindcss-colorizer-cmp").setup {
    --   color_square_width = 2,
    -- }

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      -- formatting = {
      --   format = require("tailwindcss-colorizer-cmp").formatter {
      --     format = lspkind.cmp_format {
      --       mode = "symbol_text",
      --       maxwidth = 50,
      --       ellipsis_char = "...",
      --     },
      --   },
      -- },

      -- mapping = cmp.mapping.preset.insert {
      --   ["<Tab>"] = cmp.mapping.confirm { select = true }, -- Accept currently selected item
      -- },

      sources = cmp.config.sources {
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      },
    }
  end,
}
