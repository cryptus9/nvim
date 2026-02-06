return {
  -- Mason UI for managing LSPs
  {
    "mason-org/mason.nvim",
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
  -- Bridge: Mason <-> LSPConfig
  {
    "mason-org/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",       -- Lua
          "dockerls",     -- Docker
          "yamlls",       -- YAML
          "bashls",       -- Bash

          "intelephense", --PHP
          "html",         -- HTML
          -- "ts_ls", -- TypeScript & JavaScript
          "vtsls",        -- TypeScript & JavaScript (alternative)
          "angularls",    -- Angular
          "cssls",        -- CSS (for LESS support)

          -- sourcekit (Swift) is macOS native, not installable via Mason
          -- Make sure to have Xcode installed or CLI Tools: xcode-select --install
        },
        automatic_enable = true,
        automatic_installation = true,
      })
    end,
  },

  -- Built-in LSP Support for setting up LSP servers
  {
    "neovim/nvim-lspconfig",
    config = function()
      vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, border_opts)
      vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, border_opts)

      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Lua Language Server
      vim.lsp.config("lua_ls", {
        filetypes = { "lua" },
        capabilities = capabilities,
      })

      -- Docker
			vim.lsp.config("dockerls", {
				filetypes = { "dockerfile" },
				capabilities = capabilities,
			})

			-- YAML
			vim.lsp.config("yamlls", {
				filetypes = { "yaml", "yml", "j2" },
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

      -- Bash / Shell
			vim.lsp.config("bashls", {
				filetypes = { "sh", "bash", "zsh" },
				capabilities = capabilities,
			})

			-- TypeScript / JavaScript
			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				filetypes = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
			})

			-- ESLint Language Server
			vim.lsp.config("eslint", {
				capabilities = capabilities,
			})

			-- Angular
			vim.lsp.config("angularls", {})

			-- HTML
			vim.lsp.config("html", {})

			-- CSS / LESS
			vim.lsp.config("cssls", {
				filetypes = { "css", "scss", "less" },
			})
    end,
  }
}
