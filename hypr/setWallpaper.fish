#!/usr/bin/env fish

swww-daemon --no-cache &
sleep .5
swww img $argv[1]
