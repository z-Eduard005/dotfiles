-- https://wiki.hypr.land/Configuring/Variables/#input

hl.config({
    input = {
        kb_layout = "us,ru,ua",
        kb_variant = "",
        kb_model = "",
        kb_options = "grp:caps_toggle,caps:shiftlock",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = -0.75,
        touchpad = {
            natural_scroll = true,
        },
    },
    -- Inconsistent cursor icon fix
    cursor = {
        no_hardware_cursors = 1,
    },
})

hl.gesture({
  fingers = 3,
  direction = "horizontal",
  action = "workspace",
})

hl.device({
  name = "elan07d2:00-04f3:321a-touchpad",
  sensitivity = 0,
})