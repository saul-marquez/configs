#!/usr/bin/env bash

swww-daemon &
swww img ~/dotfiles/nix/tiles.jpg &
nm-applet --indicator &
waybar &
dunst
