# Hyprland Setup — Manual

Personal Hyprland config, written in Lua via `hyprlang`'s Lua API rather than
the classic `hyprland.conf` syntax. Theme is Gruvbox Material (dark) across
the whole desktop — Hyprland, hyprlock, waybar, rofi, swaync, wlogout, and
ghostty all share the same palette.

Hyprland version at time of writing: `0.55.3`. Tracked in git as of this
revision — see [Version control](#version-control).

For a quick lookup of just apps + keybinds without the explanations, see
[CHEATSHEET.md](CHEATSHEET.md).

## Structure

```
~/.config/hypr/
├── hyprland.lua          # entrypoint — just requires the modules below, in load order
├── hyprlock.conf         # lock screen appearance
├── hypridle.conf         # idle timeouts (dim → lock → screens off → suspend)
├── hyprsunset.conf       # night light schedule
├── .luarc.json           # Lua LSP config, points at Hyprland's Lua stubs
├── README.md             # this file
├── CHEATSHEET.md         # condensed apps + keybinds reference
├── modules/
│   ├── monitors.lua      # display outputs
│   ├── binds.lua         # programs + all keybindings
│   ├── autostart.lua     # session startup commands
│   ├── env.lua           # environment variables (wayland/qt/nvidia)
│   ├── decorations.lua   # general/decoration/animation config ("look and feel")
│   ├── layout.lua        # scrolling layout config
│   ├── misc.lua          # misc toggles (wallpaper logo, etc.)
│   ├── input.lua         # keyboard/touchpad/gestures
│   └── windowrules.lua   # window rules
└── scripts/
    ├── wallpaper.sh      # sets/starts the wallpaper daemon (swww/awww)
    ├── clipboard.sh      # cliphist + rofi picker
    ├── wifi-menu.sh      # nmcli + rofi Wi-Fi picker
    ├── bluetooth-menu.sh # bluetoothctl + rofi Bluetooth picker
    ├── power-profile.sh  # cycles power-profiles-daemon profile
    └── record.sh         # wf-recorder start/stop toggle
```

Load order matters: `hyprland.lua` requires modules top-to-bottom, so anything
depending on earlier state (e.g. binds referencing scripts) should stay after
its dependency.

## Reloading / applying changes

Hyprland picks up Lua config changes automatically (like `hyprland.conf`), but
if something seems stuck:

```sh
hyprctl reload
```

`hypridle`/`hyprlock` need to be restarted manually after editing
`hypridle.conf` / `hyprlock.conf` (they don't hot-reload):

```sh
pkill hypridle && hypridle &
```

## Look & feel (`decorations.lua`)

- **Layout engine**: `scrolling` (set in `layout.lua`), with
  `fullscreen_on_one_column = true` — single-column workspaces auto-fullscreen.
- **Gaps**: 2px inner / 6px outer.
- **Borders**: 2px, muted rose-gold active border (`rgba(ea696280)`), dark
  seam for inactive (`rgba(45403dff)`) — no full color-halo effect.
- **Rounding**: 8px, rounding_power 4 (superellipse-style corners).
- **Opacity**: active 1.0, inactive 0.96.
- **Shadow**: subtle, range 12, render_power 2.
- **Blur**: light — size 6, 2 passes, vibrancy 0.17. Tuned for crispness over
  heaviness.
- **Animations**: custom bezier curves (`easeOutQuint`, `easeInOutCubic`,
  `quick`, `almostLinear`) plus two named springs:
  - `easy` — default spring (mass 1, stiffness 71.26, damping 15.83)
  - `zen` — gentle single-overshoot spring (damping ratio ~0.6) used for
    `windowsIn`, i.e. the "breath-in" feel when windows open.

To retheme, `decorations.lua` is the one file to touch for colors/blur/shadow;
animation curves live in the same file below the `hl.config` block.

## Input (`input.lua`)

- Layout: `us`.
- Key repeat: 25/sec, 300ms delay.
- Touchpad: natural scroll on, `scroll_factor = 0.2` (slow scroll).
- `follow_mouse = 1`, sensitivity 0 (unmodified).
- 3-finger horizontal swipe → switch workspace.

## Monitors (`monitors.lua`)

Single laptop panel `eDP-1`, preferred mode, auto position/scale. Add more
`hl.monitor({...})` blocks here for external displays.

## Autostart (`autostart.lua`)

On `hyprland.start`, launches (in order):

| Command | Purpose |
|---|---|
| `dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE` | imports the session env into systemd/dbus user services — needed for `xdg-desktop-portal-hyprland` (screen share, native file pickers) to see the right Wayland session on every login |
| `waybar` | status bar |
| `swaync` | notification daemon |
| `scripts/wallpaper.sh` | wallpaper daemon + image |
| `hypridle` | idle management |
| `hyprsunset` | night light (schedule in `hyprsunset.conf`) |
| `swayosd-server` | on-screen volume/brightness popups |
| `systemctl --user start hyprpolkitagent` | polkit auth agent |
| `hyprctl setcursor Bibata-Modern-Ice 30` | cursor theme/size |
| `wl-paste --type text --watch cliphist store` | clipboard text history |
| `wl-paste --type image --watch cliphist store` | clipboard image history |

### Portals

`xdg-desktop-portal-hyprland` is installed but portal services are
dbus-activated on demand (they'll show `inactive (dead)` in
`systemctl --user status` until something requests one — that's normal). The
`dbus-update-activation-environment` line above is what makes screen sharing
in Zoom/Discord/browsers and native GTK file pickers actually work reliably;
without it the portal can start with a stale/empty environment.

## Idle & lock (`hypridle.conf` / `hyprlock.conf`)

Escalating idle timeline:

| Time | Action |
|---|---|
| 2:30 | dim backlight to 10% (`brightnessctl -s set 10`, restores with `-r`) |
| 5:00 | lock session (`loginctl lock-session`) |
| 5:30 | screens off (`hyprctl dispatch dpms off/on`) |
| 20:00 | suspend (`systemctl suspend`) |

`lock_cmd` guards against stacking multiple hyprlock instances
(`pidof hyprlock || hyprlock`). `before_sleep_cmd` locks before suspend
independent of the idle timeline, so manual suspend is also locked.

hyprlock shows: blurred screenshot background, clock (88pt), date, a
password dots field, and `$USER` — all Gruvbox Material colors, font
"Iosevka Nerd Font Propo".

## Night light (`hyprsunset.conf`)

`hyprsunset` runs from autostart and reads `hyprsunset.conf`: identity (no
filter) from 07:00, warm 4000K from 20:00. It re-evaluates automatically at
each `time` boundary — no cron/loop needed.

Controlled live via `hyprctl hyprsunset ...` (temperature/gamma/identity/reset —
see the [hyprsunset wiki page](https://wiki.hypr.land/Hypr-Ecosystem/hyprsunset/)
for the full IPC surface). `SUPER+SHIFT I` runs `scripts/nightlight-toggle.sh`,
which flips into `identity` mode and back using a flag file in
`$XDG_RUNTIME_DIR`, for a manual override until the next scheduled profile
change (e.g. doing color-sensitive work at night).

## Power profiles

`power-profiles-daemon` provides `performance`/`balanced`/`power-saver` over
D-Bus; already surfaced in waybar's battery module. `SUPER+SHIFT P` runs
`scripts/power-profile.sh`, which cycles through the three and notifies which
one is now active.

## Screen recording

`SUPER+SHIFT R` runs `scripts/record.sh`, a start/stop toggle around
`wf-recorder`. Recordings save to `~/Videos/Recordings/<timestamp>.mp4`.
Video only by default (no `--audio` flag), stopped with `SIGINT` so the
container finalizes correctly instead of producing a corrupt file.

## Emoji / unicode picker

`SUPER+SHIFT Period` runs `rofimoji --action copy --selector-args="-theme
$HOME/.config/rofi/gruvbox.rasi"` — copies to clipboard rather than typing
directly, since typing would need `wtype`/`ydotool`, neither of which are
installed.

## Window rules (`windowrules.lua`)

- `suppress-maximize-events` — ignores maximize requests from all apps
  (matches `class = ".*"`).
- `fix-xwayland-drags` — `no_focus` on empty-class/title floating XWayland
  windows, works around an XWayland drag bug.

## Keybindings (`binds.lua`)

Programs referenced: `ghostty` (terminal), `nemo` (files), `rofi -show drun`
(launcher), `rofi -show run` (runner), `helium-browser`, `spotify`, and Notion
as a browser SSA (`--app=https://notion.so`).

`mainMod` = `SUPER`, `secondMod` = `SUPER+SHIFT`.

**Launch apps**
| Bind | Action |
|---|---|
| `SUPER T` | Terminal (ghostty) |
| `SUPER F` | File manager (nemo) |
| `SUPER B` | Browser |
| `SUPER M` | Spotify |
| `SUPER N` | Notion (browser app mode) |
| `SUPER Space` | App launcher (rofi drun) |
| `SUPER+SHIFT Space` | Run menu (rofi run) |
| `SUPER+SHIFT N` | Toggle notification center (swaync) |
| `SUPER V` | Clipboard history (`scripts/clipboard.sh`) |
| `SUPER+SHIFT Period` | Emoji / unicode picker (rofimoji, copies to clipboard) |

**Session / system**
| Bind | Action |
|---|---|
| `SUPER L` | Lock screen (hyprlock) |
| `SUPER+SHIFT M` | Power menu (`wlogout -b 5`) |
| `SUPER+SHIFT P` | Cycle power profile (`scripts/power-profile.sh`) |
| `SUPER+SHIFT I` | Toggle night light override (`scripts/nightlight-toggle.sh`) |

**Screenshots / color / recording**
| Bind | Action |
|---|---|
| `SUPER+SHIFT A` | Region screenshot → `~/Pictures/Screenshots` |
| `SUPER+SHIFT W` | Window screenshot |
| `SUPER+SHIFT D` | Full display screenshot |
| `SUPER+SHIFT E` | Region screenshot → annotate in `satty` |
| `SUPER+SHIFT C` | Color picker (`hyprpicker -a`, hex → clipboard) |
| `SUPER+SHIFT R` | Toggle screen recording (`scripts/record.sh`) |

**Windows**
| Bind | Action |
|---|---|
| `SUPER Q` | Close window |
| `SUPER P` | Pseudo-tile |
| `SUPER+SHIFT Tab` | Cycle to next window |
| `SUPER ←/→/↑/↓` | Move focus |
| `SUPER+SHIFT ←/→/↑/↓` | Move window |
| `SUPER+SHIFT T` | Toggle floating |
| `SUPER+SHIFT F` | Fullscreen (maximized mode) |
| `SUPER` + LMB drag | Move window |
| `SUPER` + RMB drag | Resize window |

**Workspaces**
| Bind | Action |
|---|---|
| `SUPER 0-9` | Go to workspace 1-10 |
| `SUPER+SHIFT 0-9` | Move window to workspace 1-10 |
| `SUPER Tab` | Toggle to last-used workspace (`workspace previous`, alt-tab style) |
| `SUPER S` | Toggle special scratchpad ("magic") |
| `SUPER+SHIFT S` | Move window to scratchpad |
| `SUPER` + scroll | Next/previous workspace |

**Media / hardware keys** (locked binds, work even when input-inhibited)
| Key | Action |
|---|---|
| Volume Up/Down | `swayosd-client --output-volume raise/lower` (repeating) |
| Mute | `swayosd-client --output-volume mute-toggle` |
| Mic Mute | `swayosd-client --input-volume mute-toggle` |
| Brightness Up/Down | `swayosd-client --brightness raise/lower` (repeating) |
| Next/Prev/Play-Pause | `playerctl` |

## Scripts

All rofi-based pickers share the theme `~/.config/rofi/gruvbox.rasi`.

- **`wallpaper.sh`** — starts `awww-daemon` if not running, sets wallpaper
  with a grow/center transition. `WALL` at the top of the file is the single
  source of truth for which image is active — edit that path to change
  wallpaper.
- **`clipboard.sh`** — `cliphist list` piped through rofi, decodes the
  selection back to `wl-copy`.
- **`wifi-menu.sh`** — lists SSIDs via `nmcli`, sorted by signal, de-duplicated;
  toggles Wi-Fi radio; prompts for password on new networks via a rofi
  password field.
- **`bluetooth-menu.sh`** — powers on/off, backgrounds a 5s scan, lists
  devices with connected-state icons, connects/pairs/disconnects on
  selection.
- **`power-profile.sh`** — cycles `power-profiles-daemon` through
  performance → balanced → power-saver, notifies which one is now active.
- **`record.sh`** — `wf-recorder` start/stop toggle; stops via `SIGINT` so the
  output file finalizes correctly. Saves to `~/Videos/Recordings/`.
- **`nightlight-toggle.sh`** — flips `hyprsunset` into `identity` mode (filter
  off) and back, tracked with a flag file in `$XDG_RUNTIME_DIR` so the bind is
  a true toggle across presses.

## Ecosystem (sibling configs, same theme)

These aren't part of `~/.config/hypr` but are launched by it and share the
Gruvbox Material palette:

| Path | Role |
|---|---|
| `~/.config/waybar/` | status bar (`config.jsonc`, `style.css`, `colors/`) |
| `~/.config/rofi/` | launcher/menu theming (`gruvbox.rasi`) |
| `~/.config/swaync/` | notification center |
| `~/.config/wlogout/` | power menu layout/style |
| `~/.config/ghostty/` | terminal — Gruvbox Material palette, matches desktop |

## External dependencies

Beyond Hyprland itself, this config assumes these binaries are installed:
`waybar`, `swaync`, `hypridle`, `hyprlock`, `swayosd-server`/`swayosd-client`,
`hyprpolkitagent`, `xdg-desktop-portal-hyprland`, `wl-paste`/`cliphist`,
`wl-copy`, `awww` (wallpaper daemon), `rofi`, `rofimoji`, `nemo`, `ghostty`,
`helium-browser`, `spotify`, `wlogout`, `hyprshot`, `satty`, `hyprpicker`,
`playerctl`, `brightnessctl`, `bluetoothctl`, `nmcli`, `loginctl`,
`power-profiles-daemon`, `hyprsunset`, `wf-recorder`, `Bibata-Modern-Ice`
cursor theme, `Iosevka Nerd Font Propo`.

`power-profiles-daemon` also needs its systemd **system** service enabled:
`systemctl enable --now power-profiles-daemon.service`.

## Version control

`~/.config/hypr` is a git repo (`git -C ~/.config/hypr log`). Commit after any
change you want to keep — this is what makes `hyprctl reload` experiments
safe to roll back.

## Maintenance notes

- Keep edits scoped to the relevant module — e.g. color changes go in
  `decorations.lua`, not scattered across files.
- `.luarc.json` points the Lua LSP at Hyprland's stubs
  (`/usr/share/hypr/stubs`) for autocomplete/type-checking in editors; keep it
  if you edit these files with LSP support.
- If you fork this for another machine, the paths most likely to need
  changing are: `monitors.lua` (output name), `scripts/wallpaper.sh` (`WALL`
  path), and the hardcoded absolute script paths in `binds.lua`
  (`/home/iyano/.config/hypr/scripts/...`).
