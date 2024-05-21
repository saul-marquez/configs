local function onattach(bufnr)
    local api = require "nvim-tree.api"

    local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    -- default mappings
    api.config.mappings.default_on_attach(bufnr)

    vim.cmd(":NvimTreeFindFile")
end
require('nvim-tree').setup({
    sync_root_with_cwd = true,
    view = {
        width = 40,
    },
    renderer = {
        group_empty = true,
        full_name = true
    }
})
