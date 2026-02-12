return {
  'nvim-treesitter/nvim-treesitter',
  lazy = false,
  build = ':TSUpdate',
  config = function()
    local parsers = {
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
      'angular'
    }

    -- Install missing parsers (new API only has :TSInstall / .install())
    require('nvim-treesitter').install(parsers)

    -- Enable treesitter-based highlighting for all filetypes with a parser
    vim.api.nvim_create_autocmd('FileType', {
      callback = function(args)
        pcall(vim.treesitter.start, args.buf)
      end,
    })

    -- Enable treesitter-based indentation
    vim.api.nvim_create_autocmd('FileType', {
      callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end,
    })
  end,
}
