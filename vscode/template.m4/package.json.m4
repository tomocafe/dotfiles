{
    "name": "theme-M4_CODE_THEME",
    "description": "Unified M4_CODE_THEME color scheme",
    "version": "M4_VERSION",
    "engines": {
        "vscode": "^1.40.1"
    },
    "publisher": "tomocafe",
    "categories": [
        "Themes"
    ],
    "contributes": {
        "themes": [
            {
                "label": "M4_CODE_THEME",
                "path": "./themes/M4_CODE_THEME.json",
ifelse(M4_CODE_BG,dark,dnl
                "uiTheme": "vs-dark"
,dnl
                "uiTheme": "vs"
)dnl
            }
        ]
    }
}
