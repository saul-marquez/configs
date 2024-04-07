local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      -- Only load if `make` is available
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        build = 'make',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
    },
  },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'nvim-treesitter/nvim-treesitter-context',
    },
    build = ':TSUpdate',
  },
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      { 'williamboman/mason.nvim', config = true },
      'williamboman/mason-lspconfig.nvim',
      { 'j-hui/fidget.nvim',       opts = {} },
      { 'folke/neodev.nvim',       opts = {} },
    },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    dependencies = {
      'saadparwaiz1/cmp_luasnip',
      {
        'L3MON4D3/LuaSnip',
        build = 'make install_jsregexp',
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
    },
  },
  {
    'navarasu/onedark.nvim',
    priority = 1000,
    lazy = false,
    config = function()
      require('onedark').setup {
        -- Set a style preset. 'dark' is default.
        style = 'darker', -- dark, darker, cool, deep, warm, warmer, light
      }
      require('onedark').load()
    end,
  },
  {
    'rest-nvim/rest.nvim',
    ft = "http",
    dependencies = { "luarocks.nvim" },
    opts = {}
  },
  { 'folke/which-key.nvim',                opts = {} },
  { 'lukas-reineke/indent-blankline.nvim', main = 'ibl', opts = {} },
  { 'numToStr/Comment.nvim',               opts = {} },
  { 'stevearc/dressing.nvim',              opts = {} },
  { 'mrjones2014/smart-splits.nvim' },
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  'tpope/vim-sleuth',
  'tpope/vim-surround',
  'ggandor/leap.nvim',
  'lewis6991/gitsigns.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-tree/nvim-tree.lua',
  'nvim-tree/nvim-web-devicons',
  'theprimeagen/harpoon',
  'github/copilot.vim',
  'mbbill/undotree',
  {
    "vhyrro/luarocks.nvim",
    priority = 1000,
    opts = { rocks = { 'luasnip' } }
  },
  {
    "lukas-reineke/virt-column.nvim",
    opts = {
      virtcolumn = '100,140'
    }
  },
  require 'plugins.debug',
  require 'plugins.autoformat',
}, {})
