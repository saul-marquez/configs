#!/usr/bin/env fish

set LD_LIBRARY_PATH (nix eval --raw nixpkgs#stdenv.cc.cc.lib)/lib
