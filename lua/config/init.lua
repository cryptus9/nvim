vim.g.mapleader = " "
vim.g.maplocalleader = "\\"


require("config.options")
require("config.lazy")
require("config.remap")

vim.api.nvim_create_autocmd('FileType', {
  pattern = { '<filetype>' },
  callback = function() vim.treesitter.start() end,
})
