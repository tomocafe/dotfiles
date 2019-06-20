changecom()dnl
include(color.m4)dnl
if !has("gui_running")
    set t_Co=256
    let g:gruvbox_termcolors=16
endif
set background=dark
try
    colorscheme gruvbox
catch
endtry
" For statusline:
hi User1 ctermfg=NONE ctermbg=0 guifg=NONE guibg=M4_COLOR_0
hi User2 ctermfg=2 ctermbg=0 guifg=M4_COLOR_2 guibg=M4_COLOR_0
hi User3 ctermfg=3 ctermbg=0 guifg=M4_COLOR_3 guibg=M4_COLOR_0
hi User4 ctermfg=4 ctermbg=0 guifg=M4_COLOR_4 guibg=M4_COLOR_0
hi User5 ctermfg=5 ctermbg=0 guifg=M4_COLOR_5 guibg=M4_COLOR_0
hi User6 ctermfg=6 ctermbg=0 guifg=M4_COLOR_6 guibg=M4_COLOR_0
hi User9 ctermfg=9 ctermbg=0 guifg=M4_COLOR_9 guibg=M4_COLOR_0
