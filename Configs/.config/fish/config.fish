set -g fish_greeting

source ~/.config/fish/hyde_config.fish

if type -q starship
    starship init fish | source
    set -gx STARSHIP_CACHE $XDG_CACHE_HOME/starship
    set -gx STARSHIP_CONFIG $XDG_CONFIG_HOME/starship/starship.toml
end

enable_transience

set fish_pager_color_prefix cyan
set fish_color_autosuggestion brblack 

set -g fish_key_bindings fish_vi_key_bindings

bind yy fish_clipboard_copy
bind Y fish_clipboard_copy
bind p fish_clipboard_paste

# List Directory
# Navigation
alias aliases='nvim ~/.config/aliases.sh'
alias home='z'
alias ..='z ..'
alias ...='z ../..'
alias ....='z ../../..'
alias ls='lsd'
alias ll='lsd -l'
alias la='lsd -a'
alias lla='lsd -la'
alias c='clear'
alias flatten='python3 ~/.scripts/flatten-directories.py'
alias ff='fastfetch'
alias projects="project -l"

alias vpn="~/.scripts/vpn.zsh"
alias dirac='~/.scripts/dirac.zsh'
alias vi='nvim'

if test -f ~/.scripts/projects.fish
    source ~/.scripts/projects.fish
end

# Handy change dir shortcuts
abbr .. 'cd ..'
abbr ... 'cd ../..'
abbr .3 'cd ../../..'
abbr .4 'cd ../../../..'
abbr .5 'cd ../../../../..'

# Always mkdir a path (this doesn't inhibit functionality to make a single dir)
abbr mkdir 'mkdir -p'
zoxide init fish | source
