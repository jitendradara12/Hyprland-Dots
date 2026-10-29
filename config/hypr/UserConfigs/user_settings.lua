-- ==================================================
--  KoolDots (2026)
--  Project URL: https://github.com/LinuxBeginnings
--  License: GNU GPLv3
--  SPDX-License-Identifier: GPL-3.0-or-later
-- ==================================================
-- User settings overrides template.
-- Add your personal hl.config(...) values here.

hl.config({
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    repeat_rate = 50,
    repeat_delay = 300,
    sensitivity = 0,
    numlock_by_default = true,
    left_handed = false,
    follow_mouse = 1,
    float_switch_override_focus = false,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      clickfinger_behavior = false,
      middle_button_emulation = false,
      tap_to_click = true,
      drag_lock = false,
    },
    touchdevice = {
      enabled = true,
    },
    tablet = {
      transform = 0,
      left_handed = 0,
    },
  },
})

-- Multi-language example:
-- NOTE: If specifying multiple layouts in kb_layout, kb_variant must have matching
-- comma separators (e.g. kb_layout = "fr,de", kb_variant = "azerty," or kb_variant = "").
--
-- hl.config({
--   input = {
--     kb_layout = "fr,de",
--     kb_variant = "azerty,",
--     kb_options = "grp:alt_shift_toggle",
--   },
--   misc = {
--     focus_on_activate = true,
--   },
-- })

-- Example:
-- hl.config({
--   general = {
--     gaps_in = 4,
--     gaps_out = 8,
--     border_size = 1,
--   },
-- })
--

-- Disable cursor being centered when swap workspaces
--
-- hl.config({
-- 	cursor = {
-- 		no_warps = true,
-- 		warp_on_change_workspace = 0,
-- 	},
-- })

-- =============================================================================
-- PERSONAL SETTINGS (migrated from UserSettings.conf)
-- Kept as a block at the end so upstream edits above merge cleanly.
-- =============================================================================

hl.config({
  master = {
    new_status = "master",
    new_on_top = true,
    mfact = 0.5,
  },
  general = {
    border_size = 0,
    gaps_in = 0,
    gaps_out = 0,
    resize_on_border = true,
    layout = "dwindle",
  },
  input = {
    kb_layout = "us",
    kb_variant = "",
    kb_model = "",
    kb_options = "",
    kb_rules = "",
    repeat_rate = 50,
    repeat_delay = 300,
    sensitivity = 0.49,
    numlock_by_default = true,
    left_handed = false,
    follow_mouse = 1,
    float_switch_override_focus = false,
    touchpad = {
      disable_while_typing = true,
      natural_scroll = true,
      clickfinger_behavior = false,
      middle_button_emulation = true,
      tap_to_click = true,
      drag_lock = false,
    },
    touchdevice = {
      enabled = false,
    },
    tablet = {
      transform = 0,
      left_handed = 0,
    },
  },
  gestures = {
    workspace_swipe_distance = 400,
    workspace_swipe_invert = true,
    workspace_swipe_min_speed_to_force = 30,
    workspace_swipe_cancel_ratio = 0.02,
    workspace_swipe_create_new = true,
    workspace_swipe_forever = true,
  },
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    vrr = 2,
    mouse_move_enables_dpms = true,
    enable_swallow = false,
    swallow_regex = "^(kitty)$",
    focus_on_activate = false,
    initial_workspace_tracking = 0,
    middle_click_paste = false,
    enable_anr_dialog = true,
    anr_missed_pings = 15,
    allow_session_lock_restore = true,
  },
  binds = {
    workspace_back_and_forth = true,
    allow_workspace_cycles = true,
    pass_mouse_when_bound = false,
  },
  xwayland = {
    force_zero_scaling = true,
  },
  render = {
    direct_scanout = false,
  },
  cursor = {
    sync_gsettings_theme = true,
    no_hardware_cursors = 2,
    enable_hyprcursor = true,
    warp_on_change_workspace = 2,
    no_warps = true,
  },
})

-- Personal gestures (from UserSettings.conf).
-- Upstream registers 3-finger horizontal/up/down and 4-finger up/down swipes in
-- lua/settings.lua. Hyprland refuses a second gesture on the same finger count
-- and axis, so unset those five defaults before installing the personal map.
local function unset_gesture(fingers, direction)
  if hl and hl.gesture then
    local ok, err = pcall(hl.gesture, {
      fingers = fingers,
      direction = direction,
      action = "unset",
    })
    if not ok then
      local message = tostring(err)
      if not message:find("non%-existent") then
        print("[WARN] personal gesture unset: " .. message)
      end
    end
  end
end

unset_gesture(3, "horizontal")
unset_gesture(3, "up")
unset_gesture(3, "down")
unset_gesture(4, "up")
unset_gesture(4, "down")

local function personal_set_zoom(delta)
  local factor = hl and hl.get_config
    and (hl.get_config("cursor.zoom_factor") or hl.get_config("cursor:zoom_factor"))
  if type(factor) ~= "number" or factor < 1 then
    factor = 1
  end
  factor = math.max(1, math.min(16, factor * delta))
  if hl and hl.config then
    hl.config({ cursor = { zoom_factor = factor } })
  end
end

local function personal_gesture(spec)
  if hl and hl.gesture then
    local ok, err = pcall(hl.gesture, spec)
    if not ok then
      print("[WARN] personal gesture: " .. tostring(err))
    end
  end
end

local function personal_dispatch(spec)
  if hl and hl.dispatch and spec then
    local ok, err = pcall(hl.dispatch, spec)
    if not ok then
      print("[WARN] personal gesture dispatch: " .. tostring(err))
    end
  end
end

local function personal_cycle_window(previous)
  if not (hl and hl.dsp and hl.dsp.window and hl.dsp.window.cycle_next) then
    return
  end
  if previous then
    personal_dispatch(hl.dsp.window.cycle_next({ next = false }))
  else
    personal_dispatch(hl.dsp.window.cycle_next())
  end
end

local term = (KOOLDOTS_DEFAULTS and KOOLDOTS_DEFAULTS.term) or "kitty"

-- 4-finger horizontal swipe -> workspace switch
personal_gesture({
  fingers = 4,
  direction = "horizontal",
  action = "workspace",
})

-- 3-finger swipe down -> notification panel (Super + D)
personal_gesture({
  fingers = 3,
  direction = "down",
  action = function()
    personal_dispatch(hl.dsp.exec_cmd("swaync-client -t -sw"))
  end,
})

-- 3-finger swipe up -> desktop overview (Super + A)
personal_gesture({
  fingers = 3,
  direction = "up",
  action = function()
    personal_dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/OverviewToggle.sh"))
  end,
})

-- 4-finger swipe down -> dropdown terminal (Super + Shift + Return)
personal_gesture({
  fingers = 4,
  direction = "down",
  action = function()
    personal_dispatch(hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/Dropterminal.sh " .. term))
  end,
})

-- 3-finger horizontal swipe -> cycle windows (ALT+Tab)
personal_gesture({
  fingers = 3,
  direction = "left",
  action = function()
    personal_cycle_window(true)
  end,
})
personal_gesture({
  fingers = 3,
  direction = "right",
  action = function()
    personal_cycle_window(false)
  end,
})

-- 3-finger pinch -> cursor zoom
personal_gesture({
  fingers = 3,
  direction = "pinchin",
  action = function()
    personal_set_zoom(1.5)
  end,
})
personal_gesture({
  fingers = 3,
  direction = "pinchout",
  action = function()
    personal_set_zoom(1 / 1.5)
  end,
})
