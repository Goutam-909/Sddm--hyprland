-- ╔══════════════════════════════════════════════════════════════════╗
-- ║          SDDM / Hyprland 0.55+ Lua compositor config            ║
-- ║  Replaces: /usr/share/hypr/sddm/hyprland.conf                   ║
-- ╚══════════════════════════════════════════════════════════════════╝

-- ── Cursor ────────────────────────────────────────────────────────────────────
hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
--hl.env("HYPRCURSOR_SIZE", "24")
-- ── Ecosystem ─────────────────────────────────────────────────────────────────
hl.config({
    ecosystem = {
        enforce_permissions  = false,
        no_update_news       = true,
        no_donation_nag      = true,
    },
})

-- ── Core misc / splash ────────────────────────────────────────────────────────
hl.config({
    misc = {
        disable_hyprland_logo     = true,
        disable_splash_rendering  = true,
        force_default_wallpaper   = 0,
            initial_workspace_tracking = 1,
    },
})

-- ── Input ─────────────────────────────────────────────────────────────────────
hl.config({
    input = {
        numlock_by_default = true,
        kb_layout          = "us,de,es",
    },
})

-- ── Cursor settings ───────────────────────────────────────────────────────────
hl.config({
    cursor = {
        no_warps            = true,
        no_hardware_cursors = true,
    },
})

-- ── Monitor ───────────────────────────────────────────────────────────────────
-- Auto-detect all connected monitors: use their preferred resolution,
-- position them automatically side-by-side, at 1x scale.
-- To pin a specific monitor add more hl.monitor() calls below, e.g.:
--   hl.monitor({ output = "eDP-1", mode = "1920x1080@60", position = "0x0", scale = "1" })
hl.monitor({
    output   = "",        -- "" = catch-all / every monitor
    mode     = "preferred",
    position = "auto",
    scale    = "1",
})


--hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")

-- ── Window rules for the SDDM greeter ────────────────────────────────────────
-- These keep the greeter borderless, fully-covering, and instant.
-- (Only applies when using xdg-shell compositor mode.)
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, fullscreen     = true  })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, border_size    = 0     })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, decorate       = false })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, no_anim        = true  })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, no_dim         = true  })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, rounding       = 0     })
hl.window_rule({ match = { class = "^(sddm-greeter)$" }, no_shadow      = true  })

-- ── Keyboard layout switcher ──────────────────────────────────────────────────
hl.bind("SUPER + K",
        hl.dsp.exec_cmd("hyprctl switchxkblayout all next -q"),
        { description = "Cycle keyboard layout" })

-- ── User overrides (hyprprefs equivalent) ────────────────────────────────────
-- Create /usr/share/hypr/sddm/hyprprefs.lua and add overrides there.
-- The pcall makes it optional — no error if the file is absent.
pcall(require, "hyprprefs")
