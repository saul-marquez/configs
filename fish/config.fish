if status is-interactive
    # Commands to run in interactive sessions can go here
end

set --global tide_left_prompt_items $tide_left_prompt_items kubectl

alias li="ls -lAh"
alias y="fish_clipboard_copy"
alias p="fish_clipboard_paste"
