---------------------
---- MY PROGRAMS ----
---------------------

local terminal    = "ghostty"
local fileManager = "nemo"
local launcher    = "rofi -show drun -show-icons"
local runner      = "rofi -show run"
local browser     = "helium-browser"
local music       = "spotify"
local notion      = browser .. " --app=https://notion.so"

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod     = "SUPER" -- Sets "Windows" key as main modifier
local secondMod   = "SUPER+SHIFT"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd(music))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd(notion))
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd(launcher))
hl.bind(secondMod .. " + Space", hl.dsp.exec_cmd(runner))
hl.bind(secondMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw")) -- toggle notification center
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("/home/iyano/.config/hypr/scripts/clipboard.sh")) -- clipboard history

local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- Lock + power menu
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(secondMod .. " + M", hl.dsp.exec_cmd("wlogout -b 5"))

-- Screenshots (saved to ~/Pictures/Screenshots and copied to clipboard)
hl.bind(secondMod .. " + A", hl.dsp.exec_cmd("hyprshot -m region -o ~/Pictures/Screenshots")) -- Area
hl.bind(secondMod .. " + W", hl.dsp.exec_cmd("hyprshot -m window -o ~/Pictures/Screenshots")) -- Window
hl.bind(secondMod .. " + D", hl.dsp.exec_cmd("hyprshot -m output -o ~/Pictures/Screenshots")) -- Display
hl.bind(secondMod .. " + E", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -")) -- Edit/annotate

-- Colour picker (hex copied to clipboard)
hl.bind(secondMod .. " + C", hl.dsp.exec_cmd("hyprpicker -a"))


-- hl.bind(mainMod .. " + R", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
-- hl.bind(mainMod .. " + J", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move window with mainMod + arrow keys
hl.bind(secondMod .. " + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(secondMod .. " + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(secondMod .. " + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(secondMod .. " + down", hl.dsp.window.move({ direction = "down" }))

hl.bind(secondMod .. " + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(secondMod .. " + F", hl.dsp.window.fullscreen({ mode = "maximized" }))
-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(secondMod .. " + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
-- Volume / brightness via swayosd (shows an on-screen popup)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"),
    { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"),
    { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("swayosd-client --input-volume mute-toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"),
    { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"),
    { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Cycle focus through open windows (alt-tab style)
hl.bind(secondMod .. " + Tab", hl.dsp.window.cycle_next())

-- Toggle back and forth to the last-used workspace (alt-tab style, for workspaces)
hl.bind(mainMod .. " + Tab", hl.dsp.focus({ workspace = "previous" }))

-- Cycle power-profiles-daemon profile (requires power-profiles-daemon)
hl.bind(secondMod .. " + P", hl.dsp.exec_cmd("/home/iyano/.config/hypr/scripts/power-profile.sh"))

-- Screen recording toggle (requires wf-recorder)
hl.bind(secondMod .. " + R", hl.dsp.exec_cmd("/home/iyano/.config/hypr/scripts/record.sh"))

-- Emoji / unicode picker (requires rofimoji). Copies to clipboard rather than
-- typing directly, since typing needs wtype/ydotool which aren't installed.
hl.bind(secondMod .. " + Period",
    hl.dsp.exec_cmd("rofimoji --action copy --selector-args=\"-theme $HOME/.config/rofi/gruvbox.rasi\""))

-- Toggle night light off temporarily (requires hyprsunset)
hl.bind(secondMod .. " + I", hl.dsp.exec_cmd("/home/iyano/.config/hypr/scripts/nightlight-toggle.sh"))
