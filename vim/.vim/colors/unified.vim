
" hi Group          ctermfg="xxxx" ctermbg="xxxx" guifg="#xxxxxx" guibg="#xxxxxx"

" Yellow (3): used to draw attention in UI, e.g. current linenr, matching brace, highlight
" Red (1): used to draw attention in code

" Normal 
if &background == 'dark'
hi CursorLine       ctermfg='NONE' ctermbg='0'    "guifg='NONE'    guibg='M4_COLOR_0'
hi LineNr           ctermfg='8'    ctermbg='NONE' "guifg='M4_COLOR_8' guibg='NONE'
hi CursorLineNr     ctermfg='3'    ctermbg='0'    "guifg='M4_COLOR_3' guibg='M4_COLOR_0'
else
hi CursorLine       ctermfg='NONE' ctermbg='15'   "guifg='NONE' guibg='M4_COLOR_7'
hi LineNr           ctermfg='7'    ctermbg='NONE' "guifg='M4_COLOR_7' guibg='NONE'
hi CusrorLineNr     ctermfg='3'    ctermbg='15'   "guifg='M4_COLOR_3' guibg='M4_COLOR_15'
endif
hi! link CursorColumn CursorLine

hi Search           ctermfg='3'    ctermbg='NONE' "guifg='M4_COLOR_3' guibg='NONE' cterm='inverse' gui='inverse'
hi IncSearch        ctermfg='11'   ctermbg='NONE' "guifg='M4_COLOR_11' guibg='NONE' cterm='inverse' gui='inverse'

hi MatchParen       ctermfg='3'    ctermbg=''

" TODO
" Tab*
" Pmenu*
" Diff*
" Spell*
" Visual*
