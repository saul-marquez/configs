vim.defer_fn(function()
  require('nvim-treesitter.configs').setup {
    ensure_installed = {
      'bicep',
      'c',
      'c_sharp',
      'http',
      'javascript',
      'lua',
      'markdown',
      'python',
      'rust',
      'tsx',
      'typescript',
      'vimdoc',
      'vim',
      'xml',
      'bash',
      'vue',
    },
    auto_install = false,
    sync_install = false,
    ignore_install = {},
    modules = {},
    highlight = { enable = true },
    indent = { enable = true },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<c-up>',
        node_incremental = '<c-up>',
        scope_incremental = '<c-s>',
        node_decremental = '<c-down>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
        keymaps = {
          ['aa'] = '@parameter.outer',
          ['ia'] = '@parameter.inner',
          ['af'] = '@function.outer',
          ['if'] = '@function.inner',
          ['ac'] = '@class.outer',
          ['ic'] = '@class.inner',
          ['al'] = '@loop.outer',
          ['il'] = '@loop.inner',
          ['ab'] = '@block.outer',
          ['ib'] = '@block.inner',
        },
      },
      move = {
        enable = true,
        set_jumps = true, -- whether to set jumps in the jumplist
        goto_next_start = {
          [']a'] = '@parameter.outer',
          [']b'] = '@block.outer',
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']A'] = '@parameter.outer',
          [']B'] = '@block.outer',
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[a'] = '@parameter.outer',
          ['[b'] = '@block.outer',
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[A'] = '@parameter.outer',
          ['[B'] = '@block.outer',
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
      swap = {
        enable = true,
        swap_next = {
          ['<leader>pa'] = '@parameter.inner',
          ['<leader>pf'] = '@function.inner',
        },
        swap_previous = {
          ['<leader>pA'] = '@parameter.inner',
          ['<leader>pF'] = '@function.inner',
        },
      },
    },
  }
  require 'treesitter-context'.setup {
    enable = true,
    max_lines = 4,
    min_window_height = 20,
    line_numbers = true,
    multiline_threshold = 20,
    trim_scope = 'outer',
    mode = 'cursor',
    separator = '—',
    zindex = 20,
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
  }
  vim.keymap.set("n", "[k", function()
    require("treesitter-context").go_to_context(vim.v.count1)
  end, { silent = true, desc = "Go to context" })
end, 0)
