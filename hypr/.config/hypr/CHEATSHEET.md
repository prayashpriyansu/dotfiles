# Cheatsheet — Apps & Keybindings

Quick reference. For the full explanation of *why* things are configured this
way, see [README.md](README.md).

`mainMod` = `SUPER` · `secondMod` = `SUPER+SHIFT`

## Apps

| App | Role |
|---|---|
| ghostty | Terminal |
| nemo | File manager |
| rofi | App launcher / run menu / picker frontend (theme: `~/.config/rofi/gruvbox.rasi`) |
| helium-browser | Browser |
| spotify | Music |
| Notion (browser app mode) | Notes |
| waybar | Status bar |
| swaync | Notification center |
| hypridle / hyprlock | Idle timeout + lock screen |
| swayosd | Volume / brightness OSD popups |
| wlogout | Power menu |
| hyprshot | Screenshots |
| satty | Screenshot annotation |
| hyprpicker | Color picker |
| cliphist | Clipboard history |
| playerctl | Media key control |
| nmcli / bluetoothctl | Wi-Fi / Bluetooth pickers (`scripts/wifi-menu.sh`, `scripts/bluetooth-menu.sh`) |
| power-profiles-daemon | Battery/performance profile switching |
| hyprsunset | Night light / blue-light filter |
| wf-recorder | Screen recording |
| rofimoji | Emoji / unicode picker |

## Keybindings

### Launch
| Bind | Action |
|---|---|
| `SUPER T` | Terminal |
| `SUPER F` | File manager |
| `SUPER B` | Browser |
| `SUPER M` | Spotify |
| `SUPER N` | Notion |
| `SUPER Space` | App launcher (rofi drun) |
| `SUPER+SHIFT Space` | Run menu (rofi run) |
| `SUPER+SHIFT N` | Toggle notification center |
| `SUPER V` | Clipboard history |
| `SUPER+SHIFT Period` | Emoji / unicode picker (copies to clipboard) |

### Session
| Bind | Action |
|---|---|
| `SUPER L` | Lock screen |
| `SUPER+SHIFT M` | Power menu |
| `SUPER+SHIFT P` | Cycle power profile (performance → balanced → power-saver) |
| `SUPER+SHIFT I` | Toggle night light override |

### Screenshots / capture
| Bind | Action |
|---|---|
| `SUPER+SHIFT A` | Screenshot: region |
| `SUPER+SHIFT W` | Screenshot: window |
| `SUPER+SHIFT D` | Screenshot: full display |
| `SUPER+SHIFT E` | Screenshot: region → annotate (satty) |
| `SUPER+SHIFT C` | Color picker (hex → clipboard) |
| `SUPER+SHIFT R` | Toggle screen recording (saved to `~/Videos/Recordings`) |

### Windows
| Bind | Action |
|---|---|
| `SUPER Q` | Close window |
| `SUPER P` | Pseudo-tile |
| `SUPER+SHIFT Tab` | Cycle to next window |
| `SUPER ←/→/↑/↓` | Move focus |
| `SUPER+SHIFT ←/→/↑/↓` | Move window |
| `SUPER+SHIFT T` | Toggle floating |
| `SUPER+SHIFT F` | Fullscreen (maximized) |
| `SUPER` + drag LMB | Move window |
| `SUPER` + drag RMB | Resize window |

### Workspaces
| Bind | Action |
|---|---|
| `SUPER 0-9` | Go to workspace 1-10 |
| `SUPER+SHIFT 0-9` | Move window to workspace 1-10 |
| `SUPER Tab` | Toggle to last-used workspace (alt-tab style) |
| `SUPER S` | Toggle scratchpad ("magic") |
| `SUPER+SHIFT S` | Move window to scratchpad |
| `SUPER` + scroll | Next/previous workspace |

### Media / hardware keys
| Key | Action |
|---|---|
| Volume Up/Down | Raise/lower volume |
| Mute / Mic Mute | Toggle mute |
| Brightness Up/Down | Raise/lower brightness |
| Next/Prev/Play-Pause | Media control (playerctl) |
