changecom()dnl
include(color.m4)dnl
ifelse(M4_CODE_BG,dark,dnl
define(`M4_CODE_DIMBG',M4_COLOR_0)dnl
define(`M4_CODE_DIMFG',M4_COLOR_8)dnl
define(`M4_CODE_BRIFG',M4_COLOR_7)dnl
define(`M4_CODE_BRI2FG',M4_COLOR_15)dnl
,dnl
define(`M4_CODE_DIMBG',M4_COLOR_15)dnl
define(`M4_CODE_DIMFG',M4_COLOR_7)dnl
define(`M4_CODE_BRIFG',M4_COLOR_8)dnl
define(`M4_CODE_BRI2FG',M4_COLOR_0)dnl
)dnl
{
    "name": "M4_CODE_THEME",
    "type": "M4_CODE_BG",
    "tokenColors": [
        {
            "settings": {
                "background": "M4_COLOR_BG",
                "foreground": "M4_COLOR_FG"
            }
        },
        {
            "scope": "emphasis",
            "settings": {
                "fontStyle": "italic"
            }
        },
        {
            "scope": "strong",
            "settings": {
                "fontStyle": "bold"
            }
        },
        {
            "scope": [
                "comment",
                "punctuation.definition.comment"
            ],
            "settings": {
                "foreground": "M4_CODE_DIMFG"
            }
        },
        {
            "scope": [
                "constant",
                "support.constant",
                "variable.arguments"
            ],
            "settings": {
                "foreground": "M4_COLOR_5"
            }
        },
        {
            "scope": "constant.rgb-value",
            "settings": {
                "foreground": "M4_COLOR_15"
            }
        }
    ],
    "colors": {

    }
}
