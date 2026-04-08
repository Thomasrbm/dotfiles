# Enable Powerlevel10k instant prompt.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-completions)

source $ZSH/oh-my-zsh.sh

# --- Aliases ---
alias ..="cd .."
alias ...="cd ../.."
if command -v eza >/dev/null; then
    alias ls='eza --git --icons --color=always'
    alias ll='eza -al --header --git --icons --color=always'
else
    alias ls='ls --color=always'
    alias ll='ls -alF --color=always'
fi
alias la="tree"
alias duf="du -sh * | sort -rh"
alias update="sudo apt update && sudo apt upgrade -y"
alias zsh="code ~/.zshrc"
alias py="python3"
alias serve="python3 -m http.server"
alias anti="python3 -c 'import antigravity'" 
alias extr="extract"
alias r='ranger-cd'

alias bcat=batcat

unalias rel 2>/dev/null
rel() {
  source ~/.zshrc && echo "Zsh config reloaded"
  echo -n "Sauvegarder .zshrc sur GitHub ? (oui/non): "
  read answer
  [[ "$answer" == "oui" ]] && cp ~/.zshrc ~/dotfiles/.zshrc && cd ~/dotfiles && git add . && git commit -m "update zshrc" && git push && cd - && echo "✅ Pushé"
}

unalias nixconf 2>/dev/null
nixconf() {
  code /etc/nixos
}

unalias relnix 2>/dev/null
relnix() {
  sudo nixos-rebuild switch
  echo -n "Sauvegarder configuration.nix sur GitHub ? (oui/non): "
  read answer
  [[ "$answer" == "oui" ]] && cp /etc/nixos/configuration.nix ~/dotfiles/configuration.nix && cd ~/dotfiles && git add . && git commit -m "update nixos config" && git push && cd - && echo "✅ Pushé"
}


# --- Gemini Function ---
gemini() {
     # Charge NVM si besoin
     export NVM_DIR="$HOME/.nvm"
     [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
     nvm use 20 >/dev/null 2>&1
     
     if command -v gemini >/dev/null; then
        command gemini "$@"
     else
        echo "⚠️ Commande 'gemini' introuvable. Installation..."
        npm install -g @google/gemini-cli
        command gemini "$@"
     fi
}

# --- Extract ---
extract() {
    for f in "$@"; do
        if [ -f "$f" ]; then
            case "$f" in
                *.tar.bz2)   tar xjf "$f"     ;;
                *.tar.gz)    tar xzf "$f"     ;;
                *.rar)       unrar x "$f"     ;;
                *.zip)       unzip "$f"       ;;
                *)           echo "'$f' erreur extraction" ;;
            esac
        fi
    done
}

# --- Git Shortcuts ---
push() {
    git add .
    echo -n "Message: "
    read msg
    git commit -m "$msg"
    git push
}

# --- Configs ---
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=10000
setopt APPEND_HISTORY SHARE_HISTORY HIST_IGNORE_DUPS

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Ranger
ranger-cd() {
    local temp_file="$(mktemp -t "ranger_cd.XXXXXXXXXX")"
    ranger --choosedir="$temp_file" "${@:-.}"
    if [ -f "$temp_file" ] && [ "$(cat -- "$temp_file")" != "$(pwd)" ]; then
        cd -- "$(cat "$temp_file")"
    fi
    rm -f -- "$temp_file"
}
zle -N ranger-cd
bindkey '^[r' ranger-cd
