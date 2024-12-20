if status is-interactive
    # Commands to run in interactive sessions can go here
end

# set --global tide_left_prompt_items $tide_left_prompt_items kubectl

alias ls="eza"
alias li="eza -lAh"
alias y="fish_clipboard_copy"
alias p="fish_clipboard_paste"
alias cfg="nvim ~/dotfiles/"
alias k="kubectl"

set -e SSH_ASKPASS

set PAT PAT
