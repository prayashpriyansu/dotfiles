-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
hl.on("hyprland.start", function()
    -- Import the Wayland session env into systemd/dbus user services so
    -- xdg-desktop-portal-hyprland (screen share, file pickers) sees the
    -- right WAYLAND_DISPLAY / HYPRLAND_INSTANCE_SIGNATURE right away.
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE")
    hl.exec_cmd("waybar")
    hl.exec_cmd("swaync")
    hl.exec_cmd("/home/iyano/.config/hypr/scripts/wallpaper.sh")
    hl.exec_cmd("hypridle")
    hl.exec_cmd("hyprsunset") -- night light, schedule in hyprsunset.conf
    hl.exec_cmd("swayosd-server")
    hl.exec_cmd("systemctl --user start hyprpolkitagent")
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Ice 30")
    -- clipboard history watchers (cliphist)
    hl.exec_cmd("wl-paste --type text --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)
