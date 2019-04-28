include(color.m4)dnl
include(font.m4)dnl
dnl
*foreground: M4_COLOR_FG
*background: M4_COLOR_BG
*fadeColor: M4_COLOR_BG
*cursorColor: M4_COLOR_CURSOR
*pointerColorForeground: M4_COLOR_POINTERFG
*pointerColorBackground: M4_COLOR_POINTERBG

*color0: M4_COLOR_0
*color8: M4_COLOR_8
*color1: M4_COLOR_1
*color9: M4_COLOR_9
*color2: M4_COLOR_2
*color10: M4_COLOR_10
*color3: M4_COLOR_3
*color11: M4_COLOR_11
*color4: M4_COLOR_4
*color12: M4_COLOR_12
*color5: M4_COLOR_5
*color13: M4_COLOR_13
*color6: M4_COLOR_6
*color14: M4_COLOR_14
*color7: M4_COLOR_7
*color15: M4_COLOR_15

! rxvt-unicode
URxvt*font: xft:M4_FONT_NAME:size=M4_FONT_SIZE
URxvt*boldFont: xft:M4_FONT_NAME:size=M4_FONT_SIZE
URxvt*lineSpace: 1
URxvt*scrollBar: false
URxvt*urgentOnBell: true
URxvt*iso14755: false
URxvt*iso14755_52: false

! xterm
XTerm*faceName: M4_FONT_NAME
XTerm*faceSize: M4_FONT_SIZE
XTerm*allowBoldFonts: false
XTerm*scrollBar: false

