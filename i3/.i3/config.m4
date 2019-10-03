changecom()dnl
include(i3.m4)dnl
dnl
# Do not remove this line:
# i3 config file (v4)

# Start some executables
exec_always --no-startup-id xrdb -merge ${I3_HOME:-~/.i3}/Xresources
exec_always --no-startup-id ${I3_HOME:-~/.i3}/bin/reload-ssh-xresources ${I3_HOME:-~/.i3}/Xresources
exec_always --no-startup-id killall -9 dunst; exec dunst -conf ${I3_HOME:-~/.i3}/dunstrc
exec_always --no-startup-id dmenu_path &>/dev/null
ifdef(`M4_TERMINAL_DAEMON',dnl
exec --no-startup-id M4_TERMINAL_DAEMON
)dnl

# Set X root background color
exec_always --no-startup-id xsetroot -solid "M4_I3_BG"

# Borders
new_window normal 2
hide_edge_borders both

# Font
ifdef(`M4_I3_COMPAT',dnl
font M4_FONT_XLFD
,dnl
font pango:M4_FONT_NAME M4_FONT_SIZE
)dnl

# Mod key
set $mod Mod1

# use Mouse+$mod to drag floating windows to their wanted position
floating_modifier $mod

# start a terminal
bindsym $mod+Return exec M4_TERMINAL

# kill focused window
#bindsym $mod+Shift+q kill
mode "confirm-close" {
    bindsym y kill, mode default
    bindsym Y kill, mode default

    bindsym n mode default
    bindsym Escape mode default
}
bindsym $mod+Shift+q exec --no-startup-id ${I3_HOME:-~/.i3}/bin/close-mode "confirm-close" SHELL_ROOT_PROC "sshd|sge_execd"

# start dmenu (a program launcher)
ifdef(`M4_I3_COMPAT',`define(`M4_I3_DMENU_FONT',`M4_FONT_XLFD')',`define(`M4_I3_DMENU_FONT',`M4_FONT_NAME-M4_FONT_SIZE')')dnl
bindsym $mod+d exec --no-startup-id dmenu_run -i -p run -fn "M4_I3_DMENU_FONT" -nb "M4_I3_BG" -nf "M4_COLOR_FG" -sb "M4_COLOR_3" -sf "M4_I3_ACTIVE_FG"
bindsym $mod+x exec --no-startup-id ${I3_HOME:-~/.i3}/bin/dmenu_ssh "M4_TERMINAL -e ssh -X" -i -p ssh -fn "M4_I3_DMENU_FONT" -nb "M4_I3_BG" -nf "M4_COLOR_FG" -sb "M4_COLOR_4" -sf "M4_I3_ACTIVE_FG"
bindsym $mod+Shift+t exec --no-startup-id ${I3_HOME:-~/.i3}/bin/dmenu_theme -i -p theme -fn "M4_I3_DMENU_FONT" -nb "M4_I3_BG" -nf "M4_COLOR_FG" -sb "M4_COLOR_5" -sf "M4_I3_ACTIVE_FG"
bindsym $mod+Shift+e exec --no-startup-id ${I3_HOME:-~/.i3}/bin/dmenu_exit --start-i3lock-args --clock --force-clock --time-align=1 --date-align=1 --timestr="%-I:%M %p" --datestr="%A %-d %B" --timepos="x+40:h-70" --datepos="x+40:h-45" --radius=40 --ring-width=4 --veriftext="" --wrongtext="" --noinputtext="" --color="M4_COLOR_BG" --insidecolor="M4_COLOR_BG`ff'" --ringcolor="M4_I3_BG`ff'" --line-uses-inside --keyhlcolor="M4_COLOR_FG`ff'" --bshlcolor="M4_COLOR_9`ff'" --separatorcolor="M4_I3_BG`ff'" --insidevercolor="M4_COLOR_BG`ff'" --insidewrongcolor="M4_COLOR_BG`ff'" --verifcolor="M4_COLOR_4`ff'" --wrongcolor="M4_COLOR_1`ff'" --timecolor="M4_COLOR_FG`ff'" --datecolor="M4_COLOR_FG`ff'" --time-font="M4_FONT_NAME" --date-font="M4_FONT_NAME" --end-i3lock-args --start-i3lock-fallback-args --color="M4_COLOR_BG" --end-i3lock-fallback-args -i -p exit -fn "M4_I3_DMENU_FONT" -nb "M4_I3_BG" -nf "M4_COLOR_FG" -sb "M4_COLOR_1" -sf "M4_I3_ACTIVE_FG"

# change focus
set $up l
set $down k
set $left j
set $right semicolon
bindsym $mod+$left focus left
bindsym $mod+$down focus down
bindsym $mod+$up focus up
bindsym $mod+$right focus right

# alternatively, you can use the cursor keys:
bindsym $mod+Left focus left
bindsym $mod+Down focus down
bindsym $mod+Up focus up
bindsym $mod+Right focus right

# move focused window
bindsym $mod+Shift+$left move left
bindsym $mod+Shift+$down move down
bindsym $mod+Shift+$up move up
bindsym $mod+Shift+$right move right

# alternatively, you can use the cursor keys:
bindsym $mod+Shift+Left move left
bindsym $mod+Shift+Down move down
bindsym $mod+Shift+Up move up
bindsym $mod+Shift+Right move right

# split in horizontal orientation
bindsym $mod+h split h

# split in vertical orientation
bindsym $mod+v split v

# enter fullscreen mode for the focused container
bindsym $mod+Shift+f fullscreen toggle

# change container layout (stacked, tabbed, toggle split)
bindsym $mod+s layout stacking
bindsym $mod+w layout tabbed
bindsym $mod+e layout toggle split

# toggle tiling / floating
bindsym $mod+Shift+space floating toggle

# change focus between tiling / floating windows
bindsym $mod+space focus mode_toggle

# focus the parent container
bindsym $mod+bracketleft focus parent

# focus the child container
bindsym $mod+bracketright focus child

# move the currently focused window to the scratchpad
bindsym $mod+Shift+minus move scratchpad

# Show the next scratchpad window or hide the focused scratchpad window.
# If there are multiple scratchpad windows, this command cycles through them.
bindsym $mod+minus scratchpad show

ifdef(`M4_I3_HEADLESS',,dnl
# Peripheral controls
bindsym XF86MonBrightnessUp exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control brightness up
bindsym XF86MonBrightnessDown exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control brightness down
bindsym XF86AudioPlay exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control media play-pause
bindsym XF86AudioPause exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control media pause
bindsym XF86AudioStop exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control media stop
bindsym XF86AudioPrev exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control media previous
bindsym XF86AudioNext exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control media next
bindsym XF86AudioRaiseVolume exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control volume up
bindsym XF86AudioLowerVolume exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control volume down
bindsym XF86AudioMute exec --no-startup-id ${I3_HOME:-~/.i3}/bin/peripheral-control volume mute
)dnl

# Define workspaces
ifdef(`M4_I3_W1',,`define(M4_I3_W1,`1')')dnl
ifdef(`M4_I3_W2',,`define(M4_I3_W2,`2')')dnl
ifdef(`M4_I3_W3',,`define(M4_I3_W3,`3')')dnl
ifdef(`M4_I3_W4',,`define(M4_I3_W4,`4')')dnl
ifdef(`M4_I3_W5',,`define(M4_I3_W5,`5')')dnl
ifdef(`M4_I3_W6',,`define(M4_I3_W6,`6')')dnl
ifdef(`M4_I3_W7',,`define(M4_I3_W7,`7')')dnl
ifdef(`M4_I3_W8',,`define(M4_I3_W8,`8')')dnl
ifdef(`M4_I3_W9',,`define(M4_I3_W9,`9')')dnl
ifdef(`M4_I3_W0',,`define(M4_I3_W0,`0')')dnl
set $w1 "M4_I3_W1"
set $w2 "M4_I3_W2"
set $w3 "M4_I3_W3"
set $w4 "M4_I3_W4"
set $w5 "M4_I3_W5"
set $w6 "M4_I3_W6"
set $w7 "M4_I3_W7"
set $w8 "M4_I3_W8"
set $w9 "M4_I3_W9"
set $w0 "M4_I3_W0"

# switch to workspace
bindsym $mod+1 workspace $w1
bindsym $mod+2 workspace $w2
bindsym $mod+3 workspace $w3
bindsym $mod+4 workspace $w4
bindsym $mod+5 workspace $w5
bindsym $mod+6 workspace $w6
bindsym $mod+7 workspace $w7
bindsym $mod+8 workspace $w8
bindsym $mod+9 workspace $w9
bindsym $mod+0 workspace $w0

# move focused container to workspace
bindsym $mod+Shift+1 move container to workspace $w1
bindsym $mod+Shift+2 move container to workspace $w2
bindsym $mod+Shift+3 move container to workspace $w3
bindsym $mod+Shift+4 move container to workspace $w4
bindsym $mod+Shift+5 move container to workspace $w5
bindsym $mod+Shift+6 move container to workspace $w6
bindsym $mod+Shift+7 move container to workspace $w7
bindsym $mod+Shift+8 move container to workspace $w8
bindsym $mod+Shift+9 move container to workspace $w9
bindsym $mod+Shift+0 move container to workspace $w0

# reload the configuration file
bindsym $mod+Shift+c reload
# restart i3 inplace (preserves your layout/session, can be used to upgrade i3)
bindsym $mod+Shift+r restart
# exit i3 (logs you out of your X session)
#bindsym $mod+Shift+e exec "i3-nagbar -t warning -m 'Exit i3?' -b 'Yes, exit i3' 'i3-msg exit'"

# resize window (you can also use the mouse for that)
mode "resize" {
        # These bindings trigger as soon as you enter the resize mode

        # Pressing left will shrink the window’s width.
        # Pressing right will grow the window’s width.
        # Pressing up will shrink the window’s height.
        # Pressing down will grow the window’s height.
        bindsym $left       resize shrink width 10 px or 10 ppt
        bindsym $down       resize grow height 10 px or 10 ppt
        bindsym $up         resize shrink height 10 px or 10 ppt
        bindsym $right      resize grow width 10 px or 10 ppt

        # same bindings, but for the arrow keys
        bindsym Left        resize shrink width 10 px or 10 ppt
        bindsym Down        resize grow height 10 px or 10 ppt
        bindsym Up          resize shrink height 10 px or 10 ppt
        bindsym Right       resize grow width 10 px or 10 ppt

        # back to normal: Enter or Escape
        bindsym Return mode "default"
        bindsym Escape mode "default"
}

bindsym $mod+r mode "resize"

# class border bg fg child_border
client.focused M4_I3_BG M4_I3_BG M4_I3_ACTIVE_FG M4_I3_BG M4_I3_BG
client.focused_inactive M4_I3_BG M4_I3_BG M4_COLOR_FG M4_I3_BG M4_I3_BG
client.unfocused M4_I3_BG M4_I3_BG M4_COLOR_FG M4_I3_BG M4_I3_BG
client.urgent M4_COLOR_9 M4_I3_BG M4_COLOR_9 M4_COLOR_9 M4_I3_BG
ifdef(`M4_I3_COMPAT',,dnl
client.placeholder M4_I3_BG M4_I3_BG M4_COLOR_FG M4_I3_BG M4_I3_BG
)dnl
client.background M4_COLOR_BG

# Start i3bar to display a workspace bar (plus the system information i3status
# finds out, if available)
bar {
    status_command i3blocks -c ${I3_HOME:-~/.i3}/i3blocks.conf
ifdef(`M4_I3_COMPAT',,dnl
    separator_symbol "·"
)dnl
    position bottom
    tray_output none
    colors {
ifdef(`M4_I3_BAR_BG',,`define(`M4_I3_BAR_BG',`M4_I3_BG')')dnl
ifdef(`M4_I3_BAR_ACTIVE_BG',,`define(`M4_I3_BAR_ACTIVE_BG',`M4_I3_ACTIVE_BG')')dnl
ifdef(`M4_I3_BAR_FG',,`define(`M4_I3_BAR_FG',`M4_COLOR_FG')')dnl
ifdef(`M4_I3_BAR_ACTIVE_FG',,`define(`M4_I3_BAR_ACTIVE_FG',`M4_I3_ACTIVE_FG')')dnl
        background M4_I3_BAR_BG
        statusline M4_I3_BAR_FG
        separator M4_I3_BAR_FG
        # class border bg fg
        focused_workspace M4_I3_BAR_ACTIVE_BG M4_I3_BAR_ACTIVE_BG M4_I3_BAR_ACTIVE_FG
        active_workspace M4_I3_BAR_ACTIVE_BG M4_I3_BAR_ACTIVE_BG M4_I3_BAR_ACTIVE_FG
        inactive_workspace M4_I3_BAR_BG M4_I3_BAR_BG M4_I3_BAR_FG
        urgent_workspace M4_COLOR_9 M4_I3_BAR_ACTIVE_BG M4_COLOR_9
ifdef(`M4_I3_COMPAT',,dnl
        binding_mode M4_COLOR_4 M4_I3_BAR_ACTIVE_BG M4_COLOR_4
)dnl
    }
}

