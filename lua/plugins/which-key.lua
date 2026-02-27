return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    -- your configuration comes here
    -- or leave it empty to use the default settings
    -- refer to the configuration section below
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
    { "<C-n>",   "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer",     mode = "n" },
    { "<C-p>",   "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer", mode = "n" },
    { "<Tab>",   "<cmd>BufferLineCycleNext<CR>", desc = "Next Buffer",     mode = "n" },
    { "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", desc = "Previous Buffer", mode = "n" },
    {
      "<C-x>",
      function()
        local bufnr = vim.api.nvim_get_current_buf()
        local listed = vim.fn.getbufinfo({ buflisted = 1 })
        if #listed > 1 then
          vim.cmd("bnext | bdelete " .. bufnr)
        else
          vim.cmd("enew | bdelete " .. bufnr)
        end
      end,
      desc = "Close current buffer",
    },
  },
}
