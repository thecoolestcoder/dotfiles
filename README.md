# 😎 Coolboi-Dots

My personal Hyprland configuration files for Arch Linux. A carefully crafted setup focused on aesthetics, functionality, and workflow optimization.

## ✨ Features

- **Hyprland** - Dynamic tiling Wayland compositor with smooth animations
- **Waybar** - Highly customizable status bar with system information
- **SwayNC** - Notification center with custom scripts for airplane mode and game mode
- **Rofi** - Application launcher and window switcher
- **Kitty** - GPU-accelerated terminal emulator
- **Pywal** - Dynamic color scheme generation from wallpapers
- **Waypaper** - Wallpaper manager for Wayland
- **Cava** - Console-based audio visualizer
- **Fastfetch** - System information tool
- **Starship** - Cross-shell prompt with custom configuration
- **Hyprlock** - Screen locker with multiple style options
- **Hypridle** - Idle management daemon
- **wlogout** - Logout menu with power options

## 📁 Structure

```
.
├── cava/          # Audio visualizer config
├── fastfetch/     # System fetch config
├── hypr/          # Hyprland configuration
│   ├── hyprland.conf
│   ├── hypridle.conf
│   ├── hyprlock.conf
│   ├── monitors.conf
│   ├── workspaces.conf
│   ├── scripts/   # Utility scripts
│   ├── themes/    # Theme configurations
│   └── hyprlock-styles/  # Lock screen styles
├── kitty/         # Terminal config
├── mybgs/         # Wallpaper collection
├── rofi/          # App launcher config
├── swaync/        # Notification center
│   ├── config.json
│   ├── style.css
│   └── scripts/   # Toggle scripts for features
├── wal/           # Pywal templates
├── waybar/        # Status bar config
├── waypaper/      # Wallpaper manager config
├── wlogout/       # Logout menu config
├── yazi/          # Yazi Terminal File Browser  
└── starship.toml  # Shell prompt config
└── .bashrc        # Bash shell configuration
```

## 🚀 Installation

### Prerequisites

Ensure you have these packages installed:

```bash
yay -S hyprland waybar kitty rofi swaync wlogout hyprlock hypridle \
               waypaper python-pywal16 cava fastfetch starship fzf yazi zoxide
```

### Setup

1. **Clone the repository**
```bash
git clone https://github.com/thecoolestcoder/dotfiles.git ~/dotfiles
```

2. **Backup existing configs** (if any, please feel free to edit this, it's YOUR backup)
```bash
mkdir -p ~/.config/backup
cp -r ~/.config/{hypr,waybar,kitty,rofi,swaync} ~/.config/backup/
```

3. **Symlink configurations**
```bash
cd ~/dotfiles
ln -sf ~/dotfiles/hypr ~/.config/
ln -sf ~/dotfiles/waybar ~/.config/
ln -sf ~/dotfiles/kitty ~/.config/
ln -sf ~/dotfiles/rofi ~/.config/
ln -sf ~/dotfiles/swaync ~/.config/
ln -sf ~/dotfiles/cava ~/.config/
ln -sf ~/dotfiles/fastfetch ~/.config/
ln -sf ~/dotfiles/wal ~/.config/
ln -sf ~/dotfiles/waypaper ~/.config/
ln -sf ~/dotfiles/wlogout ~/.config/
ln -sf ~/dotfiles/starship.toml ~/.config/
ln -sf ~/dotfiles/yazi ~/.config/
ln -sf ~/dotfiles/.bashrc ~/.bashrc
```

4. **Make scripts executable**
```bash
chmod +x ~/dotfiles/hypr/scripts/*
chmod +x ~/dotfiles/swaync/scripts/*
chmod +x ~/dotfiles/waybar/scripts/*
```

5. **Reload Hyprland**
Press `Super + Shift + R` or restart Hyprland

## 🎨 Customization

### Wallpapers

Wallpapers are stored in `mybgs/`. Use waypaper or pywal to change them:
```bash
wal -i ~/dotfiles/mybgs/your-wallpaper.png
```

### Themes

Multiple Hyprland themes are available in `hypr/themes/`. Edit `hypr/hyprland.conf` to source your preferred theme.

### Monitors

Edit `hypr/monitors.conf` to configure your display setup:
```conf
monitor=eDP-1,1920x1080@60,0x0,1
```

### Keybindings

Custom keybindings are defined in `hypr/hyprland.conf`. Key highlights:
- `Super + Return` - Launch terminal
- `Alt + Space` - Application launcher
- `Super + Q` - Close window
- `Super + B` - Exit/logout menu
- `Super + Space` - All in One Rofi menu
- `Super + Shift + W` - Change to random wallpaper
- `Super + W` - Launch Browser
- `Super + E` - Launch File Explorer
- `Super + Shift + O` - Launch FZF file search.
## 🔧 Scripts

### Hyprland Scripts (`hypr/scripts/`)
Utility scripts for various functions like capslock, osd for volume etc

### SwayNC Scripts (`swaync/scripts/`)
- `airplane_mode.sh` - Toggle airplane mode
- `toggle-gamemode.sh` - Enable/disable game mode optimizations

## 🖼️ Screenshots

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ae23cbb5-764a-4d0f-9e2e-7ca9ef176e46" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b31b9ee6-a2e6-420c-84dd-9961234d4869" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/b430a6f3-9cbb-4a4b-8007-b7cb5d4758f0" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0cbde9e9-5ba2-450c-906e-efa494474ecc" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/8c6e9180-2f3e-4997-97b4-0919e5f909ee" />
<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/acda2318-6f0b-463a-9eac-628719eab5cc" />


## 💡 Tips

- Run `fastfetch` in your terminal to see system info with your custom config
- Use `hyprctl reload` to reload Hyprland configuration without restarting
- Check SwayNC notification center with `swaync-client -t`
- Explore Hyprlock styles in `hypr/hyprlock-styles/` for different lock screen aesthetics

## 📝 Notes

- These configs are tailored for my Dell Inspiron 5390 (i5 8th gen, Intel UHD 620)
- Some settings may need adjustment for different hardware configurations
- Monitor configuration in `hypr/monitors.conf` should be customized for your display setup

## 🤝 Contributing

Feel free to fork this repository and customize it for your own setup. If you have suggestions or improvements, open an issue or pull request!

## 📜 License

Free to use and modify as you wish.

## 🙏 Acknowledgments

- [Hyprland](https://hyprland.org) - Amazing Wayland compositor
- [r/unix**](https://reddit.com/r/unixporn) - Inspiration and ideas
- The Linux ricing community

---

⭐ **Star this repo if you find it useful!**
