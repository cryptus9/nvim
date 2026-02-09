return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    -- Use the official setup function
    -- This handles the "logic" so it doesn't crash on leader gd
    -- List of parsers to install

    local configs = require('nvim-treesitter')

    configs.setup({
      ensure_installed = {
        'javascript',
        'typescript',
        'tsx',
        'json',
        'jsdoc',
        'html',
        'css',
        'regex',
        'lua',
        'query',
        'vim',
        'vimdoc',
        'php',
      },

      -- Install missing parsers automatically
      auto_install = true,

      -- This replaces your manual autocmd logic
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },

      -- Better automatic indentation
      indent = {
        enable = true,
      },
    })
  end,
}
