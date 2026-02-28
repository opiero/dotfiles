require('telescope').setup {
  pickers = {
    find_files = {
      hidden = true,
    },
  },
  extensions = {
    ['ui-select'] = {
      require('telescope.themes').get_dropdown(),
    },
  },
}
