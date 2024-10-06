#!/usr/bin/env fish

pkill waybar
sleep .5
waybar 2>&1 >> ~/waybarlog.txt
