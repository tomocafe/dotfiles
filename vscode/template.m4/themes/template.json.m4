changecom()dnl
include(i3.m4)dnl
ifelse(M4_CODE_BG,dark,dnl
define(`M4_COLOR_DIMBG',M4_COLOR_0)dnl
define(`M4_COLOR_DIMFG',M4_COLOR_8)dnl
define(`M4_COLOR_BRIFG',M4_COLOR_7)dnl
define(`M4_COLOR_BRI2FG',M4_COLOR_15)dnl
,dnl
define(`M4_COLOR_DIMBG',M4_COLOR_15)dnl
define(`M4_COLOR_DIMFG',M4_COLOR_7)dnl
define(`M4_COLOR_BRIFG',M4_COLOR_8)dnl
define(`M4_COLOR_BRI2FG',M4_COLOR_0)dnl
)dnl
dnl https://code.visualstudio.com/api/references/theme-color
{
    "$schema": "vscode://schemas/color-theme",
    "name": "theme-M4_CODE_THEME",
    "type": "M4_CODE_BG",
    "colors": {
        "editor.background": "M4_COLOR_BG",
        "editor.foreground": "M4_COLOR_FG",
        "editor.inactiveSelectionBackground": "M4_COLOR_DIMBG",
        "editorIndentGuide.background": "M4_COLOR_DIMBG",
        "editorIndentGuide.activeBackground": "M4_COLOR_DIMFG",
        "editor.selectionHighlightBackground": "M4_COLOR_DIMFG`'aa",
        "list.dropBackground": "M4_COLOR_DIMFG",
        "activityBarBadge.background": "M4_COLOR_DIMFG",
        "sideBarTitle.foreground": "M4_COLOR_BRIFG",
        "input.placeholderForeground": "M4_COLOR_FG",
        "settings.textInputBackground": "M4_COLOR_BG",
        "settings.numberInputBackground": "M4_COLOR_BG",
        "menu.background": "M4_COLOR_DIMBG",
        "menu.foreground": "M4_COLOR_FG",
        "statusBarItem.remoteForeground": "M4_COLOR_BRI2FG",
        "statusBarItem.remoteBackground": "M4_COLOR_4"
    },
    "tokenColors": [
        {
            "scope": [
                "meta.embedded",
                "source.groovy.embedded"
            ],
            "settings": {
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
            "scope": "header",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "comment",
            "settings": {
                "foreground": "M4_COLOR_DIMFG"
            }
        },
        {
            "scope": "constant.language",
            "settings": {
                "foreground": "M4_COLOR_5"
            }
        },
        {
            "scope": [
                "constant.numeric",
                "entity.name.operator.custom-literal.number",
                "variable.other.enummember",
                "keyword.operator.plus.exponent",
                "keyword.operator.minus.exponent"
            ],
            "settings": {
                "foreground": "M4_COLOR_5"
            }
        },
        {
            "scope": "constant.regexp",
            "settings": {
                "foreground": "M4_COLOR_5"
            }
        },
        {
            "scope": "entity.name.tag",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "entity.name.tag.css",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "entity.other.attribute-name",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": [
                "entity.other.attribute-name.class.css",
                "entity.other.attribute-name.class.mixin.css",
                "entity.other.attribute-name.id.css",
                "entity.other.attribute-name.parent-selector.css",
                "entity.other.attribute-name.pseudo-class.css",
                "entity.other.attribute-name.pseudo-element.css",
                "source.css.less entity.other.attribute-name.id",
                "entity.other.attribute-name.attribute.scss",
                "entity.other.attribute-name.scss"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "invalid",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.underline",
            "settings": {
                "fontStyle": "underline"
            }
        },
        {
            "scope": "markup.bold",
            "settings": {
                "fontStyle": "bold",
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.heading",
            "settings": {
                "fontStyle": "bold",
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.italic",
            "settings": {
                "fontStyle": "italic"
            }
        },
        {
            "scope": "markup.inserted",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.deleted",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.changed",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "punctuation.definition.quote.begin.markdown",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "punctuation.definition.list.begin.markdown",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "markup.inline.raw",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "brackets of XML/HTML tags",
            "scope": "punctuation.definition.tag",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": [
                "meta.preprocessor"
            ],
            "settings": {
                "foreground": "M4_COLOR_6"
            }
        },
        {
            "scope": "meta.preprocessor.string",
            "settings": {
                "foreground": "M4_COLOR_6"
            }
        },
        {
            "scope": "meta.preprocessor.numeric",
            "settings": {
                "foreground": "M4_COLOR_6"
            }
        },
        {
            "scope": "meta.structure.dictionary.key.python",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "meta.diff.header",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "storage",
            "settings": {
                "foreground": "M4_COLOR_4"
            }
        },
        {
            "scope": "storage.type",
            "settings": {
                "foreground": "M4_COLOR_4"
            }
        },
        {
            "scope": [
                "storage.modifier",
                "keyword.operator.noexcept"
            ],
            "settings": {
                "foreground": "M4_COLOR_4"
            }
        },
        {
            "scope": [
                "string",
                "entity.name.operator.custom-literal.string"
            ],
            "settings": {
                "foreground": "M4_COLOR_2"
            }
        },
        {
            "scope": "string.tag",
            "settings": {
                "foreground": "M4_COLOR_2"
            }
        },
        {
            "scope": "string.value",
            "settings": {
                "foreground": "M4_COLOR_2"
            }
        },
        {
            "scope": "string.regexp",
            "settings": {
                "foreground": "M4_COLOR_2"
            }
        },
        {
            "name": "String interpolation",
            "scope": [
                "punctuation.definition.template-expression.begin",
                "punctuation.definition.template-expression.end",
                "punctuation.section.embedded"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "Reset JavaScript string interpolation expression",
            "scope": [
                "meta.template.expression"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": [
                "support.type.vendored.property-name",
                "support.type.property-name",
                "variable.css",
                "variable.scss",
                "variable.other.less",
                "source.coffee.embedded"
            ],
            "settings": {
                "foreground": "M4_COLOR_4"
            }
        },
        {
            "scope": "keyword",
            "settings": {
                "foreground": "M4_COLOR_9"
            }
        },
        {
            "scope": "keyword.control",
            "settings": {
                "foreground": "M4_COLOR_9"
            }
        },
        {
            "scope": "keyword.operator",
            "settings": {
                "foreground": "M4_COLOR_BRI2FG"
            }
        },
        {
            "scope": [
                "keyword.operator.new",
                "keyword.operator.expression",
                "keyword.operator.cast",
                "keyword.operator.sizeof",
                "keyword.operator.alignof",
                "keyword.operator.typeid",
                "keyword.operator.alignas",
                "keyword.operator.instanceof",
                "keyword.operator.logical.python",
                "keyword.operator.wordlike"
            ],
            "settings": {
                "foreground": "M4_COLOR_9"
            }
        },
        {
            "scope": "keyword.other.unit",
            "settings": {
                "foreground": "M4_COLOR_9"
            }
        },
        {
            "scope": [
                "punctuation.section.embedded.begin.php",
                "punctuation.section.embedded.end.php"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "support.function.git-rebase",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "constant.sha.git-rebase",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "coloring of the Java import and package identifiers",
            "scope": [
                "storage.modifier.import.java",
                "variable.language.wildcard.java",
                "storage.modifier.package.java"
            ],
            "settings": {
                "foreground": "M4_COLOR_6"
            }
        },
        {
            "name": "this.self",
            "scope": "variable.language",
            "settings": {
                "foreground": "M4_COLOR_FG"
            }
        },
            "name": "Function declarations",
            "scope": [
                "entity.name.function",
                "support.function",
                "support.constant.handlebars",
                "source.powershell variable.other.member"
            ],
            "settings": {
                "foreground": "M4_COLOR_12"
            }
        },
        {
            "name": "Types declaration and references",
            "scope": [
                "meta.return-type",
                "support.class",
                "support.type",
                "entity.name.type",
                "entity.name.namespace",
                "entity.other.attribute",
                "entity.name.scope-resolution",
                "entity.name.class",
                "storage.type.numeric.go",
                "storage.type.byte.go",
                "storage.type.boolean.go",
                "storage.type.string.go",
                "storage.type.uintptr.go",
                "storage.type.error.go",
                "storage.type.rune.go",
                "storage.type.cs",
                "storage.type.generic.cs",
                "storage.type.modifier.cs",
                "storage.type.variable.cs",
                "storage.type.annotation.java",
                "storage.type.generic.java",
                "storage.type.java",
                "storage.type.object.array.java",
                "storage.type.primitive.array.java",
                "storage.type.primitive.java",
                "storage.type.token.java",
                "storage.type.groovy",
                "storage.type.annotation.groovy",
                "storage.type.parameters.groovy",
                "storage.type.generic.groovy",
                "storage.type.object.array.groovy",
                "storage.type.primitive.array.groovy",
                "storage.type.primitive.groovy"
            ],
            "settings": {
                "foreground": "M4_COLOR_4"
            }
        },
        {
            "name": "Types declaration and references, TS grammar specific",
            "scope": [
                "meta.type.cast.expr",
                "meta.type.new.expr",
                "support.constant.math",
                "support.constant.dom",
                "support.constant.json",
                "entity.other.inherited-class"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "Control flow / Special keywords",
            "scope": [
                "keyword.control",
                "source.cpp keyword.operator.new",
                "keyword.operator.delete",
                "keyword.other.using",
                "keyword.other.operator",
                "entity.name.operator"
            ],
            "settings": {
                "foreground": "M4_COLOR_9"
            }
        },
        {
            "name": "Variable and parameter name",
            "scope": [
                "variable",
                "meta.definition.variable.name",
                "support.variable",
                "entity.name.variable"
            ],
            "settings": {
                "foreground": "M4_COLOR_FG"
            }
        },
        {
            "name": "Object keys, TS grammar specific",
            "scope": [
                "meta.object-literal.key"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "CSS property value",
            "scope": [
                "support.constant.property-value",
                "support.constant.font-name",
                "support.constant.media-type",
                "support.constant.media",
                "constant.other.color.rgb-value",
                "constant.other.rgb-value",
                "support.constant.color"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "name": "Regular expression groups",
            "scope": [
                "punctuation.definition.group.regexp",
                "punctuation.definition.group.assertion.regexp",
                "punctuation.definition.character-class.regexp",
                "punctuation.character.set.begin.regexp",
                "punctuation.character.set.end.regexp",
                "keyword.operator.negation.regexp",
                "support.other.parenthesis.regexp"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": [
                "constant.character.character-class.regexp",
                "constant.other.character-class.set.regexp",
                "constant.other.character-class.regexp",
                "constant.character.set.regexp"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": [
                "keyword.operator.or.regexp",
                "keyword.control.anchor.regexp"
            ],
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "keyword.operator.quantifier.regexp",
            "settings": {
                "foreground": "#FF0000"
            }
        },
        {
            "scope": "constant.character",
            "settings": {
                "foreground": "M4_COLOR_13"
            }
        },
        {
            "scope": "constant.character.escape",
            "settings": {
                "foreground": "M4_COLOR_13"
            }
        },
        {
            "scope": "entity.name.label",
            "settings": {
                "foreground": "M4_COLOR_12"
            }
        }
    ]
}
