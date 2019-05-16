changecom()dnl
include(color.m4)dnl
dnl
map <F3> :set<Space>as=short<CR>
map <F4> :set<Space>as=highlight<CR>

hi Constant cterm=normal ctermfg=M4_COLOR_CONSTANT_FG
hi Comment cterm=normal ctermfg=M4_COLOR_COMMENT_FG
hi Statement cterm=normal ctermfg=M4_COLOR_STATEMENT_FG
hi PreProc cterm=normal ctermfg=M4_COLOR_PREPROC_FG
hi Type cterm=normal ctermfg=M4_COLOR_TYPE_FG

hi Breakpoint cterm=normal ctermfg=1
hi DisabledBreakpoint cterm=normal ctermfg=4

set arrowstyle=highlight
hi StatusLine cterm=normal ctermbg=M4_COLOR_HILIGHT_BG
hi Arrow cterm=normal ctermfg=5 ctermbg=M4_COLOR_HILIGHT_BG
hi LineHighlight cterm=normal ctermbg=M4_COLOR_HILIGHT_BG ctermfg=M4_COLOR_HILIGHT_FG

