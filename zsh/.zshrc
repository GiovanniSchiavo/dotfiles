# --- XDG Base Directory Standards ---
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"


# Exit early for non-interactive shells
[[ $- != *i* ]] && return


# History Configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=50000
setopt inc_append_history


# Load completion system
autoload -Uz compinit
compinit


# Starship (Prompt)
eval "$(starship init zsh)"

# Zoxide (Better cd)
eval "$(zoxide init zsh --cmd cd)"

# Mise (Version Manager)
eval "$(mise activate zsh --shims)"

# FZF (Fuzzy Finder)
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
source <(fzf --zsh)



# Fastfetch (System Info)
fastfetch


# Eza Aliases (Better ls replacement)
# Base commands
alias ls='eza --icons --long --hyperlink --smart-group --no-user --total-size'
alias lsa='ls --all'
alias lsg='ls --git'
alias lsag='lsa --git'

# Tree view
alias lt='ls --tree'
alias lta='lsa --tree'
alias ltg='lt --git'
alias ltag='lta --git'

# Tree view with 2 levels
alias lt2='lt --level 2'
alias lta2='lta --level 2'
alias ltg2='ltg --level 2'
alias ltag2='ltag --level 2'

# FZF with Bat Preview
alias ff='fzf --height 40% --layout=reverse --ansi --preview="bat --style=numbers --color=always --line-range :500 {}" --preview-window=right:60%:wrap'


# Load Zsh Plugins
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh # Should be last

