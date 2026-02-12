return {
  -- 1. Mason (Installer)
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
          },
        },
      })
    end,
  },

  -- 2. Mason-Tool-Installer (auto-install formatters, linters, etc.)
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-tool-installer").setup({
        ensure_installed = {
          "prettierd",
        },
      })
    end,
  },

  -- 3. Mason-LSPConfig (Bridge) + LSP setup
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = require('blink.cmp').get_lsp_capabilities()

      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "dockerls",
          "yamlls",
          "bashls",
          "intelephense",
          "html",
          "vtsls",
          "angularls",
          "cssls",
          "json-lsp",
        },
        automatic_installation = true,
        handlers = {
          -- Default handler for all servers
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities,
            })
          end,

          -- Specific overrides for complex servers
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = capabilities,
              settings = { Lua = { diagnostics = { globals = { "vim" } } } }
            })
          end,

          ["yamlls"] = function()
            lspconfig.yamlls.setup({
              capabilities = capabilities,
              settings = {
                yaml = {
                  schemas = {
                    ["https://json.schemastore.org/ansible-stable-2.9.json"] = "*/playbook.yml",
                    ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*",
                  },
                },
              },
            })
          end,
        },
      })
    end,
  }
}
