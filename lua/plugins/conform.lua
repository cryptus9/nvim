return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true })
      end,
      desc = "Format buffer",
    },
  },
  config = function()
    require("conform").setup({
      formatters_by_ft = {
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        html = { "prettierd", "prettier", stop_after_first = true },
        css = { "prettierd", "prettier", stop_after_first = true },
        scss = { "prettierd", "prettier", stop_after_first = true },
        json = { "prettierd", "prettier", stop_after_first = true },
        jsonc = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
        yaml = { "prettierd", "prettier", stop_after_first = true },
        vue = { "prettierd", "prettier", stop_after_first = true },
        angular = { "prettierd", "prettier", stop_after_first = true },
      },
      -- Fall back to LSP formatting for filetypes not listed above
      default_format_opts = {
        lsp_format = "fallback",
      },
      -- Format on save for filetypes that have a formatter configured above
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        local formatters = require("conform").formatters_by_ft[ft]
        if formatters then
          return { timeout_ms = 2000 }
        end
        -- Return nil to skip format-on-save for other filetypes
        return nil
      end,
    })
  end,
}
