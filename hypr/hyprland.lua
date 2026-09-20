-- ~/.config/hypr/hyprland.lua
-- Converted from your original hyprland.conf.
-- Uses the official Hyprland Lua workspace binding pattern:
-- hl.dsp.focus({ workspace = i })
-- hl.dsp.window.move({ workspace = i })
--
-- monitors.conf and workspaces.conf are not loaded here because they are
-- Hyprlang files. Put monitor rules below as hl.monitor({...}) definitions.

------------------
---- MONITORS ----
------------------

-- Replace this safe fallback with your actual monitor definitions if needed.
-- Example:
-- hl.monitor({
--     output = "eDP-1",
--     mode = "1920x1080@144",
--     position = "0x0",
--     scale = 1,
-- })
------------------
---- MONITORS ----
------------------
-- the one with 0x0 is always left, the right one will take 1920x0. if u want to switch the position , then swotch 0 and 1920.
-- Laptop BOE panel:
hl.monitor({
    output = "desc:BOE 0x07A0",
    mode = "1920x1080@59.98",
    position = "0x0",
    scale = 1.0,
})

-- External Acer monitor:
hl.monitor({
    output = "desc:Acer Technologies EK220Q H3 15170E7913W01",
    mode = "1920x1080@100.0",
    position = "1920x0",
    scale = 1.0,
})
---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "kitty"
local fileManager = "nemo"
local menu = "rofi -show drun"
local browser = "google-chrome-stable"
local mainMod = "SUPER"
local alt = "ALT"
local clipb = "~/.config/rofi/rofi-clip.sh"

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")
hl.exec_cmd("systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP QT_QPA_PLATFORMTHEME")
hl.exec_cmd("systemctl --user stop xdg-desktop-portal xdg-desktop-portal-hyprland xdg-desktop-portal-gtk")
hl.exec_cmd("systemctl --user start xdg-desktop-portal")
hl.exec_cmd("waybar")
-- hl.exec_cmd("hypridle")
hl.exec_cmd("thunar --daemon")
hl.exec_cmd("waypaper --restore")
hl.exec_cmd("wl-paste --type text --watch cliphist store")
hl.exec_cmd("wl-paste --type image --watch cliphist store")
hl.exec_cmd("~/.config/hypr/scripts/caps_lock_watch.sh")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("HYPRCURSOR_THEME", "Bibata-Modern-Classic")
hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("GDK_BACKEND", "wayland,x11")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("GTK_THEME", "Orchis-Dark")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 15,
        border_size = 3,
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
        col = {
            -- Literal colors replace old Hyprlang pywal variables $color2/$color4.
            active_border = {
                colors = { "rgba(89b4faff)", "rgba(cba6f7ff)" },
          angle = 45,
            },
            inactive_border = "rgba(ffffff1a)",
        },
    },

    dwindle = {
        preserve_split = true,
    },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = {
            enabled = true,
          range = 4,
          render_power = 3,
          color = 0xee1a1a1a,
        },
        blur = {
            enabled = true,
          size = 5,
          passes = 3,
          vibrancy = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        sensitivity = 0.5,
        accel_profile = "adaptive",
        touchpad = {
            natural_scroll = false,
        },
    },
})

------------------
---- GESTURES ----
------------------

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

--------------------
---- ANIMATIONS ----
--------------------

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 10, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 4.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 1.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers", enabled = true, speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 4, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 1.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 8, bezier = "default", style = "slide" })
hl.animation({ leaf = "workspacesIn", enabled = true, speed = 5, bezier = "easeOutQuint", style = "slide" })
hl.animation({ leaf = "workspacesOut", enabled = true, speed = 5, bezier = "easeOutQuint", style = "slide" })
-- zoomFactor deliberately omitted to avoid the zoom issue.

---------------------
---- KEYBINDINGS ----
---------------------

-- Applications
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd('rofi -show find -modi "find:~/.config/rofi/AIOrofi.sh"'))
hl.bind(alt .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("kate"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("wlogout -b 5"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + G", hl.dsp.exec_cmd("heroic"))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd(clipb))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("okular"))
hl.bind("SUPER + SHIFT + O", hl.dsp.exec_cmd([[kitty --hold sh -lc 'fzf | xargs -r -I {} xdg-open "{}"']]))

-- Screenshots
hl.bind("SUPER + SHIFT + S", hl.dsp.exec_cmd('grim -g "$(slurp)" - | wl-copy'))
hl.bind("SUPER + PRINT", hl.dsp.exec_cmd('FILE="$HOME/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png" && grim "$FILE" && wl-copy < "$FILE"'))

-- Window management
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 1"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen"))
hl.bind(mainMod .. " + left", hl.dsp.exec_cmd("hyprctl dispatch movefocus l"))
hl.bind(mainMod .. " + right", hl.dsp.exec_cmd("hyprctl dispatch movefocus r"))
hl.bind(mainMod .. " + up", hl.dsp.exec_cmd("hyprctl dispatch movefocus u"))
hl.bind(mainMod .. " + down", hl.dsp.exec_cmd("hyprctl dispatch movefocus d"))
hl.bind("SUPER + SHIFT + left", hl.dsp.exec_cmd("hyprctl dispatch swapwindow l"))
hl.bind("SUPER + SHIFT + right", hl.dsp.exec_cmd("hyprctl dispatch swapwindow r"))
hl.bind("SUPER + SHIFT + up", hl.dsp.exec_cmd("hyprctl dispatch swapwindow u"))
hl.bind("SUPER + SHIFT + down", hl.dsp.exec_cmd("hyprctl dispatch swapwindow d"))
hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))

-- Smooth keyboard resizing
hl.bind("SUPER + CTRL + left", hl.dsp.exec_cmd("hyprctl dispatch resizeactive -10 0"), { repeating = true })
hl.bind("SUPER + CTRL + right", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 10 0"), { repeating = true })
hl.bind("SUPER + CTRL + up", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 -10"), { repeating = true })
hl.bind("SUPER + CTRL + down", hl.dsp.exec_cmd("hyprctl dispatch resizeactive 0 10"), { repeating = true })

-- Official Hyprland sample Lua workspace bindings.
-- Key 0 selects/moves to workspace 10 because 10 % 10 == 0.
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
    end

    -- Official sample Lua workspace scroll bindings.
    hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
    hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

    -- Mouse move / resize
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

    -- Wallpaper, editor, reload, and theme
    hl.bind("SUPER + SHIFT + W", hl.dsp.exec_cmd("waypaper --random"))
    hl.bind("SUPER + CTRL + W", hl.dsp.exec_cmd("waypaper"))
    hl.bind("SUPER + SHIFT + H", hl.dsp.exec_cmd("kitty -e micro ~/.config/hypr/hyprland.lua"))
    hl.bind("SUPER + SHIFT + R", hl.dsp.exec_cmd("hyprctl reload"))
    hl.bind("SUPER + SHIFT + B", hl.dsp.exec_cmd("pkill waybar && waybar & disown"))
    hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd("~/.config/waybar/scripts/theme-switcher.sh"))

    -- Multimedia and brightness
    hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_osd.sh raise"), { locked = true, repeating = true })
    hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_osd.sh lower"), { locked = true, repeating = true })
    hl.bind("XF86AudioMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_osd.sh mute"), { locked = true })
    hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("~/.config/hypr/scripts/volume_osd.sh mic-mute"), { locked = true })
    hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_osd.sh up"), { locked = true, repeating = true })
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("~/.config/hypr/scripts/brightness_osd.sh down"), { locked = true, repeating = true })
    hl.bind("SUPER + F6", hl.dsp.exec_cmd("~/.config/hypr/scripts/extbrightness.sh up"), { repeating = true })
    hl.bind("SUPER + F7", hl.dsp.exec_cmd("~/.config/hypr/scripts/extbrightness.sh down"), { repeating = true })
    hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
    hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
    hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- HyprMod managed settings
require("hyprland-gui")
