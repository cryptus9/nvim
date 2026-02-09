return {
  'nvim-telescope/telescope.nvim',
  tag = 'v0.2.0',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-ui-select.nvim',
  },

  config = function()
    require('telescope').setup({
      defaults = {
        file_ignore_patterns = { 'undodir/.*' },
      },

      extensions = {
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    pcall(require('telescope').load_extension, 'ui-select')

  end,
}
