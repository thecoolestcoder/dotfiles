#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return
alias gde='sudo systemctl start gdm'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
PS1='[\\u@\\h \\W]\\$ '
alias m='micro'
alias pi='sudo pacman -S'
alias yi='yay -S'
alias ff='fastfetch'
alias imneo='cmatrix -a'
alias fx='yazi'
alias cd='z'
alias dd3='ddgr -n 3'
alias nv='nvim'
eval "$(zoxide init bash)"
eval "$(starship init bash)"
# fzf key bindings
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Fixed aesthetic fzf defaults
export FZF_DEFAULT_OPTS='--height 80% --layout=reverse --border=rounded --margin=1%,1% --padding=1 --info=inline --header="⌕ " --prompt="❯ " --pointer="▶" --marker="✗" --color=light --color="border:7,label:3,pointer:5,marker:5,spinner:5,hl:2,hl+:3" --preview-window="right:60%:border-rounded:nocycle:wrap" --preview "bat --style=numbers --color=always --line-range :100 {} 2>/dev/null || cat {} 2>/dev/null || ls -la {} 2>/dev/null"'

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix \
--exclude .git \
--exclude Games \
--exclude .cache \
--exclude ".local/share/!(applications)/**" \
--exclude ".local/state" \
--exclude ".local/share" \
--exclude ".local/bin" \
--exclude ".mozilla/firefox/*/crashes"'

# Fixed yay aliases
# Interactive yay search and install
alias ys="yay -Slq | fzf --multi --preview 'yay -Si {1}' --height=90% --layout=reverse --border | xargs -ro yay -S"

# Interactive yay remove (to clean up bloat)
alias yr="yay -Qq | fzf --multi --preview 'yay -Qi {1}' --height=90% --layout=reverse --border | xargs -ro yay -Rns"

# File Open (fo): fzf open with xdg open
alias fo='fzf | xargs -I {} xdg-open "{}"'
alias mb='micro ~/.bashrc'
alias fom='fzf | xargs -I {} micro "{}"'

# Import colors from Pywal
# This ensures new terminal windows use the generated colors
(cat ~/.cache/wal/sequences &)

# Optional: Source the colors.sh file if you want to use 
# pywal variables ($color0, $color1, etc.) in other scripts
source "$HOME/.cache/wal/colors.sh"
export VISUAL="micro"
export EDITOR="micro"

alias xfce='startxfce4'
alias hypr='start-hyprland'
alias dnld='axel -n 8'
export MOZ_ENABLE_WAYLAND=1
export SWWW_TRANSITION=any
export SWWW_TRANSITION_FPS=60
export SWWW_TRANSITION_STEP=63
alias hpush='cd ~/.config && git add . && git commit -m "update dotfiles" && git push'

# Custom Zoxide + fzf + bat preview
zp() {
  local dir
  dir=$(zoxide query -l | fzf --height 50% --layout=reverse --border \
    --preview "ls -CF {} | bat --color=always --style=plain" \
    --preview-window right:50%)
  if [ -n "$dir" ]; then
    cd "$dir"
  fi
}
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	command yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ "$cwd" != "$PWD" ] && [ -d "$cwd" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}
