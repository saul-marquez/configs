-- Keymaps for better default experience
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

vim.keymap.set({ 'n', 'v', 'i' }, '<C-s>', ':wa<CR>', { desc = 'Save' })
-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Better :noh
vim.keymap.set('n', '<ESC>', vim.cmd.nohlsearch, { desc = 'Clear highlights' })
-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

--Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })

vim.keymap.set('n', 's', '<Plug>(leap)', { desc = 'Leap around' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap globally' })
vim.keymap.set({ 'x', 'o' }, 's', '<Plug>(leap-forward)', { desc = 'Leap forward' })
vim.keymap.set({ 'x', 'o' }, 'S', '<Plug>(leap-backward)', { desc = 'Leap backward' })


--Toggle Autoformat
vim.keymap.set("n", "<leader>ta", vim.cmd.KickstartFormatToggle, { desc = 'Toggle autoformatting' })
vim.keymap.set(
  { "n", "v" },
  "<leader>f",
  function()
    require('conform').format { async = true, lsp_fallback = true }
  end,
  { desc = '[F]ormat buffer' }
)


--Nvim-Tree
function IsTreeFocused()
  return string.find(vim.fn.expand("%"), "NvimTree")
end

vim.keymap.set("n", "<C-t>",
  function()
    if not IsTreeFocused()
    then
      require('nvim-tree.api').tree.toggle({ find_file = true })
    end
  end)
