{
    "name": "M4_CODE_THEME",
    "version": "0.1",
    "engines": {
        "vscode": "^1.40"
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
