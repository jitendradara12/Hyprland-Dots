-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User window-rule overrides template.
-- Add, override, or customize personal window rules here.
--
-- =============================================================================
-- WINDOW RULE SYNTAX & PROPERTIES (KoolDots Lua)
-- =============================================================================
-- • apply_window_rule({
--     name = "unique-rule-identifier",
--     match = {
--       class = "regex_pattern",          -- Matches window class (WM_CLASS)
--       title = "regex_pattern",          -- Matches window title
--       initial_class = "regex_pattern",  -- Matches class when first opened
--       initial_title = "regex_pattern",  -- Matches title when first opened
--       tag = "tag_name",                 -- Matches assigned tag
--       fullscreen = true | 0 | 1,        -- Matches fullscreen status
--     },
--     -- Action properties:
--     float = true | false,               -- Float the window
--     center = true | false,              -- Center floating window on screen
--     size = "width height",              -- e.g. "800 600" or "(monitor_w*0.6) (monitor_h*0.6)"
--     move = "x y",                       -- e.g. "100 100" or "72% 7%"
--     workspace = "1" | "special:name",   -- Target workspace
--     opacity = 0.95 | "0.95 0.85",       -- Active & inactive opacity
--     pin = true | false,                 -- Pin window across all workspaces
--     tag = "+tagname",                   -- Assign custom tag
--     idle_inhibit = "fullscreen" | "always" | "focus",
--     no_blur = true | false,             -- Disable background blur for this window
--     no_initial_focus = true | false,    -- Prevent stealing focus on spawn
--     keep_aspect_ratio = true | false,   -- Maintain aspect ratio when resized
--   })
--
-- TIP: Run `hyprctl activewindow` or `hyprctl clients` in a terminal to find
--      the exact `class` and `title` of any open window!
--
-- =============================================================================
-- EXAMPLES OF COMMON USER WINDOW RULES
-- =============================================================================
--
-- 1. FLOATING & CENTERING TOOLS & UTILITIES:
--    apply_window_rule({
--      name = "user-float-pavucontrol",
--      match = { class = "^(pavucontrol|org.pulseaudio.pavucontrol)$" },
--      float = true,
--      center = true,
--      size = "(monitor_w*0.5) (monitor_h*0.55)",
--    })
--
--    apply_window_rule({
--      name = "user-float-bluetooth-manager",
--      match = { class = "^(blueman-manager)$" },
--      float = true,
--      center = true,
--      size = "600 500",
--    })
--
-- 2. ASSIGNING APPS TO SPECIFIC WORKSPACES:
--    apply_window_rule({
--      name = "user-spotify-workspace",
--      match = { class = "^([Ss]potify)$" },
--      workspace = "9",
--    })
--
--    apply_window_rule({
--      name = "user-discord-workspace",
--      match = { class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$" },
--      workspace = "10",
--    })
--
-- 3. CUSTOM OPACITY RULES (TRANSPARENCY):
--    apply_window_rule({
--      name = "user-transparent-terminal",
--      match = { class = "^(kitty|ghostty|Alacritty)$" },
--      opacity = "0.90 0.80", -- active=0.90, inactive=0.80
--    })
--
-- 4. PICTURE-IN-PICTURE (FLOAT, MOVE & PIN):
--    apply_window_rule({
--      name = "user-pip-video",
--      match = { title = "^[Pp]icture-in-[Pp]icture$" },
--      float = true,
--      pin = true,
--      move = "72% 7%",
--      size = "(monitor_w*0.25) (monitor_h*0.25)",
--      keep_aspect_ratio = true,
--    })
--
-- 5. PREVENTING FOCUS STEALING ON STARTUP:
--    apply_window_rule({
--      name = "user-no-focus-slack",
--      match = { class = "^(Slack|slack)$" },
--      no_initial_focus = true,
--    })
--
-- =============================================================================
do
  local source = (debug.getinfo(1, "S") or {}).source or ""
  local source_path = source:match("^@(.+)$")
  local source_dir = source_path and source_path:match("^(.*)/[^/]+$") or nil
  local home = os.getenv("HOME") or ""
  local candidate_paths = {
    source_dir and (source_dir .. "/../lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/lua/user_window_rules_helper.lua") or nil,
    home ~= "" and (home .. "/.config/hypr/user_window_rules_helper.lua") or nil,
  }

  local tried_paths = {}
  for _, helper_path in ipairs(candidate_paths) do
    if helper_path then
      table.insert(tried_paths, helper_path)
      local f = io.open(helper_path, "r")
      if f then
        f:close()
        local loaded_ok, loaded_helpers = pcall(dofile, helper_path)
        if loaded_ok and type(loaded_helpers) == "table" and loaded_helpers.apply_window_rule then
          user_window_rules_helper = loaded_helpers
          break
        end
      end
    end
  end

  if not user_window_rules_helper then
    error("Failed to load user_window_rules_helper.lua from: " .. table.concat(tried_paths, ", "))
  end
end

local apply_window_rule = user_window_rules_helper.apply_window_rule

-- Example:
-- apply_window_rule({
--   name = "user-float-pavucontrol",
--   match = { class = "pavucontrol" },
--   float = true,
--   center = true,
-- })

-- =============================================================================
-- PERSONAL WINDOW RULES (migrated from WindowRules.conf)
-- Kept as a block at the end so upstream edits above merge cleanly.
-- =============================================================================

apply_window_rule({
  name = "browser-zen",
  match = {
    class = "^(zen-alpha|zen|app.zen_browser.zen)$",
  },
  tag = "+browser",
})

apply_window_rule({
  name = "projects-vscode",
  match = {
    class = "^(VSCode|code-url-handler)$",
  },
  tag = "+projects",
})

apply_window_rule({
  name = "pip-position",
  match = {
    title = "^(Picture-in-Picture)$",
  },
  move = "(cursor_x-(window_w*0.5)) (cursor_y-(window_h*0.5))",
})

apply_window_rule({
  name = "workspace-zen",
  match = {
    class = "^(zen-alpha|zen|app.zen_browser.zen)$",
  },
  workspace = 1,
})

apply_window_rule({
  name = "workspace-code",
  match = {
    class = "^(code)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "workspace-neovide",
  match = {
    class = "^(neovide)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "workspace-kitty",
  match = {
    class = "^(kitty)$",
  },
  workspace = 3,
})

apply_window_rule({
  name = "workspace-chrome",
  match = {
    class = "^([Gg]oogle-chrome(-beta|-dev|-unstable)?)$",
  },
  workspace = 5,
})

apply_window_rule({
  name = "workspace-thorium",
  match = {
    class = "^([Tt]horium-browser)$",
  },
  workspace = 2,
})

apply_window_rule({
  name = "workspace-thunar",
  match = {
    class = "^([Tt]hunar)$",
  },
  workspace = 9,
})

apply_window_rule({
  name = "workspace-nautilus",
  match = {
    class = "^(org.gnome.Nautilus)$",
  },
  workspace = 9,
})

apply_window_rule({
  name = "workspace-obs",
  match = {
    class = "^(com.obsproject.Studio)$",
  },
  workspace = 4,
})

apply_window_rule({
  name = "workspace-steam",
  match = {
    class = "^([Ss]team)$",
  },
  workspace = 5,
})

apply_window_rule({
  name = "workspace-lutris",
  match = {
    class = "^([Ll]utris)$",
  },
  workspace = 5,
})

apply_window_rule({
  name = "workspace-discord",
  match = {
    class = "^([Dd]iscord|[Ww]ebCord|[Vv]esktop)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "workspace-ferdium",
  match = {
    class = "^([Ff]erdium)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "workspace-whatsapp",
  match = {
    class = "^([Ww]hatsapp-for-linux)$",
  },
  workspace = 7,
})

apply_window_rule({
  name = "workspace-virt-manager",
  match = {
    class = "^(virt-manager)$",
  },
  workspace = 6,
})

apply_window_rule({
  name = "workspace-audacious",
  match = {
    class = "^([Aa]udacious)$",
  },
  workspace = 9,
})

apply_window_rule({
  name = "float-vscode-add-folder",
  match = {
    class = "(codium|codium-url-handler|VSCodium|code-oss)",
    title = "(Add Folder to Workspace)",
  },
  float = true,
})

apply_window_rule({
  name = "float-electron-add-folder",
  match = {
    class = "(electron)",
    title = "(Add Folder to Workspace)",
  },
  float = true,
})

apply_window_rule({
  name = "float-vlc",
  match = {
    class = "^(vlc)$",
  },
  float = true,
})

apply_window_rule({
  name = "float-kdeconnect",
  match = {
    class = "^(org.kde.kdeconnect.app)$",
  },
  float = true,
})

apply_window_rule({
  name = "float-kdeconnect-title",
  match = {
    title = "(KDE Connect)",
  },
  float = true,
})

apply_window_rule({
  name = "float-sioyek",
  match = {
    class = "^(sioyek)",
  },
  float = true,
})

apply_window_rule({
  name = "float-preferences",
  match = {
    title = "(Preferences)",
  },
  float = true,
})

apply_window_rule({
  name = "float-gnome-clocks",
  match = {
    class = "^(org.gnome.clocks)$",
  },
  float = true,
})

apply_window_rule({
  name = "opacity-browser",
  match = {
    tag = "browser",
  },
  opacity = "0.86 0.84",
})

apply_window_rule({
  name = "opacity-zen-direct",
  match = {
    class = "^(app.zen_browser.zen|io.github.zen_browser.zen|zen|zen-alpha|zen-beta|zen-browser)$",
  },
  opacity = "0.86 0.84",
})

apply_window_rule({
  name = "vscode-opacity-blur",
  match = {
    class = "^(code)$",
  },
  opacity = 0.86,
})

apply_window_rule({
  name = "size-sioyek",
  match = {
    class = "^(sioyek)$",
  },
  size = "(monitor_w*0.65) (monitor_h*0.67)",
})

apply_window_rule({
  name = "size-kdeconnect",
  match = {
    class = "^(org.kde.kdeconnect.app)$",
  },
  size = "(monitor_w*0.52) (monitor_h*0.42)",
})

apply_window_rule({
  name = "size-kdeconnect-settings",
  match = {
    title = "(Settings — KDE Connect)",
  },
  size = "(monitor_w*0.22) (monitor_h*0.27)",
})

apply_window_rule({
  name = "size-gnome-clocks",
  match = {
    class = "^(org.gnome.clocks)$",
  },
  size = "(monitor_w*0.32) (monitor_h*0.4)",
})
