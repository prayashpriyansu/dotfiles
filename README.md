# dotfiles

Arch Linux + Hyprland desktop config, managed with [GNU Stow](https://www.gnu.org/software/stow/).

Each top-level directory is a stow package that mirrors the layout it needs inside `$HOME`
(e.g. `hypr/.config/hypr/...` → symlinked to `~/.config/hypr`).

## Packages

- `zsh` — `.zshrc`
- `ghostty`, `kitty` — terminal emulators
- `ohmyposh` — shell prompt theme
- `hypr` — Hyprland compositor config, scripts, and lua modules
- `waybar`, `rofi`, `wlogout`, `swaync`, `swayosd`, `nwg-look`, `xsettingsd` — Wayland desktop shell / session tooling
- `mpv`, `qt6ct`, `cava` — misc app config
- `gtk` — GTK 3/4 theming + `.gtkrc-2.0`

## Install on a fresh machine

```sh
sudo pacman -S stow
git clone https://github.com/PrayashPriyansu/dotfiles.git ~/dotfiles
cd ~/dotfiles
stow -t ~ zsh ghostty ohmyposh hypr waybar rofi kitty wlogout swaync swayosd nwg-look xsettingsd mpv qt6ct cava gtk
```

Stow will symlink each package into `$HOME`, preserving the `.config/...` structure.
Re-run `stow -t ~ <package>` any time you add a new package, or `stow -D -t ~ <package>` to unlink one.
