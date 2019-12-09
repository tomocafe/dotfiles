changecom()dnl
include(color.m4)dnl
define(`M4_COLOR_DIMBG',ifelse(M4_CODE_BG,dark,M4_COLOR_0,M4_COLOR_15))dnl
define(`M4_COLOR_DIMFG',ifelse(M4_CODE_BG,dark,M4_COLOR_8,M4_COLOR_7))dnl
define(`M4_COLOR_BRIFG',ifelse(M4_CODE_BG,dark,M4_COLOR_7,M4_COLOR_8))dnl
define(`M4_COLOR_BRI2FG',ifelse(M4_CODE_BG,dark,M4_COLOR_15,M4_COLOR_0))dnl
dnl https://code.visualstudio.com/docs/getstarted/themes#_customizing-a-color-theme
{
    "telemetry.enableTelemetry": false,
    "telemetry.enableCrashReporter": false,
    "workbench.activityBar.visible": false,
    "editor.fontFamily": "Roboto Mono",
    "editor.fontLigatures": true,
    "editor.wordWrap": "on",
    "editor.fontWeight": "500",
    "terminal.integrated.fontWeight": "500",
    "terminal.integrated.fontWeightBold": "normal",
    "git.ignoreLegacyWarning": true,
    "workbench.iconTheme": null,
    "workbench.editor.enablePreview": false,
    "window.zoomLevel": 0,

    "editor.tokenColorCustomizations": {
        "keywords": "M4_COLOR_9",
        "comments": "M4_COLOR_DIMFG",
        "functions": "M4_COLOR_4",
        "numbers": "M4_COLOR_5",
        "strings": "M4_COLOR_2",
        "types": "M4_COLOR_4",
        "variables": "M4_COLOR_FG",
        "textMateRules": [
            {
                "scope": "keyword.operator",
                "settings": {
                    "foreground": "M4_COLOR_BRI2FG"
                }
            },
            {
                "scope": [
                    "constant.language"
                ],
                "settings": {
                    "foreground": "M4_COLOR_13"
                }
            },
            {
                "scope": [
                    "constant.character",
                    "constant.character.escape"
                ],
                "settings": {
                    "foreground": "M4_COLOR_13"
                }
            },
            {
                "scope": [
                    "storage.modifier"
                ],
                "settings": {
                    "foreground": "M4_COLOR_9"
                }
            },
            {
                "scope": [
                    "support.type.property-name"
                ],
                "settings": {
                    "foreground": "M4_COLOR_9"
                }
            }
        ]
    },
    "workbench.colorCustomizations": {
        "foreground": "M4_COLOR_FG",
        "focusBorder": "M4_COLOR_DIMFG",
        "widget.shadow": "M4_COLOR_DIMBG",
        "descriptionForeground": "M4_COLOR_FG",
        "errorForeground": "M4_COLOR_1",
        "icon.foreground": "M4_COLOR_BRIFG",
        "editor.background": "M4_COLOR_BG",
        "editor.foreground": "M4_COLOR_FG",
        "editorLineNumber.foreground": "M4_COLOR_DIMFG", 
        "editor.inactiveSelectionBackground": "M4_COLOR_DIMBG",
        "editorIndentGuide.background": "M4_COLOR_DIMBG",
        "editorIndentGuide.activeBackground": "M4_COLOR_3`'66",
        "editor.selectionBackground": "M4_COLOR_3`'44",
        "editor.selectionHighlightBackground": "M4_COLOR_3`'11",
        "editor.wordHighlightBackground": "M4_COLOR_DIMBG",
        "editor.wordHighlightStrongBackground": "M4_COLOR_DIMFG`'22",
        "editorBracketMatch.background": "M4_COLOR_DIMBG",
        "editorBracketMatch.border": "M4_COLOR_3`'aa",
        "editorError.foreground": "M4_COLOR_1",
        "editorWarning.foreground": "M4_COLOR_3",
        "list.dropBackground": "M4_COLOR_DIMFG",
        "sideBarTitle.foreground": "M4_COLOR_BRIFG",
        "input.placeholderForeground": "M4_COLOR_FG",
        "settings.textInputBackground": "M4_COLOR_BG",
        "settings.numberInputBackground": "M4_COLOR_BG",
        "menu.background": "M4_COLOR_DIMBG",
        "menu.foreground": "M4_COLOR_FG",
        "sideBar.background": "M4_COLOR_BG",
        "sideBarTitle.foreground": "M4_COLOR_BRIFG",
        "statusBar.background": "M4_COLOR_DIMFG",
        "statusBarItem.remoteForeground": "M4_COLOR_BRI2FG",
        "statusBarItem.remoteBackground": "M4_COLOR_4",
        "terminal.ansiBlack": "M4_COLOR_0",
        "terminal.ansiRed": "M4_COLOR_1",
        "terminal.ansiGreen": "M4_COLOR_2",
        "terminal.ansiYellow": "M4_COLOR_3",
        "terminal.ansiBlue": "M4_COLOR_4",
        "terminal.ansiMagenta": "M4_COLOR_5",
        "terminal.ansiCyan": "M4_COLOR_6",
        "terminal.ansiWhite": "M4_COLOR_7",
        "terminal.ansiBrightBlack": "M4_COLOR_8",
        "terminal.ansiBrightRed": "M4_COLOR_9",
        "terminal.ansiBrightGreen": "M4_COLOR_10",
        "terminal.ansiBrightYellow": "M4_COLOR_11",
        "terminal.ansiBrightBlue": "M4_COLOR_12",
        "terminal.ansiBrightMagenta": "M4_COLOR_13",
        "terminal.ansiBrightCyan": "M4_COLOR_14",
        "terminal.ansiBrightWhite": "M4_COLOR_15",
        "activityBar.background": "M4_COLOR_DIMFG",
        "activityBar.activeBackground": "M4_COLOR_DIMFG",
        "activityBar.dropBackground": "M4_COLOR_DIMFG",
        "activityBar.foreground": "M4_COLOR_BRI2FG",
        "activityBarBadge.background": "M4_COLOR_DIMFG",
        "activityBarBadge.foreground": "M4_COLOR_BRI2FG",
        ""
    }
}
