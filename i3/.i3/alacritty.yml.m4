changecom()dnl
include(color.m4)dnl
include(font.m4)dnl
font:
    normal:
        family: M4_FONT_NAME
    bold:
        style: Regular
    italic:
        style: Italic
    size: M4_FONT_SIZE
selection:
    save_to_clipboard: true
colors:
    primary:
        background: 'M4_COLOR_BG'
        foreground: 'M4_COLOR_FG'
    normal:
        black: 'M4_COLOR_0'
        red: 'M4_COLOR_1'
        green: 'M4_COLOR_2'
        yellow: 'M4_COLOR_3'
        blue: 'M4_COLOR_4'
        magenta: 'M4_COLOR_5'
        cyan: 'M4_COLOR_6'
        white: 'M4_COLOR_7'
    bright:
        black: 'M4_COLOR_8'
        red: 'M4_COLOR_9'
        green: 'M4_COLOR_10'
        yellow: 'M4_COLOR_11'
        blue: 'M4_COLOR_12'
        magenta: 'M4_COLOR_13'
        cyan: 'M4_COLOR_14'
        white: 'M4_COLOR_15'
draw_bold_text_with_bright_colors: true
env:
  'WINIT_HIDPI_FACTOR': '1.0'
