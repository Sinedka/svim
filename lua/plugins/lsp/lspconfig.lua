return {
  -- Main LSP Configuration
  "neovim/nvim-lspconfig",
  dependencies = {
    -- Automatically install LSPs and related tools to stdpath for Neovim
    -- Mason must be loaded before its dependents so we need to set it up here.
    { "williamboman/mason.nvim", opts = {} },
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(mode, keys, func, desc)
          vim.keymap.set(mode, keys, func, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
        end

        -- This function resolves a differenc-- keymaps
        -- map("n", "gR", "<cmd>Telescope lsp_references<CR>", "Show LSP references") -- show definition, references

        map("n", "gD", vim.lsp.buf.declaration, "Go to declaration") -- go to declaration

        -- map("n", "gd", "<cmd>Telescope lsp_definitions<CR>", "Show LSP definitions") -- show lsp definitions

        -- map("n", "gi", "<cmd>Telescope lsp_implementations<CR>", "Show LSP implementations") -- show lsp implementations

        -- map("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", "Show LSP type definitions") -- show lsp type definitions

        map({ "n", "v" }, "<leader>vca", function()
          vim.lsp.buf.code_action()
        end, "See available code actions") -- see available code actions, in visual mode will apply to selection

        map("n", "<leader>rn", vim.lsp.buf.rename, "Smart rename") -- smart rename

        -- map("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", "Show buffer diagnostics") -- show  diagnostics for file

        map("n", "<leader>d", vim.diagnostic.open_float, "Show line diagnostics") -- show diagnostics for line

        map("n", "K", vim.lsp.buf.hover, "Show documentation for what is under cursor") -- show documentation for what is under cursor

        map("n", "<leader>rs", ":LspRestart<CR>", "Restart LSP") -- mapping to restart lsp if necessary

        vim.keymap.set("i", "<C-h>", function()
          vim.lsp.buf.signature_help()
        end)

        ---@param client vim.lsp.Client
        ---@param method vim.lsp.protocol.Method
        ---@param bufnr? integer some lsp support methods only in specific files
        ---@return boolean
        local function client_supports_method(client, method, bufnr)
          return client:supports_method(method, bufnr)
        end

        -- The following two autocommands are used to highlight references of the
        -- word under your cursor when your cursor rests there for a little while.
        --    See `:help CursorHold` for information about when this is executed
        --
        -- When you move your cursor, the highlights will be cleared (the second autocommand).
        local client = vim.lsp.get_client_by_id(event.data.client_id)

        if
          client and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
        then
          local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })

          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })

          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })

          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds { group = "kickstart-lsp-highlight", buffer = event2.buf }
            end,
          })
        end
      end,
    })

    -- Diagnostic Config
    -- See :help vim.diagnostic.Opts
    vim.diagnostic.config {
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = " ",
          [vim.diagnostic.severity.WARN] = " ",
          [vim.diagnostic.severity.HINT] = "󰠠 ",
          [vim.diagnostic.severity.INFO] = " ",
        },
      },
      virtual_text = true, -- Specify Enable virtual text for diagnostics
      underline = true, -- Specify Underline diagnostics
      update_in_insert = false, -- Keep diagnostics active in insert mode
    }

    local capabilities = require "cmp_nvim_lsp"

    local servers = {
      asm_lsp = {},
      clangd = {},
      tailwindcss = {
        root_dir = function(...)
          return require("lspconfig.util").root_pattern ".git"(...)
        end,
      },
      html = {},
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
          },
        },
      },
      lua_ls = {
        -- cmd = { ... },
        -- filetypes = { ... },
        -- capabilities = {},
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
            diagnostics = { disable = { "missing-fields" } },
          },
        },
      },
    }

    -- Ensure the servers and tools above are installed
    --
    -- To check the current status of installed tools and/or manually install
    -- other tools, you can run
    --    :Mason
    --
    -- You can press `g?` for help in this menu.
    --
    -- `mason` had to be setup earlier: to configure its options see the
    -- `dependencies` table for `nvim-lspconfig` above.
    --
    -- You can add other tools here that you want Mason to install
    -- for you, so that they are available from within Neovim.
    local ensure_installed = vim.tbl_keys(servers or {})
    vim.list_extend(ensure_installed, {
      "stylua", -- Used to format Lua code
      "selene",
      "shellcheck",
      "shfmt",
      "tailwindcss-language-server",
      "typescript-language-server",
      "css-lsp",
    })
    require("mason-tool-installer").setup { ensure_installed = ensure_installed }

    local lspconfig = require "lspconfig"

    lspconfig.ts_ls.setup {
      filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" }, -- важно!
      -- settings = {
      --   typescript = {
      --     inlayHints = {
      --       includeInlayParameterNameHints = "all",
      --       includeInlayVariableTypeHints = true,
      --       includeInlayFunctionLikeReturnTypeHints = true,
      --     },
      --   },
      -- },
    }

    require("mason-lspconfig").setup {
      ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
      automatic_installation = false,
      handlers = {
        function(server_name)
          local server = servers[server_name] or {}
          -- This handles overriding only values explicitly passed
          -- by the server configuration above. Useful when disabling
          -- certain features of an LSP (for example, turning off formatting for ts_ls)
          server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
          require("lspconfig")[server_name].setup(server)
        end,
      },
    }
  end,
}
