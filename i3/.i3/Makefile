THEME ?= gruvbox-dark

FILES = config Xresources dunstrc alacritty.yml $(HOME)/.vim/colors/unified.vim $(HOME)/.config/Code/User/settings.json $(HOME)/.cgdb/cgdbrc

I3_M4_SCREENWIDTH := $(shell xwininfo -root | grep Width | grep -o "[0-9]\+" 2>/dev/null)

all: $(FILES)

clean:
	$(RM) $(FILES)

.PHONY: all clean

config: config.m4 font.m4 defaults.m4 themes/$(THEME)/i3.m4
	m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) config.m4 > config

Xresources: Xresources.m4 themes/$(THEME)/color.m4
	m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) Xresources.m4 > Xresources

dunstrc: dunstrc.m4 font.m4 themes/$(THEME)/i3.m4
	test $(I3_M4_SCREENWIDTH) -gt 2000 \
	&& m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) -DI3_M4_HIDPI dunstrc.m4 > dunstrc \
	|| m4 $(I3_M4_THEMEARGS) -I. -Ithemes/$(THEME) dunstrc.m4 > dunstrc

alacritty.yml: alacritty.yml.m4 font.m4 themes/$(THEME)/color.m4
	m4 -I. -Ithemes/$(THEME) alacritty.yml.m4 > alacritty.yml

# The following targets are optional
$(HOME)/.vim/colors/unified.vim: themes/$(THEME)/color.m4
	test -r $(HOME)/.vim/colors/unified.vim.m4 && cd $(HOME)/.vim && make clean && make THEME=$(THEME) || true

$(HOME)/.config/Code/User/settings.json: themes/$(THEME)/color.m4
	test -r $(HOME)/.config/Code/User/settings.json.m4 && cd $(HOME)/.config/Code/User && make clean && make THEME=$(THEME) || true

$(HOME)/.cgdb/cgdbrc:
	test -r $(HOME)/.cgdb/cgdbrc.m4 && cd $(HOME)/.cgdb && make clean && make THEME=$(THEME) || true

