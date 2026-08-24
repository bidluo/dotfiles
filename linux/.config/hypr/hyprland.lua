
-- This is an example Hyprland Lua config file.
-- Refer to the wiki for more information.
-- https://wiki.hypr.land/Configuring/Start/

-- Please note not all available settings / options are set here.
-- For a full list, see the wiki

-- You can (and should!!) split this configuration into multiple files
-- Create your files separately and then require them like this:
-- require("myColors")


------------------
---- MONITORS ----
------------------

-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- Matched by physical description, NOT connector name: DisplayPort names
-- (DP-1/DP-2) shuffle between reboots on this machine, which previously left
-- the AOC unmatched and — worse — broke hyprlock's monitor-pinned password
-- field, causing a full lockout. desc: is tied to the panel, so it is stable.
-- AOC 24G4, left. 180 Hz gaming panel: "preferred" EDID mode was pinning it to
-- 60 Hz, so the refresh rate is set explicitly. Hyprland falls back to the
-- closest available mode if 180 is ever unavailable.
hl.monitor({
    output   = "desc:AOC 24G4 12VQCHA004334",
    mode     = "1920x1080@180",
    position = "0x0",
    scale    = "auto",
})

-- Dell P2425HE, right. Panel tops out at 100 Hz; request it explicitly rather
-- than the 60 Hz EDID-preferred mode.
hl.monitor({
    output   = "desc:Dell Inc. DELL P2425HE 9VZ1764",
    mode     = "1920x1080@100",
    position = "1920x0",
    scale    = "auto",
})

-- Catch-all so an unknown output still gets placed somewhere sane
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})


--------------------
---- WORKSPACES ----
--------------------

-- Confine workspaces to monitors: 1-5 always on the AOC, 6-10 on the Dell.
-- persistent = true keeps them alive when empty, so all five always show
-- (numbered) in that monitor's bar. desc: matching keeps the binding stable
-- across DP renumbering, exactly like the monitor rules above.
local AOC  = "desc:AOC 24G4 12VQCHA004334"
local DELL = "desc:Dell Inc. DELL P2425HE 9VZ1764"
for i = 1, 10 do
    hl.workspace_rule({
        workspace  = tostring(i),
        monitor    = (i <= 5) and AOC or DELL,
        persistent = true,
        default    = (i == 1 or i == 6),  -- the landing workspace on each monitor
    })
end


---------------------
---- MY PROGRAMS ----
---------------------

-- Set programs that you use
local terminal    = "kitty"
local fileManager = "thunar"
local menu        = "fuzzel"


-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:
--
-- Note: xdg-desktop-portal-hyprland is dbus-activated; launching it here is
-- unnecessary and racy.
hl.on("hyprland.start", function()
    -- DankMaterialShell (Quickshell) is the desktop shell: bar, launcher,
    -- notifications, wallpaper (dynamic Material You), polkit agent and OSD.
    -- It replaces waybar + swaybg + mako + hyprpolkitagent, and restores the
    -- saved wallpaper + dynamic theme on its own. Daemonised so a crash can
    -- restart without taking the session down.
    hl.exec_cmd("dms run -d")
    -- Idle management deliberately stays with hypridle + idle-guard (which pause
    -- the dim/lock/DPMS timers while CPU or GPU is busy — sims, renders, VR
    -- transcodes). DMS's own idle monitor is left disabled so render protection
    -- remains the single source of truth. Started here because Hyprland does not
    -- reach graphical-session.target.
    hl.exec_cmd("hypridle")
    hl.exec_cmd("systemctl --user start idle-guard.service")
    hl.exec_cmd("wl-paste --type text  --watch cliphist store")
    hl.exec_cmd("wl-paste --type image --watch cliphist store")
end)


-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Environment-variables/

hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")
hl.env("XCURSOR_THEME", "Bibata-Modern-Ice")

-- Qt apps (ZapZap, qt6ct-themed): use qt6ct so they pick up the matugen palette.
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")

-- Electron apps (1Password, VS Code, Discord, Slack) default to XWayland, which
-- renders blurry and ignores Wayland fractional scaling. "auto" makes them pick
-- the native Wayland backend when one is available.
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")


-----------------------
----- PERMISSIONS -----
-----------------------

-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Permissions/
-- Please note permission changes here require a Hyprland restart and are not applied on-the-fly
-- for security reasons

-- hl.config({
--   ecosystem = {
--     enforce_permissions = true,
--   },
-- })

-- hl.permission("/usr/(bin|local/bin)/grim", "screencopy", "allow")
-- hl.permission("/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", "screencopy", "allow")
-- hl.permission("/usr/(bin|local/bin)/hyprpm", "plugin", "allow")


-----------------------
---- LOOK AND FEEL ----
-----------------------

-- Wallpaper-driven palette, regenerated by matugen/nocturne-render into
-- ~/.config/hypr/colors.lua on every theme change. dofile (not require) so a
-- plain `hyprctl reload` always re-reads it. Falls back to the signature
-- cyan→mint gradient if it has not been generated yet.
local ok, Colors = pcall(dofile, os.getenv("HOME") .. "/.config/hypr/colors.lua")
if not ok or type(Colors) ~= "table" then
    Colors = {
        active   = { "rgba(33ccffee)", "rgba(00ff99ee)" },
        inactive = "rgba(595959aa)",
    }
end

-- Refer to https://wiki.hypr.land/Configuring/Basics/Variables/
hl.config({
    general = {
        gaps_in  = 8,
        gaps_out = 8,

        border_size = 2,

        col = {
            active_border   = { colors = Colors.active, angle = 45 },
            inactive_border = Colors.inactive,
        },

        -- Set to true to enable resizing windows by clicking and dragging on borders and gaps
        resize_on_border = false,

        -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing/ before you turn this on
        allow_tearing = false,

        layout = "dwindle",
    },

    decoration = {
        rounding       = 10,
        rounding_power = 2,

        -- Change transparency of focused and unfocused windows
        active_opacity   = 1.0,
        inactive_opacity = 1.0,

        shadow = {
            enabled      = true,
            range        = 4,
            render_power = 3,
            color        = 0xee1a1a1a,
        },

        blur = {
            enabled   = true,
            size      = 3,
            passes    = 1,
            vibrancy  = 0.1696,
        },
    },

    animations = {
        enabled = true,
    },
})

-- Default curves and animations, see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("linear",         { type = "bezier", points = { {0, 0},       {1, 1}       } })
hl.curve("almostLinear",   { type = "bezier", points = { {0.5, 0.5},   {0.75, 1}    } })
hl.curve("quick",          { type = "bezier", points = { {0.15, 0},    {0.1, 1}     } })

-- Default springs
hl.curve("easy",           { type = "spring", mass = 1, stiffness = 71.2633, dampening = 15.8273644 })

hl.animation({ leaf = "global",        enabled = true,  speed = 10,   bezier = "default" })
hl.animation({ leaf = "border",        enabled = true,  speed = 5.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows",       enabled = true,  speed = 4.79, spring = "easy" })
hl.animation({ leaf = "windowsIn",     enabled = true,  speed = 4.1,  spring = "easy",         style = "popin 87%" })
hl.animation({ leaf = "windowsOut",    enabled = true,  speed = 1.49, bezier = "linear",       style = "popin 87%" })
hl.animation({ leaf = "fadeIn",        enabled = true,  speed = 1.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut",       enabled = true,  speed = 1.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade",          enabled = true,  speed = 3.03, bezier = "quick" })
hl.animation({ leaf = "layers",        enabled = true,  speed = 3.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn",      enabled = true,  speed = 4,    bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut",     enabled = true,  speed = 1.5,  bezier = "linear",       style = "fade" })
hl.animation({ leaf = "fadeLayersIn",  enabled = true,  speed = 1.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true,  speed = 1.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces",    enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesIn",  enabled = true,  speed = 1.21, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "workspacesOut", enabled = true,  speed = 1.94, bezier = "almostLinear", style = "fade" })
hl.animation({ leaf = "zoomFactor",    enabled = true,  speed = 7,    bezier = "quick" })

-- Ref https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/
-- "Smart gaps" / "No gaps when only"
-- uncomment all if you wish to use that.
-- hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
-- hl.workspace_rule({ workspace = "f[1]",   gaps_out = 0, gaps_in = 0 })
-- hl.window_rule({
--     name  = "no-gaps-wtv1",
--     match = { float = false, workspace = "w[tv1]" },
--     border_size = 0,
--     rounding    = 0,
-- })
-- hl.window_rule({
--     name  = "no-gaps-f1",
--     match = { float = false, workspace = "f[1]" },
--     border_size = 0,
--     rounding    = 0,
-- })

-- See https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/ for more
hl.config({
    dwindle = {
        preserve_split = true, -- You probably want this
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Master-Layout/ for more
hl.config({
    master = {
        new_status = "master",
    },
})

-- See https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/ for more
hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})

----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper = -1,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo   = false, -- If true disables the random hyprland logo / anime girl background. :(

        -- THE RECOVERY NET. Default is false: if the session-lock client dies
        -- while holding the lock, Hyprland stays locked forever, painting solid
        -- black on every output with nothing left to accept a password — only a
        -- hard reset escapes. That is what ate the session on 2026-08-15.
        -- true lets a fresh lock client re-attach to the orphaned lock instead.
        allow_session_lock_restore = true,
    },
})


---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout  = "us",
        kb_variant = "",
        kb_model   = "",
        kb_options = "",
        kb_rules   = "",

        follow_mouse = 1,

        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.

        touchpad = {
            natural_scroll = false,
        },
    },
})

hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace"
})

-- Example per-device config
-- See https://wiki.hypr.land/Configuring/Advanced-and-Cool/Devices/ for more
hl.device({
    name        = "epic-mouse-v1",
    sensitivity = -0.5,
})


---------------------
---- KEYBINDINGS ----
---------------------
--
-- macOS modifier model, for switching between this box and a Mac with as little
-- friction as possible. The NuPhy Halo75 is in Mac mode, so the bottom row is
-- physically Ctrl / Opt / Cmd and maps to CTRL / ALT / SUPER. No xkb remap is
-- used: swapping modifiers at the layout level would make the Cmd key emit a
-- real Ctrl, which would break Ctrl+C-as-SIGINT in every terminal.
--
--   SUPER (Cmd)  -> application shortcuts, translated to Ctrl
--   ALT   (Opt)  -> word-wise text navigation
--   CTRL         -> spaces / workspaces
--   SUPER+CTRL   -> window management (macOS uses Ctrl+Cmd for fullscreen & lock)

local mainMod = "SUPER" -- Cmd

-- LIMITATION, established empirically against this build (0.55.4):
-- hl.dsp.send_shortcut accepts exactly ONE modifier. "CTRL SHIFT", "CTRL+SHIFT",
-- "CTRL,SHIFT", numeric modmasks and Lua tables all dispatch "ok" but deliver
-- nothing at all -- and a bogus modifier silently degrades to no modifier rather
-- than erroring. Anything below needing two modifiers is therefore unavailable;
-- see the notes at the end of this section.
--
-- It does bypass Hyprland's own keybind processing (verified: sending CTRL+2
-- while CTRL+2 is bound to "workspace 2" delivers to the app and does NOT switch
-- workspace), so translating onto a combo that is itself bound is safe.
local function send(mods, key)
    return hl.dsp.send_shortcut({ mods = mods, key = key })
end


---- Text navigation ---------------------------------------------------------
-- Option = by word
hl.bind("ALT + left",      send("CTRL", "left"))
hl.bind("ALT + right",     send("CTRL", "right"))
hl.bind("ALT + BackSpace", send("CTRL", "BackSpace"))

-- Cmd = line / document
hl.bind(mainMod .. " + left",          send("",      "Home"))
hl.bind(mainMod .. " + right",         send("",      "End"))
hl.bind(mainMod .. " + up",            send("CTRL",  "Home"))
hl.bind(mainMod .. " + down",          send("CTRL",  "End"))
hl.bind(mainMod .. " + SHIFT + left",  send("SHIFT", "Home"))
hl.bind(mainMod .. " + SHIFT + right", send("SHIFT", "End"))


---- Cmd as the application modifier -----------------------------------------
local TERMINALS = {
    kitty = true, foot = true, alacritty = true, wezterm = true, ghostty = true,
}

local function active_terminal()
    local w = hl.get_active_window()
    if w and TERMINALS[(w.class or ""):lower()] then return w end
    return nil
end

-- Copy/paste/tabs need different keys in a terminal (Ctrl+C is SIGINT), and we
-- cannot synthesize Ctrl+Shift+C because of the one-modifier limit. So in a
-- terminal we forward the original Cmd+<key> and let the terminal's own config
-- handle it -- see ~/.config/kitty/kitty.conf, which maps super+c and friends.
-- If the forward ever fails the key simply does nothing, which is the correct
-- direction to fail in: the alternative would be sending Ctrl+C and killing
-- whatever is running.
local function cmd_or_forward(key)
    return function()
        local term = active_terminal()
        if term then
            hl.dispatch(hl.dsp.pass({ window = "address:" .. term.address }))
        else
            hl.dispatch(hl.dsp.send_shortcut({ mods = "CTRL", key = key }))
        end
    end
end

local TERMINAL_AWARE = { "c", "v", "t", "w", "n" }
for _, k in ipairs(TERMINAL_AWARE) do
    hl.bind(mainMod .. " + " .. k, cmd_or_forward(k))
end

-- Every other Cmd+<letter> translates straight to Ctrl+<letter>. Blanket
-- coverage is deliberate: a hand-picked list means Cmd+B for bold silently does
-- nothing, which is its own kind of friction.
local CMD_SKIP = { q = true }          -- q is close-window, below
for _, k in ipairs(TERMINAL_AWARE) do CMD_SKIP[k] = true end

for c in ("abcdefghijklmnopqrstuvwxyz"):gmatch(".") do
    if not CMD_SKIP[c] then
        hl.bind(mainMod .. " + " .. c, send("CTRL", c))
    end
end

-- Cmd+<digit> -> Ctrl+<digit> (browser tab switching, etc).
for d = 0, 9 do
    hl.bind(mainMod .. " + " .. d, send("CTRL", tostring(d)))
end

-- Cmd actions that are genuinely window-manager operations on macOS too.
hl.bind(mainMod .. " + Q",     hl.dsp.window.close())        -- Cmd+Q quit
hl.bind(mainMod .. " + Space", hl.dsp.exec_cmd("dms ipc call spotlight toggle"))  -- Cmd+Space → DMS launcher
hl.bind(mainMod .. " + Tab",   hl.dsp.window.cycle_next())   -- Cmd+Tab app switcher


---- Spaces ------------------------------------------------------------------
-- Now that word-jump lives on Option, CTRL+arrows is free and takes its macOS
-- meaning. This is why the whole model hangs together.
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind("CTRL + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind("CTRL + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind("CTRL + left",  hl.dsp.focus({ workspace = "e-1" }))
hl.bind("CTRL + right", hl.dsp.focus({ workspace = "e+1" }))


---- Window management: SUPER+CTRL (Cmd+Ctrl) --------------------------------
local wm = mainMod .. " + CTRL"

hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))  -- Cmd+Enter
hl.bind(wm .. " + Return", hl.dsp.exec_cmd(terminal))       -- Cmd+Ctrl+Enter (kept)
hl.bind(wm .. " + E",      hl.dsp.exec_cmd(fileManager))
hl.bind(wm .. " + W",      hl.dsp.exec_cmd("/home/david/.local/bin/wall"))  -- wallpaper picker → recolors everything
-- macOS Ctrl+Cmd+Q. Goes through logind rather than launching a locker directly,
-- so there is exactly ONE lock client (DMS, via loginctlLockIntegration) and one
-- canonical path — hypridle's timer, before_sleep, and this bind all emit the
-- same signal. The old ~/.local/bin/lock spawned hyprlock alongside the DMS lock
-- and the two raced for ext_session_lock_v1; see hypridle.conf for the fallout.
hl.bind(wm .. " + Q",      hl.dsp.exec_cmd("loginctl lock-session"))
hl.bind(wm .. " + F",         hl.dsp.window.fullscreen({ mode = "maximized" }))  -- Ctrl+Cmd+F: maximize (keeps bar + gaps)
hl.bind(wm .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen" })) -- Ctrl+Cmd+Shift+F: true edge-to-edge (games)
hl.bind(wm .. " + T",         hl.dsp.layout("togglesplit"))
hl.bind(wm .. " + P",         hl.dsp.window.pseudo())
hl.bind(wm .. " + Space",     hl.dsp.window.float({ action = "toggle" }))         -- float toggle (moved off Shift+F)
hl.bind(wm .. " + SHIFT + Escape", hl.dsp.exit())

hl.bind(wm .. " + V", hl.dsp.exec_cmd(
    "sh -c 'cliphist list | fuzzel --dmenu | cliphist decode | wl-copy'"))

-- Notifications are handled by DMS now: N toggles the notification center
-- (full history), Shift+N clears all, D dismisses the active popups.
-- Sleep the displays; they stay off until the cursor moves. The script polls
-- the cursor itself (an independent wake path, since DPMS wake-on-input is only
-- ~80% reliable on NVIDIA + Wayland) and wakes from a trap if killed. No timed
-- force-wake, so a manual sleep does not switch itself back on.
hl.bind(wm .. " + SHIFT + Q", hl.dsp.exec_cmd("/home/david/.local/bin/sleep-displays"))

hl.bind(wm .. " + N",         hl.dsp.exec_cmd("dms ipc call notifications toggle"))
hl.bind(wm .. " + SHIFT + N", hl.dsp.exec_cmd("dms ipc call notifications clearAll"))
hl.bind(wm .. " + D",         hl.dsp.exec_cmd("dms ipc call notifications dismissAllPopups"))

-- Focus
hl.bind(wm .. " + h", hl.dsp.focus({ direction = "left"  }))
hl.bind(wm .. " + l", hl.dsp.focus({ direction = "right" }))
hl.bind(wm .. " + k", hl.dsp.focus({ direction = "up"    }))
hl.bind(wm .. " + j", hl.dsp.focus({ direction = "down"  }))

-- Move window
hl.bind(wm .. " + SHIFT + h", hl.dsp.window.move({ direction = "left"  }))
hl.bind(wm .. " + SHIFT + l", hl.dsp.window.move({ direction = "right" }))
hl.bind(wm .. " + SHIFT + k", hl.dsp.window.move({ direction = "up"    }))
hl.bind(wm .. " + SHIFT + j", hl.dsp.window.move({ direction = "down"  }))

-- Resize
local RESIZE_STEP = 60
hl.bind(mainMod .. " + ALT + h", hl.dsp.window.resize({ x = -RESIZE_STEP, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + l", hl.dsp.window.resize({ x =  RESIZE_STEP, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + k", hl.dsp.window.resize({ x = 0, y = -RESIZE_STEP, relative = true }), { repeating = true })
hl.bind(mainMod .. " + ALT + j", hl.dsp.window.resize({ x = 0, y =  RESIZE_STEP, relative = true }), { repeating = true })

-- Splits: preselect a direction in the dwindle layout, then open a terminal.
local function spawn_toward(dir)
    return function()
        hl.dispatch(hl.dsp.layout("preselect " .. dir))
        hl.dispatch(hl.dsp.exec_cmd(terminal))
    end
end

hl.bind(wm .. " + backslash", spawn_toward("r"))
hl.bind(wm .. " + minus",     spawn_toward("d"))
hl.bind(wm .. " + left",      spawn_toward("l"))
hl.bind(wm .. " + right",     spawn_toward("r"))
hl.bind(wm .. " + up",        spawn_toward("u"))
hl.bind(wm .. " + down",      spawn_toward("d"))

-- Swap panes
hl.bind(wm .. " + bracketleft",  hl.dsp.window.swap({ direction = "left"  }))
hl.bind(wm .. " + bracketright", hl.dsp.window.swap({ direction = "right" }))

-- Scratchpad
hl.bind(wm .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(wm .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))


---- Screenshots -------------------------------------------------------------
-- macOS: Cmd+Shift+3 whole screen, Cmd+Shift+4 region.
hl.bind(mainMod .. " + SHIFT + 3", hl.dsp.exec_cmd(
    "sh -c 'grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png'"))
hl.bind(mainMod .. " + SHIFT + 4", hl.dsp.exec_cmd(
    "sh -c 'grim -g \"$(slurp)\" - | wl-copy'"))
hl.bind("Print",         hl.dsp.exec_cmd("sh -c 'grim -g \"$(slurp)\" - | wl-copy'"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd(
    "sh -c 'grim ~/Pictures/Screenshots/$(date +%Y%m%d-%H%M%S).png'"))


---- Mouse -------------------------------------------------------------------
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })


-- NOT MAPPED, because send_shortcut only takes one modifier:
--   Opt+Shift+arrows   select by word   (would need Ctrl+Shift+Left)
--   Cmd+Shift+<letter> redo, reopen tab (would need Ctrl+Shift+Z / Ctrl+Shift+T)
-- Cmd+Shift+arrows DOES work, because Shift+Home/Shift+End is a single modifier.

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })


--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

-- Example window rules that are useful

local suppressMaximizeRule = hl.window_rule({
    -- Ignore maximize requests from all apps. You'll probably like this.
    name  = "suppress-maximize-events",
    match = { class = ".*" },

    suppress_event = "maximize",
})
-- suppressMaximizeRule:set_enabled(false)

hl.window_rule({
    -- Fix some dragging issues with XWayland
    name  = "fix-xwayland-drags",
    match = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },

    no_focus = true,
})

-- Frosted glass behind the fuzzel launcher (its layer namespace is "launcher").
-- blur + a slight dim of everything behind it, matching the desktop's look.
hl.layer_rule({
    name       = "fuzzel-blur",
    match      = { namespace = "^launcher$" },
    blur       = true,
    ignore_alpha = 0.2,   -- don't blur through the near-opaque body, only the edges/gaps
    dim_around = true,
})

-- Layer rules also return a handle.
-- local overlayLayerRule = hl.layer_rule({
--     name  = "no-anim-overlay",
--     match = { namespace = "^my-overlay$" },
--     no_anim = true,
-- })
-- overlayLayerRule:set_enabled(false)

-- Hyprland-run windowrule
hl.window_rule({
    name  = "move-hyprland-run",
    match = { class = "hyprland-run" },

    move  = "20 monitor_h-120",
    float = true,
})
