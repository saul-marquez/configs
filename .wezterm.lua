-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

-- This is where you actually apply your config choices

config.default_prog = { 'pwsh.exe' }

config.font = wezterm.font 'FiraMono Nerd Font'

local onehalfdark =  wezterm.color.get_builtin_schemes()['OneHalfDark']
onehalfdark.background = 'black'
onehalfdark.brights = {
  '#888',
  'red',
  'lime',
  'yellow',
  'blue',
  'fuchsia',
  'aqua',
  'white',
}
config.color_schemes = { ['My OneHalfDark'] = onehalfdark }
config.color_scheme = 'My OneHalfDark'
config.bold_brightens_ansi_colors = false

config.keys = 
{
  {
    key = 'w',
    mods = 'CTRL|SHIFT|ALT',
    action = wezterm.action.CloseCurrentPane { confirm = false },
  }
}

config.adjust_window_size_when_changing_font_size = false
-- and finally, return the configuration to wezterm
return config