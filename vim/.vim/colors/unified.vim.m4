changecom()dnl
include(color.m4)dnl
ifdef(`M4_VIM_BG',dnl
set background=M4_VIM_BG
,dnl
set background=dark
)dnl
" B/W palette from most dim to most intense
if &background == 'dark'
    let s:ctermbw = [0, 8, 7, 15]
    let s:guibw = ['M4_COLOR_0', 'M4_COLOR_8', 'M4_COLOR_7', 'M4_COLOR_15']
else
    let s:ctermbw = [15, 7, 8, 0]
    let s:guibw = ['M4_COLOR_15', 'M4_COLOR_7', 'M4_COLOR_8', 'M4_COLOR_0']
endif

function! s:hg(group, ctermfg, ctermbg, guifg, guibg, attr) 
    exe 'hi ' . a:group . ' ctermfg=' . a:ctermfg . ' ctermbg=' . a:ctermbg . ' guifg=' . a:guifg . ' guibg=' . a:guibg . ' cterm=' . a:attr . ' gui=' . a:attr
endfunction

call s:hg('URed', '1', 'NONE', 'M4_COLOR_1', 'NONE', 'NONE')
call s:hg('UOrange', '9', 'NONE', 'M4_COLOR_9', 'NONE', 'NONE')
call s:hg('UGreen', '2', 'NONE', 'M4_COLOR_2', 'NONE', 'NONE')
call s:hg('ULtGreen', '10', 'NONE', 'M4_COLOR_10', 'NONE', 'NONE')
call s:hg('UYellow', '3', 'NONE', 'M4_COLOR_3', 'NONE', 'NONE')
call s:hg('ULtYellow', '11', 'NONE', 'M4_COLOR_11', 'NONE', 'NONE')
call s:hg('UBlue', '4', 'NONE', 'M4_COLOR_4', 'NONE', 'NONE')
call s:hg('ULtBlue', '12', 'NONE', 'M4_COLOR_12', 'NONE', 'NONE')
call s:hg('UMagenta', '5', 'NONE', 'M4_COLOR_5', 'NONE', 'NONE')
call s:hg('ULtMagenta', '13', 'NONE', 'M4_COLOR_13', 'NONE', 'NONE')
call s:hg('UCyan', '6', 'NONE', 'M4_COLOR_6', 'NONE', 'NONE')
call s:hg('ULtCyan', '14', 'NONE', 'M4_COLOR_14', 'NONE', 'NONE')
call s:hg('UBW0', s:ctermbw[0], 'NONE', s:guibw[0], 'NONE', 'NONE')
call s:hg('UBW1', s:ctermbw[1], 'NONE', s:guibw[1], 'NONE', 'NONE')
call s:hg('UBW2', s:ctermbw[2], 'NONE', s:guibw[2], 'NONE', 'NONE')
call s:hg('UBW3', s:ctermbw[3], 'NONE', s:guibw[3], 'NONE', 'NONE')
call s:hg('UHiRed', '1', s:ctermbw[0], 'M4_COLOR_1', s:guibw[0], 'NONE')
call s:hg('UHiOrange', '9', s:ctermbw[0], 'M4_COLOR_9', s:guibw[0], 'NONE')
call s:hg('UHiGreen', '2', s:ctermbw[0], 'M4_COLOR_2', s:guibw[0], 'NONE')
call s:hg('UHiLtGreen', '10', s:ctermbw[0], 'M4_COLOR_10', s:guibw[0], 'NONE')
call s:hg('UHiYellow', '3', s:ctermbw[0], 'M4_COLOR_3', s:guibw[0], 'NONE')
call s:hg('UHiLtYellow', '11', s:ctermbw[0], 'M4_COLOR_11', s:guibw[0], 'NONE')
call s:hg('UHiBlue', '4', s:ctermbw[0], 'M4_COLOR_4', s:guibw[0], 'NONE')
call s:hg('UHiLtBlue', '12', s:ctermbw[0], 'M4_COLOR_12', s:guibw[0], 'NONE')
call s:hg('UHiMagenta', '5', s:ctermbw[0], 'M4_COLOR_5', s:guibw[0], 'NONE')
call s:hg('UHiLtMagenta', '13', s:ctermbw[0], 'M4_COLOR_13', s:guibw[0], 'NONE')
call s:hg('UHiCyan', '6', s:ctermbw[0], 'M4_COLOR_6', s:guibw[0], 'NONE')
call s:hg('UHiLtCyan', '14', s:ctermbw[0], 'M4_COLOR_14', s:guibw[0], 'NONE')
call s:hg('UHiBW1', s:ctermbw[1], s:ctermbw[0], s:guibw[1], s:guibw[0], 'NONE')
call s:hg('UHiBW2', s:ctermbw[2], s:ctermbw[0], s:guibw[2], s:guibw[0], 'NONE')
call s:hg('UHiBW3', s:ctermbw[3], s:ctermbw[0], s:guibw[3], s:guibw[0], 'NONE')
call s:hg('UWhiteOnRed', '15', '1', 'M4_COLOR_15', 'M4_COLOR_1', 'NONE')
call s:hg('UWhiteOnOrange', '15', '9', 'M4_COLOR_15', 'M4_COLOR_9', 'NONE')
call s:hg('UWhiteOnGreen', '15', '2', 'M4_COLOR_15', 'M4_COLOR_2', 'NONE')
call s:hg('UWhiteOnBlue', '15', '4', 'M4_COLOR_15', 'M4_COLOR_4', 'NONE')
call s:hg('UInvert', 'NONE', 'NONE', 'NONE', 'NONE', 'inverse')

call s:hg('Normal', 'NONE', 'NONE', 'M4_COLOR_FG', 'M4_COLOR_BG', 'NONE')

hi! link Comment UBW1
hi! link NonText Comment
hi! link SpecialKey NonText
hi! link Conceal NonText

hi! link ModeMsg UYellow
hi! link MoreMsg UYellow
hi! link WarningMsg UYellow
hi! link ErrorMsg UWhiteOnRed
hi! link Question UYellow

if &diff
    call s:hg('CursorLine', 'NONE', 'NONE', 'NONE', 'NONE', 'NONE')
else
    call s:hg('CursorLine', 'NONE', s:ctermbw[0], 'NONE', s:guibw[0], 'NONE')
endif
call s:hg('CursorLineNr', '3', s:ctermbw[0], 'M4_COLOR_3', s:guibw[0], 'NONE')
hi! link LineNr NonText
hi! link FoldColumn NonText
hi! link SignColumn NonText
hi! link CursorColumn CursorLine
hi! link Folded UHiBW1
hi! link VertSplit Folded
hi! link Visual UInvert

call s:hg('DiffText', '11', '4', 'M4_COLOR_11', 'M4_COLOR_4', 'undercurl')
hi! link DiffAdd UWhiteOnGreen
hi! link DiffDelete UWhiteOnRed
hi! link DiffChange UWhiteOnBlue

call s:hg('Search', '3', 'NONE', 'M4_COLOR_3', 'NONE', 'inverse')
call s:hg('IncSearch', '11', 'NONE', 'M4_COLOR_11', 'NONE', 'inverse')
call s:hg('Error', '15', '1', 'M4_COLOR_15', 'M4_COLOR_1', 'NONE')
call s:hg('MatchParen', '3', s:ctermbw[0], 'M4_COLOR_3', s:guibw[0], 'NONE')

hi! link Todo URed
hi! link Statement UOrange
hi! link Conditional UOrange
hi! link Repeat UOrange
hi! link Label UOrange
hi! link Exception UOrange
hi! link Operator UBright
hi! link Keyword UOrange
hi! link Identifier Normal
hi! link Function ULtBlue
hi! link PreProc UCyan
hi! link Include UCyan
hi! link Define UCyan
hi! link Macro UCyan
hi! link PreCondit UCyan
hi! link Constant UMagenta
hi! link Boolean ULtMagenta
hi! link Character ULtMagenta
hi! link String UGreen
hi! link Special ULtMagenta
hi! link Type UBlue
hi! link StorageClass UBlue
hi! link Structure UBlue
hi! link Typedef UBlue

