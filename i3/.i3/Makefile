THEME ?= gruvbox-dark

FILES = config Xresources dunstrc $(HOME)/.vim/theme $(HOME)/.cgdb/cgdbrc

all: $(FILES)

clean:
	$(RM) $(FILES)

.PHONY: all clean

config: config.m4 font.m4 themes/$(THEME)/i3.m4
	m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) config.m4 > config

Xresources: Xresources.m4 themes/$(THEME)/color.m4
	m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) Xresources.m4 > Xresources

dunstrc: dunstrc.m4 themes/$(THEME)/i3.m4
	m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) dunstrc.m4 > dunstrc

# The following targets are optional
$(HOME)/.vim/theme:
	test -r $(HOME)/.vim/theme.m4 && m4 -I$(HOME)/.vim -I$(HOME)/.vim/themes/$(THEME) $(HOME)/.vim/theme.m4 > $(HOME)/.vim/theme || true

$(HOME)/.cgdb/cgdbrc:
	test -r $(HOME)/.cgdb/cgdbrc.m4 && m4 -I$(HOME)/.cgdb -I$(HOME)/.cgdb/themes/$(THEME) $(HOME)/.cgdb/cgdbrc.m4 > $(HOME)/.cgdb/cgdbrc || true
