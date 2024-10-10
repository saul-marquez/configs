#!/usr/bin/env fish

swww-daemon &
sleep .5
swww img $argv[1]
