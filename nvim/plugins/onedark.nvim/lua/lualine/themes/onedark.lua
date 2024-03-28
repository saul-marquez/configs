local c = require('onedark.colors')
local cfg = vim.g.onedark_config
local colors = {
    bg = c.bg0,
    fg = c.fg,
    red = c.red,
    green = c.green,
    yellow = c.yellow,
    blue = c.blue,
    purple = c.purple,
    cyan = c.cyan,
    gray = c.grey
}

local one_dark = {
    inactive = {
        a = { fg = colors.gray, bg = colors.bg, gui = 'bold' },
        b = { fg = colors.gray, bg = colors.bg },
        c = { fg = colors.gray },
        x = { fg = colors.gray },
    },
    normal = {
        a = { fg = colors.bg, bg = colors.green, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.green },
        x = { fg = colors.gray },
    },
    visual = {
        a = { fg = colors.bg, bg = colors.purple, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.purple },
        x = { fg = colors.gray },
    },
    replace = {
        a = { fg = colors.bg, bg = colors.red, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.red },
        x = { fg = colors.gray },
    },
    insert = {
        a = { fg = colors.bg, bg = colors.blue, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.blue },
        x = { fg = colors.gray },
    },
    command = {
        a = { fg = colors.bg, bg = colors.yellow, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.yellow },
        x = { fg = colors.gray },
    },
    terminal = {
        a = { fg = colors.bg, bg = colors.cyan, gui = 'bold' },
        b = { fg = colors.gray },
        c = { fg = colors.cyan },
        x = { fg = colors.gray },
    },
}
return one_dark;
