return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {},
  config = function(_, opts)
    require("which-key").setup(opts)

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("Cydralic_LspAttach", {}),
      callback = function(e)
        local o = { buffer = e.buf }
        vim.keymap.set("n", "gd",         function() vim.lsp.buf.definition() end, o)
        vim.keymap.set("n", "K",          function() vim.lsp.buf.hover() end, o)
        vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, o)
        vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, o)
        vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, o)
        vim.keymap.set("n", "grr",        function() require("telescope.builtin").lsp_references() end, o)
        vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, o)
        vim.keymap.set("i", "<C-h>",      function() vim.lsp.buf.signature_help() end, o)
        vim.keymap.set("n", "[d",         function() vim.diagnostic.goto_next() end, o)
        vim.keymap.set("n", "]d",         function() vim.diagnostic.goto_prev() end, o)
      end,
    })
  end,
  keys = {
    {
      "<leader>?",
      function() require("which-key").show({ global = false }) end,
      desc = "Buffer Local Keymaps (which-key)",
    },

    -- buffer navigation
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

    -- file explorer
    { "<leader>pv", vim.cmd.Ex, desc = "File Explorer" },

    -- move selected lines in visual mode
    { "J", ":m '>+1<CR>gv=gv", desc = "Move line down", mode = "v" },
    { "K", ":m '<-2<CR>gv=gv", desc = "Move line up",   mode = "v" },

    -- paste / yank / delete
    { "<leader>p", [["_dP]],  desc = "Paste without yanking",       mode = "x" },
    { "<leader>y", [["+y]],   desc = "Yank to clipboard",           mode = { "n", "v" } },
    { "<leader>Y", [["+Y]],   desc = "Yank line to clipboard",      mode = "n" },
    { "<leader>d", [["_d]],   desc = "Delete without yanking",      mode = { "n", "v" } },

    -- disable ex mode
    { "Q", "<nop>", desc = "Disabled (ex mode)", mode = "n" },

    -- quickfix list
    { "<C-k>", "<cmd>cnext<CR>zz", desc = "Next quickfix item",     mode = "n" },
    { "<C-j>", "<cmd>cprev<CR>zz", desc = "Prev quickfix item",     mode = "n" },

    -- location list
    { "<leader>k", "<cmd>lnext<CR>zz", desc = "Next location item", mode = "n" },
    { "<leader>j", "<cmd>lprev<CR>zz", desc = "Prev location item", mode = "n" },

    -- replace word under cursor across file
    { "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], desc = "Replace word under cursor", mode = "n" },

    -- make current file executable
    { "<leader>x", "<cmd>!chmod +x %<CR>", desc = "Make file executable", mode = "n", silent = true },

    -- source current file
    { "<leader><leader>", function() vim.cmd("so") end, desc = "Source current file", mode = "n" },

    -- telescope
    { "<leader>fb", function() require("telescope.builtin").buffers() end,    desc = "[F]ind [B]uffers" },
    { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "[F]ind [F]iles" },
    { "<leader>fg", function() require("telescope.builtin").git_files() end,   desc = "[F]ind [G]it files" },
    { "<leader>fr", function() require("telescope.builtin").oldfiles() end,    desc = "[F]ind [R]ecent files" },
    { "<leader>fs", function() require("telescope.builtin").live_grep() end,   desc = "[F]ind [S]tring in files" },
    { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "[F]ind [D]iagnostics" },
    { "<leader>fh", "<cmd>Telescope find_files hidden=true<CR>",               desc = "[F]ind [H]idden files" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(
          require("telescope.themes").get_dropdown({ previewer = false })
        )
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
  },
}
