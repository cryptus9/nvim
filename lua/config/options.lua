-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.smarttab = true
vim.opt.list = true
vim.opt.listchars = "eol:.,tab:>-,trail:~,extends:>,precedes:<"

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:1"
vim.opt.scrolloff = 8
vim.opt.showcmd = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.config/nvim/undodir"
vim.opt.undofile = true
vim.opt.clipboard = "unnamed"

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.termguicolors = true

vim.opt.showmode = false

-- No automatic comment insertion
vim.cmd([[autocmd FileType * set formatoptions-=ro]])

-- Custom diagnostic signs in the gutter
local signs = {
  { name = "DiagnosticSignError", text = "✘" },
  { name = "DiagnosticSignWarn", text = "▲" },
  { name = "DiagnosticSignInfo", text = "●" },
  { name = "DiagnosticSignHint", text = "" },
}

for _, sign in ipairs(signs) do
  vim.fn.sign_define(sign.name, { text = sign.text, texthl = sign.name, numhl = "" })
end

vim.diagnostic.config({
  virtual_text = false,                    -- no end-of-line text
  virtual_lines = { current_line = true }, -- diagnostics on their own lines (current line only)
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})
