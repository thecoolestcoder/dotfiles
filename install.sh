#!/bin/bash

# ============================================================
#  Coolboi-Dots — Automated Installer
#  github.com/thecoolestcoder/dotfiles
# ============================================================

# --- Colors ---
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# --- Defaults ---
AUTO_YES=false
DOTFILES_DIR="$HOME/dotfiles"

# --- Parse args ---
for arg in "$@"; do
    case $arg in
        -y|--yes)  AUTO_YES=true ;;
        --dir=*)   DOTFILES_DIR="${arg#*=}" ;;
    esac
done

# --- Helpers ---
info()    { echo -e "${CYAN}${BOLD}  [INFO]${NC}  $1"; }
success() { echo -e "${GREEN}${BOLD}  [ OK ]${NC}  $1"; }
warn()    { echo -e "${YELLOW}${BOLD}  [WARN]${NC}  $1"; }
error()   { echo -e "${RED}${BOLD}  [ERR ]${NC}  $1"; }
step()    { echo -e "\n${BOLD}${CYAN}━━━ $1 ${NC}"; }

confirm() {
    if $AUTO_YES; then return 0; fi
    echo -ne "${YELLOW}${BOLD}  [?]${NC}  $1 [Y/n] "
    read -r reply
    [[ "$reply" =~ ^[Yy]$|^$ ]]
}

# --- Banner ---
echo ""
echo -e "${CYAN}${BOLD}"
echo "   ██████╗ ██████╗  ██████╗ ██╗     ██████╗  ██████╗ ██╗"
echo "  ██╔════╝██╔═══██╗██╔═══██╗██║     ██╔══██╗██╔═══██╗██║"
echo "  ██║     ██║   ██║██║   ██║██║     ██████╔╝██║   ██║██║"
echo "  ██║     ██║   ██║██║   ██║██║     ██╔══██╗██║   ██║██║"
echo "  ╚██████╗╚██████╔╝╚██████╔╝███████╗██████╔╝╚██████╔╝██║"
echo "   ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝ ╚═╝"
echo -e "${NC}"
echo -e "  ${BOLD}Coolboi-Dots Installer${NC}  —  github.com/thecoolestcoder/dotfiles"
echo ""

if $AUTO_YES; then
    warn "Non-interactive mode (--yes). All prompts will be auto-confirmed."
fi

# ============================================================
# STEP 1 — Check for yay
# ============================================================
step "Step 1 — Checking for AUR helper (yay)"

if ! command -v yay &>/dev/null; then
    error "yay not found. Install it first: https://github.com/Jguer/yay"
    exit 1
fi
success "yay is available"

# ============================================================
# STEP 2 — Install packages
# ============================================================
step "Step 2 — Installing packages"

PACKAGES=(
    hyprland waybar kitty rofi swaync wlogout hyprlock hypridle
    waypaper python-pywal16 cava fastfetch starship
    fzf yazi zoxide fd bc power-profiles-daemon
    swww ttf-jetbrains-mono-nerd bibata-cursor-theme
    ttf-roboto ttf-roboto-mono-nerd ttf-nerd-fonts-symbols
    apple-fonts ttf-minecraft monocraft
)

if confirm "Install all required packages?"; then
    info "Installing ${#PACKAGES[@]} packages via yay..."
    if $AUTO_YES; then
        yay -S --noconfirm --needed "${PACKAGES[@]}"
    else
        yay -S --needed "${PACKAGES[@]}"
    fi
    success "All packages installed"
else
    warn "Skipping package installation"
fi

# ============================================================
# STEP 3 — Clone or update dotfiles
# ============================================================
step "Step 3 — Fetching dotfiles"

if [[ -d "$DOTFILES_DIR/.git" ]]; then
    info "Dotfiles found at $DOTFILES_DIR — pulling latest changes..."
    git -C "$DOTFILES_DIR" pull
    success "Dotfiles updated"
elif [[ -d "$DOTFILES_DIR" ]]; then
    warn "$DOTFILES_DIR exists but is not a git repo."
    if confirm "Remove it and clone fresh?"; then
        rm -rf "$DOTFILES_DIR"
        git clone https://github.com/thecoolestcoder/dotfiles.git "$DOTFILES_DIR"
        success "Dotfiles cloned to $DOTFILES_DIR"
    else
        error "Cannot continue without a valid dotfiles directory. Exiting."
        exit 1
    fi
else
    info "Cloning dotfiles into $DOTFILES_DIR..."
    git clone https://github.com/thecoolestcoder/dotfiles.git "$DOTFILES_DIR"
    success "Dotfiles cloned to $DOTFILES_DIR"
fi

# ============================================================
# STEP 4 — Backup existing configs
# ============================================================
step "Step 4 — Backup existing configs"

BACKUP_DIR="$HOME/.config/backup_$(date +%Y%m%d_%H%M%S)"
CONFIG_DIRS=(hypr waybar kitty rofi swaync cava fastfetch wal waypaper wlogout yazi mybgs)

if confirm "Back up existing configs to $BACKUP_DIR?"; then
    mkdir -p "$BACKUP_DIR"
    for cfg in "${CONFIG_DIRS[@]}"; do
        target="$HOME/.config/$cfg"
        if [[ -e "$target" || -L "$target" ]]; then
            cp -rP "$target" "$BACKUP_DIR/" 2>/dev/null || true
            info "Backed up ~/.config/$cfg"
        fi
    done
    # Backup .bashrc
    [[ -f "$HOME/.bashrc" ]] && cp "$HOME/.bashrc" "$BACKUP_DIR/.bashrc" && info "Backed up ~/.bashrc"
    success "Backup saved to $BACKUP_DIR"
else
    warn "Skipping backup"
fi

# ============================================================
# STEP 5 — Create symlinks (force overwrite)
# ============================================================
step "Step 5 — Creating symlinks"

# Remove existing target then symlink — prevents 'target is a directory' errors
safe_link() {
    local src="$1"
    local dest="$2"
    if [[ -e "$dest" || -L "$dest" ]]; then
        rm -rf "$dest"
    fi
    ln -sf "$src" "$dest"
    info "Linked $dest → $src"
}

mkdir -p "$HOME/.config"

safe_link "$DOTFILES_DIR/hypr"          "$HOME/.config/hypr"
safe_link "$DOTFILES_DIR/waybar"        "$HOME/.config/waybar"
safe_link "$DOTFILES_DIR/kitty"         "$HOME/.config/kitty"
safe_link "$DOTFILES_DIR/rofi"          "$HOME/.config/rofi"
safe_link "$DOTFILES_DIR/swaync"        "$HOME/.config/swaync"
safe_link "$DOTFILES_DIR/cava"          "$HOME/.config/cava"
safe_link "$DOTFILES_DIR/fastfetch"     "$HOME/.config/fastfetch"
safe_link "$DOTFILES_DIR/wal"           "$HOME/.config/wal"
safe_link "$DOTFILES_DIR/waypaper"      "$HOME/.config/waypaper"
safe_link "$DOTFILES_DIR/wlogout"       "$HOME/.config/wlogout"
safe_link "$DOTFILES_DIR/yazi"          "$HOME/.config/yazi"
safe_link "$DOTFILES_DIR/mybgs"         "$HOME/.config/mybgs"
safe_link "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
safe_link "$DOTFILES_DIR/.bashrc"       "$HOME/.bashrc"

success "All symlinks created"

# ============================================================
# STEP 6 — Make scripts executable
# ============================================================
step "Step 6 — Setting script permissions"

chmod +x "$DOTFILES_DIR/hypr/scripts/"*      2>/dev/null || true
chmod +x "$DOTFILES_DIR/swaync/scripts/"*    2>/dev/null || true
chmod +x "$DOTFILES_DIR/waybar/scripts/"*    2>/dev/null || true
chmod +x "$DOTFILES_DIR/rofi/"*.sh           2>/dev/null || true
chmod +x "$DOTFILES_DIR/waypaper/reload.sh"  2>/dev/null || true

success "Scripts are executable"

# ============================================================
# STEP 7 — Generate initial pywal colors
# ============================================================
step "Step 7 — Generating initial pywal color cache"

DEFAULT_WALLPAPER="$DOTFILES_DIR/mybgs/jeff-ostberg-cozy-autumn-rain.jpg"

if [[ -f "$DEFAULT_WALLPAPER" ]]; then
    info "Running wal on default wallpaper..."
    wal -i "$DEFAULT_WALLPAPER" -q
    success "Pywal cache generated (~/.cache/wal/)"
else
    warn "Default wallpaper not found at $DEFAULT_WALLPAPER"
    warn "Run manually after install: wal -i ~/dotfiles/mybgs/<your-wallpaper>"
fi

# ============================================================
# DONE
# ============================================================
echo ""
echo -e "${GREEN}${BOLD}  ╔══════════════════════════════════════════════════════╗"
echo    "  ║      Installation complete! Enjoy your dots 🎉       ║"
echo -e "  ╚══════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "  ${BOLD}Next steps:${NC}"
echo -e "  ${CYAN}•${NC} Reload Hyprland:       ${BOLD}Super + Shift + R${NC}"
echo -e "  ${CYAN}•${NC} Change wallpaper:      ${BOLD}Super + Shift + W${NC} (random) or ${BOLD}Super + Ctrl + W${NC} (picker)"
echo -e "  ${CYAN}•${NC} Edit monitor config:   ${BOLD}~/.config/hypr/monitors.conf${NC}"
echo ""
echo -e "  ${YELLOW}${BOLD}  Manual step required:${NC}"
echo -e "  ${CYAN}•${NC} Install ${BOLD}StretchPro${NC} font (used by hyprlock clock):"
echo    "    Download from: https://fontsource.org/fonts/stretch-pro"
echo    "    Then run: mkdir -p ~/.local/share/fonts && cp StretchPro*.ttf ~/.local/share/fonts/ && fc-cache -fv"
echo ""
