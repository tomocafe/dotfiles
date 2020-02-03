map <F3> :set<Space>as=short<CR>
map <F4> :set<Space>as=highlight<CR>

hi Constant cterm=normal ctermfg=5
hi Statement cterm=normal ctermfg=9
hi PreProc cterm=normal ctermfg=6
hi Type cterm=normal ctermfg=4
hi Breakpoint cterm=normal ctermfg=1
hi DisabledBreakpoint cterm=normal ctermfg=4

set arrowstyle=highlight

ifelse(M4_CGDB_BG,dark,dnl
hi Comment cterm=normal ctermfg=8
hi StatusLine cterm=normal ctermbg=0
hi Arrow cterm=normal ctermfg=5 ctermbg=0
hi LineHighlight cterm=normal ctermbg=0 ctermfg=7
,dnl
hi Comment cterm=normal ctermfg=7
hi StatusLine cterm=normal ctermbg=15
hi Arrow cterm=normal ctermfg=5 ctermbg=15
hi LineHighlight cterm=normal ctermbg=15 ctermfg=8
)dnl

