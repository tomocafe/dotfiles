changecom()dnl
include(color.m4)dnl
set background=dark
let g:nord_cursor_line_number_background=1
colorscheme nord
" For statusline:
hi User1 ctermfg=NONE ctermbg=0 guifg=NONE guibg=M4_COLOR_0
hi User2 ctermfg=2 ctermbg=0 guifg=M4_COLOR_2 guibg=M4_COLOR_0
hi User3 ctermfg=3 ctermbg=0 guifg=M4_COLOR_3 guibg=M4_COLOR_0
hi User4 ctermfg=4 ctermbg=0 guifg=M4_COLOR_4 guibg=M4_COLOR_0
hi User5 ctermfg=5 ctermbg=0 guifg=M4_COLOR_5 guibg=M4_COLOR_0
hi User6 ctermfg=6 ctermbg=0 guifg=M4_COLOR_6 guibg=M4_COLOR_0
hi User9 ctermfg=9 ctermbg=0 guifg=M4_COLOR_9 guibg=M4_COLOR_0
hi DefHeader ctermfg=15 ctermbg=4 guifg=M4_COLOR_15 guibg=M4_COLOR_4
hi ModHeader ctermfg=15 ctermbg=2 guifg=M4_COLOR_15 guibg=M4_COLOR_2
hi RoHeader ctermfg=15 ctermbg=9 guifg=M4_COLOR_15 guibg=M4_COLOR_9