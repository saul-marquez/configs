vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- vim.o.shell = 'pwsh.exe'
-- vim.o.shellcmdflag = '-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command '
-- vim.o.shellquote = ''
-- vim.o.shellxquote = ''
-- vim.o.shellpipe = '| %s'
-- vim.o.shellredir = '> %s'

vim.g.editorconfig = true
-- Absolute number for current, relative for others
vim.wo.number = true
vim.wo.relativenumber = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.o.clipboard = 'unnamedplus'

vim.o.hlsearch = true
vim.o.incsearch = true

-- Enable break indent
vim.o.breakindent = true

--Scroll padding
vim.o.scrolloff = 15

-- Save undo history
vim.o.swapfile = false
vim.o.backup = false
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 100
vim.o.timeoutlen = 150

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.o.textwidth = 140
vim.o.colorcolumn = "140"

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

vim.filetype.add({ extensions = { props = "xml" } })
