changecom()dnl
include(color.m4)dnl
# From ~/.gtkrc-2.0: include ".vim/gtkrc-2.0"
style "gvim" {
    bg[NORMAL] = "M4_COLOR_BG"
}
widget "vim-main-window.*GtkForm" style "gvim"

