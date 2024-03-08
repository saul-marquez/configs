-- Keymaps for better default experience
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous diagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next diagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Open floating diagnostic message' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostics list' })

--Move lines
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--Toggle Autoformat
vim.keymap.set("n", "<leader>ta", vim.cmd.KickstartFormatToggle, { desc = 'Toggle autoformatting' })

--Rest Client
vim.keymap.set("n", "<leader><CR>", "<Plug>RestNvim", { desc = 'Execute http request' })

--Nvim-Tree
function IsTreeFocused()
  return string.find(vim.fn.expand("%"), "NvimTree")
end

vim.keymap.set("n", "<C-t>",
  function()
    if not IsTreeFocused()
    then
      require('nvim-tree.api').tree.toggle({ focus = false })
    end
  end)

vim.keymap.set("n", "<C-h>",
  function()
    if IsTreeFocused()
    then
      vim.cmd(":bnext")
    else
      require('nvim-tree.api').tree.open({ find_file = true })
    end
  end)
