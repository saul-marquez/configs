#!/usr/bin/env fish

set current (hyprctl monitors | rg scale | tail -1 | cut -d':' -f2 | tr -d ' ')

if test {$current} = 1.00
    hyprctl keyword monitor HDMI-A-1,preferred,auto,1.333333
else
    hyprctl keyword monitor HDMI-A-1,preferred,auto,auto
end
