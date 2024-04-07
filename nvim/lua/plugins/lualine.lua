require('lualine').setup {
  opts = {
    options = {
      icons_enabled = true,
      theme = 'auto',
      component_separators = '|',
      section_separators = '',
      globalstatus = true,
    },
    sections = {
      lualine_a = { 'mode' },
      lualine_b = { { 'branch', icon = '' }, 'diff', 'diagnostics' },
      lualine_c = { { 'filename', path = 1 } },
      lualine_x = { 'encoding', 'fileformat', 'filetype' },
      lualine_y = { 'progress' },
      lualine_z = { 'location' },
    }
  },
}
