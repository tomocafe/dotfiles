include(i3.m4)dnl
include(font.m4)dnl
[global]
    background = "M4_I3_BG"
    foreground = "M4_COLOR_FG"
    frame_color = "M4_COLOR_BG" 
    separator_color = "M4_COLOR_BG" 
    font = M4_FONT_NAME M4_FONT_SIZE
    monitor = 0
    follow = mouse
    indicate_hidden = yes
    shrink = no 
    transparency = 0
    notification_height = 0
ifdef(`I3_M4_HIDPI',dnl
    geometry = "720x2-40-80"
    padding = 48
    horizontal_padding = 72
    frame_width = 8
    separator_height = 8
,dnl
    geometry = "360x2-20-40"
    padding = 24
    horizontal_padding = 36
    frame_width = 4
    separator_height = 4
)dnl
    sort = yes
    idle_threshold = 120
    line_height = 0
ifdef(`M4_I3_COMPAT',dnl
    markup = no
,dnl
    markup = full
)dnl
    #   %a  appname
    #   %s  summary
    #   %b  body
    #   %i  iconname (including its path)
    #   %I  iconname (without its path)
    #   %p  progress value if set ([  0%] to [100%]) or nothing
    #   %n  progress value if set without any extra characters
    #   %%  Literal %
    format = "%s\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = off
    max_icon_size = 0
    icon_path = 
    sticky_history = yes
    history_length = 20
    dmenu = dmenu -p dunst
    browser = firefox -new-tab
    always_run_script = true
    title = Dunst
    class = Dunst
    startup_notification = false
    verbosity = mesg
    corner_radius = 0
    force_xinerama = false
    mouse_left_click = close_current
    mouse_middle_click = do_action
    mouse_right_click = close_all

[experimental]
    per_monitor_dpi = false

[shortcuts]
    close = ctrl+space
    close_all = ctrl+shift+space
    history = ctrl+grave
    context = ctrl+shift+period

[urgency_low]
    background = "M4_I3_BG"
    foreground = "M4_COLOR_FG"
    timeout = 10

[urgency_normal]
    background = "M4_I3_BG"
    foreground = "M4_COLOR_FG"
    timeout = 10

[urgency_critical]
    background = "M4_I3_BG"
    foreground = "M4_COLOR_9"
    timeout = 0

