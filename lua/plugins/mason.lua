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

  -- 2. Mason-LSPConfig (Bridge)
  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "lua_ls",
          "dockerls",
          "yamlls",
          "bashls",
          "intelephense",
          "html",
          "vtsls",
          "angularls", "cssls",
        },
        automatic_installation = true,
      })
    end,
  },

  -- 3. LSPConfig (The Connection & Keymaps)
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")
      local capabilities = vim.lsp.protocol.make_client_capabilities()

      -- Create the Primeagen Group
      local JannesGroup = vim.api.nvim_create_augroup("JannesGroup", {})

      -- Attach the Keymaps whenever an LSP connects
      vim.api.nvim_create_autocmd('LspAttach', {
        group = JannesGroup,
        callback = function(e)
          local opts = { buffer = e.buf }
          -- THE REMAPS
          vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
          vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
          vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
          vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
          vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
          vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
          vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
          vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
          vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
          vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
        end
      })

      -- Automatically setup all servers installed via Mason
      require("mason-lspconfig").setup_handlers({
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
      })
    end,
  }
}
