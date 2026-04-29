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

  -- 3. Mason-LSPConfig (auto-install LSP servers via Mason)
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    config = function()
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = { "emmylua_ls" },
        },
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
          "jsonls",
          "eslint",
        },
      })
    end,
  },

  -- 4. nvim-lspconfig (server configuration via Neovim 0.11+ API)
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.diagnostic.config({
        virtual_text = true,
        float = {
          border = "rounded",
          source = true,
          focusable = true,
        },
      })

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            workspace = { checkThirdParty = false },
          },
        },
      })

      vim.lsp.config("yamlls", {
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

      vim.lsp.config("dockerls", { capabilities = capabilities })
      vim.lsp.config("bashls", { capabilities = capabilities })
      vim.lsp.config("intelephense", { capabilities = capabilities })
      vim.lsp.config("html", { capabilities = capabilities })
      vim.lsp.config("vtsls", { capabilities = capabilities })
      vim.lsp.config("angularls", { capabilities = capabilities })
      vim.lsp.config("cssls", { capabilities = capabilities })
      vim.lsp.config("jsonls", { capabilities = capabilities })
      vim.lsp.config("eslint", { capabilities = capabilities })

      vim.lsp.enable({
        "lua_ls",
        "dockerls",
        "yamlls",
        "bashls",
        "intelephense",
        "html",
        "vtsls",
        "angularls",
        "cssls",
        "jsonls",
        "eslint",
      })
    end,
  },
}
